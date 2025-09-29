<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Salario Mínimo - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, modal: true, title: titulo,
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
            $("#SalarioMinimoCrear").validate({
                rules: { anio: { required: true, digits: true } , smlv: { required: true, number: true }},
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }
            });
        });
    </script>

    <h2>Salario mínimo</h2>
    
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
                <h4>Adicionar Salario Mínimo</h4>
                <% using (Html.BeginForm("Crear", "SalarioMinimo", FormMethod.Post, new { id = "SalarioMinimoCrear" }))
                   {
                       Html.ValidationSummary(true); %>
                <p>
                    <%: Html.Label("Año") %>
                    <%: Html.TextBox("anio")%>
                    <%: Html.ValidationMessageFor(Model => ((IEnumerable<SalarioMinimo>)ViewData["SalarioMinimo"]).First().anio)%>
                </p>
                <p>
                    <%: Html.Label("SMLV") %>
                    <%: Html.TextBox("smlv")%>
                    <%: Html.ValidationMessageFor(Model => ((IEnumerable<SalarioMinimo>)ViewData["SalarioMinimo"]).First().smlv)%>
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
                            <th>SMLV</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% foreach (var item in ((IEnumerable<SalarioMinimo>)ViewData["SalarioMinimo"]))
                           { %>
                        <tr>
                            <td align="center"><%: item.anio %></td>
                            <td><%: item.smlv %></td>
                            <td align="center">
                                <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>', 'Editar salario:  <%: item.anio %>', 'dialogEditar');">Editar</a>
                                &nbsp;|&nbsp;
                                <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>', 'Eliminar salario:  <%: item.anio %>', 'dialogEliminar');">Eliminar</a>
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
