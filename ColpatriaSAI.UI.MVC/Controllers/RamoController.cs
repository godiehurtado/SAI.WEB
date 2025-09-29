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
    public class RamoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Ramos"] = web.AdministracionClient.ListarRamos();
            Crear();
            return View(ViewData["Ramos"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new RamoViewModel()
            {
                RamoView = new Ramo(),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre")
            };
            ViewData["RamoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int idRamoAgrupado = 0;
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    Ramo ramo = new Ramo()
                    {
                        nombre = collection["nombre"],
                        compania_id = int.Parse(collection["compania_id"])
                    };

                    idRamoAgrupado = web.AdministracionClient.InsertarRamo(ramo, userName);
                    TempData["RamoAgrupado"] = collection["nombre"];

                    if (idRamoAgrupado != 0)
                    {
                        Logging.Auditoria("Creación del registro " + ramo.id + " en la tabla RAMO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        return RedirectToAction("Index", "RamoDetalle", new { r = idRamoAgrupado });
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
            }
            catch { }
            return RedirectToAction("Index", "Ramo");
        }

        public ActionResult Editar(int id)
        {
            Ramo ramo = web.AdministracionClient.ListarRamosPorId(id).ToList()[0];
            var viewModel = new RamoViewModel()
            {
                RamoView = ramo,
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", ramo.compania_id)
            };
            ViewData["RamoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                Ramo ramo = web.AdministracionClient.ListarRamosPorId(id).ToList()[0];
                {
                    ramo.nombre = collection[0];
                    ramo.compania_id = int.Parse(collection["compania_id"]);
                };

                if (web.AdministracionClient.ActualizarRamo(id, ramo, userName) != 0)
                {
                    Logging.Auditoria("Actualización del registro " + ramo.id + " en la tabla RAMO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                }
                else
                {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]);
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            string userName = HttpContext.Session["userName"].ToString();
            mensaje = web.AdministracionClient.EliminarRamo(id, null, userName);
            if (mensaje == "")
            {
                Logging.Auditoria("Eliminación del registro " + id + " en la tabla RAMO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                TempData["Mensaje"] = "exito|" + Mensajes.Exito_Delete;
                return Json("");
            }
            else
            {
                TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]);
                return Json(mensaje);
            }
        }
    }
}
