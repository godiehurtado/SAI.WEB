<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<script type="text/javascript">
    $().ready(function () {
        $("#formUnidadMedidaEditar").validate({

    });

});
</script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "UnidadMedida", FormMethod.Post, new { id = "formUnidadMedidaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.UnidadMedidaViewModel unidadmedida =
                (ColpatriaSAI.UI.MVC.Models.UnidadMedidaViewModel)ViewData["UnidadMedidaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                 <tr>                
                <td>
             <%: Html.Label("Nombre")%>
                </td>
                <td>
             <%: Html.TextBoxFor(Model => unidadmedida.UnidadMedidaView.nombre, new { @class = "required" })%>
             <%: Html.ValidationMessageFor(Model => unidadmedida.UnidadMedidaView.nombre)%>
                </td>              
                </tr> 
                <tr>                
                <td>
             <%: Html.Label("Tipo Unidad de Medida")%>
                </td>
                <td>
             <%: Html.DropDownList("tipounidadmedida_id", (SelectList)unidadmedida.TipoUnidadMedidaList, "Seleccione un Valor", new { @class = "required" })%>
                </td>              
                </tr>                                           
              </table>
        
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>