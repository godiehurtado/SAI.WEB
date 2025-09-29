<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#formRamoEditar").validate({
        });
    });
    </script>

    <script type="text/javascript">
    $(function () {
        $("#compania_id option").each(function () {
            $(this).attr({ 'title': $.trim($(this).html()) });
        });
    });
    </script>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
       
    <% } %>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Ramo", FormMethod.Post, new { id = "formRamoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.RamoViewModel ramo =
                (ColpatriaSAI.UI.MVC.Models.RamoViewModel)ViewData["RamoViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="5" cellpadding="0" style="padding-left:10px">
              <tr>
                  <td><u><%: Html.Label("Nombre")%></u></td>
                  <td><%: Html.TextBoxFor(Model => ramo.RamoView.nombre, new { @class = "required", title = "Ingresar Nombre del Ramo Agrupado" })%>
                      <%: Html.ValidationMessageFor(Model => ramo.RamoView.nombre)%></td>                   
              </tr>
              <tr>
                  <td><u><%: Html.Label("Compañia") %></u></td>
                  <td><%: Html.DropDownList("compania_id", (SelectList)ramo.CompaniaList, "Seleccione un Valor", new { @class = "required", style = "width:150px;", title = "Seleccionar Compañía" })%></td>   
              </tr>
              <tr>
                <td colspan="2">Recuerde que el sistema no permite utilizar el mismo nombre de ramo en la misma compañía.</td>
              </tr>  
              <tr>
                <td colspan="2"><input type="submit" value="Actualizar" /></td>
              </tr>  
              </table>
      
    <% } %>
