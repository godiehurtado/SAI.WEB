using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ParticipacionController : ControladorBase
    {
        WebPage web = new WebPage();

        public ViewResult Index()
        {
            List<Participacione> parts = web.AdministracionClient.ListarParticipaciones().ToList();
            Crear();
            return View(parts);
        }

        public ActionResult getRamos(int idCompa)
        {
            //List<Ramo> ramos = web.AdministracionClient.ListarRamos().Where(r => r.compania_id == idCompa).Select(r => new { id = r.id, nombre = r.nombre });
            return Json(web.AdministracionClient.ListarRamosPorCompania(idCompa).Select(r => new { r.nombre, r.id }).OrderBy(r => r.nombre).ToList(), 0);
        }

        public ActionResult Crear()
        {
            //Participacione part = new Participacione();
            //ViewData["Participacion"] = new Participacione();
            List<LineaNegocio> lineas = web.AdministracionClient.ListarLineaNegocios().OrderBy(c => c.nombre).ToList();
            lineas.Insert(0, new LineaNegocio() { id = 0, nombre = "Todas" });
            List<Compania> companias = web.AdministracionClient.ListarCompanias().OrderBy(c => c.nombre).ToList();

            ViewBag.compania_id = new SelectList(companias, "id", "nombre");
            ViewBag.lineaNegocio_id = new SelectList(lineas, "id", "nombre");
            ViewBag.ramo_id = new SelectList(web.AdministracionClient.ListarRamos().OrderBy(r => r.nombre).ToList(), "id", "nombre");
            return View();
        }

        [HttpPost]
        public ActionResult Crear(Participacione part)
        {
            string userName = HttpContext.Session["userName"].ToString();
            part.id = web.AdministracionClient.InsertarParticipacion(part, userName);
            if (part.id == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Insert; View(TempData["Mensaje"]); }
            else
            {
                TempData["Mensaje"] = "info|" + Mensajes.Exito_Insert; View(TempData["Mensaje"]);
                Logging.Auditoria("Insersión del registro " + part.id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
            }
            return RedirectToAction("Index");
        }

        public ViewResult Editar(int id)
        {

            Participacione part = web.AdministracionClient.ListarParticipacionPorId(id)[0];
            List<LineaNegocio> lineas = web.AdministracionClient.ListarLineaNegocios(); //lineas.RemoveAt(0);
            lineas.Insert(0, new LineaNegocio() { id = 0, nombre = "Todas" });
            var viewModel = new ParticipacionViewModel()
            {
                ParticipacionView = part,
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias(), "id", "nombre", part.compania_id),
                LineaNegocioList = new SelectList(lineas, "id", "nombre", part.lineaNegocio_id),
                RamoList = new SelectList(web.AdministracionClient.ListarRamosPorCompania((int)part.compania_id).ToList(), "id", "nombre", part.ramo_id)
            };
            ViewData["Participaciones"] = viewModel;
            return View();
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                Participacione part = new Participacione()
                {
                    fechaIni = Convert.ToDateTime(collection["fechaIniEdit"]),
                    fechaFin = Convert.ToDateTime(collection["fechaFinEdit"]),
                    compania_id = Convert.ToInt32(collection["eCompania_id"]),
                    lineaNegocio_id = Convert.ToInt32(collection["eLineaNegocio_id"]),
                    ramo_id = Convert.ToInt32(collection["eRamo_id"]),
                    mesesAntiguedad = Convert.ToInt32(collection["eMesesAntiguedad"]),
                    porcentaje = Convert.ToDouble(collection["ePorcentaje"])
                };
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.ActualizarParticipacion(id, part, userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + part.id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            //Participacione participacione = db.Participaciones.Single(p => p.id == id);
            return View(id);
        }

        [HttpPost, ActionName("Eliminar")]
        public ActionResult DeleteConfirmed(int id)
        {
            string mensaje = "";
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarParticipacion(id, null, userName);
                if (mensaje != "1") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }
    }
}