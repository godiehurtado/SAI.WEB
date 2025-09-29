<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
        
        <script type="text/javascript">
            $().ready(function () {
                $("#formPersistenciadeCAPIDetalleEditar").validate({
                });
            });
        </script>    

        <script type="text/javascript">
            function PersistenciadeCAPIDetalleSave() {
                    $("#editar").attr('disabled', true);
                    $("#formPersistenciadeCAPIDetalleEditar").submit();
                    mostrarCargando("Enviando informacion. Espere Por Favor...");               
            }
        </script>

        <% Html.EnableClientValidation(); %>
        <% using (Html.BeginForm("Editar", "PersistenciaCAPIDetalle", FormMethod.Post, new { id = "formPersistenciadeCAPIDetalleEditar" }))
           {
               Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.PersistenciaCAPIDetalleViewModel persistenciadecapidetalle = (ColpatriaSAI.UI.MVC.Models.PersistenciaCAPIDetalleViewModel)ViewData["PersistenciaCAPIDetalleViewModel"]; %>
        <table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0"
            cellpadding="0" style="padding-left: 50px">
            <tr>
                <td><%: Html.Label("Cumple?:")%></td>
                <% bool cumple = (bool)ViewBag.cumple; %>
                <% if (cumple == true)
                   { %>
                       <td><%: Html.DropDownList("cumple_Editar", new SelectList(new List<string>() { "SI", "NO" }))%></td>
                  <% } %> 
                <% else
                   { %>
                       <td><%: Html.DropDownList("cumple_Editar", new SelectList(new List<string>() { "NO", "SI" }))%></td>
                  <% } %>                
            </tr>
            <tr>
                <td><%: Html.Label("Comentarios") %></td>                
                <td><%: Html.TextAreaFor(Model => persistenciadecapidetalle.PersistenciaCAPIDetalleView.comentarios, new { @style = "height:200px;width:350px;border:#000000 1px solid;" })%>
                    <%: Html.ValidationMessageFor(Model => persistenciadecapidetalle.PersistenciaCAPIDetalleView.comentarios)%></td>
            </tr>
        </table>        
        <p align="center"><input type="button" value="Actualizar y recalcular" id = "editar" onclick="PersistenciadeCAPIDetalleSave()" /></p>
<% } %>