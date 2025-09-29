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
    public class LineaNegocioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {

            ViewData["LineaNegocios"] = web.AdministracionClient.ListarLineaNegocios();
            Crear();
            return View(ViewData["LineaNegocio"]);

        }

        public ActionResult Details(int id)
        {
            return View();
        }


        public ActionResult Crear()
        {
            var viewModel = new LineaNegocioViewModel()
            {
                LineaNegocioView = new LineaNegocio(),
            };
            ViewData["LineaNegocioViewModel"] = viewModel;
            return View(viewModel);
        }




    }
}
