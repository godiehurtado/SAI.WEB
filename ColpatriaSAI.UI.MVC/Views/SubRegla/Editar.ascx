<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#formSubReglaEditar").validate({
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
        function subreglaSave() {
            if ($("#formSubReglaEditar").valid()) {
                $("#editar").attr('disabled', true);
                $("#formSubReglaEditar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "SubRegla", FormMethod.Post, new { id = "formSubReglaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.SubReglaViewModel subregla =
                (ColpatriaSAI.UI.MVC.Models.SubReglaViewModel)ViewData["SubReglaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>                
                    <td><%: Html.Label("Descripcion")%></td>
                    <td><%: Html.TextBoxFor(Model => subregla.SubReglaView.descripcion, new { @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => subregla.SubReglaView.descripcion)%></td>              
                </tr>
                <tr>
                    <% if (subregla.SubReglaView.tipoSubregla != 3)
                       { %>

                       <% bool principal = (bool)subregla.SubReglaView.principal; %>
                    <td><label>Es Principal?</label><%: Html.RadioButton("principal_Edit", true, principal ? true : false, new { title = "Es Principal?", onclick = "uncheckRadio(this)" })%></td>

                    <% } %>
                        
                </tr>  
              </table>
      
        <input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["valuer"] %>" />
        <p align = "center"><input type="button" value="Actualizar" id = "editar" onclick="subreglaSave()" /></p>
    <% } %>