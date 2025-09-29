<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<script type="text/javascript">
    $(function () {
        var dates = $("#fecha").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            numberOfMonths: 2, 
            dateFormat: "dd/mm/yy",
            showButtonPanel: true,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selectedDate) {
                var option = this.id == "FechaInicio" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                dates.not(this).datepicker("option", option, date);
            }
        });
    });
    function GenerarReporteExcepcion() {
        if ($("#ReporteEjecutivo").valid()) {

            var stUrl = '/Concursos/GenerarReporte';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnReporte").attr('disabled', true);
            var dataForm = $("#ReporteEjecutivo").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success && response.result != 0) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = "/ReportesSAI";
                    }
                }
            });
        }
    }
             

        
</script>
<div class="seccion" id="dialog">
  <% using (Html.BeginForm("ReporteAsesor", "ConcursoController", FormMethod.Post, new { id = "ReporteAsesor" }))
     { %>
        <%: Html.ValidationSummary(true); %>
<table>
    <tr>
        <td style="width: 19px">
            <h3>
                Filtros</h3>
        </td>
    </tr>
    <tr>
        <td style="width: 19px">
            Premio:
        </td>
        <td>
            <select id="premio" name="premio" style = "width:209px;">
               <option value="0">Seleccione</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
                <option>CONVENCIÓN POR TOTAL COLQUINES</option>
                <option>CONVENCIÓN POR VIDA INDIVIDUAL</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
                <option>CONVENCIÓN POR CAPITALIZACIÓN TRADICIONAL</option>
                <option>CONVENCIÓN POR PYMES</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
            </select>
        </td>
    </tr>
    <tr>
        <td style="width: 19px">
            Fecha:
        </td>
        <td>
            <input type="text" id="fecha" name="fecha" style="width: 209px;" />
        </td>
    </tr>
    <tr>
        <td style="width: 19px">
            Director:
        </td>
        <td>
            <input type="text" id="director" name="director" style="width: 209px;" />
        </td>
    </tr>
    <tr>
        <td style="width: 19px" colspan="3" align="center">
        <p></p>
            <input type="button" value="Generar" id="btnReporte" onclick="GenerarReporteExcepcion();"
                name="btnReporte" />
        </td>
    </tr>
</table>
<% } %>
</div>