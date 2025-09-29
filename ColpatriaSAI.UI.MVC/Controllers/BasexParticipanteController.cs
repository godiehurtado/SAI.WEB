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
    public class BasexParticipanteController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["BasexParticipantes"] = web.AdministracionClient.ListarBasexParticipantes();
            Crear();
            return View(ViewData["BasexParticipantes"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new BasexParticipanteViewModel() {
                BasexParticipanteView = new BasexParticipante(),
                ParticipanteList = new SelectList(web.AdministracionClient.ListarParticipantes(1).ToList(), "id", "nombre")
            };
            ViewData["BasexParticipanteViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    BasexParticipante basexParticipante = new BasexParticipante() {
                        @base = Convert.ToDouble(collection[0]),
                        salario = Convert.ToDouble(collection[1]),
                        participante_id = Convert.ToInt16(collection[2]),
                    };
                    string userName = HttpContext.Session["userName"].ToString();
                    if (web.AdministracionClient.InsertarBasexParticipante(basexParticipante, userName) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + basexParticipante.@base + " en la tabla BASExPARTICIPANTE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            BasexParticipante basexParticipante = web.AdministracionClient.ListarBasexParticipantesPorId(id).ToList()[0];
            var viewModel = new BasexParticipanteViewModel()
            {
                BasexParticipanteView = basexParticipante,
                ParticipanteList = new SelectList(web.AdministracionClient.ListarParticipantes(1).ToList(), "id", "nombre", basexParticipante.participante_id)
            };
            ViewData["BasexParticipanteViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                BasexParticipante basexParticipante = new BasexParticipante() {
                    @base = Convert.ToDouble(collection[0]),
                    salario = Convert.ToDouble(collection[1]),
                    participante_id = Convert.ToInt16(collection[2]),
                };
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarBasexParticipante(id, basexParticipante,userName);
                Logging.Auditoria("Actualización del registro " + id + " en la tabla BASExPARTICIPANTE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarBasexParticipante(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla BASExPARTICIPANTE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


