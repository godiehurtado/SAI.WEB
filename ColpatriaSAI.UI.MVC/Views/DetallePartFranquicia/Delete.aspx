<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Delete
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Delete</h2>

<h3>Esta usted seguro de eliminar este registro?</h3>
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

    <div class="display-label">Rango Inferior</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.rangoinferior) %>
    </div>

    <div class="display-label">Rango Superior</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.rangosuperior) %>
    </div>

    <div class="display-label">Tipo de Vehiculo</div>
    <div class="display-field">
        <%: Html.DisplayFor(model => model.tipoVehiculo_id) %>
    </div>
</fieldset>
<% using (Html.BeginForm()) { %>
    <p>
        <input type="submit" value="Eliminar" /> |
        <%: Html.ActionLink("Regresar", "Index") %>
    </p>
<% } %>

</asp:Content>
