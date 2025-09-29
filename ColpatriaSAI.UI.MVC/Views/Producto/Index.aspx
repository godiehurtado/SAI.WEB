<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Productos Agrupados - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog, altura, ancho) {
            $("#" + dialog).dialog({
                height: 190, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function editarProducto(id) {
            $('#btnCrear').attr("value", "Actualizar");
            $('#btnCancelarEdit').css("display", "block");
            $('#tablaLista').attr("disabled", "disabled");

            $('#id').val(id);
            $('#nombre').val(jQuery.trim($('#nombre' + id).text()));
            $('#ramo_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#ramo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#amparo_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#amparo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#cobertura_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#cobertura' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#plazo_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#plazo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#nombre').focus(); $('#nombre').select();
        }

        function cancelarEdicion() {
            inicializarControles();
            $('#btnCrear').attr("value", "Guardar");
            $('#btnCancelarEdit').css("display", "none");
        }

        function inicializarControles() {
            $('#id').val(0);
            $('#nombre').val("");
            $('#ramo_id option:first-child').attr('selected', 'selected');
            $('#amparo_id option:first-child').attr('selected', 'selected');
            $('#cobertura_id option:first-child').attr('selected', 'selected');
            $('#plazo_id option:first-child').attr('selected', 'selected');

            $('#tablaLista').removeAttr('disabled');
        }

        function eliminarProducto(id) {
            if (confirm("Esta seguro de eliminar este producto")) {
                $.ajax({ url: "/Producto/Eliminar/", data: { id: id }, type: 'POST',// async: false,
                    success: function (result) {
                        if (result == "")
                            window.location.href = document.location.protocol + '//' + document.location.hostname +
                                (document.location.port != '' ? ':' + document.location.port : '') + '/Producto/Index';
                        else
                            mostrarError(Error_Delete_Asociado);
                    }
                });
            }
        }

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            $("#formProducto").validate();
            $("#bRamo").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bPlan").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bProductos").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bReporte").button({ icons: { primary: "ui-icon-script"} });
        });
    </script> 

    <% string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>
    <% Random random = new Random(); int num = random.Next(1, 10000);  %>
    <div>
        <div style="float:left"><h2>Agrupación de Productos</h2></div>
        <!--<div style="float:left; padding-left:30px; padding-top:5px;">
            <%: Html.ActionLink("Regresar", "Index", "Administracion", null, new { id = "bRegresar" })%>
        </div>-->
        <div style="float:right">
            <%: Html.ActionLink("Agrupar Ramos", "Index", "Ramo", null, new { id = "bRamo" })%>
            <%: Html.ActionLink("Agrupar Planes", "Index", "Plan", null, new { id = "bPlan" })%>
            <a href='#'  onclick="popupReport('ReporteCompania','');" title='Reporte de productos' id="bReporte" >Descargar</a>
            <%: Html.ActionLink("Listar Productos Core", "Detalle", "Producto", new { id = 0 }, new { id = "bProductos" })%>
        </div>
        <div style="clear:both;"></div>
        <h4><%=Html.ActionLink("Regresar","Index","Administracion") %></h4>
    </div>
    <% if (TempData["Mensaje"] != null) { %> <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div> <% } %>
    
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <fieldset>
                    <div style="float:left">
                    <% using (Html.BeginForm("Crear", "Producto", FormMethod.Post, new { id = "formProducto" })) {
                        Html.ValidationSummary(true); %>
                    <table>
                        <%: Html.Hidden("id", 0) %>
                        <tr>
                            <td><u><%: Html.Label("Nombre")%></u></td>
                            <td><%: Html.TextBox("nombre", null, new { @class = "required", title = "Ingresar nombre del Producto Agrupado" })%></td>

                            <td style="padding-left:10px;"><u><%: Html.Label("Ramo")%></u></td>
                            <td><%: Html.DropDownList("ramo_id", (SelectList)ViewBag.Ramos, "Seleccione...", new { @class = "required", 
                                title = "Seleccione un ramo" }) %></td>

                            <td style="padding-left:10px;"><%: Html.Label("Plazo")%></td>
                            <td><%: Html.DropDownList("plazo_id", (SelectList)ViewBag.Plazos, "Seleccione...", new { title = "Seleccione un plazo" }) %></td>
                        </tr>
                    </table>
                    </div>
                    <div style="float:left; padding-left:10px;">
                        <input type="submit" value="Guardar" id="btnCrear" style="float:left; margin-right:10px;" />
                        <input type="button" value="Cancelar edición" onclick="cancelarEdicion()" style="display:none; float:left;" id="btnCancelarEdit" />
                    </div>
                    <% } %>
                </fieldset>
            </td>
        </tr>
    </table>
    <br />

    <table id="tablaLista">
    <thead>
        <tr> <th align="center">Compañía de pago</th> <th align="center">Ramo agrupado</th> <th align="center">Producto agrupado</th> <th align="center">Plazo</th> <th align="center">Opciones</th> </tr>
    </thead>
    <tbody>
    <% foreach (var item in (IEnumerable<Producto>)ViewBag.Productos) { %>
        <tr> 
            <td id="compania<%: item.id %>">    <%: item.Ramo.Compania.nombre %></td>
            <td id="ramo<%: item.id %>">    <%: item.Ramo.nombre %></td>
            <td id="nombre<%: item.id %>">  <%: item.nombre %></td>
            <td id="plazo<%: item.id %>">   <%: item.Plazo != null ? item.Plazo.nombre : "" %></td>
            <td>
            <div style="width:48px">
                <a href="#" onclick="editarProducto(<%: item.id %>)" style='float:left;' title='Editar Producto Agrupado'><span class='ui-icon ui-icon-pencil'/></a>
                <a href="/Producto/Detalle/<%: item.id %>" style='float:left;' title='Editar elementos de esta agrupación'><span class='ui-icon ui-icon-suitcase'/></a>
                <a href="javascript:eliminarProducto(<%: item.id %>);" style='float:left;' title='Eliminar Producto Agrupado'><span class='ui-icon ui-icon-trash'/></a>
            </div>
            </td>
        </tr>
    <% } %>
    </tbody>
    </table>

</asp:Content>