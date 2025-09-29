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
    public class TopeMonedaController : ControladorBase
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
                    ViewData["MaestroMonedaxNegocios"] = web.AdministracionClient.ListarMaestroMonedaxNegocio().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].Moneda.nombre;
                    ViewData["TopeMonedas"] = web.AdministracionClient.ListarTopeMoneda().Where(P => P.maestromoneda_id == int.Parse(ViewData["value"].ToString()));
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de tope moneda", ex);
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

        public ActionResult Crear()
        {
            TopeMonedaViewModel viewModel = llenarCollection();

            ViewData["TopeMonedaViewModel"] = viewModel;
            return View(viewModel);
        }

        public TopeMonedaViewModel llenarCollection()
        {
            TopeMonedaViewModel viewModel = new TopeMonedaViewModel()
            {
                TopeMonedaView = new TopeMoneda(),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductoes().ToList(), "id", "nombre"),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                RamoList = new SelectList(web.AdministracionClient.ListarRamos().ToList(), "id", "nombre")
            };
            return viewModel;
        }

        [HttpPost]
        public ActionResult Crear(string id, FormCollection collection)
        {
            string idProducto = (collection["producto_id"] != null ? collection["producto_id"] : collection["producto_id"] = "0");
            string idRamo = (collection["ramo_id"] != "" ? collection["ramo_id"] : collection["ramo_id"] = "0");
            string tope = collection["tope"].Replace(".", ",");
            string userName = HttpContext.Session["userName"].ToString();
            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);

            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            }

            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        TopeMoneda topemoneda = new TopeMoneda()
                        {
                            maestromoneda_id = Convert.ToInt16(collection["maestromoneda_id"]),
                            producto_id = Convert.ToInt16(collection["producto_id"]),
                            compania_id = Convert.ToInt16(collection["compania_id"]),
                            ramo_id = Convert.ToInt16(collection["ramo_id"]),
                            tope = double.Parse(tope)
                        };

                        if (web.AdministracionClient.InsertarTopeMoneda(topemoneda, userName) != 0)
                        {
                            Logging.Auditoria("Creación del registro " + topemoneda.id + " en la tabla TOPEMONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.CombinacionRepetida; View(TempData["Mensaje"]);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear el tope moneda", ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            TopeMoneda topemoneda = web.AdministracionClient.ListarTopeMonedaPorId(id).ToList()[0];
            var viewModel = new TopeMonedaViewModel()
            {
                TopeMonedaView = topemoneda
            };
            ViewData["TopeMonedaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            }

            else
            {
                try
                {
                    TopeMoneda topemoneda = new TopeMoneda()
                    {
                        tope = double.Parse(collection[0].Replace(".", ","))
                    };

                    if (web.AdministracionClient.ActualizarTopeMoneda(id, topemoneda, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + topemoneda.id + " en la tabla TOPEMONEDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.CombinacionRepetida; View(TempData["Mensaje"]);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar el tope moneda con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
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
            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            }

            else
            {
                string mensaje = "";
                try
                {
                    mensaje = web.AdministracionClient.EliminarTopeMoneda(id, null, userName);
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla TOPEMONEDA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar el tope moneda con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }
        }
    }
}


