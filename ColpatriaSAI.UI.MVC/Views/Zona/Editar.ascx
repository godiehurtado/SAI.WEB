<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.Zona>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#ZonaEditar").validate({
            rules: { nombre: "required" }
        });
    });
</script>

    <% using (Html.BeginForm("Editar", "Zona", FormMethod.Post, new { id = "ZonaEditar" })) { %>
        <%: Html.ValidationSummary(true) %>
        <p>
            <%: Html.Label("Nombre") %>
            <%: Html.TextBoxFor(Model => Model.nombre)%>
            <%: Html.ValidationMessageFor(Model => Model.nombre)%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>

    <% } %>