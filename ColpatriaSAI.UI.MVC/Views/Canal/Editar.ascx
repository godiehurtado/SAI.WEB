<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formCanalEditar").validate({
            
        });
    });
</script>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Canal", FormMethod.Post, new { id = "formCanalEditar" })) {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CanalViewModel canal =
                (ColpatriaSAI.UI.MVC.Models.CanalViewModel)ViewData["CanalViewModel"]; %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBoxFor(Model => canal.CanalView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => canal.CanalView.nombre)%>
        </p>
      
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>