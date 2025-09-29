<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Create</h2>

<script src="<%: Url.Content("~/Scripts/jquery.validate.js") %>" type="text/javascript"></script>
<script src="<%: Url.Content("~/Scripts/jquery.validate.unobtrusive.js") %>" type="text/javascript"></script>

<% using (Html.BeginForm()) { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend>DetallePartFranquicia</legend>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.part_franquicia_id, "ParticipacionFranquicia") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("part_franquicia_id", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.part_franquicia_id) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.compania_id, "Compania") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("compania_id", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.compania_id) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.ramo_id, "Ramo") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("ramo_id", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.ramo_id) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.producto_id, "Producto") %>
        </div>
        <div class="editor-field">
            <%: Html.DropDownList("producto_id", String.Empty) %>
            <%: Html.ValidationMessageFor(model => model.producto_id) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.porcentaje) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.porcentaje) %>
            <%: Html.ValidationMessageFor(model => model.porcentaje) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.va_min) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.va_min) %>
            <%: Html.ValidationMessageFor(model => model.va_min) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.va_max) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.va_max) %>
            <%: Html.ValidationMessageFor(model => model.va_max) %>
        </div>

        <div class="editor-label">
            <%: Html.LabelFor(model => model.tipo_vehiculo_id) %>
        </div>
        <div class="editor-field">
            <%: Html.EditorFor(model => model.tipo_vehiculo_id) %>
            <%: Html.ValidationMessageFor(model => model.tipo_vehiculo_id) %>
        </div>

        <p>
            <input type="submit" value="Create" />
        </p>
    </fieldset>
<% } %>

<div>
    <%: Html.ActionLink("Back to List", "Index") %>
</div>

</asp:Content>
