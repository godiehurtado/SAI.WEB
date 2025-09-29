<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.TipoEndoso>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#TipoEndosoEditar").validate({
            rules: {
                nombre: "required"
            }
        });
    });
</script>

    <% using (Html.BeginForm("Editar", "TipoEndoso", FormMethod.Post, new { id = "TipoEndosoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBox("nombre")%>
            <%: Html.ValidationMessageFor(Model => Model.nombre)%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>