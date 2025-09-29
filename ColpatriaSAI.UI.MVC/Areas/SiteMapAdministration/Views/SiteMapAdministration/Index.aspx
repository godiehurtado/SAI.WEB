<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.SiteMap>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Administración Permisos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                "bStateSave": true
            });
        });
    </script>

    <h2>Administración Permisos</h2>

    <table id="tablaLista">
    <thead>
        <tr>
            <th>Opciones</th>
            <th style="visibility: hidden; display: none">
                Código
            </th>
            <th>
                Título
            </th>
            <th>
                Descripción
            </th>
            <th style="visibility: hidden; display: none">
                Controlador
            </th>
            <th style="visibility: hidden; display: none">
                Acción
            </th>
            <th style="visibility: hidden; display: none">
                PARAMID
            </th>
            <th style="visibility: hidden; display: none">
                URL
            </th>
            <th style="visibility: hidden; display: none">
                Página padre
            </th>
            <th>
                Roles
            </th>
        </tr>
    </thead>
    <tbody>
    <% foreach (var item in Model) { %>
        <tr>
            <td align="center">
                <%: Html.ActionLink("Editar", "Edit", new { id=item.ID }) %> 
               <%-- <%: Html.ActionLink("Details", "Details", new { /* id=item.PrimaryKey */ })%> |--%>
               <%-- <%: Html.ActionLink("Borrar", "Delete", new { /* id=item.PrimaryKey */ })%>--%>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.ID %>
            </td>
            <td>
                <%: item.TITLE %>
            </td>
            <td>
                <%: item.DESCRIPTION %>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.CONTROLLER %>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.ACTION %>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.PARAMID %>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.URL %>
            </td>
            <td style="visibility: hidden; display: none">
                <%: item.PARENT_ID %>
            </td>
            <td>
                <ul class="listaRoles">
                <%

           
                    string[] roleList = item.Roles.Split(',');
                    foreach(string rol in roleList){
                %>
                        <li><%: rol %></li>
                <%        
                    }
                    //item.Roles 
                %>
                </ul>
            </td>
        </tr>
    
    <% } %>
    </tbody>
    </table>

    <p>
        <%--<%: Html.ActionLink("Crear Nuevo", "Create") %>--%>
    </p>
    
</asp:Content>