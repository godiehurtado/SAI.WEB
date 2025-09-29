<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Plan>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Planes Agrupados - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 160, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNombre = document.getElementById('buscarNombre').value;
	            var bProducto = document.getElementById('buscarProducto').value;

	            var Nombre = aData[0];
	            var Producto = aData[1];

	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
	            var comparaProducto = Producto.toUpperCase().indexOf(bProducto.toUpperCase());

	            if ((comparaNombre >= 0) && (comparaProducto >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
	    function mostrarBusqueda() {
	        $("#busquedaAvanzada").toggle('slow');
	        $("#buscarNombre").attr("value", "");
	        $("#buscarProducto").attr("value", "");
	        oTable.fnDraw();
	    }
	</script>
    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
            $('#buscarProducto').keyup(function () { oTable.fnDraw(); });

            $("#formPlan").validate({
                rules: {
                    nombre: "required",
                    producto_id: "required"
                }
            });
            $("#bRamo").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bProducto").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bPlanes").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bReporte").button({ icons: { primary: "ui-icon-script"} });
        });
	</script>
    <script type="text/javascript">
        function editarPlan(id) {
            $('#btnCrear').attr("value", "Actualizar");
            $('#btnCancelarEdit').css("display", "block");
            $('#tablaLista').attr("disabled", "disabled");

            $('#id').val(id);
            $('#nombre').val(jQuery.trim($('#nombre' + id).text()));
            $('#producto_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#producto' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
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
            $('#producto_id option:first-child').attr('selected', 'selected');

            $('#tablaLista').removeAttr('disabled');
        }

        function eliminarPlan(id) {
            if (confirm("¿Esta seguro de eliminar este plan agrupado?")) {
                $.ajax({ url: "/Plan/Eliminar/", data: { id: id }, type: 'POST',
                    success: function (result) {
                        if (result == "")
                            window.location.href = document.location.protocol + '//' + document.location.hostname +
                                (document.location.port != '' ? ':' + document.location.port : '') + '/Plan/Index';
                        else
                            mostrarError(Error_Delete_Asociado);
                    }
                });
            }
        }
	</script>
    <div>
        <div style="float:left"><h2>Agrupación de Planes</h2></div>
        <div style="float:left; padding-left:30px; padding-top:5px;">
            <%: Html.ActionLink("Regresar", "Index", "Administracion", null, new { id = "bRegresar" })%>
        </div>
        <div style="float:right">
            <%: Html.ActionLink("Agrupar Ramos", "Index", "Ramo", null, new { id = "bRamo" })%>
            <%: Html.ActionLink("Agrupar Productos", "Index", "Producto", null, new { id = "bProducto" })%>
            <a href='#'  onclick="popupReport('ReporteCompania','');" title='Reporte de productos' id="bReporte" >Descargar</a>
            <%: Html.ActionLink("Listar Planes Core", "Detalle", "Plan", new { id = 0 }, new { id = "bPlanes" }) %>
        </div>
        <div style="clear:both;"></div>
    </div>

    <% if (TempData["Mensaje"] != null) { %> <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div> <% } %>
    <% string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>
    <% ColpatriaSAI.UI.MVC.Models.PlanViewModel plan = (ColpatriaSAI.UI.MVC.Models.PlanViewModel)ViewData["PlanViewModel"]; %>
    
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <fieldset>
                <% using (Html.BeginForm("Crear", "Plan", FormMethod.Post, new { id = "formPlan" })) {
                    Html.ValidationSummary(true); %>
                    <div id='dialogCrear' style="float:left">
                    <table>
                        <%: Html.Hidden("id", 0) %>
                        <tr>
                            <td><%: Html.Label("Plan agrupado:") %></td>
                            <td><%: Html.TextBox("nombre", "", new { title = "*" })%></td>

                            <td style="padding-left:15px;"><%: Html.Label("Producto agrupado:") %></td>
                            <td><%: Html.DropDownList("producto_id", (SelectList)plan.ProductoList, "Seleccione...", new {style = "width:250px", title = "*" })%></td>
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

    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
    <table border="0" cellspacing="3" cellpadding="3" id="busquedaAvanzada" style="display:none">
		<tr>
			<td><label for="buscarNombre">Nombre:</label></td>
			<td><input type="text" id="buscarNombre" name="buscarNombre" /></td>
			<td><label for="buscarProducto">Producto:</label></td>
			<td><input type="text" id="buscarProducto" name="buscarProducto" /></td>
		</tr>
	</table>

    <table  id="tablaLista">
        <thead>
            <tr>
                <th>Compañía de pago</th>
                <th>Ramo agrupado</th>
                <th>Producto agrupado</th>
                <th>Plan agrupado</th> 
                <th>Opciones</th> 
            </tr>
        </thead>
        <tbody>
        <% foreach (var item in ((IEnumerable<Plan>)ViewData["Planes"])) { %>
            <tr>
                <td id="compania<%: item.id %>">    <%: item.Producto.Ramo.Compania.nombre %></td>
                <td id="ramo<%: item.id %>">        <%: item.Producto.Ramo.nombre %></td>
                <td id="producto<%: item.id %>">    <%: item.Producto.nombre %></td>
                <td id="nombre<%: item.id %>">      <%: item.nombre %></td>
                <td>
                <div style="width:48px">
                    <a href="#" onclick="editarPlan(<%: item.id %>)" style='float:left;' title='Editar Producto Agrupado'><span class='ui-icon ui-icon-pencil'></span></a>
                    <a href="/Plan/Detalle/<%: item.id %>" style='float:left;' title='Editar elementos de esta agrupación'><span class='ui-icon ui-icon-suitcase'></span></a>
                    <a href="javascript:eliminarPlan(<%: item.id %>);" style='float:left;' title='Eliminar Producto Agrupado'><span class='ui-icon ui-icon-trash'></span></a>
                </div>
                </td>
            </tr>
        <% } %>
         </tbody>
    </table>

</asp:Content>