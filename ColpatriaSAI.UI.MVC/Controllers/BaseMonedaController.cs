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
    public class BaseMonedaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["BaseMonedas"] = web.AdministracionClient.ListarBaseMoneda();
            Crear();
            return View(ViewData["BaseMonedas"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new BaseMonedaViewModel()
            {
                BaseMonedaView = new BaseMoneda(),
                MonedaList = new SelectList(web.AdministracionClient.ListarMonedas().ToList(), "id", "nombre")
            };
            ViewData["BaseMonedaViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    BaseMoneda baseMoneda = new BaseMoneda() {
                        fecha_inicioVigencia = Convert.ToDateTime(collection[0]),
                        fecha_finVigencia = Convert.ToDateTime(collection[1]),
                        @base = Convert.ToDouble(collection[2]),
                        moneda_id = Convert.ToInt16(collection[3])
                    };
                    string userName = HttpContext.Session["userName"].ToString();
                    if (web.AdministracionClient.InsertarBaseMoneda(baseMoneda, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + baseMoneda.@base + " en la tabla BASEMONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Rango_Fechas; View(TempData["Mensaje"]);
                    }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }
        
        public ActionResult Editar(int id)
        {
            BaseMoneda baseMoneda = web.AdministracionClient.ListarBaseMonedasPorId(id).ToList()[0];
            var viewModel = new BaseMonedaViewModel()
            {
                BaseMonedaView = baseMoneda,
                MonedaList = new SelectList(web.AdministracionClient.ListarMonedas().ToList(), "id", "nombre", baseMoneda.moneda_id)
            };
            ViewData["BaseMonedaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try {
                BaseMoneda baseMoneda = new BaseMoneda() {
                    fecha_inicioVigencia = Convert.ToDateTime(collection[0]),
                    fecha_finVigencia = Convert.ToDateTime(collection[1]),
                    @base = Convert.ToDouble(collection[2]),
                    moneda_id = Convert.ToInt16(collection[3])
                };
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.ActualizarBaseMoneda(id, baseMoneda,userName);
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla BASEMONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
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
                mensaje = web.AdministracionClient.EliminarBaseMoneda(id, null,userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla BASEMONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {


            }

            return RedirectToAction("Index");
        }

        public ActionResult ObtenerSegmentoxUsuario()
        {
            string nombreUsuario = (string)Session["username"];
            var sxu = web.AdministracionClient.ListarSegmentoxUsuario(nombreUsuario).ToList();
            return Json(sxu, JsonRequestBehavior.AllowGet);
        }
    }
}


