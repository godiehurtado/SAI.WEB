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
    public class PersistenciaCAPIDetalleController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["clave"]         = Request.QueryString["clave"];
            ViewData["numeroNegocio"] = Request.QueryString["numeroNegocio"];

            TempData["clave_"]         = Request.QueryString["clave"];
            TempData["numeroNegocio_"] = Request.QueryString["numeroNegocio"];

            BuscarRegistroPersistencia();

            ViewData["PersistenciaCAPIDetalle"] = web.AdministracionClient.ListarPersistenciaCAPIDetalle(Convert.ToString(ViewData["numeroNegocio"]), Convert.ToString(ViewData["clave"]));
            return View(ViewData["PersistenciaCAPIDetalle"]);
             
        }

        public ActionResult BuscarRegistroPersistencia()
        {
            var viewModel = new PersistenciaCAPIDetalleViewModel()
            {
                PersistenciaCAPIDetalleView = new PersistenciadeCAPIDetalle()
            };
            ViewData["PersistenciaCAPIDetalleViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult BuscarRegistroPersistencia(FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    PersistenciadeCAPIDetalle persistenciadecapidetalle = new PersistenciadeCAPIDetalle()
                    {
                        clave         = collection["clave"],
                        numeroNegocio = collection["numeroNegocio"]
                    };
                    TempData["clave"]         = collection["clave"];
                    TempData["numeroNegocio"] = collection["numeroNegocio"];                    
                }
                return RedirectToAction("Index", new { clave = TempData["clave"], numeroNegocio = TempData["numeroNegocio"] });
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la lista de persistencia de CAPI detalle", ex);
            }
        }

        public ActionResult Editar(int id)
        {
            PersistenciadeCAPIDetalle persistenciacapidetalle = web.AdministracionClient.ListarPersistenciaCAPIDetallePorId(id).ToList()[0];
            ViewBag.cumple             = persistenciacapidetalle.cumple.Value;

            var viewModel = new PersistenciaCAPIDetalleViewModel()
            {
                PersistenciaCAPIDetalleView = persistenciacapidetalle
            };
            ViewData["PersistenciaCAPIDetalleViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string tipoCumple       = collection.Get("cumple_Editar") == "NO" ? "false" : "true";
            string clave            = Convert.ToString(TempData["clave_"]);
            string numeroNegocio    = Convert.ToString(TempData["numeroNegocio_"]);
            string nombreUsuario    = (string)Session["username"];

            PersistenciadeCAPIDetalle persistenciacapidetalle_ = web.AdministracionClient.ListarPersistenciaCAPIDetallePorId(id).ToList()[0];
            string numeroNegocio_ = persistenciacapidetalle_.numeroNegocio;
            string clave_         = persistenciacapidetalle_.clave;

            try
            {
                if (ModelState.IsValid)
                {
                    PersistenciadeCAPIDetalle persistenciacapidetalle = new PersistenciadeCAPIDetalle()
                    {
                        cumple      = bool.Parse(tipoCumple),
                        comentarios = collection[1] + ":: Editado por usuario " + nombreUsuario + ":: Fecha: " + Convert.ToString(DateTime.Now)
                    };
                    web.AdministracionClient.ActualizarPersistenciaCAPIDetalle(id, persistenciacapidetalle, HttpContext.Session["userName"].ToString());
                    Logging.Auditoria("Actualización del cumplimiento del negocio persistencia CAPI " + numeroNegocio_ + " y clave " + clave_ + " en la tabla PERSISTENCIACAPIDETALLE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    web.AdministracionClient.EjecutarSP("SAI_Recalculo_PersistenciaCAPI");
                    
                }
                return RedirectToAction("Index", new { clave = clave, numeroNegocio = numeroNegocio });
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar el registro de persistencia de capi detalle con id = " + id, ex);
            }           
        }
    }
}
