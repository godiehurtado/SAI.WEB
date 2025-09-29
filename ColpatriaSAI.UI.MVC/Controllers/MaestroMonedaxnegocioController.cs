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
    public class MaestroMonedaxnegocioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["MaestroMonedaxNegocios"] = web.AdministracionClient.ListarMaestroMonedaxNegocio();
            Crear();
            return View(ViewData["MaestroMonedaxNegocios"]);
        }
   
        public ActionResult Crear()
        {
            MaestroMonedaxNegocioViewModel viewModel = llenarCollection();

            ViewData["MaestroMonedaxNegocioViewModel"] = viewModel;
            return View(viewModel);
        }

        public MaestroMonedaxNegocioViewModel llenarCollection()
        {
            MaestroMonedaxNegocioViewModel viewModel = new MaestroMonedaxNegocioViewModel()
            {
                MaestroMonedaxNegocioView = new MaestroMonedaxNegocio(),
                MonedaList = new SelectList(web.AdministracionClient.ListarMonedas().ToList(), "id", "nombre")                
            };

            return viewModel;
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int idMaestroMoneda = 0;

            try
            {
                if (ModelState.IsValid)
                {
                    MaestroMonedaxNegocio maestromonedaxnegocio = new MaestroMonedaxNegocio()
                    {
                        moneda_id     = Convert.ToInt16(collection["moneda_id"]),
                        fecha_inicial = DateTime.Parse(collection["FechaInicio"]),
                        fecha_final   = DateTime.Parse(collection["FechaFin"])
                    };
                    idMaestroMoneda = web.AdministracionClient.InsertarMaestroMonedaxNegocio(maestromonedaxnegocio, HttpContext.Session["userName"].ToString());

                    if (idMaestroMoneda != 0)
                    {
                        Logging.Auditoria("Creación del registro " + maestromonedaxnegocio.id + " en la tabla MAESTROMONEDAXNEGOCIO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Rango_Fechas; View(TempData["Mensaje"]);
                    }
                }                    
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear el maestro moneda", ex);
            }
            return RedirectToAction("Index");
        }
 
        public ActionResult Editar(int id)
        {           
            MaestroMonedaxNegocio maestromonedaxnegocio = web.AdministracionClient.ListarMaestroMonedaxNegocioPorId(id).ToList()[0];
            var viewModel = new MaestroMonedaxNegocioViewModel()
            {
                MaestroMonedaxNegocioView = maestromonedaxnegocio,
                MonedaList = new SelectList(web.AdministracionClient.ListarMonedas().ToList(), "id", "nombre", maestromonedaxnegocio.moneda_id)
                
            };
            ViewData["MaestroMonedaxNegocioViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0; 
            try
            {
                MaestroMonedaxNegocio maestromonedaxnegocio = new MaestroMonedaxNegocio()
                {
                    fecha_inicial = DateTime.Parse(collection["FechaInicial"]),
                    fecha_final   = DateTime.Parse(collection["FechaFinal"]),
                    moneda_id     = int.Parse(collection["moneda_id"])                    
                };

                mensaje = web.AdministracionClient.ActualizarMaestroMonedaxNegocio(id, maestromonedaxnegocio, HttpContext.Session["userName"].ToString());
                if (mensaje != 0){
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; 
                    View(TempData["Mensaje"]);
                } else 
                    Logging.Auditoria("Actualización del registro " + id + " en la tabla MAESTRO MONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());                 
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar el maestro moneda con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }
 
        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            mensaje = web.AdministracionClient.EliminarMaestroMonedaxNegocio(id, null, HttpContext.Session["userName"].ToString());
            try
            {
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla MAESTROMONEDAXNEGOCIO.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                 
            }
            catch (Exception ex) 
            {
                throw new Exception("No se pudo eliminar el maestro moneda con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult ObtenerSegmentoxUsuario()
        {
            string nombreUsuario = (string)Session["username"];            
            var sxu              = web.AdministracionClient.ListarSegmentoxUsuario(nombreUsuario).ToList();
            return Json(sxu, JsonRequestBehavior.AllowGet);
        }
    }
}
