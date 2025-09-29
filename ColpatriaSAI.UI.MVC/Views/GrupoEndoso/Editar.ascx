<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.GrupoEndoso>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#GrupoEndosoEditar").validate({
            rules: {
                nombre: "required"
            }
        });
    });
</script>

    <% using (Html.BeginForm("Editar", "GrupoEndoso", FormMethod.Post, new { id = "GrupoEndosoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBox("nombre")%>
            <%: Html.ValidationMessageFor(Model => Model.nombre)%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>