<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.SalarioMinimo>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<script type="text/javascript">
    $().ready(function () {
        $("#SalarioMinimoEditar").validate({
            rules: { smlv: { required: true, number: true } }
        });
    });
</script>
<% using (Html.BeginForm("Editar", "SalarioMinimo", FormMethod.Post, new { id = "SalarioMinimoEditar" }))
   {
       Html.ValidationSummary(true); %>
<p>
    <label>SMLV</label>
    <%: Html.TextBoxFor(Model => Model.smlv)%>
    <%: Html.ValidationMessageFor(Model => Model.smlv)%>
</p>
<p>
    <input type="submit" value="Actualizar" />
</p>
<% } %>