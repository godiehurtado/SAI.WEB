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
    public class AntiguedadxNivelController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Antiguedades"] = web.AdministracionClient.ListarAntiguedades();
            Crear();
            return View();
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new AntiguedadViewModel()
            {
                AntiguedadView = new AntiguedadxNivel(),
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().ToList(), "id", "nombre")
            };
            ViewData["AntiguedadViewModel"] = viewModel;
            return View();
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    AntiguedadxNivel antiguedad = new AntiguedadxNivel()
                    {
                        numeroMeses = Convert.ToInt16(collection[0]),
                        nivel_id = Convert.ToInt16(collection[1])

                    };
                    if (web.AdministracionClient.InsertarAntiguedadxNivel(antiguedad, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + antiguedad.numeroMeses + " en la tabla ANTIGUEDADxNIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            AntiguedadxNivel antiguedad = web.AdministracionClient.ListarAntiguedadesPorId(id).ToList()[0];
            var viewModel = new AntiguedadViewModel()
            {
                AntiguedadView = antiguedad,
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().ToList(), "id", "nombre", antiguedad.nivel_id)
            };
            ViewData["EditarAntiguedad"] = viewModel;
            return View();
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                AntiguedadxNivel antiguedad = new AntiguedadxNivel()
                {
                    numeroMeses = Convert.ToInt16(collection[0]),
                    nivel_id = Convert.ToInt16(collection[1])
                };
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.ActualizarAntiguedadxNivel(id, antiguedad, userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla ANTIGUEDADxNIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            //web.AdministracionClient.ListarAntiguedadesPorId(id).First()
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                mensaje = web.AdministracionClient.EliminarAntiguedadxNivel(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla ANTIGUEDADxNIVEL.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


