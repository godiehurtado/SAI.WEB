<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Ramos Agrupados - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function cerrarDialog(dialog) {
            $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            $("#compania_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
        });
    </script>
    <script type="text/javascript">
        $.validator.setDefaults({});
        $().ready(function () {
            $("#formRamo").validate();
            $("#formRamo").validate({
                rules: { nombre: "required" }
            });

            $("#bProducto").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bPlan").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bRamos").button({ icons: { primary: "ui-icon ui-icon-carat-1-e"} });
            $("#bReporte").button({ icons: { primary: "ui-icon-script"} });
        });

        function eliminarRamo(id) {
            if (confirm("Esta seguro de eliminar este producto")) {
                $.ajax({ url: "/Ramo/Eliminar/", data: { id: id }, type: 'POST', // async: false,
                    success: function (result) {
                        if (result == "")
                            window.location.href = document.location.protocol + '//' + document.location.hostname +
                                (document.location.port != '' ? ':' + document.location.port : '') + '/Ramo/Index';
                        else
                            mostrarError(Error_Delete_Asociado);
                    }
                });
            }
        }
    </script>
    <div>
        <div style="float:left"><h2>Agrupación de Ramos</h2></div>
        <!--<div style="float:left; padding-left:30px; padding-top:5px;">
            <%: Html.ActionLink("Regresar", "Index", "Administracion", null, new { id = "bRegresar" })%>
        </div>-->
        
        <div style="float:right">
            <%: Html.ActionLink("Agrupar Productos", "Index", "Producto", null, new { id = "bProducto" })%>
            <%: Html.ActionLink("Agrupar Planes", "Index", "Plan", null, new { id = "bPlan" })%>
            <a href='#'  onclick="popupReport('ReporteCompania','');" title='Reporte de productos' id="bReporte" >Descargar</a>
            <%: Html.ActionLink("Listar Ramos Core", "Index", "RamoDetalle", new { id = 0 }, new { id = "bRamos" })%>
        </div>
        <div style="clear:both;"></div>
        <h4><%=Html.ActionLink("Regresar","Index","Administracion") %></h4>
    </div>
      <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
    <% if (TempData["Mensaje"] != null) { %> <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div> <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% using (Html.BeginForm("Crear", "Ramo", FormMethod.Post, new { id = "formRamo" })) {
                    Html.ValidationSummary(true); %>
                <% ColpatriaSAI.UI.MVC.Models.RamoViewModel ramo = (ColpatriaSAI.UI.MVC.Models.RamoViewModel)ViewData["RamoViewModel"]; %>
                <fieldset>
                <legend>Nueva agrupación:</legend>
                <table align="center" width="100%" cellpadding="2">
                    <tr>
                        <td><u><%: Html.Label("Nombre del ramo agrupado")%></u></td>
                        <td><%: Html.TextBox("nombre", null, new{ @class = "required", title = "Ingresar Nombre del Ramo Agrupado"} )%></td>

                        <td><u><%: Html.Label("Compañía")%></u></td>
                        <td><%: Html.DropDownList("compania_id", (SelectList)ramo.CompaniaList, "Seleccione un Valor",
                            new { style = "width:300px;", @class = "required", title = "Seleccionar Compañía"  })%></td>
                        <td>
                            <input type="submit" value="Guardar" />
                        </td>
                    </tr>
                </table>
                </fieldset>       
                <% } %>
            </td>
        </tr>
    </table>
    <br />

    <table  id="tablaLista">
    <thead> <tr> <th align="center">Compañía (de pago)</th> <th align="center">Ramo agrupado</th> <th align="center">Opciones</th> </tr> </thead>
    <tbody>
    <% Random random = new Random(); int num = random.Next(1, 10000);  %>
    <% foreach (var item in ((IEnumerable<Ramo>)ViewData["Ramos"])) { %>
        <tr>
            <td align="center"><%: item.Compania.nombre %></td>
            <td align="center"><%: item.nombre %></td>
            <td align="center">
            <div style="width:48px">
                <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Ramo Agrupado'><span class='ui-icon ui-icon-pencil' ></span></a>
                <a href="/RamoDetalle/Index/?r=<%: item.id %>" style='float:left;' title='Editar elementos de esta agrupación'><span class='ui-icon ui-icon-suitcase' ></span></a>
                <a href="javascript:eliminarRamo(<%: item.id %>);" style='float:left;' title='Eliminar Ramo Agrupado'><span class='ui-icon ui-icon-trash' ></span></a>
            </div>
            </td>
        </tr>
    <% } %>
    </tbody>
    </table>

    <div id='dialogEliminar' style="display:none;"></div>
    <div id='dialogEditar' style="display:none;"></div>
</asp:Content>