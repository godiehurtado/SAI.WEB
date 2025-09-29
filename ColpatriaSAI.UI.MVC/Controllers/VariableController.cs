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
    public class VariableController : ControladorBase
    {
    WebPage web = new WebPage();

        public ActionResult Index()
        {

            ViewData["Variables"] = web.AdministracionClient.ListarVariables();
            Crear();
            return View(ViewData["Variables"]);

        }

        public ActionResult Details(int id)
        {
            return View();
        }


        public ActionResult Crear()
        {
            var viewModel = new VariableViewModel()
            {
                VariableView = new Variable(),
                TipovariableList = new SelectList(web.AdministracionClient.ListarTipovariables().ToList(), "id", "tipovariable1")
            };
            ViewData["VariableViewModel"] = viewModel;
            return View(viewModel);
        }

        

        
    }
}
