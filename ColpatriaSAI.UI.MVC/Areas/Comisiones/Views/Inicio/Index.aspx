<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Parametrizaci&oacute;n - Comisiones
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Comisiones</h2>
            <p>
            </p>
        </div>
        <div id="progresoSeccion">
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <div id="cuadroAdministracion">
        <div class="seccion">
            <h3>
                Parametrización</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Modelo Comisión", "ModeloComision", "Modelos")%></li>
                    <li>
                    <%: Html.ActionLink("Consulta Modelo Comisión", "ConsultaParametrizacion", "ConsultaParametrizacion")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <%--<div class="seccion">
            <h3>
                Extracci&oacute;n de datos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Invocación manual", "Manual", "Extraccion")%></li>--%>
                <%--<li>
                    <%: Html.ActionLink("Invocación programada", "Programacion", "Extraccion")%></li>--%>
           <%-- </ul>
            <div style="clear: both;">
            </div>
        </div>--%>
        <div class="seccion">
            <h3>
                C&aacute;lculos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Cálculos de Talentos por Usuarios Nuevos", "CalculosTalentos", "CalculoUsuarios")%></li>
                <li>
                    <%: Html.ActionLink("Cálculos de Talentos por Usuarios Netos", "CalculosNetos", "CalculoUsuarios")%></li>
                <li>
                    <%: Html.ActionLink("Cálculos Comisión", "CalculoComision", "CalculoComision")%></li>
                <li>
                    <%: Html.ActionLink("Históricos Liquidaciones", "Historico", "CalculoComision")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Reportes Comisi&oacute;n</h3>
            <ul>
             
                    <%--<%: Html.ActionLink("Resumen de beneficiarios para cálculo de comisión variable", "ReportesBeneficiario", "Reportes")%></li>--%>
             
                <li>
                    <%: Html.ActionLink("Resumen mensual de liquidación por Asesores", "ReporteAsesores", "Reportes")%></li>
             
                    <%
                        ViewBag.RepLiquidacion = new AppSettingsReader().GetValue("RepLiquidacion", String.Empty.GetType()).ToString();
                        ViewBag.RepPagoAsesores = new AppSettingsReader().GetValue("RepPagoAsesores", String.Empty.GetType()).ToString();    
                     %>
                    <li><a href="<%= ViewBag.RepLiquidacion%>" target="_blank">Reporte pago de liquidación comisiones</a></li>
                    <li><a href="<%= ViewBag.RepPagoAsesores%>" target="_blank">Reporte pago de Comisiones x Asesos</a></li>

                        <li><%: Html.ActionLink("Reportes BH-SAI", "ReportsBH", "Reportes")%></li>

             

            </ul>
            <div style="clear: both;">
            </div>
        </div>
          <div style="clear: both;">
            </div>
         <div class="seccion">
            <h3>
                Consultas</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Tablero calculo comisión", "bitacoraPorCalculo", "Consultas")%>

                </li>
                
            </ul>
            <div style="clear: both;">
            </div>
        </div>
      
         <div class="seccion">
            <h3>
                Administración</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Configuración", "Parametros", "AdminComision")%>

                </li>
                <li>
                    <%: Html.ActionLink("Novedades Usuarios", "NovedadesUsuarios", "AdminComision")%>

                </li>
                
            </ul>
            <div style="clear: both;">
            </div>
        </div>
    </div>
</asp:Content>
