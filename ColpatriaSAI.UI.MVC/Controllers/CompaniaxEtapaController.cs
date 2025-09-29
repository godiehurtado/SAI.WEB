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
    public class CompaniaxEtapaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["valuet"] != string.Empty)
            {
                ViewData["valuet"] = Request.QueryString["valuet"];
                TempData["valuet"] = Request.QueryString["valuet"];               
            }

            try
            {
                if (int.Parse(ViewData["valuet"].ToString()) != null)
                {                    
                    ViewData["EtapaConcursos"]  = web.AdministracionClient.ListarEtapaProductoes().Where(e => e.id == int.Parse(ViewData["valuet"].ToString())).ToList()[0].nombre;
                    ViewData["CompaniaxEtapas"] = web.AdministracionClient.ListarCompaniaxEtapa().Where(P => P.etapa_id == int.Parse(ViewData["valuet"].ToString())); ;                    
                    return View();
                }
            }

            catch { }

            return RedirectToAction("Index", "Concursos");
        }
  
        public ActionResult Editar(int id)
        {
            CompaniaxEtapa companiaxetapa = web.AdministracionClient.ListarCompaniaxEtapaPorId(id).ToList()[0];
            var viewModel = new CompaniaxEtapaViewModel()
            {
                CompaniaxEtapaView = companiaxetapa,
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", companiaxetapa.compania_id) 
            };
            ViewData["CompaniaxEtapaViewModel"] = viewModel;

            var mes_inicio = new List<SelectListItem>();

            mes_inicio.Add(new SelectListItem { Value = "1", Text = "Enero" });
            mes_inicio.Add(new SelectListItem { Value = "2", Text = "Febrero" });
            mes_inicio.Add(new SelectListItem { Value = "3", Text = "Marzo" });
            mes_inicio.Add(new SelectListItem { Value = "4", Text = "Abril" });
            mes_inicio.Add(new SelectListItem { Value = "5", Text = "Mayo" });
            mes_inicio.Add(new SelectListItem { Value = "6", Text = "Junio" });
            mes_inicio.Add(new SelectListItem { Value = "7", Text = "Julio" });
            mes_inicio.Add(new SelectListItem { Value = "8", Text = "Agosto" });
            mes_inicio.Add(new SelectListItem { Value = "9", Text = "Septiembre" });
            mes_inicio.Add(new SelectListItem { Value = "10", Text = "Octubre" });
            mes_inicio.Add(new SelectListItem { Value = "11", Text = "Noviembre" });
            mes_inicio.Add(new SelectListItem { Value = "12", Text = "Dicimebre" });

            ViewData["mes_inicio"] = mes_inicio;

            var mes_fin = new List<SelectListItem>();

            mes_fin.Add(new SelectListItem { Value = "1", Text = "Enero" });
            mes_fin.Add(new SelectListItem { Value = "2", Text = "Febrero" });
            mes_fin.Add(new SelectListItem { Value = "3", Text = "Marzo" });
            mes_fin.Add(new SelectListItem { Value = "4", Text = "Abril" });
            mes_fin.Add(new SelectListItem { Value = "5", Text = "Mayo" });
            mes_fin.Add(new SelectListItem { Value = "6", Text = "Junio" });
            mes_fin.Add(new SelectListItem { Value = "7", Text = "Julio" });
            mes_fin.Add(new SelectListItem { Value = "8", Text = "Agosto" });
            mes_fin.Add(new SelectListItem { Value = "9", Text = "Septiembre" });
            mes_fin.Add(new SelectListItem { Value = "10", Text = "Octubre" });
            mes_fin.Add(new SelectListItem { Value = "11", Text = "Noviembre" });
            mes_fin.Add(new SelectListItem { Value = "12", Text = "Dicimebre" });

            ViewData["mes_fin"] = mes_fin;

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int etapavalue = Convert.ToInt16(TempData["valuet"]);
            string userName = HttpContext.Session["userName"].ToString();
                try
                {
                    CompaniaxEtapa companiaxetapa = new CompaniaxEtapa()
                    {                        
                        mes_inicial = int.Parse(collection[0]),
                        mes_final   = int.Parse(collection[1])
                        
                    };
                    web.AdministracionClient.ActualizarCompaniaxEtapa(id, companiaxetapa, userName);

                }
                catch { }
            return RedirectToAction("Index", new { valuet = etapavalue});
            
        }
    }
}


