<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Segmento
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Segmento</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
        });
    </script>

        <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formSegmento").validate({
                        rules: {
                            nombre: "required"
                        },
                        submitHandler: function (form) {
                            $("#crear").attr('disabled', true);
                            form.submit();
                        }
                    });               

                });
            </script>
            
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Crear nuevo Segmento</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "Segmento", FormMethod.Post, new { id = "formSegmento" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.SegmentoViewModel segmento =
                           (ColpatriaSAI.UI.MVC.Models.SegmentoViewModel)ViewData["SegmentoViewModel"]; %>
                    <p>
                        <%: Html.Label("Nombre")%>
                        <%: Html.TextBox("nombre", null, new { @class = "required", maxlength = 70 })%>
                        <%: Html.ValidationMessageFor(Model => segmento.SegmentoView.nombre)%>
                    </p>
                 
                  
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Nombre</th>
                       
                     
                    </tr>
                </thead>
                <tbody>
                  <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<Segmento>)ViewData["Segmentoes"])) { %>
                    <tr>
                        <td align=center>
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar Segmento', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Segmento', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td><%: item.id %></td>
                        <td><%: item.nombre %></td>
                       
                     
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>
