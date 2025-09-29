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
    public class FactorVariableController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Factores"] = web.AdministracionClient.ListarFactorVariables();
            Crear();
            return View(ViewData["Factores"]);
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
                    FactorVariable factorVariable = new FactorVariable() {
                        nombre = collection[0],
                        valorDirecto = Convert.ToDouble(collection[1]),
                        valorContratacion = Convert.ToDouble(collection[2])
                    };
                    if (web.AdministracionClient.InsertarFactorVariable(factorVariable, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + factorVariable.nombre + " en la tabla FACTORVARIABLE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            FactorVariable factorVariable = web.AdministracionClient.ListarFactorVariablesPorId(id).ToList()[0];
            return View(factorVariable);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    FactorVariable factorVariable = new FactorVariable() {
                        nombre = collection[0],
                        valorDirecto = Convert.ToDouble(collection[1]),
                        valorContratacion = Convert.ToDouble(collection[2])
                    };
                    web.AdministracionClient.ActualizarFactorVariable(id, factorVariable, HttpContext.Session["userName"].ToString());
                    Logging.Auditoria("Actualización del registro " + id + " en la tabla FACTORVARIABLE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
                mensaje = web.AdministracionClient.EliminarFactorVariable(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla ZONA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


