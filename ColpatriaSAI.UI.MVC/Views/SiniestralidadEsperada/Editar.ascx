<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formSiniestralidadEsperadaEditar").validate({

    });

});
</script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "SiniestralidadEsperada", FormMethod.Post, new { id = "formSiniestralidadEsperadaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.SiniestralidadEsperadaViewModel siniestralidadesperada = (ColpatriaSAI.UI.MVC.Models.SiniestralidadEsperadaViewModel)ViewData["SiniestralidadEsperadaViewModel"]; %>
          <fieldset style="border:1px solid gray">
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>                
                <td>
            <%: Html.Label("Valor")%>
                </td>
                <td>
            <%: Html.TextBoxFor(Model => siniestralidadesperada.SiniestralidadEsperadaView.valor, new { @class = "required decimal", title = "Ingrese Porcentaje de Siniestraldiad Esperada" })%> %
            <%: Html.ValidationMessageFor(Model => siniestralidadesperada.SiniestralidadEsperadaView.valor)%>
                </td>              
                </tr> 
              </table>
              </fieldset>

              <h5 align = "center"><u>Recuerde usar "," (coma) para identificar los números decimales</u></h5>
      
        <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>