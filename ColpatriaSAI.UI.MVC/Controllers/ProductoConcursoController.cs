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
    public class ProductoConcursoController : ControladorBase
    {
        WebPage web = new WebPage();
           
        public ActionResult Index()
        {         
            if (Request.QueryString["value"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
            }

            try
            {
                if (int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                    ViewData["ProductoConcursos"] = web.AdministracionClient.ListarProductoConcursoes().Where(P => P.concurso_id == int.Parse(ViewData["value"].ToString()));
                    Crear();                    
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de producto concurso", ex);
            }
            return View();
        }

        [AcceptVerbs(HttpVerbs.Get)]
        
        public ActionResult getRamos(int compania_id)
        {
          return Json(web.AdministracionClient.ListarRamosPorCompania(compania_id).Select(r => new { r.nombre, r.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult getProductos(int ramo_id)
        {
            return Json(web.AdministracionClient.ListarProductosporRamo(ramo_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult getPlanes(int producto_id)
        {
            var planes= web.AdministracionClient.ListarPlansPorProducto(producto_id).Select(p => new {p.nombre, p.id}).ToList() ;

            var js = Json(web.AdministracionClient.ListarPlansPorProducto(producto_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);

            return Json(web.AdministracionClient.ListarPlansPorProducto(producto_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult Crear()
        {
            var viewModel = new ProductoConcursoViewModel()
            {
                ProductoConcursoView = new ProductoConcurso(),
                CompaniaList     = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre")
            
            };
            ViewData["ProductoConcursoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            string idRamo         = (collection["ramo_id"] != "" ? collection["ramo_id"] : collection["ramo_id"] = "0");
            string idProducto     = (collection["producto_id"] != "" ? collection["producto_id"] : collection["producto_id"] = "0");
            string idLineanegocio = (collection["lineaNegocio_id"] != "" ? collection["lineaNegocio_id"] : collection["lineaNegocio_id"] = "0");
            int concursovalue     = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        ProductoConcurso productoconcurso = new ProductoConcurso()
                         {
                             concurso_id     = Convert.ToInt16(collection["concurso_id"]),
                             fecha_inicio    = Convert.ToDateTime(collection["FechaInicio"]),
                             fecha_fin       = Convert.ToDateTime(collection["FechaFin"]),
                             compania_id     = Convert.ToInt16(collection["compania_id"]),
                             ramo_id         = Convert.ToInt16(collection["ramo_id"]),
                             producto_id     = Convert.ToInt16(collection["producto_id"]),
                             lineaNegocio_id = Convert.ToInt16(collection["lineaNegocio_id"])
                         };
                        if (web.AdministracionClient.InsertarProductoConcurso(productoconcurso, userName) != 0)
                        {                            
                            Logging.Auditoria("Creación del registro " + productoconcurso.id + " en la tabla PRODUCTOCONCURSO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear el registro de producto x concurso", ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            ProductoConcurso productoconcurso = web.AdministracionClient.ListarProductoConcursoesPorId(id).ToList()[0];
            ViewData["compania"] = productoconcurso.compania_id;
            ViewData["ramo"]     = productoconcurso.ramo_id;

            if (Convert.ToInt16(ViewData["ramo"]) == 0)
            {
                var viewModel = new ProductoConcursoViewModel()
                {
                    ProductoConcursoView = productoconcurso,
                    CompaniaList         = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", productoconcurso.compania_id),
                    LineaNegocioList     = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre", productoconcurso.lineaNegocio_id),
                    RamoList             = new SelectList(web.AdministracionClient.ListarRamos().Where(r => r.compania_id == Convert.ToInt16(ViewData["compania"])).ToList(), "id", "nombre", productoconcurso.ramo_id),
                    ProductoList         = new SelectList(new List<string>())
                };
                ViewData["ProductoConcursoViewModel"] = viewModel;
                return View(viewModel);
            }

            else
            {
                var viewModel = new ProductoConcursoViewModel()
                {
                    ProductoConcursoView = productoconcurso,
                    CompaniaList     = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", productoconcurso.compania_id),
                    LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre", productoconcurso.lineaNegocio_id),
                    RamoList         = new SelectList(web.AdministracionClient.ListarRamos().Where(r => r.compania_id == Convert.ToInt16(ViewData["compania"])).ToList(), "id", "nombre", productoconcurso.ramo_id),
                    ProductoList     = new SelectList(web.AdministracionClient.ListarProductoes().Where(p => p.ramo_id == Convert.ToInt16(ViewData["ramo"])).ToList(), "id", "nombre", productoconcurso.producto_id)
                };
                ViewData["ProductoConcursoViewModel"] = viewModel;
                return View(viewModel); 
            }
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string idRamo         = (collection["ramo_id_editar"] != "" ? collection["ramo_id_editar"] : collection["ramo_id_editar"] = "0");
            string idProducto     = (collection["producto_id_editar"] != "" ? collection["producto_id_editar"] : collection["producto_id_editar"] = "0");
            string idLineanegocio = (collection["lineaNegocio_id_editar"] != "" ? collection["lineaNegocio_id_editar"] : collection["lineaNegocio_id_editar"] = "0");
            int concursovalue     = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    ProductoConcurso productoconcurso = new ProductoConcurso()
                    {
                        fecha_inicio    = Convert.ToDateTime(collection["FechaInicioEdit"]),
                        fecha_fin       = Convert.ToDateTime(collection["FechaFinEdit"]),
                        compania_id     = Convert.ToInt16(collection["compania_id_editar"]),
                        lineaNegocio_id = Convert.ToInt16(collection["lineaNegocio_id_editar"]),
                        ramo_id         = Convert.ToInt16(collection["ramo_id_editar"]),
                        producto_id     = Convert.ToInt16(collection["producto_id_editar"])
                    };
                    web.AdministracionClient.ActualizarProductoConcurso(id, productoconcurso, userName);
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar el registro de producto x concurso con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);

            if (concursovalue == 0)
            {
                return RedirectToAction("Index", new { value = concursovalue });
            }

            else
            {
                try
                {
                    string mensaje = "";
                    string userName = HttpContext.Session["userName"].ToString();
                    mensaje = web.AdministracionClient.EliminarProductoConcurso(id, null, userName);
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PRODUCTOCONCURSO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar el registro de producto x concurso con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }
    }
}


