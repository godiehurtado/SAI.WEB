<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Crear modelo de contratación - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <script type="text/javascript">
        $(document).ready(function () {
            $("#ModeloCrear").validate();
            $("#DetalleCrear").validate();

            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });

            if ($('#descripcion').val() != '') {
                $('h2').text('Modelos de Contratación / Editar Modelo. ');
                $('#ModeloCrear').attr('style', 'display: block;');
                $('#btnGuardarModelo').val("Actualizar");
                guardarModelo(false);
            }

            //            $('#tablaLista tbody tr').each(function () { });

            var factor = $('#factorxnota_id');
            var factorVal = $('#factorxnota_id :selected').val();
            factor.change(function () {
                var mensaje = "¿Asociar este factor al modelo?";
                if ($('#factorxnota_id :selected').val() == "") mensaje = "¿Desea desasociar el factor de este modelo?";

                if (confirm(mensaje)) {
                    AsociarFactor($("#modelo_id").val(), factor.val() == "" ? 0 : factor.val());
                } else {
                    $('#factorxnota_id option').each(function () {
                        if ($(this).val() == factorVal) {
                            $(this).attr('selected', 'selected');
                        };
                    });
                }
            });

        });

        function AsociarFactor(modelo, factor) {
            mostrarCargando(Procesando);
            $.ajax({ url: '/Modelo/AsociarFactor', data: { modelo: modelo, factor: factor }, type: "POST",
                success: function (result) {
                    if ($(result).length > 1) mostrarError('Error: ' + result); else mostrarExito(Exito_Insert);
                },
                complete: function () { closeNotify("jNotify"); }
            });
        }

        function guardarModelo(recargarPagina) {
            $('#btnGuardarModelo').attr("disabled", true);
            if ($("#descripcion").val() != "")
            {
                mostrarCargando(Procesando);
                $.ajax({ url: $("#ModeloCrear").attr('action'), data: $("#ModeloCrear").serialize(), type: "POST",
                    success: function (result) {

                        if (recargarPagina)
                            window.location.href = "/Modelo/Crear/" + result[0].modelo_id;
                        else {
                            $("#detalles").show();
                            $("#fieldFactor").show();

                            if (result[0].nombre != null) {
                                var totalPeso = 0;

                                $(result).each(function () {
                                    agregarFila(this); totalPeso = redondear(totalPeso + this.peso, 3);
                                });
                                $('#totalPeso').text(totalPeso);
                            }
                            $("#modelo_id").val(result[0].modelo_id); //AsociarFactor(); //aplicarPaginado('#tablaLista');
                            $("#modelo_idTemp").val(result[0].modelo_id);
                            $('#btnGuardarModelo').attr("disabled", false);
                            $('#btnGuardarModelo').val("Actualizar");
                            closeNotify("jNotify"); 
                        }
                    }
                });
            } else {
                
            }
        }

        function guardarDetalle() {
            if (isNaN(parseFloat($('#totalPeso').text()))) $('#totalPeso').text(0);

            /*$("#tablaLista tbody tr").each(function () { alert($(this + " td").text()); });*/

            if (($("#meta_id").val() != "") && ($("#peso").val() != "") && ($("#id_factorxnota").val() != "")) {

                if (redondear(parseFloat($('#totalPeso').text()) + parseFloat($("#peso").val()), 0) <= 100) {
                    mostrarCargando(Procesando);
                    $('#meta').val($("#meta_id :selected").text())
                    $.ajax({
                        url: $("#DetalleCrear").attr('action'), data: $("#DetalleCrear").serialize(), type: "POST",
                        success: function (result) {
                            if (result.id != "0") {
                                agregarFila(result);
                                $('#totalPeso').text(parseFloat($('#totalPeso').text()) + result.peso);
                                mostrarExito(Exito_Insert);
                                $("#meta_id").val("");
                                $("#peso").val("");
                                $("#id_factorxnota").val("");
                            } else {
                                mostrarError(Error_Insert_Duplicado);
                            }
                        },
                        complete: function () { closeNotify("jNotify"); }
                    });
                } else {
                    mostrarError("No puede ingresar mas asociaciones. El total de pesos se encuentra o superaría el 100%");
                }
            } else mostrarError(Error_Validacion);
        }

        function eliminarDetalle(id) {
            if (confirm('¿Esta seguro de eliminar esta asociación?')) {
                mostrarCargando(Procesando);
                $.ajax({
                    url: '/Modelo/EliminarModeloxMeta', data: { id: id }, type: "POST",
                    success: function (result) {
                        if (result != "0") {
                            $('#totalPeso').text(parseFloat($('#totalPeso').text()) - parseFloat($('#cell2' + id).text()));
                            eliminarFilaTabla(oTable, '#tablaLista', id); mostrarExito(Exito_Delete);
                        } else {
                            mostrarError(Error_Delete_Asociado);
                        }
                    },
                    complete: function () { closeNotify("jNotify"); }
                });
            }
        }

        function editarDetalle(id) {
            $("#meta_id").find('option:contains(' + $('#cell1' + id).text() + ')').each(function () {
                if ($(this).text() == $('#cell1' + id).text()) $(this).attr("selected", "selected");
            });
            $("#peso").val($('#cell2' + id).text());
            $("#meta").val(id);
        }

        function agregarFila(fila) {
            var filaNueva = $(
                "<tr id='fila" + fila.id + "' align='center'>" +
                "<td id='cell1" + fila.id + "' style='background-color:#e2e4ff'>" + fila.meta_id + "</td>" +
                "<td id='cell1" + fila.id + "' style='background-color:#e2e4ff'>" + fila.nombre + "</td>" +
                "<td id='cell2" + fila.id + "' style='background-color:#e2e4ff'>" + redondear(fila.peso, 3) + "</td>" +
                "<td id='cell3" + fila.id + "' style='background-color:#e2e4ff'>" + fila.factorxNota + "</td>" +
                "<td style='background-color:#e2e4ff'>" +
                    //"<a href='#' onClick='editarDetalle(" + fila.id + ")' title='Editar' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-pencil'/></a>" +
                    "<a href='#' onClick='eliminarDetalle(" + fila.id + ")' title='Eliminar' class='ui-state-default ui-corner-all'  style='float:left;'><span class='ui-icon ui-icon-trash'/></a>" +
                "</td></tr>");
            oTable.fnAddTr($(filaNueva)[0]);
        }
    </script>
    
    <% Modelo modelo = (Modelo)ViewData["Modelo"]; ModeloXMetaViewModel modelos = (ModeloXMetaViewModel)ViewData["ModelosXMetas"]; %>
    <h2>Crear nuevo modelo de contratación</h2>
    
    <%: Html.ActionLink("Regresar", "Index") %> <br /><br />

    <%--<fieldset id="fieldCrear"><legend>Crear modelo</legend>--%>
        <% using (Html.BeginForm("Crear", "Modelo", FormMethod.Post, new { id = "ModeloCrear" })) {
            Html.ValidationSummary(true); %>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBox("descripcion", modelo.descripcion, new { @class = "required", @style = "width:400px" })%>
            <%: Html.ValidationMessageFor(model => modelo.descripcion)%>
            &nbsp;&nbsp;            
            <input id="modelo_idTemp" name="modelo_idTemp" type="hidden" value="0" />
            <input id="btnGuardarModelo" type="button" value="Crear" onclick="guardarModelo(true);" />
            <br/><br/>
        <% } %>

        <fieldset id="fieldFactor" style="display:none"><legend>Asociar una escala a este modelo</legend>
            <%: Html.DropDownList("factorxnota_id", (SelectList)ViewBag.Factor, "Seleccione...", new { @class = "required" })%>
        </fieldset>
        <br /><br />
        <fieldset id="detalles" style="display:none"><legend>Incluir detalles del modelo </legend>
            <table id="tablaLista">
                <thead>
                <tr>
                    <td colspan="5" style="background-color:White; border-color:White;">&nbsp;
                    <% using (Html.BeginForm("CrearDetalle", "Modelo", FormMethod.Post, new { id = "DetalleCrear" })) {
                        Html.ValidationSummary(true); %>
                            <%: Html.Label("Meta:")%>
                            <%: Html.DropDownList("meta_id", (SelectList)modelos.MetaList, "Seleccione...", new { @class = "required", @style = "font-size:12px" })%>
                            &nbsp;
                            <%: Html.Label("Peso:")%>
                            <%: Html.TextBox("peso", null, new { @class = "required number", @style = "width:40px" })%>&nbsp;<%: Html.Label("%")%>
                            &nbsp;
                            <br/><br/>
                            <%: Html.Label("Escala Metas:")%>
                            <%: Html.DropDownList("id_factorxnota", (SelectList)modelos.FactorList, "Seleccione...", new { @class = "required", @style = "font-size:12px" })%>

                            <%: Html.Hidden("modelo_id") %>
                            <%: Html.Hidden("meta")%>
                            &nbsp;&nbsp;&nbsp;
                            <input type="button" value="Guardar" onclick="guardarDetalle()" />
                            <div style="position:relative; left:650px; width:100px; font-size:13px; font-weight:bold">
                                Total: <span id="totalPeso" />
                            </div>
                    <% } %>
                    </td>
                </tr>
                <tr>
                    <th>Id Meta</th><th>Meta</th><th>Peso</th><th>Escala Meta</th><th style="width:10">Opciones</th>
                </tr>
                </thead>
                <tbody class="dataTemp"></tbody>
            </table>
        </fieldset>
    <%--</fieldset>--%>
    
</asp:Content>
<%--                    $idTabla.append("<tr><td>AAA</td><td>AAA</td><td>AAA</td></tr>");
                    $('#tablaLista > tbody').find('tr:last').append('<tr><td></td><td></td><td></td></tr>');
                    $("#tablaLista").find('tbody')
                        .append($('<tr>')
                            .append($('<td>')
                                .append($('<img>')
                                    .attr('src', 'img.png')
                                    .text('Image cell')
                                )
                            )
                        );--%>