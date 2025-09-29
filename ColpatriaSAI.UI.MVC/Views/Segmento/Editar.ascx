<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formSegmentoEditar").validate({

    });
});
</script>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Segmento", FormMethod.Post, new { id = "formSegmentoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.SegmentoViewModel segmento =
                (ColpatriaSAI.UI.MVC.Models.SegmentoViewModel)ViewData["SegmentoViewModel"]; %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBoxFor(Model => segmento.SegmentoView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => segmento.SegmentoView.nombre)%>
        </p>
       
      
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>