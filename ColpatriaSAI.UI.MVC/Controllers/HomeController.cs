using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using System.Collections.Generic;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    [FiltroSessionExpira]
    [HandleError]
    public class HomeController : Controller
	{
        WebPage web = new WebPage();
		public ActionResult Index()
		{
            if (Request.IsAuthenticated && HttpContext.Session["UserName"] != null) {
                List<TipoPanel> listDashboard = web.AdministracionClient.TraerDashboardxPanel();
                ViewData["listDashboard"] = listDashboard;
                return View();
            }
            else {
                //new RedirectToRouteResult(new RouteValueDictionary { { "action", "Index" }, { "controller", "Cuenta/LogOn" } });
                return View("Inicio");
            }
		}

        public ActionResult Inicio()
        {
            //Logging.Error("Mensaje de Prueba de Error", Logging.Prioridad.Media, Modulo.Concursos, TipoEvento.Error, Sesion.VariablesSesion());
            ViewData["Message"] = "Bienvenidos!";
            return View();
        }

        public ActionResult TablasControl()
        {
            if (Request.IsAuthenticated && HttpContext.Session["UserName"] != null) {
                List<TipoPanel> listDashboard = web.AdministracionClient.TraerDashboardxPanel();
                ViewData["listDashboard"] = listDashboard;
                return View();
            }
            else
            {
                return View("Inicio");
            }
        }
	}
}
