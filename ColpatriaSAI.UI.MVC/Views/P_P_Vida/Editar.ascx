<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#P_P_VidaEditar").validate();
    });
</script>

     <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <% using (Html.BeginForm("Editar", "P_P_Vida", FormMethod.Post, new { id = "P_P_VidaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.P_P_VidaViewModel p_p_vida = (ColpatriaSAI.UI.MVC.Models.P_P_VidaViewModel)ViewData["P_P_VidaViewModel"]; %>
        <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        <tr>
             <td><%: Html.Label("Factor") %> </td>
             <td><%: Html.TextBoxFor(Model => p_p_vida.P_P_VidaView.factor, new { @class = "required decimal", title = "Ingrese el valor del factor" })%>
                 <%: Html.ValidationMessageFor(Model => p_p_vida.P_P_VidaView.factor)%></td>
        </tr>
        </table>        
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>

        <h5 align = "center"><u>Recuerde usar "," (coma) para identificar los números decimales</u></h5>