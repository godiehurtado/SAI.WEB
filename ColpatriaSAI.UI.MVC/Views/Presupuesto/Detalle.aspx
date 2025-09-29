<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Presupuesto>" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Detalle Presupuesto
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script  type="text/javascript">
        $(document).ready(function () {
            $("#bLiquidacion").button({ icons: { primary: "ui-icon-calculator"} });
            $("#bReporte").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporteEjecucion").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporte1").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporte2").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporte3").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporte4").button({ icons: { primary: "ui-icon-search"} });
            $("#bReporte5").button({ icons: { primary: "ui-icon-search"} });
            $("#bEjecucion").button({ icons: { primary: "ui-icon-document"} });
            $("#bEjecucion1").button({ icons: { primary: "ui-icon-document"} });

            $("#formEjecucionManual").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });
        });


        function mostrarEjecucionManual(idPresupuesto, anio) {

            $("#idPresupuesto").val(idPresupuesto);
            $("#anioText").text(anio);
            $("#valor").val("");
            $("#descripcion").val("");
            $("#ejecucionManual").dialog({
                width: 600,
                minHeight: 250,
                title: 'Ajuste Manual Ejecución',
                position: 'center',
                modal: true
            });

            $("#ejecucionManual").dialog("open");
            cancelarEjecucionDetalle();
        }

        function buscarEjecucionDetalle() {

            if ($("#formEjecucionManual").valid()) {
                var stUrl = '/Ejecucion/BuscarEjecucionManual';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnbuscarEjecucionDetalle").attr('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data:
                    {
                        idPresupuesto: $("#idPresupuesto").val(),
                        codigoNivel: $("#codigo_nivel").val(),
                        metaId: $("#meta_id").val(),
                        canalId: $("#canal_id").val(),
                        mes: $("#mes").val()
                    },
                    success: function (response) {
                        closeNotify('jNotify');
                        if (response.Success) {
                            $("#btnbuscarEjecucionDetalle").attr('disabled', false);
                            $("#idEjecucionDetalle").val(response.IdEjecucionDetalle);
                            $("#valor").val(response.Valor);
                            $("#descripcionText").html(response.Descripcion);
                            $("#fechaAjuste").text(response.FechaAjuste);
                            $("#usuario").text(response.Usuario);
                            $("#valor").addClass("required");
                            $("#descripcion").addClass("required");
                            $("#ejecucionManualInfo").show();
                        }
                        else {
                            mostrarError("No hay informacion para los datos ingresados.");
                        }
                    }
                });
            }
        }

        function actualizarEjecucionDetalle() {

            if ($("#formEjecucionManual").valid()) {
                var stUrl = '/Ejecucion/ActualizarEjecucionManual';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnactualizarEjecucionDetalle").attr('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data:
                    {
                        idEjecucionDetalle: $("#idEjecucionDetalle").val(),
                        valor: $("#valor").val(),
                        descripcion: $("#descripcion").val()
                    },
                    success: function (response) {
                        closeNotify('jNotify');
                        if (response.Success) {
                            mostrarExito("El proceso se realizo con exito.");
                            $("#btnactualizarEjecucionDetalle").attr('disabled', false);
                            cancelarEjecucionDetalle();
                        }
                    }
                });
            }
        }

        function cancelarEjecucionDetalle() {
            $("#ejecucionManualInfo").hide();
            $("#valor").val("");
            $("#valor").removeClass("required");
            $("#descripcion").val("");
            $("#descripcion").removeClass("required");
            $("#codigo_nivel").val("");
            $("#mes").val("");
            $("#meta_id").val("");
            $("#canal_id").val("");
            $("#btnbuscarEjecucionDetalle").attr('disabled', false);
            $("#idEjecucionDetalle").val(0);
        }

        var intervalProcesoMetas;
        function calcularMetas(idPresupuesto) {

            var stUrl = '/Presupuesto/CalcularMetas';
            mostrarCargando("Calculando Metas y Ejecucion. Espere por favor...");
            $("#bLiquidacion").attr('disabled', true);
            intervalProcesoMetas = setInterval("validarCalculoMetas(" + idPresupuesto + ");", 5000);

            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idPresupuesto: idPresupuesto
                },
                success: function (response) {
                    //closeNotify('jNotify');
                    if (response.Success) {
                        //clearInterval(intervalProcesoMetas);
                        //mostrarExito(response.Messagge);
                    }
                    else
                        mostrarExito("Hay errores en la parametrización. No se completo el proceso");

                    $("#bLiquidacion").removeAttr('disabled');
                }
            });
        }

        function validarCalculoMetas(idPresupuesto) {
            var stUrl = '/SessionLess/ValidarProcesosACancelar';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: {
                    idLiquidacion: idPresupuesto
                },
                success: function (responseProceso) {
                    if (responseProceso.Success) {                        
                        clearInterval(intervalProcesoMetas);
                        closeNotify('jNotify');
                        mostrarExito('El calculo metas y ejecución para el presupuesto se realizó con éxito.');
                    }
                }
            });
        }

        function generarAsincrono(idPresupuesto) {
            mostrarCargando("En unos minutos el reporte solicitado estará disponible en el FTP. Consultelo en la opción 'Ver Reportes'");
            var stUrl = '/Presupuesto/Asincrono';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: {
                    idPresupuesto: idPresupuesto
                },
                success: function (responseProceso) {
                    if (responseProceso.Success) {
                        window.setTimeout(function () {
                            closeNotify('jNotify');
                        }, 3000);
                    }
                }
            });
        }

	</script>
	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Detalle Presupuesto.</h2>
			<p>
				Seleccione un proceso a ejecutar para el presupuesto.<br />
				<h4><%: Html.ActionLink("Regresar", "Presupuestos", "Presupuesto")%></h4>
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaLista">
        <thead>
        <tr>
            <th>Fecha inicial</th><th>Fecha final</th><th>Último carge</th>
        </tr>
        </thead>
        <tbody>
            <tr>
                <td><%: String.Format("{0:d}", Model.fechaInicio)%> </td>
                <td><%: String.Format("{0:d}", Model.fechaFin)%> </td>
                <td><%: Model.fechaModificacion%> </td>
            </tr>
        </tbody>
    </table>
    <div style="clear:both;"><hr /></div>
    <br/>
    <%
        var anio = Model.fechaInicio.Value.Year;    
    %>
    <center>    
    <a href="javascript:calcularMetas(<%: Model.id %>);" id="bLiquidacion" title='Calcular metas y ejecucion'>Calcular Metas y Ejecución</a>
    <a href="/Ejecucion/CargueManualEjecucionDetalle/<%: Model.id %>" id="bEjecucion" title='Cargar Ejecucion Metas Manual'>Cargar Ejecución Metas Manuales</a>
    <a href='javascript:mostrarEjecucionManual(<%: Model.id %>,<%=anio%>);' id="bEjecucion1" title='Ajuste Manual Ejecucion'>Ajuste Manual Ejecución</a>
    <br/><br/>
    <a href="#" onclick="popupReport('ReportePresupuesto','presupuesto_id=<%: Model.id %>');" id="bReporte" title='Ver detalle presupuesto'>Detalle Presupuesto</a>
    <a href='#'  onclick="generarAsincrono(<%= Model.id %>);" id="bReporte1" title='Reporte Presupuesto vs Ejecución'>Reporte Presupuesto vs Ejecución</a>
    <a href='#'  onclick="popupReport('ReportPresupuestoEjecucionCanal','idPresupuesto=<%: Model.id %>');" id="bReporte2" title='Reporte Ejecución por Canal'>Reporte Ejecución por Canal</a>
    <br/><br/>
    <a href='#'  onclick="popupReport('ReporteLogErroresCargue','cargue_id=<%: Model.id %>&cargue_tipo=1');" id="bReporte3" title='Reporte Log de Errores Cargue Presupuesto'>Reporte Log de Errores Cargue Presupuesto</a>
    <a href='#'  onclick="popupReport('ReporteMetasJerarquiaComercial','anio=<%= anio %>');" id="bReporte4" title='Reporte Metas Jerarquía'>Reporte Metas Jerarquía</a>
    <% if (Model.Ejecucions.Count > 0)
       { %>
        <a href='#'  onclick="popupReport('ReporteLogErroresCargue','cargue_id=<%: Model.Ejecucions[0].id %>&cargue_tipo=2');" id="bReporte5" title='Reporte Log de Errores Cargue Metas'>Reporte Log de Errores Cargue Metas</a>
    <% }%>
    </center>
    
    <div id="ejecucionManual" style="display:none;">
        <form name="formEjecucionManual" id="formEjecucionManual">
        <input type="hidden" name="idPresupuesto" id="idPresupuesto" value="0" />
        <input type="hidden" name="idEjecucionDetalle" id="idEjecucionDetalle" value="0" />
        Busque la ejecucion que quiere actualizar. - <a href="#" onclick="popupReport('ReporteAjustesManualEjecucion','');" id="bReporteEjecucion" title='Reporte Ajustes'>Reporte Ajustes</a>
        <hr/>
        <table>
            <tr>
                <td>Meta:</td>
                <td><%= Html.DropDownList("meta_id", (SelectList)ViewData["MetasList"], "Seleccione uno...", new { id = "meta_id", @class = "required" })%></td>
            </tr>
            <tr>
                <td>Codigo Nivel:</td>
                <td><%= Html.TextBox("codigo_nivel", "", new { id = "codigo_nivel", @class = "required" })%></td>
            </tr>
            <tr>
                <td>Canal:</td>
                <td><%= Html.DropDownList("canal_id", (SelectList)ViewData["CanalList"], "Seleccione uno...", new { id = "canal_id", @class = "required" })%></td>
            </tr>
            <tr>
                <td>Año:</td>
                <td><div id="anioText"></div></td>
            </tr>
            <tr>
                <td>Mes:</td>
                <td>
                    <select name="mes" id="mes" class="required">
                        <option value="">Seleccione uno...</option>
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
                </td>
            </tr>
        </table>
        <input type="button" value="Buscar" onclick="buscarEjecucionDetalle()" id="btnbuscarEjecucionDetalle" />        
        <input type="button" value="Cancelar" onclick="cancelarEjecucionDetalle()" id="btncancelarEjecucionDetalle"/>        
        <div id="ejecucionManualInfo" style="display:none;">
            <table>
                <tr>
                    <td>Valor:</td>
                    <td><%= Html.TextBox("valor","",new { id = "valor"})%></td>
                </tr>
                <tr>
                    <td>Descripción:</td>
                    <td><%= Html.TextArea("descripcion", "", new { id = "descripcion", cols="60"})%></td>
                </tr>
                <tr>
                    <td valign="top">Ultima descripción:</td>
                    <td><div id="descripcionText" style="height:200px;overflow:auto;"></div></td>
                </tr>
                <tr>
                    <td>Actualizado Por:</td>
                    <td><div id="usuario"></div></td>
                </tr>
                <tr>
                    <td>Fecha último ajuste:</td>
                    <td><div id="fechaAjuste"></div></td>
                </tr>
            </table>          
            <br/>
            <input type="button" value="Actualizar" onclick="actualizarEjecucionDetalle()" id="btnactualizarEjecucionDetalle"/>        
        </div>
        </form>
    </div>  
</asp:Content>
