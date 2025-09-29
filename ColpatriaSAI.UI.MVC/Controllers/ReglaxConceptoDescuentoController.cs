using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Data.SqlClient;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ReglaxConceptoDescuentoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["value"]  = Request.QueryString["value"];            
            ViewData["valuer"] = Request.QueryString["valuer"];            

            ViewData["Concursos"]               = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
            ViewData["Reglas"]                  = web.AdministracionClient.ListarRegla().Where(e => e.id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].nombre;
            ViewData["ReglaxConceptoDescuento"] = web.AdministracionClient.ListarReglaxConceptoDescuento().Where(P => P.regla_id == int.Parse(ViewData["valuer"].ToString()));

            return View();
        }

        //
        // GET: /ReglaxConceptoDescuento/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /ReglaxConceptoDescuento/Create

        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /ReglaxConceptoDescuento/Create

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
        // GET: /ReglaxConceptoDescuento/Edit/5
 
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /ReglaxConceptoDescuento/Edit/5

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
        // GET: /ReglaxConceptoDescuento/Delete/5
 
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /ReglaxConceptoDescuento/Delete/5

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
