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
    public class MonedaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Monedas"] = web.AdministracionClient.ListarMonedas();
            Crear();
            return View(ViewData["Monedas"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new MonedaViewModel() {
                MonedaView = new Moneda(),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre"),
                UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadesMedida().ToList(), "id", "nombre")
            };
            ViewData["MonedaViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    Moneda moneda = new Moneda() {
                        nombre = collection[0],
                        unidadmedida_id = Convert.ToInt16(collection[1]),
                        segmento_id = int.Parse(collection["segmento_id"])
                    };
                    if (web.AdministracionClient.InsertarMoneda(moneda, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + moneda.id + " en la tabla MONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            Moneda moneda = web.AdministracionClient.ListarMonedasPorId(id).ToList()[0];
            var viewModel = new MonedaViewModel() {
                MonedaView = moneda,
                UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadesMedida().ToList(), "id", "nombre", moneda.unidadmedida_id),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", moneda.segmento_id)
            };
            ViewData["CrearMoneda"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try {
                Moneda moneda = new Moneda() {
                    nombre = collection[0],
                    unidadmedida_id = Convert.ToInt16(collection[1]),
                    segmento_id = int.Parse(collection["segmento_id"])
                };
                mensaje = web.AdministracionClient.ActualizarMoneda(id, moneda, HttpContext.Session["userName"].ToString());
                if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Actualización del registro " + id + " en la tabla MONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(web.AdministracionClient.ListarMonedasPorId(id).First());
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try {
                mensaje = web.AdministracionClient.EliminarMoneda(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla MONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


