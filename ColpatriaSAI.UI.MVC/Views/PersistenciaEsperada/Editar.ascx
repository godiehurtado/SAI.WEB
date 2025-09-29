<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#PersistenciaEsperadaEditar").validate();
        });
        $("#tipoPersistencia_EditVIDA").click(function () {
            if (this.checked)
                $('#plazo_id_edit').attr('disabled', 'disabled');
            else
                $('#plazo_id_edit').removeAttr('disabled');
        });
        $("#tipoPersistencia_EditCAPI").click(function () {
            if (this.checked)
                $('#plazo_id_edit').removeAttr('disabled');
            else
                $('#plazo_id_edit').attr('disabled', 'disabled');
        });
    </script>

 <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <% using (Html.BeginForm("Editar", "PersistenciaEsperada", FormMethod.Post, new { id = "PersistenciaEsperadaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.PersistenciaEsperadaViewModel persistenciaesperada = (ColpatriaSAI.UI.MVC.Models.PersistenciaEsperadaViewModel)ViewData["PersistenciaEsperadaViewModel"]; %>
        <fieldset style="border:1px solid gray">
        <table width="100%" cellpadding="2">                   
            <tr>
                <td  align = "center"><u><%: Html.Label("Tipo de Persistencia:")%></u></td>
                <% bool tipo = (bool)persistenciaesperada.PersistenciaEsperadaView.tipoPersistencia; %>
                <td align = "center"><%: Html.RadioButton("tipoPersistencia_Edit", false, tipo ? false : true, new { title = "Capitalización Tradicional", id = "tipoPersistencia_EditCAPI" })%><label>Tradicional</label></td>
                <td align = "center"><%: Html.RadioButton("tipoPersistencia_Edit", true, tipo ? true : false, new { title = "Vida Individual", id = "tipoPersistencia_EditVIDA" })%><label>Vida Individual</label></td>
            </tr>               
            <tr>
                <td align = "center"><u><%: Html.Label("Valor")%></u></td>  
                <td><%: Html.TextBoxFor(Model => persistenciaesperada.PersistenciaEsperadaView.valor, new { @class = "required decimal", title = "Ingrese Porcentaje de Persistencia Esperado" })%> %
                    <%: Html.ValidationMessageFor(Model => persistenciaesperada.PersistenciaEsperadaView.valor)%></td>                         

                <td align = "center"><%: Html.Label("Plazo") %></td>
                <td><%: Html.DropDownList("plazo_id_edit", (SelectList)persistenciaesperada.PlazoList, new { style = "width:150px;", id = "plazo_id_edit", title = "Seleccione Plazo" })%></td>
            </tr>
        </table>
        </fieldset>

        <h5 align = "center"><u>Recuerde usar "," (coma) para identificar los números decimales</u></h5>

        <p align = "center"><input type="submit" value="Editar" /></p>
    <% } %>