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
    public class EtapaProductoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {           
            ViewData["EtapaConcursos"] = web.AdministracionClient.ListarEtapaProductoes();
            return View(ViewData["EtapaConcursos"]);
        }

        public ActionResult Editar(int id)
        {
            EtapaProducto etapaproducto = web.AdministracionClient.ListarEtapaProductoesPorId(id).ToList()[0];
            var viewModel = new EtapaProductoViewModel()
            {
                EtapaProductoView = etapaproducto
            };
            ViewData["EtapaProductoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
                {
                EtapaProducto etapaproducto = new EtapaProducto()
                {
                    nombre = collection[0]
                };
                web.AdministracionClient.ActualizarEtapaProducto(id, etapaproducto, HttpContext.Session["userName"].ToString());
                }
            catch 
                {

                }
                return RedirectToAction("Index");
            
        }
    }
}


