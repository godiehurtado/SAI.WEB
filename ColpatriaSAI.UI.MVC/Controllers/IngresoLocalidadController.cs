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
    public class IngresoLocalidadController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            var viewModel = new IngresoLocalidadModel()
            {
                IngresosLocalidades = web.AdministracionClient.ListarIngresoLocalidades(),
                Localidad = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre"),
                Grupo = new SelectList(new[] { "1", "2", "3" })
            };
            return View(viewModel);
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
            try
            {
                if (ModelState.IsValid)
                {
                    IngresoLocalidad ingreso = new IngresoLocalidad()
                    {
                        año = Convert.ToInt32(collection[0]),
                        localidad_id = Convert.ToInt32(collection[1]),
                        grupo = Convert.ToInt32(collection[2]),
                        valor = Convert.ToDouble(collection[3])
                    };
                    if (web.AdministracionClient.InsertarIngresoLocalidades(ingreso, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + ingreso.año + " en la tabla IngresoLocalidad.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            IngresoLocalidad ingreso = web.AdministracionClient.ListarIngresoLocalidadesPorId(id).ToList()[0];
            SelectListItem[] sl = new SelectListItem[3];
            sl[0] = new SelectListItem() { Value = "1", Text = "1" };
            sl[1] = new SelectListItem() { Value = "2", Text = "2" };
            sl[2] = new SelectListItem() { Value = "3", Text = "3" };

            var viewModel = new IngresoLocalidadModel()
            {
                Localidad = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre", ingreso.localidad_id.ToString()),
                Grupo = new SelectList(sl, "Value", "Text", ingreso.grupo.ToString()),
                IngresoLocalidad = ingreso
            };
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                if (ModelState.IsValid)
                {
                    IngresoLocalidad ingreso = new IngresoLocalidad() { id = id, año = Convert.ToInt32(collection[0]), localidad_id = Convert.ToInt32(collection[1]), grupo = Convert.ToInt32(collection[2]), valor = Convert.ToDouble(collection[3]) };
                    mensaje = web.AdministracionClient.ActualizarIngresoLocalidades(ingreso, HttpContext.Session["userName"].ToString());
                    web.Liberar();
                    if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Actualización del registro " + id + " en la tabla IngresoLocalidad.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(web.AdministracionClient.ListarIngresoLocalidadesPorId(id).ToList()[0]);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                mensaje = web.AdministracionClient.EliminarIngresoLocalidades(new IngresoLocalidad() { id = id }, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla IngresoLocalidad.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }
    }
}