<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

        <script type="text/javascript">
            $().ready(function () {
                $("#formReglaDuplicar").validate({
            });
        });
        </script>

    <script  type="text/javascript">
        $(function () {
            var dates = $("#fechaInicialDup, #fechaFinalDup").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaInicialDup" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });
	</script>

    <script type="text/javascript">
        function reglaSave() {
            if ($("#formReglaDuplicar").valid()) {
                $("#duplicar").attr('disabled', true);
                $("#formReglaDuplicar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script> 


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Duplicar", "Regla", FormMethod.Post, new { id = "formReglaDuplicar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ReglaViewModel regla =
                (ColpatriaSAI.UI.MVC.Models.ReglaViewModel)ViewData["ReglaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>
                    <td><%: Html.Label("Nombre")%></td>
                    <td><%: Html.Label("Nombre", Convert.ToString(TempData["nombreRegla"]))%></td>                   
                </tr> 
                <tr>
                    <td><u><%: Html.Label("Fecha Inicial")%></u></td>
                    <td><%: Html.TextBox("fechaInicialDup", String.Format("{0:d}", regla.ReglaView.fecha_inicio), new { @readonly = "true", @class = "required", id = "fechaInicialDup" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.fecha_inicio)%></td>              
                </tr> 
                <tr> 
                    <td><u><%: Html.Label("Fecha Final")%></u></td>
                    <td><%: Html.TextBox("fechaFinalDup", String.Format("{0:d}", regla.ReglaView.fecha_fin), new { @readonly = "true", @class = "required", id = "fechaFinalDup" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.fecha_fin)%></td>              
                </tr>     
                <tr> 
                    <td><%: Html.Label("Tipo de Regla")%></td>
                    <td><%: Html.Label("Tipo de Regla", Convert.ToString(TempData["tipoRegla"]))%></td>
                </tr>
                <tr>                
                    <td><%: Html.Label("Periodo de Regla")%></td>
                    <td><%: Html.Label("Periodo de Regla", Convert.ToString(TempData["periodoRegla"]))%></td>
                </tr>
                <tr>
                    <td><%: Html.Label("Concurso") %></td>
                    <td><%: Html.DropDownList("concurso_id_editar", (SelectList)regla.ConcursoList, "Seleccione un Valor", new { style = "width:150px;", id = "concurso_id_editar", @class = "required" })%></td></tr>
              </table>
      
        <p><input type="submit" value="Duplicar" id="duplicar" onclick="reglaSave()" /></p>
    <% } %>