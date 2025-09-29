using System;
using System.Configuration;
using Microsoft.Reporting.WebForms;
using System.IO;
using System.Collections.Generic;

namespace ColpatriaSAI.UI.MVC.Reportes {
    public partial class verReporte : System.Web.UI.Page {

        protected void Page_Load(object sender, EventArgs e) {
            
            List<string> formatosValidos = new List<string>(new string[] { "HTML3.2", "HTML4.0", "MHTML", "IMAGE", "EXCEL", "WORD", "CSV", "PDF", "XML" });
            string formato = "";
            
            if (!IsPostBack)
            {
                System.Configuration.AppSettingsReader reader = new AppSettingsReader();
                String value = String.Empty;
                
                // Tomar los valores del servidor de reportes del web.config
                string ReportServerUrl = reader.GetValue("ReportServerUrl", value.GetType()).ToString();
                string ReportPath = reader.GetValue("ReportPath", value.GetType()).ToString();
                string reporte = Request.QueryString["Reporte"];
                if (reporte != null)
                {
                    ReportViewerWeb.Reset();
                    ReportViewerWeb.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote;
                    ReportViewerWeb.ServerReport.ReportServerUrl = new Uri(ReportServerUrl);
                    ReportViewerWeb.ServerReport.ReportPath = ReportPath + reporte;
                    ReportViewerWeb.ServerReport.Timeout = 1000000;

                    // Definir las credenciales para poder acceder al reporte. 
                    ReportViewerWeb.ServerReport.ReportServerCredentials = new SAIReportServerCredentials();
                    
                    // Tomar los parametros del querystring para enviarselos al reporte
                    foreach (string parametro in Request.QueryString.AllKeys)
                    {
                        if ((parametro != "Reporte") && (parametro != "Formato") && (parametro != null))
                        {
                            ReportParameter rParametro = new ReportParameter(parametro, Request.QueryString[parametro]);
                            ReportViewerWeb.ServerReport.SetParameters(rParametro);
                        }
                    }

                    // Se busca si estan definidos todos los parametros del reporte para poder generarlo en excel
                    // de lo contrario se genera en pantalla para solicitar los parametros que hagan falta
                    ReportParameterInfoCollection  parametrosR = ReportViewerWeb.ServerReport.GetParameters();
                    bool descargar = true;
                    foreach (ReportParameterInfo item in parametrosR) {
                        if (!item.AllowBlank)
                            if (item.State != ParameterState.HasValidValue)
                                descargar = false;
                    }

                    if(reporte == "ReporteLogDiario" || reporte == "LogSegmentacion")
                        descargar = false;

                    // Se valida si se puede descargar directamente, es decir, si tiene todos los parametros requeridos
                    if (descargar) {
                        string formatoQuery = Request.QueryString["Formato"];
                        if (formatoQuery != null)
                            formato = formatosValidos.Contains(Request.QueryString["Formato"].ToUpper()) ? Request.QueryString["Formato"] : "CSV";
                        else
                            formato = "CSV";
                        // Este método exporta el reporte en el formato requerido
                        ExportarReporte(formato);
                    }
                }

            }
        }
        /// <summary>
        /// Permite generar un reporte en un formato determinado
        /// </summary>
        /// <param name="formato">Formato a utilizar para generar el reporte. Los valores válidos son: HTML3.2, HTML4.0, MHTML, IMAGE, EXCEL, WORD, CSV, PDF, XML</param>
        public void ExportarReporte(string formato) {
            
            Microsoft.Reporting.WebForms.Warning[] warnings;
            string[] streamids;
            string mimeType;
            string encoding;
            string extension;
            byte[] bResult = null; // En esta variable se almacena el resultado del reporte que genera el Report Server


            ReportViewerWeb.ServerReport.Timeout = 3600000; //Timeout de 60 min
            bResult = ReportViewerWeb.ServerReport.Render(formato, null, out mimeType, out encoding, out extension,out streamids, out warnings);

            // Si hay resultados se procesa y genera el archivo
            if (bResult != null) {
                MemoryStream ms = null;
                try {
                    String strReportFileName = Request.QueryString["Reporte"] ?? "Reporte";
                    Response.BufferOutput = false;
                    Response.Clear();

                    Response.AddHeader("content-length", bResult.Length.ToString());
                    Response.ContentType = mimeType;
                    Response.AppendHeader("Content-Disposition", "attachment;filename=" + strReportFileName + "." + extension);
                    Response.Flush();
                    
                    // Escribir el archivo
                    if (Response.IsClientConnected) {
                        //Response.BinaryWrite(bResult);
                        const int iBufferSize = 16384;
                        ms = new MemoryStream(bResult);

                        byte[] buffer = new byte[iBufferSize];
                        int count = 0;
                        int offset = 0;
                        while ((count = ms.Read(buffer, offset, buffer.Length)) > 0) {
                            Response.OutputStream.Write(buffer, offset, count);
                            Response.Flush();
                        }
                    }
                } finally {
                    if (ms != null)
                        ms.Dispose();
                    Response.End();
                    Response.Close();
                }

            }

        }

    }
}