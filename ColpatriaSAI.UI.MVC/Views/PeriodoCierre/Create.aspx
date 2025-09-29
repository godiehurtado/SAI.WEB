<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.PeriodoCierreModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Periodos de Cierre - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var periodoId = 0;
    var fechaInicial = string.Empty;
    var fechaFinal = string.Empty;
    var fechaCierre = string.Empty;
    int mesCierre = 0;
    int anioCierre = DateTime.Now.Year;
    int companiaId = 0;
    
    if (this.Model.PeriodoCierre != null)
    {
        periodoId = this.Model.PeriodoCierre.id;

        if (this.Model.PeriodoCierre.fechaInicio.Value != null)
            fechaInicial = this.Model.PeriodoCierre.fechaInicio.Value.Year + "-" + ((this.Model.PeriodoCierre.fechaInicio.Value.Month.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaInicio.Value.Month.ToString()) : this.Model.PeriodoCierre.fechaInicio.Value.Month.ToString()) + "-" + ((this.Model.PeriodoCierre.fechaInicio.Value.Day.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaInicio.Value.Day.ToString()) : this.Model.PeriodoCierre.fechaInicio.Value.Day.ToString());

        if (this.Model.PeriodoCierre.fechaFin.Value != null)
            fechaFinal = this.Model.PeriodoCierre.fechaFin.Value.Year + "-" + ((this.Model.PeriodoCierre.fechaFin.Value.Month.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaFin.Value.Month.ToString()) : this.Model.PeriodoCierre.fechaFin.Value.Month.ToString()) + "-" + ((this.Model.PeriodoCierre.fechaFin.Value.Day.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaFin.Value.Day.ToString()) : this.Model.PeriodoCierre.fechaFin.Value.Day.ToString());

        if (this.Model.PeriodoCierre.fechaCierre.Value.ToShortDateString() != null)
            fechaCierre = this.Model.PeriodoCierre.fechaCierre.Value.Year + "-" + ((this.Model.PeriodoCierre.fechaCierre.Value.Month.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaCierre.Value.Month.ToString()) : this.Model.PeriodoCierre.fechaCierre.Value.Month.ToString()) + "-" + ((this.Model.PeriodoCierre.fechaCierre.Value.Day.ToString().Length == 1) ? ("0" + this.Model.PeriodoCierre.fechaCierre.Value.Day.ToString()) : this.Model.PeriodoCierre.fechaCierre.Value.Day.ToString());

        mesCierre = Convert.ToInt32(this.Model.PeriodoCierre.mesCierre);
        anioCierre = Convert.ToInt32(this.Model.PeriodoCierre.anioCierre);
        
        companiaId = Convert.ToInt32(this.Model.PeriodoCierre.compania_id);
        
    }
    
%>

<script type="text/javascript">

    $(document).ready(function () {
        $('#fechaInicio').datepicker({ dateFormat: 'yy-mm-dd' });
        $('#fechaFin').datepicker({ dateFormat: 'yy-mm-dd' });
        $('#fechaCierre').datepicker({ dateFormat: 'yy-mm-dd' });

        $("#FormPeriodos").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });

        $('#mes').val(<%=mesCierre%>);
        $('#anio').val(<%=anioCierre%>);
    });   

    function periodoSave() {

        if ($("#FormPeriodos").valid() && validarFechas()) {
            var stUrl = '/PeriodoCierre/SavePeriodoCierre';
            $("#guardar").attr('disabled', true);
            mostrarCargando("Enviando informacion. Espere Por Favor...");
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    periodoId: $('#PeriodoId').val(),
                    companiaId: $('#compania_id').val(),
                    mes: $('#mes').val(),
                    anio: $('#anio').val(),
                    fechaInicio: $('#fechaInicio').val(),
                    fechaFin: $('#fechaFin').val(),
                    fechaCierre: $('#fechaCierre').val()
                },
                success: function (response) {
                    closeNotify('jNotify');
                    if (response.Success) {
                        mostrarExito(response.Messagge);
                        window.location.href = '../../PeriodoCierre';
                    }
                    else {
                        mostrarError(response.Messagge);
                    }
                }
            });

        }
    }

    function validarFechas() {

        var validado = true;
        var mes = $('#mes').val();
        var anio = $('#anio').val();
        var fechaInicio = $('#fechaInicio').val();
        var fechaFin = $('#fechaFin').val();
        var fechaCierre = $('#fechaCierre').val();
        var arrFechaCierre = fechaCierre.split('-');
        var msjError = "";

        if (fechaFin < fechaInicio) {
            msjError += "La fecha final no puede ser menor que la fecha de inicio.<br/>";
        }

        if (fechaCierre < fechaFin || fechaCierre < fechaInicio){
            msjError += "La fecha de cierre no puede ser menor que la fecha inicial o la fecha final.<br/>";
        }

        if (!(parseFloat(arrFechaCierre[1]) >= mes && parseFloat(arrFechaCierre[0]) >= anio)) {
            msjError += "La fecha de cierre no puede ser menor al periodo de cierre.<br/>";
        }

        if (msjError != "") {
            mostrarError(msjError);
            validado = false;
        }

        return validado;
    }

	</script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Periodo Cierre</h2>
            <h4></h4>
		    <div >
			    Ingrese la información requerida para crear un nuevo periodo de de cierre.
			</div>
			<br /><%: Html.ActionLink("Regresar", "Index", "PeriodoCierre")%>
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

	<% 
     
        using (Html.BeginForm("SavePeriodo", "PeriodoCierre", FormMethod.Post, new { id = "FormPeriodos" }))
	   {%>

			<fieldset style="border:1px solid gray">
			
            <input type="hidden"  id="PeriodoId" name="PeriodoId" value='<%= periodoId %>' />

			<table cellspacing="2" width="100%">
				<tr>
					<td>* Periodo de Cierre:</td>
					<td colspan="4">
                        <select id="mes" name="mes" class="required">
                            <option value="">Seleccione...</option>
                            <option value="1">Enero</option>
                            <option value="2">Febrero</option>
                            <option value="3">Marzo</option>
                            <option value="4">Abril</option>
                            <option value="5">Mayo</option>
                            <option value="6">Junio</option>
                            <option value="7">Julio</option>
                            <option value="8">Agosto</option>
                            <option value="9">Septiembre</option>
                            <option value="10">Octubre</option>
                            <option value="11">Noviembre</option>
                            <option value="12">Diciembre</option>
                        </select>
                        -
                        <%=Html.ComboAnios("anio") %>
					</td>
				</tr>
				<tr>
					<td>* Fecha Inicial:</td>
					<td>
						<%: Html.TextBox("fechaInicio", fechaInicial, new { id = "fechaInicio", @class = "required" })%>
					</td>
					<td>* Fecha Final:</td>
					<td>
						<%: Html.TextBox("fechaFin", fechaFinal, new { id = "fechaFin", @class = "required" })%>
					</td>
                    <td>* Fecha Cierre:</td>
					<td>
						<%: Html.TextBox("fechaCierre", fechaCierre, new { id = "fechaCierre", @class = "required" })%>
					</td>
				</tr>
				<tr>
					<td>* Compañia:</td>
					<td colspan="4">
						<%: Html.DropDownList("compania_id", new SelectList(this.Model.CompaniaList, "id", "nombre", companiaId), "Seleccione uno...", new { style = "width:300px;", id = "compania_id", @class = "required" })%>
					</td>
				</tr>
			    <tr>
				    <td colspan="4" align="left">
                        <input type="button" onclick="periodoSave()" id="guardar" value="Guardar"/>
                        <div id="mensaje" style="color: #FF0000">Tenga en cuenta que los campos requeridos estan marcados con (*)</div>
                    </td>
			    </tr>
			</table>
			</fieldset>
			<br />
	<% } %>
	  
</asp:Content>

