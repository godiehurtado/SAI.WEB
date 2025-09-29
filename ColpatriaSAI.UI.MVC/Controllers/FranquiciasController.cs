using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.Seguridad.Proveedores;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Comun;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class FranquiciasController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Franquicias"] = web.AdministracionClient.ListarFranquicias();
            return View(ViewData["Franquicias"]);
        }
 
        public ActionResult CondicionesGenerales()
        {
            Session["idfranquicia"] = "0";
            return RedirectToAction("Create","ParticipacionFranquicias");
        }

        public ActionResult Details(int id)
        {
            ViewData["FranquiciasDet"] = web.AdministracionClient.DetalleFranquicia(id);
            return View(ViewData["FranquiciasDet"]);
        }

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Franquicias/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
        
        //
        // GET: /Franquicias/Edit/5 
        public ActionResult Edit(int id)
        {
            List<Localidad> franquicias = web.AdministracionClient.ListarFranquiciaPorId(id);
         
            return View(franquicias[0]);
        }

        //
        // POST: /Franquicias/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Franquicias/Delete/5 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Franquicias/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

    }
}
