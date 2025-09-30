<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reportes - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        a
        {
            text-decoration: none;
        }
        a:hover
        {
            text-decoration: underline;
            color: black;
        }
        
        table.reportes
        {
            border-width: 1px;
            border-spacing: 2px;
            border-style: hidden;
            border-color: white;
            border-collapse: collapse;
            background-color: white;
        }
        table.reportes th
        {
            border-width: 1px;
            padding: 2px;
            border-style: inset;
            border-color: red;
            background-color: white; /*-moz-border-radius: ;*/
        }
        table.reportes td
        {
            border-width: 1px;
            padding: 2px;
            border-style: inset;
            border-color: red;
            background-color: white;
            border-collapse: collapse; /*-moz-border-radius: ;*/
        }
    </style>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Reportes</h2>
            <p>
            </p>
        </div>
        <div id="progresoSeccion">
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <div id="cuadroReportes">
        <div class="seccion">
            <h3>
                Integración</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Log Errores Negocio", "VerReporte", "ReportesSAI", new { @id = "ReporteLogErroresNegocio" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Log Errores Recaudo", "VerReporte", "ReportesSAI", new { @id = "ReporteLogErroresRecaudo" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Resumen Integración", "VerReporte", "ReportesSAI", new { @id = "ReportexEjecucionIntegracion" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Errores Integración", "VerReporte", "ReportesSAI", new { @id = "ReportexErrorIntegracion" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Log Multijerarquía", "VerReporte", "ReportesSAI", new { @id = "LogErroresMultijerarquia" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Reporte Diario de cargue", "VerReporte", "ReportesSAI", new { @id = "ReporteLogDiario" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Validador Errores de cargue", "VerReporte", "ReportesSAI", new { @id = "ReporteErroresCargue" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Validador Log Segmentacion", "VerReporte", "ReportesSAI", new { @id = "LogSegmentacion" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Consolidado Detalle Meta", "VerReporte", "ReportesSAI", new { @id = "ConsolidadoMesMeta" }, new { @target = "_blank" })%></li>
            </ul>
        </div>
        <div class="seccion">
            <h3>
                Pagos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Pagos GP", "VerReporte", "ReportesSAI", new { @id = "ReportePagos" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Anticipo Franquicias", "VerReporte", "ReportesSAI", new { @id = "ReportAnticipoFranquicia" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("SAI Vs SIG (PYP)", "VerReporte", "ReportesSAI", new { @id = "RPT_saiVssig" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("SAI - SIG", "VerReporte", "ReportesSAI", new { @id = "RPT_Diferencia_SAI_SIG" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("SIG - SAI", "VerReporte", "ReportesSAI", new { @id = "RPT_Diferencia_SIG_SAI" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Consolidado Total SIG - SAI", "VerReporte", "ReportesSAI", new { @id = "RPT_ConsolidadoSIG_SAI" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Validador SIG - SAI", "VerReporte", "ReportesSAI", new { @id = "ReporteLogValidacionSISE" }, new { @target = "_blank" })%></li>                
                <li>
                    <%: Html.ActionLink("Reporte del Asesor", "VerReporte", "ReportesSAI", new { @id = "ExtraccionAsesor" }, new { @target = "_blank" })%></li>
                <li>
                    <%:Html.ActionLink("Reporte Franquicias", "Create", "RptFranquicias")%></li>
                <li>
                    <%:Html.ActionLink("Reporte Consolidado Pagos Franquicias", "VerReporte", "ReportesSAI", new { @id = "ReporteConsolidadoPagosLiquidacionFranquicias" }, new { @target = "_blank" })%></li>
            </ul>
        </div>
        <div class="seccion">
            <h3>
                Persistencia y siniestralidad</h3>
            <h4>
                Persistencia de CAPI</h4>
            <table width="100%" class="reportes">
                <tr>
                    <td align="center">
                        <b>Asesores</b>
                    </td>
                    <td align="center">
                        <b>Ejecutivos</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Detalle", "VerReporte", "ReportesSAI", new { @id = "ReportePersistenciadeCAPIDetalle" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Periodo", "VerReporte", "ReportesSAI", new { @id = "ReportePersistenciadeCAPIPeriodo" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Periodo", "VerReporte", "ReportesSAI", new { @id = "PersistenciaCAPIPeriodoEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "ReportePersistenciadeCAPIAcumulada" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "PersistenciaCAPIAcumuladaEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
            </table>
            <h4>
                Siniestralidad</h4>
            <table width="100%" class="reportes">
                <tr>
                    <td align="center">
                        <b>Asesores</b>
                    </td>
                    <td align="center">
                        <b>Ejecutivos</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Detalle", "VerReporte", "ReportesSAI", new { @id= "ReporteDetalleSiniestralidad"}, new { @target = "_blank" })%>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Periodo", "VerReporte", "ReportesSAI", new { @id = "ReporteSiniestralidad" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Periodo", "VerReporte", "ReportesSAI", new { @id = "SiniestralidadEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "ReporteSiniestralidadAcumulada" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "SiniestralidadAcumuladaEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                
            </table>
            <h4>
                Persistencia de VIDA</h4>
            <table width="100%" class="reportes">
                <tr>
                    <td align="center">
                        <b>Asesores</b>
                    </td>
                    <td align="center">
                        <b>Ejecutivos</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Detalle", "VerReporte", "ReportesSAI", new { @id = "PersistenciaVIDADetalle" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "ReportePersistenciaVIDA" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Acumulada", "VerReporte", "ReportesSAI", new { @id = "PersistenciaVIDAEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
            </table>
        </div>
        <div class="seccion">
            <h3>
                Participantes</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Ejecutivos", "VerReporte", "ReportesSAI", new { @id = "ReportEjecutivo" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Asesores", "VerReporte", "ReportesSAI", new { @id = "ReportAsesor" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Ranking", "VerReporte", "ReportesSAI", new { @id = "ReporteRanking" }, new { @target = "_blank" })%></li>
            </ul>
        </div>        
        <div class="seccion">
            <h3>
                Eficiencia</h3>
            <u>
            <li>Eficiencia ARL (Temporalmente deshabilitado)</li>
                <%--<li>
                    <%: Html.ActionLink("Eficiencia ARL", "VerReporte", "ReportesSAI", new { @id = "EficienciaARL" }, new { @target = "_blank" })%></li>--%>
            </u>
        </div>
        <div class="seccion">
            <h3>
                Producción</h3>
            <h4>
                Negocios y recaudos</h4>
            <table width="100%" class="reportes">
                <tr>
                    <td align="center">
                        <b>Negocios</b>
                    </td>
                    <td align="center">
                        <b>Recaudos</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Por fecha de cierre", "VerReporte", "ReportesSAI", new { @id = "ReporteNegocioCierre" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Por fecha de cierre", "VerReporte", "ReportesSAI", new { @id = "ReporteRecaudosCierre" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Consolidado primas", "VerReporte", "ReportesSAI", new { @id = "ReporteConsolidadoPrimas" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Consolidado", "VerReporte", "ReportesSAI", new { @id = "ReporteConsolidadoRecaudos" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Informe productividad", "VerReporte", "ReportesSAI", new { @id = "InformeProductividad" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Colquines x segmento", "VerReporte", "ReportesSAI", new { @id = "ColquinesxSegmento" }, new { @target = "_blank" })%>
                    </td>
                </tr>
            </table>
            <h4>
                Otros</h4>
            <table width="100%" class="reportes">
                <tr>
                    <td align="center">
                        <b>Consolidado Mes</b>
                    </td>
                    <td align="center">
                        <b>Otros</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Colquines mínimos", "VerReporte", "ReportesSAI", new { @id = "ReporteColquinesConsolidadoRamo" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Ingresos por asesor", "VerReporte", "ReportesSAI", new { @id = "ReporteIngresosxAsesor" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Ramos asesor", "VerReporte", "ReportesSAI", new { @id = "ReporteConsolidadoxMes" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Informe de fábrica", "VerReporte", "ReportesSAI", new { @id = "ReporteInformeFabrica" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Ejecución por Nodo", "VerReporte", "ReportesSAI", new { @id = "ReporteTotalEjecutadoxNodo" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Comisiones por Nodo", "VerReporte", "ReportesSAI", new { @id = "ReporteTotalComisionesxNodo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%: Html.ActionLink("Ejec. nodo Excepc.", "VerReporte", "ReportesSAI", new { @id = "ReporteTotalEjecutadoxNodoExcepciones" }, new { @target = "_blank" })%>
                    </td>
                    <td>
                        <%: Html.ActionLink("Cons. Mes ejecutivo", "VerReporte", "ReportesSAI", new { @id = "ReporteConsolidadoMesEjecutivo" }, new { @target = "_blank" })%>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <%: Html.ActionLink("Productos", "VerReporte", "ReportesSAI", new { @id = "ReporteCompania" }, new { @target = "_blank" })%>
                    </td>
                </tr>
            </table>
        </div>
        <div class="seccion">
            <h3>
                Presupuesto</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Presupuesto", "VerReporte", "ReportesSAI", new { @id = "ReportePresupuesto" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Metas Director", "VerReporte", "ReportesSAI", new { @id = "ReportPresupuestoEjecucion" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Metas Director Canal", "VerReporte", "ReportesSAI", new { @id = "ReportPresupuestoEjecucionCanal" }, new { @target = "_blank" })%></li>
                <li>
                    <%: Html.ActionLink("Metas Jerarquía Comercial", "VerReporte", "ReportesSAI", new { @id = "ReporteMetasJerarquiaComercial" }, new { @target = "_blank" })%></li>
            </ul>
        </div>        
        <div class="seccion">
            <h3>
                General</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Reporte Auditoria Sistema", "VerReporte", "ReportesSAI", new { @id = "ReporteLogAuditoria" }, new { @target = "_blank" })%></li>
            </ul>
        </div>
        <div class="seccion">
            <h3>
                Reportes Asíncronos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Generar Reportes", "Etl")%></li>
                <li><a href="<%= ViewBag.FTPReportes%>" target="_blank">Ver Reportes</a></li>
                <li><%: Html.ActionLink("Reportes FTP", "Reportesftp")%></li>
            </ul>
        </div>
    </div>
</asp:Content>
