using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class AuditoriaSeguimientoController : ControladorBase
    {
        WebPage web = new WebPage();

        //
        // GET: /AuditoriaSeguimiento/
        
        /// <summary>
        /// Funcion que se encarga de iniciar la vista y traer los datos que ya estan en la BD
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            try
            {
                //ViewData["AuditoriaSeguimiento"] = web.AdministracionClient.ListarAuditoria();
                //return View(ViewData["AuditoriaSeguimiento"]);
                return View();
            }
            catch (Exception ex)
            {
                return Json(new { Result = "ERROR", Message = ex.Message });
            }
        }

    }
}
