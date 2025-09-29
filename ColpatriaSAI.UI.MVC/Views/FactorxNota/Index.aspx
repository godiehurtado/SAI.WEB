<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Factores por Nota
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        var oTable;
        var oTablePeriodo;
        var oTableDetalle;

        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
//        function mostrarBusqueda() {
//            $("#busquedaAvanzada").toggle('slow');
//            $("#buscarNota").attr("value", "");
//            $("#buscarFactor").attr("value", "");
//            $("#buscarModelo").attr("value", "");
//            oTable.fnDraw();
//        }
//        $.fn.dataTableExt.afnFiltering.push(
//	        function (oSettings, aData, iDataIndex) {
//	            var bNota = document.getElementById('buscarNota').value;
//	            var bFactor = document.getElementById('buscarFactor').value;
//	            var bModelo = document.getElementById('buscarModelo').value;

//	            var Nota = aData[2];
//	            var Factor = aData[3];
//	            var Modelo = aData[4];

//	            var comparaNota = Nota.toUpperCase().indexOf(bNota.toUpperCase());
//	            var comparaFactor = Factor.toUpperCase().indexOf(bFactor.toUpperCase());
//	            var comparaModelo = Modelo.toUpperCase().indexOf(bModelo.toUpperCase());

//	            if ((comparaNota >= 0) && (comparaFactor >= 0) && (comparaModelo >= 0)) {
//	                return true;
//	            }
//	            return false;
//	        }
//        );
        $(document).ready(function () {
            var dates = $("#fechaIni, #fechaFin").datepicker({
                defaultDate: "+1w", numberOfMonths: 3, dateFormat: "yy-mm-dd",
                showButtonPanel: true, changeMonth: true, changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
            $.validator.setDefaults();
            $("#formfactorxNota").validate();
            $("#formfactorxNota").validate({
                rules: { nota: "required", factor: "required" }//,
//                submitHandler: function (form) {
//                    $("#crear").attr('disabled', true);
//                    form.submit();
//                }
            });
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            oTablePeriodo = $('#tablaPeriodo').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            oTableDetalle = $('#tablaDetalle').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            /* Event Listener del campo de búsqueda avanzada */
//            $('#buscarNota').keyup(function () { oTable.fnDraw(); });
//            $('#buscarFactor').keyup(function () { oTable.fnDraw(); });
//            $('#buscarModelo').keyup(function () { oTable.fnDraw(); });
        });

        function toggleTabla(tabla) {
//            if ($('#fieldPeriodo').attr('style') != 'display: none;') {
//                $('#fieldPeriodo').attr('style', 'display: none;');
//                $('#fieldDetalle').attr('style', 'display: none;');
            //            }
            if ($(tabla).attr('style') == 'display: none;' || $(tabla).attr('style') == 'DISPLAY: none') {
                $(tabla).show('slide');
            } else {
                $(tabla).hide('slide'); $(tabla).show('slide');
            }
        }

        function inicializarTabla(tabla, fila) {
            if ($(tabla + ' >tbody >tr >td').length == 1) $(tabla + ' >tbody >tr:last').remove();
            /*if (tabla == "#tablaPeriodo") {
                for (var i = 0; i < oTablePeriodo.fnSettings().aoData.length; i++) {
                    delete oTablePeriodo.fnSettings().aoData[i];
                }
            }*/
            $(tabla + " tbody tr").remove();
            $("tr[id^='" + fila + "']").remove();
        }
    </script>
    <script type="text/javascript">
        function guardarFactorxNota() {
            if (($("#nombre").val() != "") && ($("#tipoescala_id").val() != "")) {
                $('#btnGuardarFactorxNota').attr("disabled", true);
                mostrarCargando(Procesando);
                $.ajax({
                    url: $("#formfactorxNota").attr('action'), data: $("#formfactorxNota").serialize(), type: "POST",
                    success: function (result) {
                        window.location.href = window.location.pathname;
                        if (result.id != 0) {
                            eliminarFila('#fila1' + result.id);
                            agregarFila('#tablaLista', result);
                            $("#factorxnota_id").val(result.id); mostrarExito(Exito_Insert);
                            cancelarEdicion();
                        } else {
                            mostrarError(Error_Insert_Duplicado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
                $('#btnGuardarFactorxNota').attr("disabled", false);
            }
        }

        function editarFactorxNota(id) {
            $('#tipoescala_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#escala' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });

            $('#nombre').val(jQuery.trim($('#NombreEscala' + id).text()))
            $("#factorxnota_id").val(id);
            $('#nombre').focus();
            $('#nombre').select();
            $('#btnCancelarEdit').css("display", "block");

        }
        function inicializarControles() {
            //$('#crearJerarquia').attr("action", "/Jerarquia/Crear/0");
            $('#factorxnota_id').val(0);
            $("#tipoescala_id option:first-child").attr("selected", "selected");
            $('#nombre').val('');
        }
        function cancelarEdicion() {
            inicializarControles();
            $('#btnCrear').attr("value", "Crear");
            $('#btnCancelarEdit').css("display", "none");
        }


        function eliminarFactorxNota(id) {
            if (confirm('¿Esta seguro de eliminar esta configuración?')) {
                mostrarCargando(Procesando);
                $.ajax({
                    url: '/FactorxNota/EliminarFactorxNota', data: { id: id }, type: "POST",
                    success: function (result) {
                        if (result > 0) {
                            //eliminarFilaTabla(oTable, '#tablaLista', id); 
                            eliminarFila('#fila1' + id); mostrarExito(Exito_Delete);
                        } else {
                            mostrarError(Error_Delete_Asociado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function mostrarPeriodos(idFactorxNota) {
            inicializarTabla('#tablaPeriodo', 'fila2');
            mostrarCargando(Procesando);
            $.ajax({
                url: '/FactorxNota/ListarPeriodos', data: { id: idFactorxNota }, type: "POST",
                success: function (result) {
                    $(result).each(function () {
                        agregarFila('#tablaPeriodo', this);
                    });
                },
                complete: function () { closeNotify("jNotify"); }
            });
            toggleTabla('#fieldPeriodo');

            $("#nombreEscalaEditar").html($("#NombreEscala" + idFactorxNota).html()); // Mostrar el nombre de la escala en la edición de periodos

            $('#fieldDetalle').hide();
            $("#id_factorxnota").val(idFactorxNota);
        }

        function guardarPeriodo() {
            if (($("#fechaIni").val() != "") && ($("#fechaFin").val() != "")) {
                $('#btnGuardarPeriodo').attr("disabled", true);
                mostrarCargando(Procesando);
                $.ajax({
                    url: $('#PeriodoCrear').attr('action'), data: $('#PeriodoCrear').serialize(), type: "POST",
                    success: function (result) {
                        if (result.id != 0) {
                            agregarFila('#tablaPeriodo', result);
                            $("#periodo_id").val(result.id); mostrarExito(Exito_Insert);
                        } else {
                            mostrarError(Error_Update_Duplicado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
                $('#btnGuardarPeriodo').attr("disabled", false);
            }
        }

        function editarPeriodo(id) {
            $('#fechaIni').val($('#cell21' + id).text());
            $('#fechaFin').val($('#cell22' + id).text());
            $('#periodo_id').val($('#cell23' + id).text());
        }

        function eliminarPeriodo(id) {
            if (confirm('¿Esta seguro de eliminar esta asociación?')) {
                mostrarCargando(Procesando);
                $.ajax({
                    url: '/FactorxNota/EliminarPeriodo', data: { id: id }, type: "POST",
                    success: function (result) {
                        if (result > 0) {
                            //eliminarFilaTabla(oTablePeriodo, '#tablaPeriodo', id);
                            eliminarFila('#fila2' + id);
                            mostrarExito(Exito_Delete);
                        } else {
                            mostrarError(Error_Delete_Asociado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function mostrarDetalles(idPeriodo) {
            mostrarCargando(Procesando);
            $.ajax({
                url: '/FactorxNota/ListarDetalles', data: { id: idPeriodo }, type: "POST",
                success: function (result) {
                    inicializarTabla('#tablaDetalle', 'fila3');
                    $(result).each(function () {
                        agregarFila('#tablaDetalle', this);
                    });
                },
                complete: function () { closeNotify("jNotify"); }
            });
            toggleTabla('#fieldDetalle');
            $("#periodoEscala").html($("#NombrePeriodoIni" + idPeriodo).html() + " - " +  $("#NombrePeriodoFin" + idPeriodo).html()); // Mostrar el periodo que se esta editando.
            $("#id_periodo").val(idPeriodo);
        }

        function guardarDetalle() {
            if (($("#factor").val() != "") && ($("#nota").val() != "")) {
                $('#btnGuardarDetalle').attr("disabled", true);
                mostrarCargando(Procesando);
                $.ajax({
                    url: $('#DetalleCrear').attr('action'), data: $('#DetalleCrear').serialize(), type: "POST",
                    success: function (result) {
                        if (result.id != 0) {
                            agregarFila('#tablaDetalle', result);
                            $("#detalle_id").val(result.id); mostrarExito(Exito_Insert);
                        } else {
                            mostrarError(Error_Insert_Duplicado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
                $('#btnGuardarDetalle').attr("disabled", false);
            }
        }

        function editarDetalle(id) {
            $('#fechaIni').val($('#cell31' + id).text());
            $('#fechaFin').val($('#cell32' + id).text());
            $('#detalle_id').val($('#cell33' + id).text());
        }

        function eliminarDetalle(id) {
            if (confirm('¿Esta seguro de eliminar esta asociación?')) {
                mostrarCargando(Procesando);
                $.ajax({
                    url: '/FactorxNota/EliminarDetalle', data: { id: id }, type: "POST",
                    success: function (result) {
                        if (result > 0) {
                            //eliminarFilaTabla(oTableDetalle, '#tablaDetalle', id);
                            eliminarFila('#fila3' + id);
                            mostrarExito(Exito_Delete);
                        } else {
                            mostrarError(Error_Delete_Asociado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
            }
        }
    </script>
    <script type="text/javascript">
        function eliminarFila(fila_id) {
            $(fila_id).remove();
        }

        function agregarFila(op, fila) {
            var filaNueva = '';
            if (op == '#tablaLista') {
                var tipoEscala = $("#tipoescala_id option:selected").text();
                filaNueva = $(
                    "<tr id='fila1" + fila.id + "'>" +
                    "<td id='cell11" + fila.id + "' style='background-color:#e2e4ff;'><div id='NombreEscala" + fila.id + "'>" + fila.nombre + "</div></td>" +
                    "<td id='cell12" + fila.id + "' style='background-color:#e2e4ff;'><div id='escala" + fila.id + "'>" + tipoEscala + "</div></td>" +
                    "<td style='background-color:#e2e4ff; width:75px'>" +
                        "<a href='#' onclick='editarFactorxNota(" + fila.id + ");' title='Editar esta escala' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-pencil'></span></a>" +
                        "<a onclick='mostrarPeriodos(" + fila.id + ")' title='Gestionar periodos' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-suitcase'/></a>" +
                        "<a onclick='eliminarFactorxNota(" + fila.id + ")' title='Eliminar configuración' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                    "</td> </tr>");
                //oTable.fnAddTr($(filaNueva)[0]);
            }
            else if (op == '#tablaPeriodo') {
                filaNueva = $(
                    "<tr id='fila2" + fila.id + "'>" +
                    "<td id='cell21" + fila.id + "' style='background-color:#e2e4ff;'><div id='NombrePeriodoIni" + fila.id + "'>" + fila.fechaIni + "</div></td>" +
                    "<td id='cell22" + fila.id + "' style='background-color:#e2e4ff;'><div id='NombrePeriodoFin" + fila.id + "'>" + fila.fechaFin + "</div></td>" +
                    //"<td id='cell23" + fila.factorxnota_id + "' style='display:none'></td>" +
                    "<td style='background-color:#e2e4ff; width:75px'>" +
                        //"<a onclick='editarPeriodo(" + fila.id + ")' title='Editar periodo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-pencil'/></a>" +
                        "<a onclick='mostrarDetalles(" + fila.id + ")' title='Gestionar detalles' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-suitcase'/></a>" +
                        "<a onclick='eliminarPeriodo(" + fila.id + ")' title='Eliminar periodo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                    "</td> </tr>");
                //oTablePeriodo.fnAddTr($(filaNueva)[0]);
            }
            else if (op == '#tablaDetalle') {
                filaNueva = $(
                    "<tr id='fila3" + fila.id + "'>" +
                    "<td id='cell31" + fila.id + "' style='background-color:#e2e4ff;'>" + fila.factor + "</td>" +
                    "<td id='cell32" + fila.id + "' style='background-color:#e2e4ff;'>" + fila.nota + "</td>" +
                    //"<td id='cell33" + fila.id + "' style='display:none'></td>" +
                    "<td style='background-color:#e2e4ff; width:75px'>" +
                        //"<a onclick='editarDetalle(" + fila.id + ")' title='Editar periodo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-pencil'/></a>" +
                        "<a onclick='eliminarDetalle(" + fila.id + ")' title='Eliminar periodo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                    "</td> </tr>");
                //oTableDetalle.fnAddTr($(filaNueva)[0]);
            }
            $(op + ' tr:last').after(filaNueva);// $(op).fnReDraw();
        }
    </script>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    
    <% FactorxNotaViewModel factorModel = (FactorxNotaViewModel)ViewData["FactorModel"];
        IEnumerable<FactorxNota> factorxNotas = (IEnumerable<FactorxNota>)ViewData["FactorxNotas"];
        Random random = new Random();  int num = random.Next(1, 10000);
        string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %><%-- IEnumerable<PeriodoFactorxNota> periodos = (IEnumerable<PeriodoFactorxNota>)ViewData["Periodos"]; --%>
    
    <h2>Gestionar Escalas</h2>
    <%: Html.ActionLink("Regresar", "../Contratacion/Parametrizacion")%>

    <fieldset id="fieldNota"><legend>Nombre de la Escala</legend><%-- style="display:none"--%>
        <table id="tablaAdmin">
            <tr valign="top">
                <td style="width:280px">
                    <% Html.EnableClientValidation(); %>
                    <% using (Html.BeginForm("CrearFactorxNota", "FactorxNota", FormMethod.Post, new { id = "formfactorxNota" })) {
                        Html.ValidationSummary(true); %>
                        <%: Html.Label("Nombre")%>&nbsp;
                        <%: Html.TextBox("nombre", null, new { @class = "required" }) %>
                        <%: Html.ValidationMessageFor(Model => factorModel.FactorxNotaView.nombre)%>
                        <br />
                        <%: Html.Label("Tipo: ")%>&nbsp;
                        <%: Html.DropDownList("tipoescala_id", (SelectList)factorModel.TipoEscalaList, "Seleccione...", new { @class = "required" })%>
                        <%: Html.Hidden("factorxnota_id") %><br />
                        <input id="btnGuardarFactorxNota" type="button" value="Guardar" onclick="guardarFactorxNota()" />
                        <input type="button" value="Cancelar edición" onclick="cancelarEdicion()" style="display:none; float:left" id="btnCancelarEdit" />
                    <% } %>
                </td>
                <td>
            
                    <table id="tablaLista">
                    <thead>
                        <tr> <th nowrap="nowrap">Id</th><th>Nombre de la Nota</th><th>Tipo escala para</th><th>Opciones</th> </tr>
                    </thead>
                    <tbody>
                    <% foreach (var item in factorxNotas) { %>
                        <tr id='fila1<%: item.id %>'>
                            <td><%: item.id %></td>
                            <td><div id="NombreEscala<%: item.id %>"><%: item.nombre %></div></td>
                            <td style='background-color:#e2e4ff;'><div id="escala<%: item.id %>" ><%: item.TipoEscala.nombre%></div></td>
                            <td style='background-color:#e2e4ff; width:75px'>
                                <a href="#" onclick="editarFactorxNota(<%: item.id %>);" title='Editar esta escala' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-pencil'></span></a>
                                <a onclick="mostrarPeriodos('<%: item.id %>')" title='Gestionar periodos' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-suitcase'/></a>
                                <a onclick='eliminarFactorxNota(<%: item.id %>)' title='Eliminar configuración' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                    </table>

                </td>
            </tr>

            <tr id="FilaDetalle" valign="top">
                <td colspan="2">

                    <table>
                        <tr>
                            <td style="width:50%; vertical-align:top">
                                
                                <fieldset id="fieldPeriodo" style="display:none"><legend>Periodos de <div id="nombreEscalaEditar"></div></legend><%----%>
                                    <% using (Html.BeginForm("CrearPeriodo", "FactorxNota", FormMethod.Post, new { id = "PeriodoCrear" }))
                                    { %>
                                        <%: Html.Label("Fecha inicial:")%>&nbsp;
                                        <%: Html.TextBox("fechaIni", null, new { @readonly = "true", @class = "required", @style = "width:70px" })%>
                                        &nbsp;&nbsp;&nbsp;
                                        <%: Html.Label("Fecha final:")%>&nbsp;
                                        <%: Html.TextBox("fechaFin", null, new { @readonly = "true", @class = "required", @style = "width:70px" })%> &nbsp;
                                        <%: Html.Hidden("periodo_id") %>
                                        <%: Html.Hidden("id_factorxnota") %>
                                        <input id="btnGuardarPeriodo" type="button" value="Crear" onclick="guardarPeriodo()" /> <br /><br />
                                    <% } %>
                                    <table id="tablaPeriodo" width="100%">
                                    <thead>
                                        <tr> <th>Fecha inicial</th><th>Fecha final</th><th>Opciones</th> </tr>
                                    </thead>
                                    <tbody>
                                    <%--<% foreach (var item in periodos) { %>
                                        <tr>--%>
                                            <%--<td><%: item.id %></td><td><%: item.fechaIni %></td><td><%: item.fechaFin %></td><td></td>--%>
                                            <%--<td></td><td></td><td></td>
                                        </tr>
                                    <% } %>--%>
                                    </tbody>
                                    </table>

                                </fieldset>

                            </td>

                            <td style="width:50%; vertical-align:top">
                                
                                <fieldset id="fieldDetalle" style="display:none"><legend>Detalle de la escala <div id="periodoEscala"></div></legend><%----%>
                                    <% using (Html.BeginForm("CrearDetalle", "FactorxNota", FormMethod.Post, new { id = "DetalleCrear" }))
                                    { %>
                                        <%: Html.Label("Factor:")%>&nbsp;
                                        <%: Html.TextBox("factor", null, new { @class = "required", @style = "width:40px" })%>
                                        <%--<%: Html.ValidationMessageFor(Model => detalles.First().factor) %>--%>
                                        &nbsp;&nbsp;&nbsp;
                                        <%: Html.Label("Nota:") %>&nbsp;
                                        <%: Html.TextBox("nota", null, new { @class = "required number", @style = "width:40px" })%>
                                        <%--<%: Html.ValidationMessageFor(Model => detalles.First().nota) %>--%>
                                        <%: Html.Hidden("detalle_id")%>
                                        <%: Html.Hidden("id_periodo")%>
                                        <input id="btnGuardarDetalle" type="button" value="Crear" onclick="guardarDetalle()" /> <br /><br />
                                    <% } %>

                                    <table id="tablaDetalle" width="100%">
                                    <thead>
                                        <tr> <th>Factor</th><th>Nota</th><th>Opciones</th> </tr>
                                    </thead>
                                    <tbody>
                                    <%--<% foreach (var item in detalles) { %>
                                        <tr>
                                            <td><%: item.id %></td>
                                            <td><%: item.factor %></td>
                                            <td><%: item.nota %></td>
                                            <td></td>
                                        </tr>
                                    <% } %>--%>
                                    </tbody>
                                    </table>
                                </fieldset>

                            </td>
                        </tr>
                    </table>

                </td>
            </tr>

        </table>
    </fieldset>
</asp:Content>
