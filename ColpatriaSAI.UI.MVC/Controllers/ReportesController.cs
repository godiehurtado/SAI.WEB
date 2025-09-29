using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ReportesController : ControladorBase
    {
        //
        // GET: /Reportes/

        public ActionResult Index()
        {
            Response.Redirect("/reportes/reportes.aspx");
            return null;
        }
    }
}
