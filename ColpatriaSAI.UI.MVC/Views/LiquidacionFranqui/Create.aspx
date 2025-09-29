<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.LiquidacionFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Nueva liquidación - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $(function () {
        var dates = $("#periodoLiquidacionIni, #periodoLiquidacionFin").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
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

    var intervalProceso = null;
    function liquidarFranquicias() {

        $("#FormLiqFranquicias").validate({
            onsubmit: false,
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });

        if ($("#FormLiqFranquicias").valid()) {

            var stUrl = '/LiquidacionFranqui/LiquidarFranquicias';
            mostrarCargando("Liquidando Franquicias. Espere Por Favor...");
            $("#btnLiquidar").attr('disabled', true);
            mostrarValidarProceso();             
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    fechaInicial: $("#mes_ini").val(),
                    fechaFinal: $("#mes_fin").val(),
                    annio: $("#anio").val()
                },
                success: function (response) {
                    if (response.Success) {                        
                        /*closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        $("#idLiquidacion").val(response.idLiquidacion);                                                
                        $("#btnLiquidar").hide();                        
                        $("#btnVerLiquidacion").show('slow');
                        clearInterval(intervalProceso);
                        $("#msjNotifyLiquidacion").hide();*/
                    }
                }
            });
            intervalProceso = setInterval("validarProceso();", 5000);        
        }

    }

    function anularLiquidacion() {

        var stUrl = '/LiquidacionFranqui/Anular';
        mostrarCargando("Anulando Liquidaciones. Espere Por Favor...");
        $("#btnAnular").attr('disabled', true);
        $.ajax({
            type: 'POST',
            url: stUrl,
            data:
            {
                idLiquidacion: $("#idLiquidacionAbierta").val()
            },
            success: function (response) {
                if (response.Success) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    $("#idLiquidacionAbierta").val(0);
                    $("#msjLiquidacionesXAnular").hide();
                    $("#btnLiquidar").show('slow');
                }
            }
        });
    }

    function verLiquidacionFranquicia() {
        var idLiquidacion = $("#idLiquidacion").val();
        popupReport('ReportLiqFranquicias', 'ID=' + idLiquidacion);
    }

    function validarProceso() {
        var idProcesoAnterior;
        var idProcesoActual = 0;
        var stUrl = '/SessionLess/ValidarProceso';
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: {},
            success: function (responseProceso) {
                if (responseProceso.Success) {
                    if (responseProceso.idProceso != 0) {
                        if (idProcesoActual != responseProceso.idProceso) {
                            idProcesoAnterior = parseInt(responseProceso.idProceso) - 1;
                            $("#proceso" + idProcesoAnterior + "_loading").addClass("ui-icon ui-icon-check");
                            $("#proceso" + responseProceso.idProceso).show();
                            $("#proceso" + responseProceso.idProceso + "_loading").show();
                            idProcesoActual = responseProceso.idProceso;
                        }
                    }
                    else if (responseProceso.idProceso == 0) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        $("#btnLiquidar").hide();
                        $("#btnVerLiquidacion").hide();
                        clearInterval(intervalProceso);
                        $("#msjNotifyLiquidacion").hide();
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

 <% using (Html.BeginForm(null,null,FormMethod.Post , new{id="FormLiqFranquicias"}))
  {%>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Liquidación</h2>
			<p>
				Defina la fecha inicial y final para realizar la liquidación de la producción de las franquicias.<br />
				<%: Html.ActionLink("Regresar", "LiquiIndex") %>
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>
	<fieldset>
		<legend>Liquidación Franquicia</legend>
		
		<table cellspacing="2" width="70%">
			<tr>
                <td>Año:</td>
                <td>
					<%: Html.ComboAnios("anio") %>
				</td>
				<td>Mes Inicial:</td>
				<td>
					<%: Html.ComboMeses("mes_ini") %>
				</td>
				<td>Mes Final:</td>
				 <td>
                        <%: Html.ComboMeses("mes_fin") %>
                </td>
			</tr>

            <%
                var displayCSSBoton = "none";
                var displayCSSFila = "block";
                if (ViewData["idLiquidacionFranquicia"] == "0")
                {
                    displayCSSFila = "none";
                    displayCSSBoton = "block";
                }          
            %>

            <tr>
                <td colspan="4">
                <div style="display:<%=displayCSSFila%>;text-align=center;" id="msjLiquidacionesXAnular">
                    Hay Liquidaciones pendientes por procesar. Si desea anularlas haga clic en Anular de lo contrario regrese al listado y complete el proceso de pago.
                    <input type="button" value="Anular" onclick="anularLiquidacion()" id="btnAnular"/>
                </div>
                </td>
            </tr>
			<tr>
				<td colspan="2">
                <input type="button" value="Liquidar" onclick="liquidarFranquicias()" id="btnLiquidar" style="display:<%=displayCSSBoton%>"/>
                <input type="button" value="Ver Detalle Liquidacion" onclick="verLiquidacionFranquicia()" id="btnVerLiquidacion" style="display:none;"/>
                <input type="hidden" id="idLiquidacion"/>
                <input type="hidden" id="idLiquidacionAbierta" value="<%=ViewData["idLiquidacionFranquicia"]%>"/>                
                </td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</fieldset>
<% } %>

</asp:Content>
