<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#FactorxNotaEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "FactorxNota", FormMethod.Post, new { id = "FactorxNotaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.FactorxNotaViewModel factorxNota = (ColpatriaSAI.UI.MVC.Models.FactorxNotaViewModel)ViewData["FactorxNotaViewModel"]; %>
        <p>
            <%: Html.Label("Nota")%>
            <%: Html.TextBoxFor(Model => factorxNota.FactorxNotaView.nota, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => factorxNota.FactorxNotaView.nota)%>
        </p>
        <p>
            <%: Html.Label("Factor")%>
            <%: Html.TextBoxFor(Model => factorxNota.FactorxNotaView.factor, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => factorxNota.FactorxNotaView.factor)%>
        </p>
        <p>
            <%: Html.Label("Modelo")%>
            <%: Html.DropDownList("modelo_id", (SelectList)factorxNota.ModeloList, "Seleccionar...", new { @class = "required" })%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>