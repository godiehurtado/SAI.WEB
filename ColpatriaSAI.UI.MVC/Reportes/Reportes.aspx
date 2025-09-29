<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="ColpatriaSAI.UI.MVC.Views.Reportes.Reporte" MasterPageFile="Reportes.Master" %>

   <%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

   <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
       <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <div>
            <div id="areaMenuReportes">
            <asp:Menu ID="menuReportes" runat="server" Orientation="Horizontal" >
                <Items>
                    <asp:MenuItem Text="Producción Asesor">
                        <asp:MenuItem Text="Negocios" Value="negocios" NavigateUrl="?Reporte=ReporteNegocio"></asp:MenuItem>
                        <asp:MenuItem Text="Recaudos" Value="recaudos" NavigateUrl="?Reporte=ReporteRecaudos"></asp:MenuItem>
                        <asp:MenuItem Text="Colquines" Value="colquines" NavigateUrl="?Reporte=ColquinesxSegmento"></asp:MenuItem>
                    </asp:MenuItem>
                    <asp:MenuItem Text="Productos">
                        <asp:MenuItem Text="Productos" Value="productos" NavigateUrl="?Reporte=ReporteCompania"></asp:MenuItem>
                    </asp:MenuItem>
                    <asp:MenuItem Text="Participantes">
                        <asp:MenuItem Text="Ejecutivos" Value="ejecutivos" NavigateUrl="?Reporte=ReportEjecutivo&GP=false"></asp:MenuItem>
                        <asp:MenuItem Text="Asesores" Value="asesores" NavigateUrl="?Reporte=ReportEjecutivo&GP=true"></asp:MenuItem>
                    </asp:MenuItem>
                    <asp:MenuItem Text="Franquicias">
                        <asp:MenuItem Text="Liquidación" Value="liquidacion" NavigateUrl="?Reporte=ReportLiqFranquicias"></asp:MenuItem>
                        <asp:MenuItem Text="Pagos" Value="pagos" NavigateUrl="?Reporte=ReportPagosFranq"></asp:MenuItem>
                    </asp:MenuItem>
                </Items>
            </asp:Menu>
            </div>
            <div id="areaReporte">
                <rsweb:ReportViewer ID="ReportViewer" runat="server"  
                Width="100%" Height="100%">
                </rsweb:ReportViewer>       
            </div>
        </div>
</asp:Content>
