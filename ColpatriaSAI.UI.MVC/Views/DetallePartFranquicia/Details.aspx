<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Details
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Details</h2>

<fieldset>
    <legend>DetallePartFranquicia</legend>

    <div class="display-label">ParticipacionFranquicia</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.ParticipacionFranquicia.id) %>
    </div>

    <div class="display-label">Compania</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.Compania.nombre) %>
    </div>

    <div class="display-label">Ramo</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.Ramo.nombre) %>
    </div>

    <div class="display-label">Producto</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.Producto.nombre) %>
    </div>

    <div class="display-label">porcentaje</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.porcentaje) %>
    </div>

    <div class="display-label">va_min</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.va_min) %>
    </div>

    <div class="display-label">va_max</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.va_max) %>
    </div>

    <div class="display-label">tipo_vehiculo_id</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.tipo_vehiculo_id) %>
    </div>
</fieldset>
<p>

    <%: Html.ActionLink("Edit", "Edit", new { id=Model.id }) %> |
    <%: Html.ActionLink("Back to List", "Index") %>
</p>

</asp:Content>
