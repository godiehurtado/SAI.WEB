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
    public class ParticipacionDirectorController : ControladorBase
    {
        WebPage web = new WebPage();

        public ViewResult Index()
        {
            List<ParticipacionDirector> parts = web.AdministracionClient.ListarParticipacionesDirector().ToList();
            Crear();
            return View(parts);
        }

        public int codigoNivelDirector()
        {
            return web.AdministracionClient.ListarNivels().Single(n => n.nombre == "Director").id;
        }

        [HttpGet]
        public ActionResult Directores()
        {
            //int inicio = 0;
            //int cantidad = 20;
            //ViewData["Directores"] = web.AdministracionClient.ListarParticipantesIndex(inicio, cantidad).Where(p => p.nivel_id == codigoNivelDirector());
            return View();
        }

        [HttpPost]
        public ActionResult Directores(string texto, int inicio, int cantidad)
        {
            int idNivel = web.AdministracionClient.ListarNivels().Single(n => n.nombre == "Director").id;
            var directores = web.AdministracionClient.ListarNodosBuscador(1, texto, inicio, cantidad, idNivel, 0, 0, "")
                .Select(p => new
                {
                    p.id,
                    nombreNodo = p.nombre,
                    nombreZona = p.Zona.nombre,
                    nombreCanal = (p.Canal != null) ? p.Canal.nombre : "",
                    p.codigoNivel,
                    nombreNivel = p.Nivel.nombre
                });
            return Json(directores, 0);
        }

        public ActionResult Crear()
        {
            ViewBag.compania_id = new SelectList(web.AdministracionClient.ListarCompanias(), "id", "nombre");

            List<Canal> canales = web.AdministracionClient.ListarCanals();
            canales.Insert(0, new Canal() { id = 0, nombre = "Todos" });
            ViewBag.canal_id = new SelectList(canales, "id", "nombre");
            //ViewBag.participante_id = new SelectList(web.AdministracionClient.ListarParticipantes().Where(p => p.nivel_id == idNivel), "id", "nombre");
            return View();
        }

        [HttpPost]
        public ActionResult Crear(ParticipacionDirector part)
        {
            string userName = HttpContext.Session["userName"].ToString();
            part.id = web.AdministracionClient.InsertarParticipacionDirector(part, userName);
            if (part.id == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Insert; View(TempData["Mensaje"]); }
            else
            {
                TempData["Mensaje"] = "info|" + Mensajes.Exito_Insert; View(TempData["Mensaje"]);
                Logging.Auditoria("Insersión del registro " + part.id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
            }
            return RedirectToAction("Index");
        }

        public ActionResult Editar(int id)
        {
            List<Canal> canales = web.AdministracionClient.ListarCanals();
            canales.Insert(0, new Canal() { id = 0, nombre = "Todos" });

            ParticipacionDirector part = web.AdministracionClient.ListarParticipacionDirectorPorId(id)[0];
            var viewModel = new PpacionDirectorViewModel()
            {
                PpanteDirectorView = part,
                CanalList = new SelectList(canales, "id", "nombre", part.canal_id),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias(), "id", "nombre", part.compania_id)
            };
            ViewData["PpanteDirector"] = viewModel;
            //ViewBag.compania_id = new SelectList(web.AdministracionClient.ListarCompanias(), "id", "nombre", part.compania_id);
            //ViewBag.participante_id = new SelectList(web.AdministracionClient.ListarParticipantes().Where(
            //    p => p.nivel_id == web.AdministracionClient.ListarNivels().Single(n => n.nombre == "Director").id), "id", "nombre", participacione.participante_id);
            return View();
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                ParticipacionDirector part = new ParticipacionDirector()
                {
                    fechaIni = Convert.ToDateTime(collection[0]),
                    fechaFin = Convert.ToDateTime(collection[1]),
                    compania_id = Convert.ToInt32(collection[2]),
                    canal_id = Convert.ToInt32(collection[3]),
                    jerarquiaDetalle_id = Convert.ToInt32(collection[5]),
                    porcentaje = Convert.ToDouble(collection[6])
                };
                mensaje = web.AdministracionClient.ActualizarParticipacionDirector(id, part, userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + part.id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost, ActionName("Eliminar")]
        public ActionResult DeleteConfirmed(int id)
        {
            string mensaje = "";
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarParticipacionDirector(id, null, userName);
                if (mensaje != "1") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PARTICIPACIONES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

    }
}
