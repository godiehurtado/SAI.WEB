<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#BaseMonedaEditar").validate();
    });
</script>

      <script  type="text/javascript">
          $(function () {
              var dates = $("#fecha_inicioVigencia_Edit, #fecha_finVigencia_Edit").datepicker({
                  defaultDate: "+1w",
                  changeMonth: true,
                  numberOfMonths: 3,
                  dateFormat: "yy-mm-dd",
                  showButtonPanel: true,
                  changeMonth: true,
                  changeYear: true,
                  onSelect: function (selectedDate) {
                      var option = this.id == "fecha_inicioVigencia_Edit" ? "minDate" : "maxDate",
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
        function monedaSave() {
            if ($("#BaseMonedaEditar").valid()) {
                $("#editar").attr('disabled', true);
                mostrarCargando("Enviando informacion. Espere Por Favor...");
                $("#BaseMonedaEditar").submit();
            }
        }
    </script>

    <% using (Html.BeginForm("Editar", "BaseMoneda", FormMethod.Post, new { id = "BaseMonedaEditar" })) {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.BaseMonedaViewModel baseMoneda = (ColpatriaSAI.UI.MVC.Models.BaseMonedaViewModel)ViewData["BaseMonedaViewModel"]; %>
        <table>
        <tr>
        <td>
            <%: Html.Label("Fecha inicial vigencia") %>
            <%: Html.TextBox("fecha_inicioVigencia_Edit", String.Format("{0:d}", baseMoneda.BaseMonedaView.fecha_inicioVigencia), new { @class = "required" })%>
            <%: Html.ValidationMessageFor(p => baseMoneda.BaseMonedaView.fecha_inicioVigencia)%>
        </td>
        <td>
            <%: Html.Label("Fecha final vigencia")%>
            <%: Html.TextBox("fecha_finVigencia_Edit", String.Format("{0:d}", baseMoneda.BaseMonedaView.fecha_finVigencia), new { @class = "required" })%>
            <%: Html.ValidationMessageFor(p => baseMoneda.BaseMonedaView.fecha_finVigencia)%>
        </td>
        </tr>
        <tr>
        <td>
            <%: Html.Label("Base")%>
            <%: Html.TextBoxFor(p => baseMoneda.BaseMonedaView.@base, new { @class = "required number" })%>
            <%: Html.ValidationMessageFor(p => baseMoneda.BaseMonedaView.@base)%>
        </td>
        <td>
            <%: Html.Label("Moneda") %>
            <%: Html.DropDownList("moneda_id", (SelectList)baseMoneda.MonedaList, "Seleccionar...", new { @class = "required" })%>
        </td>
        </tr>
        </table>
        <p align = "center"><input type="button" id="editar" value="Actualizar" onclick="monedaSave()" /></p>
    <% } %>