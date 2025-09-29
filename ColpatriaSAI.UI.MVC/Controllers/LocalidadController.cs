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
    public class LocalidadController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Localidades"] = web.AdministracionClient.ListarLocalidades().Where(Localidad => Localidad.id > 0);
            Crear();
            return View(ViewData["Localidades"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new LocalidadViewModel() {
                LocalidadView = new Localidad(),
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre"),
                TipoLocalidad = new SelectList(web.AdministracionClient.ListarTipoLocalidad().ToList(), "id", "nombre")
            };
            ViewData["LocalidadViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            string idcodigoCAPI = (collection["codigo_capi"] != "" ? collection["codigo_capi"] : "-999");
            try {
                if (ModelState.IsValid) {
                    Localidad localidad = new Localidad();
                    localidad.nombre = collection["nombre"];
                    localidad.zona_id = Convert.ToInt16(collection["zona_id"]);
                    localidad.tipo_localidad_id = int.Parse(collection["tipolocalidad_id"]);
                    localidad.codigo_SISE = collection["codigo_sise"];
                    localidad.codigo_CAPI = int.Parse(idcodigoCAPI);
                    localidad.codigo_BH = collection["codigo_bh"];
                    localidad.codigo_EMERMEDICA = collection["codigo_emermedica"];
                    localidad.codigo_ARP = collection["codigo_arp"];
                    localidad.clavePago = collection["clave_pago"];

                    if (web.AdministracionClient.InsertarLocalidad(localidad, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + localidad.nombre + " en la tabla LOCALIDAD", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        TempData["Mensaje"] = "exito|" + Mensajes.Exito_Insert;
                    } else {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]); 
                    }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Editar(int id)
        {
            Localidad localidad = web.AdministracionClient.ListarLocalidadesPorId(id).Where(Localidad => Localidad.id > 0).ToList()[0];
            var viewModel = new LocalidadViewModel() {
                LocalidadView = localidad,
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre", localidad.zona_id),
                TipoLocalidad = new SelectList(web.AdministracionClient.ListarTipoLocalidad().ToList(), "id", "nombre", localidad.tipo_localidad_id)
            };
            ViewData["LocalidadViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string idcodigoCAPI = (collection["codigo_capi"] != null ? collection["codigo_capi"] != "" ? collection["codigo_capi"] : "-999" : "-999");
            int mensaje = 0;
            try {
                Localidad localidad = new Localidad() {
                    nombre = collection[0],
                    zona_id = Convert.ToInt16(collection["zona_id"]),
                    tipo_localidad_id = int.Parse(collection["tipolocalidad_id"]),
                    codigo_SISE = collection[3],
                    codigo_CAPI = int.Parse(idcodigoCAPI),
                    codigo_BH = collection[5],
                    codigo_EMERMEDICA = collection[6],
                    codigo_ARP = collection[7],
                    clavePago = collection["clave_pago"]
                };
                mensaje = web.AdministracionClient.ActualizarLocalidad(id, localidad, HttpContext.Session["userName"].ToString());
                if (mensaje == 0) {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]);
                } else {
                    Logging.Auditoria("Actualización del registro " + id + " en la tabla LOCALIDAD.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    TempData["Mensaje"] = "exito|" + Mensajes.Exito_Edit;
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            //var localidad = web.AdministracionClient.ListarLocalidadesPorId(id);
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try {
                mensaje = web.AdministracionClient.EliminarLocalidad(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla LOCALIDAD.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


