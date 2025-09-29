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
    public class RamoDetalleController : ControladorBase
    {
        WebPage web = new WebPage();
        
        public ActionResult Index()
        {
            ViewData["r"] = Request.QueryString["r"];
            int id = Convert.ToInt32(ViewData["r"]);
            var ramosDetalle = web.AdministracionClient.ListarRamoDetalle(id).ToList();
            if (ViewData["r"] != null) {
                int ramoDetalle_id = Convert.ToInt32(ViewData["r"]);
                Ramo ramo = web.AdministracionClient.ListarRamosPorId(Convert.ToInt32(ViewData["r"])).First();
                ViewData["RamoAgrupado"] = ramo.nombre;
                ViewData["CompaniaAgrupada"] = ramo.Compania.nombre;
            }
            ViewData["RamosDetalle"] = ramosDetalle;
            Crear();
            return View(ViewData["RamosDetalle"]);
        }        

        [HttpPost]
        public ActionResult Index(int ramo_id, string ramosTrue, string ramosFalse)
        {
            int resultado = web.AdministracionClient.AgruparRamoDetalle(ramo_id, ramosTrue, ramosFalse);
            return RedirectToAction("Index", "Ramo");
        }

        public ActionResult Crear()
        {
            var viewModel = new RamoDetalleViewModel
            {                
                RamoDetalleView = new RamoDetalle()
            };
            ViewData["RamoDetalleViewModel"] = viewModel;
            return View(viewModel);
        } 

        public ActionResult Edit(int id)
        {
            return View();
        }        

        [HttpPost]
        public ActionResult Agrupar(int id, FormCollection collection)
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
        // GET: /RamoDetalle/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /RamoDetalle/Delete/5

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
