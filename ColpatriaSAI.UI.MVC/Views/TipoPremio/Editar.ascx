<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>


<script type="text/javascript">
    $().ready(function () {
        $("#formTipoPremioEditar").validate({

    });

});
</script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "TipoPremio", FormMethod.Post, new { id = "formTipoPremioEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.TipoPremioViewModel tipopremio =
                (ColpatriaSAI.UI.MVC.Models.TipoPremioViewModel)ViewData["TipoPremioViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                 <tr>                
                <td>
             <%: Html.Label("Nombre")%>
                </td>
                <td>
             <%: Html.TextBoxFor(Model => tipopremio.TipoPremioView.nombre, new { @class = "required" })%>
             <%: Html.ValidationMessageFor(Model => tipopremio.TipoPremioView.nombre)%>
                </td>              
                </tr> 
                <tr>                
                <td>
             <%: Html.Label("Unidad de Medida")%>
                </td>
                <td>
             <%: Html.DropDownList("unidadmedida_id", (SelectList)tipopremio.UnidadMedidaList, "Seleccione un Valor", new { @class = "required" })%>
                </td>              
                </tr>
                <tr>
                <td><%: Html.Label("Genera Pago")%></td>
                <td>
                    <%: Html.DropDownList("generapago", (SelectList)tipopremio.PagoList, "Seleccione un Valor", new { @class = "required" })%>
                </td>
                </tr>
                             
              </table>
        
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>