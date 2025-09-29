using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ColpatriaSAI.Negocio.Componentes.LiqFranquicias;
using ColpatriaSAI.UI.MVC.Reportes;
using ColpatriaSAI.UI.MVC.Views.Shared;
using Microsoft.Reporting.WebForms;

namespace ColpatriaSAI.UI.MVC.Views.Reportes
{
    public partial class Reporte : BasePage//System.Web.UI.Page
    {
          WebPage web = new WebPage();
          protected void Page_Load(object sender, EventArgs e)
          {
              if (!IsPostBack) {

                  System.Configuration.AppSettingsReader reader = new AppSettingsReader();
                  String value = String.Empty;

                  string ReportServerUrl = reader.GetValue("ReportServerUrl", value.GetType()).ToString();
                  string ReportPath = reader.GetValue("ReportPath", value.GetType()).ToString();
                  string reporte = Request.QueryString["Reporte"];

                  if (reporte != null) {
                      ReportViewer.Reset();
                      ReportViewer.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote;
                      ReportViewer.ServerReport.ReportServerUrl = new Uri(ReportServerUrl);
                    ReportViewer.ServerReport.ReportPath = ReportPath + reporte;
                    ReportViewer.ServerReport.ReportServerCredentials = new SAIReportServerCredentials();
                      foreach (string parametro in Request.QueryString.AllKeys) {
                          if ((parametro != "Reporte") && (parametro != null)) {
                              ReportParameter rParametro = new ReportParameter(parametro, Request.QueryString[parametro]);
                            ReportViewer.ServerReport.SetParameters(rParametro);
                          }
                      }
                  }
              }
          }

          protected void ReportViewerWeb_ReportRefresh(object sender, System.ComponentModel.CancelEventArgs e)
          {
              ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "foo", "AdjustViewButton();", true); 
          }

       
    }
}
