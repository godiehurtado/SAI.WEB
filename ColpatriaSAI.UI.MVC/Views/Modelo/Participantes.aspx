<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Modelo - Participantes
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">        // INICIALIZACIÓN DE LA VISTA
        function mostrarDialogParticipantes(pagina, titulo, dialog) {
            if ($("#nivel_id").val() != "" && $("#zona_id").val() != "")
                $("#" + dialog).dialog({
                    height: 630, width: 640, modal: true,
                    buttons: {
                        Cerrar: function () { $(this).dialog("close"); }
                    },
                    title: titulo,
                    open: function (event, ui) { $(this).load(pagina); },
                    close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
                });
            else mostrarError("Debe seleccionar un nivel y una zona!");
        }

        $(document).ready(function () {
            $("#ModeloxParticipanteCrear").validate();
            $("#CanalCrear").validate();
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            oTableCanal = $('#tablaCanal').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            $("#bRegresar").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
        });

        $(function () {
            //$("#nivel_id option[value='1']").remove();

            var dates = $("#fechaIni, #fechaFin").datepicker({
                defaultDate: "+1w", changeMonth: true, numberOfMonths: 3, dateFormat: "yy-mm-dd",
                showButtonPanel: true, changeMonth: true, changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings); dates.not(this).datepicker("option", option, date);
                }
            });
            // Cargar items de localidades por la zona seleccionada
            var zonas = $("#zona_id");
            var localidades = $("#localidad_id");
            zonas.change(function () {
                localidades.find('option').remove();
                $.getJSON('/Modelo/getLocalidades', { idZona: zonas.val() },
                    function (data) {
                        $("<option value='0'>Seleccione...</option>").appendTo(localidades);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
                        });
                    }
                );
            });
        });

        function numeroPaginas() { //var texto = $('#tablaLista_info').text().split(' '); // $('#tablaLista_info').text(texto[0] + " " + texto[1] + " " + texto[2] + " " + totalFilas + " " + texto[4] + " " + totalFilas + " " + texto[6]);
            var totalFilas = $('#tablaLista >tbody >tr').length;
            $('#tablaLista_info').text("Mostrando 1 a " + totalFilas + " de " + totalFilas + " registros");
        }
    </script>
    <script type="text/javascript"> // MODELO POR PATICIPANTE
        function guardarModeloPart() {
            if (($("#fechaIni").val() != "") && ($("#fechaFin").val() != "") && ($("#modelo_id").val() != "")) {
                mostrarCargando("Enviando informacion. Espere Por Favor...");
                $.ajax({
                    url: $("#ModeloxParticipanteCrear").attr('action'), data: $("#ModeloxParticipanteCrear").serialize(), type: "POST",
                    success: function (result) {
                        closeNotify('jNotify');
                        if (result.id != null) {
                            if (result.id != "0") {
                                agragarFila('#tablaLista', result); 
                                mostrarExito(Exito_Insert);
                            } else {
                                mostrarError(Error_Insert_Duplicado);
                            }
                        } else {
                            mostrarError(Error_Insert);
                        }
                    }
                });
            }
        }

        function eliminarModeloXPart(idModeloxPart) {
            if (confirm('¿Esta seguro de eliminar esta asociación?')) {
                $.ajax({
                    url: '/Modelo/EliminarModeloPart', data: { id: idModeloxPart }, type: "POST",
                    success: function (result) {
                        if (result != "0") {
                            eliminarFilaTabla(oTable, '#tablaLista', idModeloxPart); mostrarExito(Exito_Delete); // $('#fila1' + idModeloxPart).remove();
                        }
                        else mostrarError(Error_Delete);
                    }
                });
            }
        }
    </script>
    <script type="text/javascript">// CANAL POR MODELO
        function guardarCanalxModelo() {
            $.ajax({
                url: $("#CanalxModeloCrear").attr('action'), data: $("#CanalxModeloCrear").serialize(), type: "POST",
                success: function (result) {
                    if (result.id != "0") {
                        agragarFila('#tablaCanal', result); mostrarExito(Exito_Insert);
                    } else {
                        mostrarError(Error_Insert_Duplicado);
                    }
                }
            });
        }

        function eliminarCanalxModelo(idCanalxModelo) {
            if (confirm('¿Esta seguro de eliminar esta asociación?')) {
                $.ajax({
                    url: '/Modelo/EliminarCanalxModelo', data: { id: idCanalxModelo }, type: "POST",
                    success: function (result) {
                        if (result != "0") {
                            eliminarFilaTabla(oTableCanal, '#tablaCanal', idCanalxModelo); mostrarExito(Exito_Delete); //$('#fila2' + idCanalxModelo).remove();
                        }
                        else mostrarError(Error_Delete);
                    }
                });
            }
        }

        /// Agregar una fila a las tablas de modelo por participantes.
        function agragarFila(op, fila) {
            var filaNueva = '';
            if (op == '#tablaLista') {
                var nivel = ($('#nivel_id :selected').text() != "Seleccione...") ? $('#nivel_id :selected').text() : "";
                var zona = ($('#zona_id :selected').text() != "Seleccione...") ? $('#zona_id :selected').text() : "";
                var localidad = ($('#localidad_id :selected').text() != "Seleccione...") ? $('#localidad_id :selected').text() : "";

                if ($('#participante').val() != "") {
                    nivel = "";
                    zona = "";
                    localidad = "";
                }

                filaNueva = $(
                    "<tr id='fila1" + fila.id + "' align='center'>" +
                    "<td id='cell11" + fila.id + "' style='background-color:#e2e4ff; width:100px'>" + $('#fechaIni').val() + "</td>" +
                    "<td id='cell12" + fila.id + "' style='background-color:#e2e4ff; width:85px'>" + $('#fechaFin').val() + "</td>" +
                    "<td id='cell13" + fila.id + "' style='background-color:#e2e4ff'>" + nivel + "</td>" +
                    "<td id='cell14" + fila.id + "' style='background-color:#e2e4ff'>" + zona + "</td>" +
                    "<td id='cell15" + fila.id + "' style='background-color:#e2e4ff'>" + localidad + "</td>" +
                    "<td id='cell16" + fila.id + "' style='background-color:#e2e4ff'>" + $('#participante').val() + "</td>" +
                    "<td style='background-color:#e2e4ff; width:75px'>" +
                        //"<a href=''>Editar</a><img class='eliminar' src='' alt='Eliminar asociación' />" +
                        "<a onclick='eliminarModeloXPart(" + fila.id + ")' title='Eliminar' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                    "</td> </tr>");
                oTable.fnAddTr($(filaNueva)[0]);
            } else {
                filaNueva = $(
                    "<tr id='fila2" + fila.id + "' align='center'>" +
                    "<td id='cell22" + fila.id + "' style='background-color:#e2e4ff'>" + $('#canal_id :selected').text() + "</td>" +
                    "<td style='background-color:#e2e4ff; width:75px'>" +
                        "<a onclick='eliminarCanalxModelo(" + fila.id + ")' title='Eliminar' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                    "</td> </tr>");
                oTableCanal.fnAddTr($(filaNueva)[0]);
            }
            //$(op + ' tr:last').after(filaNueva);
        }
    </script>
    
    <% string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }
       ModeloxParticipanteViewModel modeloxPart = (ModeloxParticipanteViewModel)ViewData["ModelosXParticipantes"];
       IEnumerable<ModeloxNodo> modeloPartList = (IEnumerable<ModeloxNodo>)ViewData["ModelosXParticipanteList"];
       Random random = new Random(); int num = random.Next(1, 10000); %>

    <h2><%: modeloxPart.ModeloxParticipanteView.Modelo.descripcion %></h2>

    <%: Html.ActionLink("Regresar", "Index", null, new { @style = "align:right", id = "bRegresar" })%>
    
    <fieldset id="AreaModeloxPart"><legend>Lista de participantes en el modelo</legend><%--modeloxPart.ModeloxParticipanteView.Modelo.descripcion  --%>
    <% using (Html.BeginForm("CrearModeloxParticipante", "Modelo", FormMethod.Post, new { id = "ModeloxParticipanteCrear" })) {
            Html.ValidationSummary(true); %>
        <table id="tablaLista">
        <thead>
            <tr style="background-color: White">
                <td colspan="7">
                    <table width="100%">
                        <tr>
                            <td>
                                <%: Html.Label("Fecha inicial:")%>
                                <%: Html.TextBox("fechaIni", null, new { @class = "required number", @style = "width:70px" })%>
                            </td>
                            <td>
                                <%: Html.Label("Fecha final:")%>
                                <%: Html.TextBox("fechaFin", null, new { @class = "required number", @style = "width:70px" })%>
                            </td>
                            <td>
                                <%: Html.Label("Nivel:")%>
                                <%: Html.DropDownList("nivel_id", (SelectList)modeloxPart.NivelList, "Seleccione...", new { @class = "required" })%>
                            </td>
                            <td>
                                <%: Html.Label("Zona:")%>
                                <%: Html.DropDownList("zona_id", (SelectList)modeloxPart.ZonaList, "Seleccione...", new { @class = "required" })%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%: Html.Label("Localidad:")%><br />
                                <%: Html.DropDownList("localidad_id", new List<SelectListItem>(), new { @class = "required" })%>
                            </td>
                            <td>
                                <%: Html.Label("Participante:")%><br />
                                <%: Html.TextBox("participante", null, new { @readonly = "true", style = "width:200px;" })%><%--, @class = "required"--%>
                                <%: Html.Hidden("participante_id", null, new { id = "participante_id"}  ) %>
                            </td>
                            <td>
                                <a href="javascript:mostrarDialogParticipantes('/Modelo/Nodos?r=<%: num %>', 'Lista de Participantes', 'dialogPart');" style="float:left" title='Seleccionar nodo de la jerarquía'><span class='ui-icon ui-icon-search'/></a>
                            </td>
                            <td>
                                <%: Html.Hidden("modelo_id", modeloxPart.ModeloxParticipanteView.Modelo.id, new { id = "modelo_id" })%>
                                <input type="button" value="Agregar" onclick="guardarModeloPart()" />
                            </td>
                        </tr>
                    </table>

                </td>
            </tr>
            <tr>
                <th>Fecha inicial</th><th>Fecha final</th><th>Nivel</th><th>Zona</th><th>Localidad</th><th>Participante</th><th style="width:20px">Opciones</th>
            </tr>
        </thead>
        <tbody>
        <% foreach (var item in modeloPartList) { %>
            <tr id='fila1<%: item.id %>' align='center'>
                <td id='cell11<%: item.id %>' style='background-color:#e2e4ff; width:100px'><%: String.Format("{0:d}", item.fechaIni) %></td>
                <td id='cell12<%: item.id %>' style='background-color:#e2e4ff; width:85px'><%: String.Format("{0:d}", item.fechaFin)%></td>
                <td id='cell13<%: item.id %>' style='background-color:#e2e4ff'><%: item.Nivel.nombre %></td>
                <td id='cell14<%: item.id %>' style='background-color:#e2e4ff'><%: item.Zona.nombre %></td>
                <td id='cell15<%: item.id %>' style='background-color:#e2e4ff'><%: item.Localidad.nombre %></td>
                <td id='cell16<%: item.id %>' style='background-color:#e2e4ff'><%: item.JerarquiaDetalle.nombre %></td>
                <td style='background-color:#e2e4ff; width:75px'>
                    <%--<a href='#'>Editar</a>--%>
                    <a onclick='eliminarModeloXPart(<%: item.id %>)' title='Eliminar asociación' class='ui-state-default ui-corner-all' style='float:left;'>
                        <span class='ui-icon ui-icon-trash'/>
                    </a>
                </td>
            </tr>
        <% } %>
        </tbody>
        </table>
    <% } %>
    </fieldset>

    <br />

    <div id='dialogPart' style="display:none;"></div>
</asp:Content>