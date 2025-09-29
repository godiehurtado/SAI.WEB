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
    public class CanalController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Canals"] = web.AdministracionClient.ListarCanals();
            Crear();
            return View(ViewData["Canals"]);
        }

        public ActionResult Crear()
        {
            var viewModel = new CanalViewModel()
            {
                CanalView = new Canal()
            };
            ViewData["CanalViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {            
            try {
                if (ModelState.IsValid) {
                    string userName = HttpContext.Session["userName"].ToString();
                    Canal canal = new Canal() {
                        nombre = collection[0]                        
                    };
                    if (web.AdministracionClient.InsertarCanal(canal, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + canal.nombre + " en la tabla CANAL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            Canal canal = web.AdministracionClient.ListarCanalsPorId(id).ToList()[0];
            var viewModel = new CanalViewModel()
            {
                CanalView = canal
            };
            ViewData["CanalViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try {
                Canal canal = new Canal() {
                    nombre = collection[0]
                };
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.ActualizarCanal(id, canal, userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla CANAL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
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
            try {
                string mensaje = "";
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarCanal(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla CANAL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


