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
    public class EscalaNotaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Escalas"] = web.AdministracionClient.ListarEscalaNotas();
            Crear();
            return View(ViewData["Escalas"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new EscalaNotaViewModel() {
                EscalaNotaView = new EscalaNota(),
                TipoEscalaList = new SelectList(web.AdministracionClient.ListarTipoEscalas().ToList(), "id", "nombre")
            };
            ViewData["EscalaNotaViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    EscalaNota escalaNota = new EscalaNota() {
                        nota = Convert.ToDouble(collection[0]),
                        porcentaje = Convert.ToDouble(collection[1]),
                        tipoEscala_id = Convert.ToInt16(collection[2]),
                        limiteInferior = Convert.ToInt16(collection[3]),
                        limiteSuperior = Convert.ToInt16(collection[4]),
                        fechaIni = Convert.ToDateTime(collection[5]),
                        fechaFin = Convert.ToDateTime(collection[6])
                    };
                    if (web.AdministracionClient.InsertarEscalaNota(escalaNota, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + escalaNota.nota + " en la tabla ESCALANOTA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            EscalaNota escalaNota = web.AdministracionClient.ListarEscalaNotasPorId(id).ToList()[0];
            var viewModel = new EscalaNotaViewModel() {
                EscalaNotaView = escalaNota,
                TipoEscalaList = new SelectList(web.AdministracionClient.ListarTipoEscalas().ToList(), "id", "nombre", escalaNota.tipoEscala_id)
            };
            ViewData["EscalaNotaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    EscalaNota escalaNota = new EscalaNota() {
                        nota = Convert.ToDouble(collection[0]),
                        porcentaje = Convert.ToDouble(collection[1]),
                        tipoEscala_id = Convert.ToInt16(collection[2]),
                        limiteInferior = Convert.ToInt16(collection[3]),
                        limiteSuperior = Convert.ToInt16(collection[4]),
                        fechaIni = Convert.ToDateTime(collection[5]),
                        fechaFin = Convert.ToDateTime(collection[6])
                    };
                    web.AdministracionClient.ActualizarEscalaNota(id, escalaNota, HttpContext.Session["userName"].ToString());
                    Logging.Auditoria("Actualización del registro " + id + " en la tabla ESCALANOTA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
                mensaje = web.AdministracionClient.EliminarEscalaNota(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla ESCALANOTA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


