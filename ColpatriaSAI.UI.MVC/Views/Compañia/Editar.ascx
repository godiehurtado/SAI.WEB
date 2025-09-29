<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formCompaniaEditar").validate({

    });
});
</script>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Compañia", FormMethod.Post, new { id = "formCompaniaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CompaniaViewModel compania =
                (ColpatriaSAI.UI.MVC.Models.CompaniaViewModel)ViewData["CompaniaViewModel"]; %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBoxFor(Model => compania.CompaniaView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => compania.CompaniaView.nombre)%>
        </p>
      
        
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>