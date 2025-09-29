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
    public class LogIntegracionBzController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {            
            ViewData["LogIntegracions"] = web.AdministracionClient.ListarLogIntWsIns();
            Crear();
            return View(ViewData["LogIntegracions"]);
        }


        public ActionResult Crear()
        {
            return View();
        }

        public ActionResult Editar(int id)
        {
            LogIntegracionwsIntegrador logintegracionwsintegrador = web.AdministracionClient.ListarLogIntWsInsPorId(id).ToList()[0];
            var viewModel = new LogIntegracionBzViewModel()
            {
                LogIntegracionBzView = logintegracionwsintegrador

            };
            ViewData["LogIntegracionBzViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
                LogIntegracionwsIntegrador logintegracionwsintegrador = web.AdministracionClient.ListarLogIntWsInsPorId(id).ToList()[0];
                {
                    logintegracionwsintegrador.fechaInicial = Convert.ToDateTime(collection[0]);
                };

                web.AdministracionClient.ActualizarLogIntWsIns(id, logintegracionwsintegrador, HttpContext.Session["userName"].ToString());
            }
            catch { }
            return RedirectToAction("Index");
        }
    }
}
