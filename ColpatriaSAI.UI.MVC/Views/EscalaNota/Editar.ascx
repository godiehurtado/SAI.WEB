<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#EscalaEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "EscalaNota", FormMethod.Post, new { id = "EscalaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.EscalaNotaViewModel escalaNota = (ColpatriaSAI.UI.MVC.Models.EscalaNotaViewModel)ViewData["EscalaNotaViewModel"]; %>
        <p>
            <%: Html.Label("Nota")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.nota, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.nota)%>
        </p>
        <p>
            <%: Html.Label("Porcentaje")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.porcentaje, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.porcentaje)%>
        </p>
        <p>
            <%: Html.Label("Tipo de escala")%>
            <%: Html.DropDownList("tipoEscala_id", (SelectList)escalaNota.TipoEscalaList, "Seleccionar...", new { @class = "required" })%>
        </p>
        <p>
            <%: Html.Label("Limite inferior")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.limiteInferior, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.limiteInferior)%>
        </p>
        <p>
            <%: Html.Label("Limite superior")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.limiteSuperior, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.limiteSuperior)%>
        </p>
        <p>
            <%: Html.Label("Fecha inicial")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.fechaIni, new { @readonly = "true", @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.fechaIni)%>
        </p>
        <p>
            <%: Html.Label("Fecha final")%>
            <%: Html.TextBoxFor(Model => escalaNota.EscalaNotaView.fechaFin, new { @readonly = "true", @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.fechaFin)%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>