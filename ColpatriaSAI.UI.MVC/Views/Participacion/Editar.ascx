<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.Participacione>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#ParticipacionEditar").validate({
            rules: {
                fechaIniEdit: "required",
                fechaFinEdit: "required",
                eCompania_id: "required",
                eLineaNegocio_id: "required",
                eMesesAntiguedad: "required",
                ePorcentaje: "required"
            }
        });
        var dates = $("#fechaIniEdit, #fechaFinEdit").datepicker({
            defaultDate: "+1w", changeMonth: true, numberOfMonths: 3, dateFormat: "mm/dd/yy",
            showButtonPanel: true, changeMonth: true, changeYear: true,
            onSelect: function (selectedDate) {
                var option = this.id == "fechaIniEdit" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                dates.not(this).datepicker("option", option, date);
            }
        });
        var compania = $('#eCompania_id');
        compania.change(function () {
            $('#eRamo_id').find('option').remove();
            $.ajax({ url: '/Participacion/getRamos', data: { idCompa: compania.val() },
                success: function (data) {
                    $("<option value='0' selected>Seleccione..</option>").appendTo($('#eRamo_id'));
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#eRamo_id'));
                    });
                    $('#eRamo_id option').each(function () {
                        if ($(this).val() == $('#eRamo_id').val()) $(this).attr('selected', 'selected');
                    });
                }
            });
        });
    });
</script>

<% ColpatriaSAI.UI.MVC.Models.ParticipacionViewModel part = (ColpatriaSAI.UI.MVC.Models.ParticipacionViewModel)ViewData["Participaciones"]; %>

<% using (Html.BeginForm("Editar", "Participacion", FormMethod.Post, new { id = "ParticipacionEditar" }))
   { %>
    <%: Html.ValidationSummary(true) %>
    <table>
        <tr>
            <td>Fecha inicial:</td> <% string fechaIni = part.ParticipacionView.fechaIni.Value.ToShortDateString(); %>
            <td><%: Html.TextBox("fechaIniEdit", fechaIni, new { @readonly = "true", @id = "fechaIniEdit" })%></td>
        </tr>
        <tr>
            <td>Fecha final:</td> <% string fechaFin = part.ParticipacionView.fechaFin.Value.ToShortDateString(); %>
            <td><%: Html.TextBox("fechaFinEdit", fechaFin, new { @rteadonly = "true", @id = "fechaFinEdit" })%></td>
        </tr>
        <tr>
            <td>Compañia:</td>
            <td><%: Html.DropDownList("eCompania_id", (SelectList)part.CompaniaList, "Seleccione...", new { @class = "required" })%></td>
        </tr>
        <tr>
            <td>Linea de negocio:</td>
            <td><%: Html.DropDownList("eLineaNegocio_id", (SelectList)part.LineaNegocioList) %></td>
        </tr>
        <tr>
            <td>Ramo:</td>
            <td><%: Html.DropDownList("eRamo_id", (SelectList)part.RamoList, "Seleccione...", new {})%></td>
        </tr>
        <tr>
            <td>Meses de antiguedad:</td>
            <td><%: Html.TextBox("eMesesAntiguedad", part.ParticipacionView.mesesAntiguedad, new { @id = "eMesesAntiguedad", @class = "required" })%></td>
        </tr>
        <tr>
            <td>Porcentaje:</td>
            <td><%: Html.TextBox("ePorcentaje", part.ParticipacionView.porcentaje, new { @id = "ePorcentaje", @class = "required" })%></td>
        </tr>
    </table>
    <p style="text-align:right"><input type="submit" value="Actualizar participacion" id="btnCrear" /></p>
<% } %>