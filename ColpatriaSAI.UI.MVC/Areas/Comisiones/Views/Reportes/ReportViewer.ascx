<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<script runat="server">
    private void Page_Load(object sender, System.EventArgs e)
    {
        ReportDataSource rds = new ReportDataSource();
        string lRutaReporte = string.Empty;
        if (Model.TipoReporte == 1)
        {
            rds = new ReportDataSource("ReporteBeneficiarios", Model.lDatos);
            lRutaReporte = Server.MapPath("~/Areas/Comisiones/Reports/ReporteBeneficiarios.rdlc");
        }
        else if (Model.TipoReporte == 2)
        {
            rds = new ReportDataSource("ReporteTransferencias", Model.lDatos);
            lRutaReporte = Server.MapPath("~/Areas/Comisiones/Reports/ReporteTransferencias.rdlc");
        }
        else if (Model.TipoReporte == 3)
        {
            rds = new ReportDataSource("ReporteAsesores", Model.lDatos);
            lRutaReporte = Server.MapPath("~/Areas/Comisiones/Reports/ReporteAsesores.rdlc");
        }
        ReportViewer1.LocalReport.ReportPath = lRutaReporte;
        ReportViewer1.LocalReport.DataSources.Clear();
        ReportViewer1.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Local;
        ReportViewer1.LocalReport.DataSources.Add(rds);
        ReportViewer1.LocalReport.Refresh();
    }
</script>
<form id="Form1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<rsweb:ReportViewer ID="ReportViewer1" runat="server" AsyncRendering="false" Width="850px">
</rsweb:ReportViewer>
</form>
