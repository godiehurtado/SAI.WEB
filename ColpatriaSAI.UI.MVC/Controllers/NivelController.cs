using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using System.Data.SqlClient;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class NivelController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Niveles"] = web.AdministracionClient.ListarNivels();
            Crear();
            return View(ViewData["Niveles"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new NivelViewModel()
            {
                NivelView = new Nivel(),

            };
            ViewData["NivelViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    Nivel nivel = new Nivel()
                    {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarNivel(nivel, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + nivel.nombre + " en la tabla NIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            Nivel nivel = web.AdministracionClient.ListarNivelsPorId(id).ToList()[0];
            var viewModel = new NivelViewModel()
            {
                NivelView = nivel

            };
            ViewData["CrearNivel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                Nivel nivel = new Nivel()
                {
                    nombre = collection[0]
                };
                mensaje = web.AdministracionClient.ActualizarNivel(id, nivel, HttpContext.Session["userName"].ToString());
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla NIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(web.AdministracionClient.ListarNivelsPorId(id).First());
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                mensaje = web.AdministracionClient.EliminarNivel(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla NIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}
