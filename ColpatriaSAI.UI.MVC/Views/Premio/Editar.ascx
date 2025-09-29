<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

            <script type="text/javascript">
                $().ready(function () {
                    $("#formPremioEditar").validate({
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
                function premioSave() {
                    if ($("#formPremioEditar").valid()) {
                        $("#editar").attr('disabled', true);
                        $("#formPremioEditar").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Premio", FormMethod.Post, new { id = "formPremioEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.PremioViewModel premio =
                (ColpatriaSAI.UI.MVC.Models.PremioViewModel)ViewData["PremioViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>                
                    <td><u><%: Html.Label("Nombre")%></u></td>
                    <td><%: Html.TextBoxFor(Model => premio.PremioView.descripcion, new { @class = "required", @style = "width:200px;" })%>
                        <%: Html.ValidationMessageFor(Model => premio.PremioView.descripcion)%></td>              
                </tr>                 
                <tr>                
                    <td><u><%: Html.Label("Tipo de Premio")%></u></td>
                    <td><%: Html.DropDownList("tipoPremio_id", (SelectList)premio.TipoPremiosList, "Seleccione un Valor", new { @class = "required", @style = "width:200px;" })%></td>              
                </tr>
                <tr>
                    <td><%: Html.Label("Variable")%></td>
                    <td><%: Html.DropDownList("variable_id", (SelectList)premio.VariableList, "Ninguno", new { @style = "width:200px;" })%></td>
                </tr>
                <tr>                
                    <td><%: Html.Label("Unidad de Medida")%></td>
                    <td><%: Html.DropDownList("unidadmedida_id", (SelectList)premio.UnidadMedidaList, "Ninguno", new { @style = "width:200px;" })%></td>              
                </tr>
                <tr>                
                    <td><u><%: Html.Label("Operador")%></u></td>
                    <td><%: Html.DropDownList("operador_id", (SelectList)premio.OperadorList, "Seleccione un Valor", new { @class = "required", @style = "width:200px;" })%></td>              
                </tr>
                <tr>                
                    <td><u><%: Html.Label("Valor")%></u></td>
                    <td><%: Html.TextBox("valor", String.Format("{0:0.00}",premio.PremioView.valor), new { @class = "required decimal", @style = "width:100px;"})%>
                        <%: Html.ValidationMessageFor(Model => premio.PremioView.valor)%></td>              
                </tr>
                <tr>
                    <td><% bool regularidad = (bool)premio.PremioView.regularidad; %></td>
                    <td><label>Regularidad?</label><%: Html.RadioButton("regularidad_Edit", true, regularidad ? true : false, new { title = "Regularidad?", onclick = "uncheckRadio(this)" })%></td>
                </tr> 
                <tr>
                    <td><%: Html.Label("Descripcion") %></td>
                    <td><%: Html.TextAreaFor (Model => premio.PremioView.descripcion_premio, new {@style = "height:200px;width:350px;border:#000000 1px solid;" })%>
                        <%: Html.ValidationMessageFor(Model => premio.PremioView.descripcion_premio)%></td>
                </tr>                 
              </table>
        
        <p align = "center"><input type="submit" value="Actualizar" id="editar" onclick="premioSave()" /></p>
    <% } %>