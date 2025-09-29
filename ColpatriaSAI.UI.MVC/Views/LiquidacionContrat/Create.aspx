<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.LiquidacionContratacion>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Nueva liquidación de contratación - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    var intervalProcesoContratacion = null;
    $(function () {
        var dates = $("#periodoLiquidacionIni").datepicker({
            changeMonth: true,
            dateFormat: 'yy-mm-dd'
        });

    });

    function liquidarContratacion() {

        $("#FormLiqContratacion").validate({
            onsubmit: false,
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });

        if ($("#FormLiqContratacion").valid()) {

            var stUrl = '/LiquidacionContrat/LiquidarContratacion';
            mostrarCargando("Liquidando Contratación. Espere Por Favor...");
            $("#btnLiquidar").attr('disabled', true);
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    fechaInicial: $("#periodoLiquidacionIni").val(),
                    segmento: $("#segmento_id").val()
                },
                success: function (response) {
                    if (response.Success) {
                        intervalProcesoContratacion = setInterval("validarLiquidacionContratacion()", 3000);
                    }
                }
            });

        }

    }

    function anularLiquidacion() {

        var stUrl = '/LiquidacionContrat/Anular';
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

    function verLiquidacionContratacion() {
        var idLiquidacion = $("#idLiquidacion").val();
        popupReport('ReporteContratacion', 'liquidacionContratacion_id=' + idLiquidacion);
    }


    function validarLiquidacionContratacion() {
        var stUrl = '/SessionLess/ValidarProcesosACancelarxTipo';
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: {
                idTipo: 2
            },
            success: function (responseProceso) {
                if (responseProceso.Success) {
                    clearInterval(intervalProcesoContratacion);
                    closeNotify('jNotify');
                    mostrarExito('La Liquidación a la contratación se realizó con éxito. Espere por favor.');
                    window.setTimeout(function () {
                        window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' + document.location.port : '') + '/LiquidacionContrat/';
                    }, 4000);

                }
            }
        });
    }

	</script>


 <% using (Html.BeginForm(null, null, FormMethod.Post, new { id = "FormLiqContratacion" }))
  {%>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Liquidación</h2>
			<p>
				Defina la fecha inicial y final para realizar la liquidación de la contratación.<br />
				<%: Html.ActionLink("Regresar", "Index") %>
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>
	<fieldset>
		<legend>Liquidación de la Contratación</legend>
		
		<table cellspacing="2" width="70%">
			<tr>
				<td>Periodo de Liquidación:</td>
				<td colspan="3">
					<%: Html.TextBox("periodoLiquidacionIni", "", new { @class = "required" }) %>
				</td>
			</tr>
            <tr>
                <td>Segmento:</td>
                <td colspan="3"><%: Html.DropDownList("segmento_id", (SelectList)ViewBag.Segmentos, "Todos", new { @class = "required" }) %></td>                                
            </tr>

            <%
                var displayCSSBoton = "none";
                var displayCSSFila = "block";
                if (ViewData["idLiquidacionContratacion"] == "0")
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
                <input type="button" value="Liquidar" onclick="liquidarContratacion()" id="btnLiquidar" style="display:<%=displayCSSBoton%>"/>
                <input type="button" value="Ver Detalle Liquidacion" onclick="verLiquidacionContratacion()" id="btnVerLiquidacion" style="display:none;"/>
                <input type="hidden" id="idLiquidacion"/>
                <input type="hidden" id="idLiquidacionAbierta" value="<%=ViewData["idLiquidacionContratacion"]%>"/>                
                </td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</fieldset>
<% } %>

</asp:Content>
