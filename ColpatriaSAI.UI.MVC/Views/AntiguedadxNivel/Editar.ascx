<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#AntiguedadEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "AntiguedadxNivel", FormMethod.Post, new { id = "AntiguedadEditar" })) {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.AntiguedadViewModel antiguedad = (ColpatriaSAI.UI.MVC.Models.AntiguedadViewModel)ViewData["EditarAntiguedad"]; %>
        <p>
            <%: Html.Label("Número de meses")%>
            <%: Html.TextBoxFor(Model => antiguedad.AntiguedadView.numeroMeses, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => antiguedad.AntiguedadView.numeroMeses)%>
        </p>
        <p>
            <%: Html.Label("Nivel")%>
            <%: Html.DropDownList("nivel_id", (SelectList)antiguedad.NivelList, "Seleccionar...", new { @class = "required" })%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>