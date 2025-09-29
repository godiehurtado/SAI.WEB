<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.LiquidacionFranquicia>"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Pago
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    function AnularLiqFranquicia() {
        
        var id = $('#idLiquidacion').val();

        if (confirm('Está seguro de anular la liquidación. El proceso no se podra deshacer')) {

            mostrarCargando("Anulando la liquidación. Espere Por Favor...");
            $.ajax({
                url: '/Liquidacionfranqui/Anular',
                data: {
                    idLiquidacion: id
                },
                type: 'POST',
                success: function (result) {
                    if (result.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        $("#btnAnular").hide();
                        $("#btnReLiquidado").hide();
                        $("#btnPagar").hide();
                        $("#lblEstado").text('Anulado');
                    }
                }
            });

        }
    }

    function PagarLiqFranquicia() {
        var id = $('#idLiquidacion').val();

        if (confirm('Está seguro de pagar la liquidación. El proceso no se podra deshacer')) {

            $("#btnPagar").attr('disabled', true);
            $.ajax({
                url: '/LiquidacionFranqui/PagarLiqui',
                data: {
                    idLiquidacion: id
                },
                type: 'POST',
                success: function (result) {
                    closeNotify('jNotify');
                    if (result.Success) {
                        $("#btnAnular").hide();
                        $("#btnPagar").hide();
                        $("#btnReLiquidado").hide();
                        $("#btnVerPagosLiquidacion").show('slow');
                        $("#lblEstado").text('Pagado');
                    }
                    mostrarExito(result.Messagge);
                }
            });
        }
    }

    function Reliquidado() {

        var id = $('#idLiquidacion').val();

        if (confirm('Está seguro de pasar a estado Reliquidado esta liquidación. El proceso no se podra deshacer')) {

            $("#btnPagar").attr('disabled', true);
            $.ajax({
                url: '/LiquidacionFranqui/Reliquidado',
                data: {
                    idLiquidacion: id
                },
                type: 'POST',
                success: function (result) {
                    closeNotify('jNotify');
                    if (result.Success) {
                        $("#btnAnular").hide();
                        $("#btnPagar").hide();
                        $("#btnReLiquidado").hide();
                        $("#btnVerPagosLiquidacion").hide();
                        $("#lblEstado").text('Re-Liquidado');
                    }
                    mostrarExito(result.Messagge);
                }
            });
        }
    }

    function verPagosLiquidacionFranquicia() {

        var idLiquidacion = $("#idLiquidacion").val();
        popupReport('ReporteDetallePagosFranquicia', 'id=' + idLiquidacion);
    }

</script>
<br/>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" style="width:auto;">
			<h2>Liquidación Franquicia / Pagos de Liquidación.</h2>
			<p>
				<%: Html.ActionLink("Regresar", "LiquiIndex") %>
			</p>
		</div>
		<div id="progresoSeccion"></div>
		<div style="clear:both;"><hr /></div>
	</div>
    <fieldset>
        <legend>Liquidación Franquicia</legend>
     
        <table cellspacing="1" cellpadding="1" width="100%" border="0">
            <tr class="trColor1">
                <td><b>Fecha de Liquidación</b></td>
                <td><b>Periodo de Liquidación inicial</b></td>
                <td><b>Periodo de Liquidación final</b></td>
                <td><b>Estado</b></td>
            </tr>
            <tr>
                <td><%=Model.fechaLiquidacion%></td>
                <td><%=Model.periodoLiquidacionIni%></td>
                <td><%=Model.periodoLiquidacionFin%></td>
                <td><div id="lblEstado"><%=Model.EstadoLiquidacion.nombre%></div></td>
            </tr>

        </table>       

        <p>
        <% 
           
            string styleBtnAnular = "block";
            string styleBtnPagar = "block";
            string styleBtnVer = "block";
            string styleBtnReLiquidado = "block";
            if (Model.estado == 1)
            {
                styleBtnVer = "none";                
                //if (Model.id_liquidacion_reliquidada != null)
                //        styleBtnPagar = "none";                    
            }                
            else if (Model.estado == 2)
            {
                styleBtnPagar = "none";
                styleBtnReLiquidado = "none";
                styleBtnAnular = "none";
            }
            else if (Model.estado == 3)
            {
                styleBtnPagar = "none";
                styleBtnReLiquidado = "none";
                styleBtnAnular = "none";
                styleBtnVer = "none";     
            }
            else if (Model.estado == 5)
            {
                styleBtnPagar = "none";
                styleBtnReLiquidado = "none";
                styleBtnAnular = "none";
                styleBtnVer = "none";
            }            
        %>       

        <input type="button" id="btnAnular" value="Anular" onclick="AnularLiqFranquicia()" style="display:<%=styleBtnAnular%>;float:left;margin-left:4px;"/>
        <input type="button" id="btnPagar" value="Pagar" onclick="PagarLiqFranquicia()" style="display:<%=styleBtnPagar%>;float:left;margin-left:4px;"/>
        <input type="button" id="btnReLiquidado" value="Re-Liquidado" onclick="Reliquidado()" style="display:<%=styleBtnReLiquidado%>;float:left;margin-left:4px;"/>        
        <input type="button" value="Ver Pagos Liquidacion" onclick="verPagosLiquidacionFranquicia()" id="btnVerPagosLiquidacion" style="display:<%=styleBtnVer%>;float:left;margin-left:4px;"/>       
        <input type="hidden" id="idLiquidacion" value="<%= Model.id %>" />
        </p>

    </fieldset>
</asp:Content>
