using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ErroresController : Controller
    {
        //
        // GET: /Errores/
        [FiltroSessionExpira]
        public ActionResult Index()
       {
            ViewBag.TituloError = "No Autorizado";
            ViewBag.CuerpoError = "Usted no tiene acceso a esta opción del Sistema de Administración de Incentivos." +
                "Por favor comuniquese con el área funcional o con el administrador del sistema para solicitar acceso.";
            return View();
        }

        public ActionResult Error()
        {
            var type = Request["type"];
            ViewBag.TituloError = "Se ha producido un error en el sistema.";
            
            if (!string.IsNullOrEmpty(type))
            {
                if (type == "404")
                    ViewBag.CuerpoError = "La página que esta buscando no existe o ha sido eliminada.";
                else if (type == "500")
                    ViewBag.CuerpoError = "Por favor vuelva a intentarlo. Si persiste el problema consulte al administrador del sistema.";
                else
                    ViewBag.CuerpoError = "Por favor vuelva a intentarlo. Si persiste el problema consulte al administrador del sistema.";
            }

            return View();
        }
    }
}
