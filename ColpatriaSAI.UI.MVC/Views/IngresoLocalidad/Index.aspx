<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.IngresoLocalidadModel>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ingresos por Localidad - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 250, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
        });
        $().ready(function () {
            $("#IngresoLocalidadCrear").validate({
                rules: { anio: { required: true, digits: true }, localidad_id: { required: true }, grupo_id: { required: true }, ingreso: { required: true, number: true} },
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }
            });
        });
    </script>

    <h2>Ingresos por localidad</h2>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"]%></div>
    <% } %>

      <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Adicionar Ingreso por localidad</h4>
                <% using (Html.BeginForm("Crear", "IngresoLocalidad", FormMethod.Post, new { id = "IngresoLocalidadCrear" }))
                   {
                       Html.ValidationSummary(true); %>
                <p>
                    <%: Html.Label("Año") %>
                    <%: Html.TextBox("anio", null, new { @size = "4"} )%>
                </p>
                <p>
                    <%: Html.Label("Localidad") %>
                    <%: Html.DropDownList("localidad_id", this.Model.Localidad, "Seleccione uno...")%>
                </p>
                <p>
                    <%: Html.Label("Grupo") %>
                    <%: Html.DropDownList("grupo_id", this.Model.Grupo, "Seleccione uno...")%>
                </p>
                <p>
                    <%: Html.Label("Ingreso") %>
                    <%: Html.TextBox("ingreso")%>
                </p>
                <p>
                    <input type="submit" value="Crear" id="crear" />
                </p>
                <% } %>
            </td>
            <td>
                <table id="tablaLista">
                    <thead>
                        <tr>
                            <th>Año</th>
                            <th>Localidad</th>
                            <th>Grupo</th>
                            <th>Ingreso</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% foreach (var item in this.Model.IngresosLocalidades)
                           { %>
                        <tr>
                            <td align="center"><%: item.año %></td>
                            <td><%: item.Localidad.nombre %></td>
                            <td><%: item.grupo %></td>
                            <td><%: item.valor %></td>
                            <td align="center">
                                <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>', 'Editar ingreso del grupo <%: item.grupo %> para el año <%: item.año %>', 'dialogEditar');">Editar</a>
                                &nbsp;|&nbsp;
                                <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>', 'Eliminar ingreso del grupo <%: item.grupo %> para el año <%: item.año %>', 'dialogEliminar');">Eliminar</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </td>
        </tr>
    </table>
    <div id='dialogEditar' style="display: none;">
    </div>
    <div id='dialogEliminar' style="display: none;">
    </div>

</asp:Content>