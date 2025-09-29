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
    public class BeneficiarioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {

            ViewData["Beneficiarios"] = web.AdministracionClient.ListarBeneficiarios();
            Crear();
            return View(ViewData["Beneficiarios"]);

        }

        public ActionResult Details(int id)
        {
            return View();
        }


        public ActionResult Crear()
        {
            var viewModel = new BeneficiarioViewModel()
            {
                
                BeneficiarioView = new Beneficiario(),
                ClienteList = new SelectList(web.AdministracionClient.ListarClientes().ToList(), "id", "nombre")
            };
            ViewData["BeneficiarioViewModel"] = viewModel;
            return View(viewModel);
        }

        

        
    }
}
