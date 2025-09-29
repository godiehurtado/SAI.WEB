<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formEtapaEditar").validate({

    });

});
</script>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "EtapaProducto", FormMethod.Post, new { id = "formEtapaEditar"}))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.EtapaProductoViewModel etapaproducto =
                (ColpatriaSAI.UI.MVC.Models.EtapaProductoViewModel)ViewData["EtapaProductoViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
              <tr>
              <td>
            <%: Html.Label("Nombre: ")%>
               </td>
               <td>
            <%: Html.TextBoxFor(Model => etapaproducto.EtapaProductoView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => etapaproducto.EtapaProductoView.nombre)%>
                </td>                   
                </tr>     
                
                </table>
              
        <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>