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
    public class TipoEndosoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Tipos"] = web.AdministracionClient.ListarTipoEndoso();
            Crear();
            return View(ViewData["Tipos"]);
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

            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    TipoEndoso TipoEndoso = new TipoEndoso()
                    {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarTipoEndoso(TipoEndoso, userName) != 0)
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
            TipoEndoso tipoEndoso = web.AdministracionClient.ListarTipoEndososPorId(id).ToList()[0];
            return View(tipoEndoso);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    TipoEndoso tipoEndoso = new TipoEndoso()
                    {
                        nombre = collection[0]
                    };
                    web.AdministracionClient.ActualizarTipoEndoso(id, tipoEndoso, userName);
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
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                mensaje = web.AdministracionClient.EliminarTipoEndoso(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
            }
            catch (Exception ex)
            {


            }

            return RedirectToAction("Index");
        }
    }
}


