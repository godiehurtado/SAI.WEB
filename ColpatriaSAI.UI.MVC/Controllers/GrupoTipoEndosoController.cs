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
    public class GrupoTipoEndosoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["GruposTipos"] = web.AdministracionClient.ListarExcepcionesxGrupoTipoEndoso();
            Crear();
            return View(ViewData["GruposTipos"]);
        }

        public ActionResult Crear()
        {
            var viewModel = new ExcepcionesporGrupoTipoEndosoViewModel {
                GrupoEndosoList = new SelectList(web.AdministracionClient.ListarGrupoEndosos().Where(g => g.id > 0).ToList(), "id", "nombre"),
                TipoEndosoList  = new SelectList(web.AdministracionClient.ListarTipoEndoso().ToList(), "id", "nombre"),
                CompaniaList    = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
            };
            ViewData["GTEViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            // Estado Vigente (V), Estado No Vigente (NV)
            
            string estadoDestino = collection.Get("estadoDestino") == "V" ? "V" : "NV";

            try 
            {
                if (ModelState.IsValid) 
                {
                    ExcepcionesxGrupoTipoEndoso exgrupoTipoEndoso = new ExcepcionesxGrupoTipoEndoso() 
                    {
                        grupoEndoso_id = Convert.ToInt16(collection["grupoEndoso_id"]),
                        tipoEndoso_id  = Convert.ToInt16(collection["tipoEndoso_id"]),
                        compania_id    = 2, // VIDA
                        estado         = estadoDestino
                    };
                    if (web.AdministracionClient.InsertarExcepcionesxGrupoTipoEndoso(exgrupoTipoEndoso, HttpContext.Session["userName"].ToString()) != 0)
                    {
                          Logging.Auditoria("Creación del registro " + exgrupoTipoEndoso.id + " en la tabla ExcepcionesxGrupoTipoEndoso.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }                    
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear la excepción por grupo tipo endoso", ex);
            }
            return RedirectToAction("Index");
        }
        
        public ActionResult Editar(int id)
        {
            ExcepcionesxGrupoTipoEndoso exgrupoTipoEndoso = web.AdministracionClient.ListarExcepcionesxGrupoTipoEndosoPorId(id).ToList()[0];
            ViewBag.estadoReal = exgrupoTipoEndoso.estado;

            var viewModel = new ExcepcionesporGrupoTipoEndosoViewModel() 
            {
                GrupoEndosoList = new SelectList(web.AdministracionClient.ListarGrupoEndosos().Where(g => g.id > 0).ToList(), "id", "nombre", exgrupoTipoEndoso.grupoEndoso_id),
                TipoEndosoList  = new SelectList(web.AdministracionClient.ListarTipoEndoso().ToList(), "id", "nombre", exgrupoTipoEndoso.tipoEndoso_id),
                CompaniaList    = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", exgrupoTipoEndoso.compania_id)
            };
            ViewData["GTEViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            // Estado Vigente (V), Estado No Vigente (NV)
            
            string estadoReal = collection.Get("estadoReal_Editar") == "V" ? "V" : "NV";

            try 
            {
                if (ModelState.IsValid) 
                {
                    ExcepcionesxGrupoTipoEndoso exgrupoTipoEndoso = new ExcepcionesxGrupoTipoEndoso() 
                    {
                        grupoEndoso_id = Convert.ToInt16(collection["grupoEndoso_idEdit"]),
                        tipoEndoso_id  = Convert.ToInt16(collection["tipoEndoso_idEdit"]),
                        compania_id    = 2, // VIDA
                        estado         = estadoReal
                    };
                    web.AdministracionClient.ActualizarExcepcionesxGrupoTipoEndoso(id, exgrupoTipoEndoso, HttpContext.Session["userName"].ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar la excepción por grupo tipo endoso del registro " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            try {
                web.AdministracionClient.EliminarExcepcionesxGrupoTipoEndoso(id, null, HttpContext.Session["userName"].ToString());
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar la excepción por grupo tipo endoso del registro " + id, ex);
            }
            return RedirectToAction("Index");
        }
    }
}