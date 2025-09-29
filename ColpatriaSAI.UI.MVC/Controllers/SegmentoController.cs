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
    public class SegmentoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Segmentoes"] = web.AdministracionClient.ListarSegmentoes();
            Crear();
            return View(ViewData["Segmentoes"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new SegmentoViewModel()
            {
                SegmentoView = new Segmento()

            };
            ViewData["SegmentoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {

            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                if (ModelState.IsValid)
                {
                    Segmento segmento = new Segmento()
                    {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarSegmento(segmento, userName) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + segmento.nombre + " en la tabla SEGMENTO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            Segmento segmento = web.AdministracionClient.ListarSegmentoesPorId(id).ToList()[0];
            var viewModel = new SegmentoViewModel()
            {
                SegmentoView = segmento
            };
            ViewData["SegmentoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                Segmento segmento = new Segmento()
                {
                    nombre = collection[0]
                };
                mensaje = web.AdministracionClient.ActualizarSegmento(id, segmento, userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla SEGMENTO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
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
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarSegmento(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla SEGMENTO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


