using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ZonaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Zonas"] = web.AdministracionClient.ListarZonas().Where(Zona => Zona.id > 0).ToList();
            return View(ViewData["Zonas"]);
        }

        public ActionResult Listar()
        {
            List<Zona> zonas = web.AdministracionClient.ListarZonas().Where(Zona => Zona.id > 0).ToList();
            web.Liberar();
            return View(zonas);
        }

        public ActionResult Crear()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    Zona zona = new Zona()
                    {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarZona(zona, userName) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación de registro en la tabla ZONA: " + Helper.Backup(zona).ToString(), Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            return View(web.AdministracionClient.ListarZonasPorId(id).Where(Zona => Zona.id > 0).ToList()[0]);
        }


        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    Zona zona = new Zona() { nombre = collection[0] };
                    if (web.AdministracionClient.ActualizarZona(id, zona, userName) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Actualización del registro " + id + " en la tabla ZONA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            string mensaje = "";
            try
            {
                mensaje = web.AdministracionClient.EliminarZona(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla ZONA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


