<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Beneficiario
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
   <h2>Beneficiario</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 160, width: 350, modal: true, title: titulo,
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




    <%  string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>

    

    <div id='dialogCrear' style="display:none;">
        <% using (Html.BeginForm("Crear", "Beneficiario")) {
            Html.ValidationSummary(true); %>
            <% ColpatriaSAI.UI.MVC.Models.BeneficiarioViewModel beneficiario = (ColpatriaSAI.UI.MVC.Models.BeneficiarioViewModel)ViewData["BeneficiarioViewModel"]; %>
            <p>
                <%: Html.Label("Nombre") %>
                <%: Html.TextBox("nombre")%>
                <%: Html.ValidationMessageFor(Model => beneficiario.BeneficiarioView.nombre)%>
            </p>
            <p>
                <%: Html.Label("Cliente") %>
                <%: Html.DropDownList("cliente_id", (SelectList)beneficiario.ClienteList)%>
            </p>
            
        <% } %>
    </div>
     <table id="tablaLista">
                <thead>
        <tr>
            <th></th>
            <th>Nombre</th>
            <th>Cliente</th>
        </tr>
        </thead>
      <tbody>
     <% foreach (var item in ((IEnumerable<Beneficiario>)ViewData["Beneficiarios"]))
       { %>
        <tr>
            <td>
               
            </td>
            
            <td><%: item.nombre %></td>
            <td><%: item.Cliente.nombre %></td>
        </tr>
    <% } %>
     </tbody>
                </table>

            </td>
        </tr>
    </table>
    
    
</asp:Content>