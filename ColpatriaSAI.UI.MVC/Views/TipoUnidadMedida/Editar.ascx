<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<script type="text/javascript">
    $().ready(function () {
        $("#formTipoUnidadMedidaEditar").validate({

    });

});
</script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "TipoUnidadMedida", FormMethod.Post, new { id = "formTipoUnidadMedidaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.TipoUnidadMedidaViewModel tipounidadmedida =
                (ColpatriaSAI.UI.MVC.Models.TipoUnidadMedidaViewModel)ViewData["TipoUnidadMedidaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                 <tr>                
                <td>
             <%: Html.Label("Nombre")%>
                </td>
                <td>
             <%: Html.TextBoxFor(Model => tipounidadmedida.TipoUnidadMedidaView.nombre, new { @class = "required" })%>
             <%: Html.ValidationMessageFor(Model => tipounidadmedida.TipoUnidadMedidaView.nombre)%>
                </td>              
                </tr> 
                </table>
        
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>