<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formCompaniaxEtapaEditar").validate({
    });
});
</script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "CompaniaxEtapa", FormMethod.Post, new { id = "formCompaniaxEtapaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CompaniaxEtapaViewModel companiaxetapa =
                (ColpatriaSAI.UI.MVC.Models.CompaniaxEtapaViewModel)ViewData["CompaniaxEtapaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
             <tr>
                <td><%: Html.Label("Mes Inicial:")%></td>
                <td><%: Html.DropDownList("mes_inicio")%></td>
             </tr>
             <tr>
                <td><%: Html.Label("Mes Final:")%></td>
                <td><%: Html.DropDownList("mes_fin")%></td>
             </tr>
              </table>
        <input type="hidden" id="etapa_id" name="etapa_id" value="<%: ViewData["valuet"] %>" />
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>