<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#BaseEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "BasexParticipante", FormMethod.Post, new { id = "BaseEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.BasexParticipanteViewModel basexParticipante =
                (ColpatriaSAI.UI.MVC.Models.BasexParticipanteViewModel)ViewData["BasexParticipanteViewModel"]; %>
        <p>
            <%: Html.Label("Base") %>
            <%: Html.TextBoxFor(Model => basexParticipante.BasexParticipanteView.@base, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => basexParticipante.BasexParticipanteView.@base)%>
        </p>
        <p>
            <%: Html.Label("Salario")%>
            <%: Html.TextBoxFor(Model => basexParticipante.BasexParticipanteView.salario, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => basexParticipante.BasexParticipanteView.salario)%>
        </p>
        <p>
            <%: Html.Label("Participante")%>
            <%: Html.DropDownList("participante_id", (SelectList)basexParticipante.ParticipanteList, "Seleccionar...", new { @class = "required" })%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>