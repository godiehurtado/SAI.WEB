using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ExcepcionesJerarquiaController : ControladorBase
    {
        //
        // GET: /Excepciones/
        WebPage web = new WebPage();
        public ActionResult Index(int id)
        {
            var model = new ExcepcionJerarquiaDetalleModel();

            return View(model);
        }        
    }
}
