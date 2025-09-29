using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class InicioController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        //
        // GET: /Comisiones/Inicio/

        [Authorize]
        public ActionResult Index()
        {
            ViewBag.FTPReportes = new AppSettingsReader().GetValue("FTPReportes", String.Empty.GetType()).ToString() + "/ReportesComision/";
            
            return View();
        }


        [Authorize]
        public ActionResult Excepciones(int Id)
        {
            ViewBag.id = Id;
            return View(ViewBag);
        }

    }
}
