using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;

namespace ColpatriaSAI.UI.MVC.Helpers
{
    public static class RouteReportsExtensions
    {
        public static string URLServerReport(this HtmlHelper helper)
        {
            System.Configuration.AppSettingsReader configuracion = new AppSettingsReader();
            string serverReport = configuracion.GetValue("ReportServerUrl", String.Empty.GetType()).ToString();
            return serverReport;
        }
    }
}