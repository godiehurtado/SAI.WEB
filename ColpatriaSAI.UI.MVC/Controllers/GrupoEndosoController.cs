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
    public class GrupoEndosoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["GrupoEndoso"] = web.AdministracionClient.ListarGrupoEndosos();
            Crear();
            return View(ViewData["GrupoEndoso"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            return View();
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            
            try {
                if (ModelState.IsValid) {
                    GrupoEndoso grupoEndoso = new GrupoEndoso() {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarGrupoEndoso(grupoEndoso, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }
        
        public ActionResult Editar(int id)
        {
            GrupoEndoso grupoEndoso = web.AdministracionClient.ListarGrupoEndososPorId(id).ToList()[0];
            return View(grupoEndoso);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    GrupoEndoso grupoEndoso = new GrupoEndoso() {
                        nombre = collection[0]
                    };
                    web.AdministracionClient.ActualizarGrupoEndoso(id, grupoEndoso, HttpContext.Session["userName"].ToString());
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try {
                mensaje = web.AdministracionClient.EliminarGrupoEndoso(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
            }
            catch (Exception ex)
            {


            }

            return RedirectToAction("Index");
        }
    }
}


