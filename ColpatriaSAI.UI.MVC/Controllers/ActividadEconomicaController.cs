using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Web.Mvc.Ajax;


namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ActividadEconomicaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["ActividadEconomicas"] = Listar();
            return View();
        }

        public ActionResult Listar()
        {
            List<ActividadEconomica> actividadeconomicas = web.AdministracionClient.ListarActividadEconomicas().ToList();
            web.Liberar();
            return View(actividadeconomicas);
        }
    }
}
