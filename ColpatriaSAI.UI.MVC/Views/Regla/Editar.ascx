<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

        <script type="text/javascript">
            $().ready(function () {
                $("#formReglaEditar").validate({
            });
        });
        </script>

    <script  type="text/javascript">
    $(function () {
        var dates = $("#FechaInicioEdit, #FechaFinEdit").datepicker({
            defaultDate: "+1w",
            changeMonth: false,
            numberOfMonths: 3,
            dateFormat: "yy-mm-dd",
            showButtonPanel: true,
            changeMonth: false,
            changeYear: false,
            onSelect: function (selectedDate) {
                var option = this.id == "FechaInicioEdit" ? "minDate" : "maxDate",
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
            if ($("#formReglaEditar").valid()) {
                $("#editar").attr('disabled', true);
                $("#formReglaEditar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script> 


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Regla", FormMethod.Post, new { id = "formReglaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ReglaViewModel regla =
                (ColpatriaSAI.UI.MVC.Models.ReglaViewModel)ViewData["ReglaViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>
                    <td><u><%: Html.Label("Nombre")%></td>
                    <td><%: Html.TextBoxFor(Model => regla.ReglaView.nombre, new { @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.nombre)%></td>                   
                </tr> 
                <tr>
                    <td><u><%: Html.Label("Fecha Inicial")%></u></td>
                    <td><%: Html.TextBox("fechaInicial", String.Format("{0:d}",regla.ReglaView.fecha_inicio), new { @readonly = "true", @class = "required", id = "FechaInicioEdit" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.fecha_inicio)%></td>              
                </tr> 
                <tr> 
                    <td><u><%: Html.Label("Fecha Final")%></u></td>
                    <td><%: Html.TextBox("fechaFinal", String.Format("{0:d}",regla.ReglaView.fecha_fin), new { @readonly = "true", @class = "required", id = "FechaFinEdit" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.fecha_fin)%></td>              
                </tr>     
                <tr> 
                    <td><u><%: Html.Label("Tipo de Regla")%></u></td>
                    <td><%: Html.DropDownList("tipoRegla_id", (SelectList)regla.TipoReglaList, "Seleccione un Valor", new { @class = "required" })%></td>              
                </tr>
                <tr>                
                    <td><u><%: Html.Label("Periodo de Regla")%></u></td>
                    <td><%: Html.DropDownList("periodoRegla_id", (SelectList)regla.PeriodoReglaList, "Seleccione un Valor", new { @class = "required" })%></td>              
                </tr>
                <tr>                
                    <td><%: Html.Label("Descripcion")%></td>
                    <td><%: Html.TextAreaFor(Model => regla.ReglaView.descripcion, new { @style = "height:200px;width:250px;border:#000000 1px solid;" })%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.descripcion)%></td>              
                </tr>
                <tr>                
                    <td><%: Html.Label("Premio a sumar")%></td>
                    <td><%: Html.DropDownList("regla_id", (SelectList)ViewBag.ListaPremios, "Seleccione...")%>
                        <%: Html.ValidationMessageFor(Model => regla.ReglaView.regla_id)%></td>    
                </tr>
                <tr>                
                    <td><%: Html.Label("Concepto Descuento")%></td>
                    <td><%: Html.ListBox("conceptoDescuento_idEdit", (MultiSelectList)regla.ConceptoDescuentoList, new { id = "conceptoDescuento_idEdit", style = "width:300px; height:70px;", cols = "70", rows = "5", })%></td>  
                </tr>
              </table>
      
        <p><input type="submit" value="Actualizar" id="editar" onclick="reglaSave()" /></p>
    <% } %>