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
    public class CoberturaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Coberturas"] = Listar();
            return View();

        }

        public ActionResult Listar()
        {
            List<Cobertura> coberturas = web.AdministracionClient.ListarCoberturas().ToList();
            web.Liberar();
            return View(coberturas);
        }


    }
}