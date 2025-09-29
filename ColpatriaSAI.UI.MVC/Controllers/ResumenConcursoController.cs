using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Controllers;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ResumenConcursoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
            }

            try
            {
                if (int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Concursos"]             = web.AdministracionClient.ListarConcursoesPorId(int.Parse(ViewData["value"].ToString())).ToList()[0];
                    ViewData["ParticipanteConcursos"] = web.AdministracionClient.ListarParticipanteConcursoes().Where(P => P.concurso_id == int.Parse(ViewData["value"].ToString()));
                    ViewData["ProductoConcursos"]     = web.AdministracionClient.ListarProductoConcursoes().Where(P => P.concurso_id == int.Parse(ViewData["value"].ToString()));                    
                    ViewData["Reglas"]                = web.AdministracionClient.ListarRegla().Where(e => e.concurso_id == int.Parse(ViewData["value"].ToString()));
                    //ViewData["subReglas"] = web.AdministracionClient.ListarSubRegla().Where(e => e.id == int.Parse(ViewData["valuesr"].ToString())).ToList()[0].descripcion;
                    //ViewData["Condiciones"] = web.AdministracionClient.ListarCondicion().Where(P => P.subregla_id == int.Parse(ViewData["valuesr"].ToString()));
                    //ViewData["PremioxSubReglas"] = web.AdministracionClient.ListarPremioxSubregla().Where(P => P.subregla_id == int.Parse(ViewData["valuesr"].ToString()));

                    return View();
                }
            }
            catch { }
            return RedirectToAction("Index", "Concursos");
        }  
    }
}


