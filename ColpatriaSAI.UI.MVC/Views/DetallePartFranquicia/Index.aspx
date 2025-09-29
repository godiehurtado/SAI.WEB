<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Index</h2>

<p>
    <%: Html.ActionLink("Create New", "Create") %>
</p>
<table>
    <tr>
        <th>
            ParticipacionFranquicia
        </th>
        <th>
            Compania
        </th>
        <th>
            Ramo
        </th>
        <th>
            Producto
        </th>
        <th>
            porcentaje
        </th>
        <th>
            va_min
        </th>
        <th>
            va_max
        </th>
        <th>
            tipo_vehiculo_id
        </th>
        <th></th>
    </tr>

<% foreach (var item in Model) { %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.ParticipacionFranquicia.id) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.Compania.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.Ramo.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.Producto.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.porcentaje) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.va_min) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.va_max) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.tipo_vehiculo_id) %>
        </td>
        <td>
            <%: Html.ActionLink("Edit", "Edit", new { id=item.id }) %> |
            <%: Html.ActionLink("Details", "Details", new { id=item.id }) %> |
            <%: Html.ActionLink("Delete", "Delete", new { id=item.id }) %>
        </td>
    </tr>
<% } %>

</table>

</asp:Content>
