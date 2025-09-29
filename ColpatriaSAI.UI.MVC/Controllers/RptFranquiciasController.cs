using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class RptFranquiciasController : ControladorBase
    {
        //
        // GET: /RptFranquicias/
        WebPage web = new WebPage();

        public ActionResult Index()
        {           
            return View();
        }

        //
        // GET: /RptFranquicias/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult GenerarReporte(FormCollection collection)
        {
            try
            {
                string parametro = collection["liquidaciones_id"];

                web.AdministracionClient.BeginreportePagosFranquicia(int.Parse(parametro),null,null);

                return RedirectToAction("Create");
            }
            catch
            {
                return RedirectToAction("Index");
            }
        }


        //
        // GET: /RptFranquicias/Create

        public ActionResult Create()
        {
            List<LiquidacionFranquicia> liquidaciones = web.AdministracionClient.ListarLiquidacionFranquicias().Where(x => x.estado == 2).ToList();
            ViewBag.Liquidaciones = new SelectList(liquidaciones, "id", "id");
            return View();
        } 

        
        //
        // GET: /RptFranquicias/Edit/5
 
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /RptFranquicias/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /RptFranquicias/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /RptFranquicias/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
