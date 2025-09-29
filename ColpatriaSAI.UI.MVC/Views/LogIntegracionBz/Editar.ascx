<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#LogIntegracionEditar").validate();
    });
</script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#fechaInicialEdit').datepicker({ dateFormat: 'yy-mm-dd',
                changeMonth: true,
                changeYear: true
            });
        });
    </script>

     <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <% using (Html.BeginForm("Editar", "LogIntegracionBz", FormMethod.Post, new { id = "LogIntegracionEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.LogIntegracionBzViewModel logintegracionbz = (ColpatriaSAI.UI.MVC.Models.LogIntegracionBzViewModel)ViewData["LogIntegracionBzViewModel"]; %>
        <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        
        <tr>
             <td><label for="FechaInicial">Fecha Inicial:</label></td>
             <td><%: Html.TextBox("fechaInicialEdit",  String.Format("{0:d}",logintegracionbz.LogIntegracionBzView.fechaInicial), new { @readonly = "true", id = "fechaInicialEdit" })%>
                 <%: Html.ValidationMessageFor(Model => logintegracionbz.LogIntegracionBzView.fechaInicial)%></td>
        </tr>
        </table>
        
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>