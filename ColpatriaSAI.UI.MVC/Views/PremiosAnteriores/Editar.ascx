<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
        
        <script type="text/javascript">
            $().ready(function () {
                $("#formPremiosAnterioresEditar").validate({
            });
        });
        </script>
        
        <script type="text/javascript">
            var era;
            function uncheckRadio(rbutton) {
                if (rbutton.checked == true && era == true) { rbutton.checked = false; }
                era = rbutton.checked;
            }
        </script>       

        <script type="text/javascript">
            function PremioAnteriorSave() {
                if ($("#FASECOLDA_Editar")[0].checked == true || $("#LIMRA_Editar")[0].checked == true) {
                    $("#editar").attr('disabled', true);
                    $("#formPremiosAnterioresEditar").submit();
                    mostrarCargando("Enviando informacion. Espere Por Favor...");
                }

                else {
                    mostrarError("El Premio no se ha asignado!");
                }      
            }
        </script>

        <% Html.EnableClientValidation(); %>
        <% using (Html.BeginForm("Editar", "PremiosAnteriores", FormMethod.Post, new { id = "formPremiosAnterioresEditar" }))
           {
               Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.PremiosAnterioresViewModel premiosanteriores = (ColpatriaSAI.UI.MVC.Models.PremiosAnterioresViewModel)ViewData["PremiosAnterioresViewModel"]; %>
        <table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0"
            cellpadding="0" style="padding-left: 50px">
            <tr>
                <td><u><%: Html.Label("FASECOLDA:")%></u></td>
                <% bool FASECOLDA = (bool)ViewBag.FASECOLDA; %>   
                <td><%: Html.RadioButton("FASECOLDA_Editar", true, FASECOLDA ? true : false, new { title = "Premio FASECOLDA", onclick = "uncheckRadio(this)" })%></td>               
            </tr>
            <tr>
                <td><%: Html.Label("LIMRA:")%></td>
                <% bool LIMRA = (bool)ViewBag.LIMRA; %>   
                <td><%: Html.RadioButton("LIMRA_Editar", true, LIMRA ? true : false, new { title = "Premio LIMRA", onclick = "uncheckRadio(this)" })%></td>
            </tr>               
            <tr>
                <td><%: Html.Label("Clave:")%></td>
                <td><%: Html.TextBox("clave_Editar", premiosanteriores.PremiosAnterioresView.clave, new { title = "Ingrese Clave", size = "4" })%>
                    <%: Html.ValidationMessageFor(Model => premiosanteriores.PremiosAnterioresView.clave)%></td>
            </tr>
            <tr>
                <td><%:Html.Label("Año:")%></td>
                <td><%=Html.ComboAnios("anio_Editar") %></td> 
            </tr>
        </table>        
        <p align="center"><input type="button" value="Actualizar" id = "editar" onclick="PremioAnteriorSave()" /></p>
<% } %>