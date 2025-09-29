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
    public class P_P_VidaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["ParametrosVida"] = web.AdministracionClient.ListarPPVIDA().Where(PPV => PPV.id > 0).ToList();
            return View(ViewData["ParametrosVida"]);
        }
        
        public ActionResult Editar(int id)
        {
            ParametrosPersistenciaVIDA ppv = web.AdministracionClient.ListarPPVIDAPorId(id).ToList()[0];
            var viewModel = new P_P_VidaViewModel()
            {
                P_P_VidaView = ppv

            };
            ViewData["P_P_VidaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
                ParametrosPersistenciaVIDA ppv = new ParametrosPersistenciaVIDA()
                {
                    factor = float.Parse(collection[0])
                };

                web.AdministracionClient.ActualizarPPV(id, ppv, HttpContext.Session["userName"].ToString());
            }
            catch { }
            return RedirectToAction("Index");
        }        
    }
}
