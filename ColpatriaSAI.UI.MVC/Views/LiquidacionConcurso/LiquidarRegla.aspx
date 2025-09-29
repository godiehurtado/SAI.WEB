<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidar Regla - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript">
	    $(function () {
	        var dates = $("#periodoLiquidacionIni, #periodoLiquidacionFin").datepicker({
	            defaultDate: "+1w",
	            changeMonth: true,
	            changeYear: true,
	            numberOfMonths: 1,
	            dateFormat: 'yy-mm-dd',
	            onSelect: function (selectedDate) {
	                var option = this.id == "periodoLiquidacionIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
	                dates.not(this).datepicker("option", option, date);
	            }
	        });
	    });

	    function liquidarRegla() {

	        $("#FormLiqReglas").validate({
	            onsubmit: false,
	            errorClass: "invalid",
	            errorPlacement: function (error, element) {
	                return true;
	            }
	        });

	        if ($("#FormLiqReglas").valid()) {

	            var stUrl = '/LiquidacionConcurso/LiquidarReglaSave';
	            $("#btnLiquidar").attr('disabled', true);
	            mostrarCargando("La liquidación inició. En unos minutos podrá consultarla en la tabla de liquidaciones de la regla.");
	            $.ajax({
	                type: 'GET',
	                timeout: 10000,
	                url: stUrl,
	                data: {
	                    fechaInicial: $("#periodoLiquidacionIni").val(),
	                    fechaFinal: $("#periodoLiquidacionFin").val(),
	                    reglaId: $("#reglaId").val()
	                },
	                success: function (response) {
	                    if (response.Success) {
	                        mostrarExito(response.Messagge);
	                        $("#btnLiquidar").hide();
	                    }
	                    else {
	                        $("#btnLiquidar").attr('disabled', false);
	                        mostrarError(response.Messagge);
	                    }
	                    $('#liquidacionRedirect').submit();
	                },
	                error: function (x, t, m) {
	                    if (t === "timeout") {
	                        closeNotify('jNotify');
	                        mostrarExito("El proceso se realizó con éxito.");
	                        $("#btnLiquidar").hide();
	                        $('#liquidacionRedirect').submit();	                        
	                    } else {
	                        closeNotify('jNotify');
	                        $("#btnLiquidar").attr('disabled', false);
	                        mostrarError("El proceso se realizó con éxito.");
	                        $('#liquidacionRedirect').submit();
	                    }
	                }
	            });
	            window.setTimeout(function () {
	                $('#liquidacionRedirect').submit();
	            }, 5000);                                      
            }
        }

        function validarProceso() {
            var idProcesoAnterior, idProcesoActual = 0;
            var stUrl = '/SessionLess/ValidarProceso';
            $.ajax({ type: 'POST', url: stUrl, data: {},
                success: function (respuesta)
                {
                    if (respuesta.Success) {
                        if (respuesta.idProceso != 0) {
                            if (idProcesoActual != respuesta.idProceso) {
                                idProcesoAnterior = parseInt(respuesta.idProceso) - 1;
                                $("#proceso" + idProcesoAnterior + "_loading").addClass("ui-icon ui-icon-check");
                                $("#proceso" + respuesta.idProceso).show();
                                $("#proceso" + respuesta.idProceso + "_loading").show();
                                idProcesoActual = respuesta.idProceso;
                            }
                        }
                    }
                }
            });
        }

        function mostrarValidarProceso() {
            $('#msjNotifyLiquidacion').css({
                left: ($('#contenido').width() - $('#msjNotifyLiquidacion').outerWidth()) / 2
            });
            $("#msjNotifyLiquidacion").show();
        }
	</script>

    <div id="msjNotifyLiquidacion" style="display:none;">
        <div id="proceso0" style="float:left;">Iniciando Liquidacion</div><div id="proceso0_loading">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso1" style="float:left;display:none;">Obteniendo Recaudos </div><div id="proceso1_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso2" style="float:left;display:none;">Liquidando Excepciones </div><div id="proceso2_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso3" style="float:left;display:none;">Liquidando Porcentajes por Participacion </div><div id="proceso3_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso4" style="float:left;display:none;">Obteniendo informacion para liquidar porcentajes por rangos </div><div id="proceso4_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso5" style="float:left;display:none;">Liquidando Porcentajes Participacion Por Rangos </div><div id="proceso5_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
        <div id="proceso6" style="float:left;display:none;">Terminando Liquidacion Franquicias </div><div id="proceso6_loading" style="display:none;">&nbsp;<img src="/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif" alt="Procesando..."/></div>
    </div>

 <% using (Html.BeginForm(null, null, FormMethod.Post, new { id = "FormLiqReglas" }))
    { %>
	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Liquidar Regla <%: ViewData["nombreRegla"] %></h2>
			<p>
				Defina la fecha inicial y final para realizar la liquidación de la regla.<br />
                <a href="javascript:$('#liquidacionRedirect').submit();">Regresar</a>                
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>
	<fieldset>
		<legend>Liquidacion Regla</legend>
		<table cellspacing="2" width="70%">
			<tr>
				<td>Fecha Inicial:</td>
				<td><%: Html.TextBox("periodoLiquidacionIni", "", new { @class = "required" }) %></td>
				<td>Fecha Final:</td>
				<td><%: Html.TextBox("periodoLiquidacionFin", "",new { @class = "required" }) %></td>
			</tr>
			<tr>
				<td colspan="2">
                <input type="button" value="Liquidar Regla" onclick="liquidarRegla()" id="btnLiquidar"/>
                <input type="button" value="Ver Detalle Liquidacion" onclick="verLiquidacionRegla()" id="btnVerLiquidacion" style="display:none;"/>
                <input type="hidden" id="reglaId" name="reglaId" value="<%=ViewData["reglaId"] %>"/>
                </td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</fieldset>
<% } %>
<% using (Html.BeginForm("Liquidaciones", "LiquidacionConcurso", FormMethod.Post, new  { id="liquidacionRedirect" })) { %>
    <%: Html.Hidden("regla", ViewData["reglaId"])%>
<% } %>

</asp:Content>