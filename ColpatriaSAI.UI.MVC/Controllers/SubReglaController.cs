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
    public class SubReglaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
                ViewData["valuer"] = Request.QueryString["valuer"];
                TempData["valuer"] = Request.QueryString["valuer"];
            }

            try
            {
                if (int.Parse(ViewData["valuer"].ToString()) != null || int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                    ViewData["Reglas"] = web.AdministracionClient.ListarRegla().Where(e => e.id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].nombre;
                    ViewData["subReglas"] = web.AdministracionClient.ListarSubRegla().Where(P => P.regla_id == int.Parse(ViewData["valuer"].ToString()));
                    ViewData["condiciones"] = web.AdministracionClient.ListarCondicion();
                    ViewData["premiosxsubregla"] = web.AdministracionClient.ListarPremioxSubregla();
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina subregla", ex);
            }
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new SubReglaViewModel()
            {
                SubReglaView = new SubRegla()
            };
            ViewData["SubReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int idSubRegla = 0;
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string tipoConcurso = (collection["tipoSubRegla"] != null ? "3" : collection["tipoSubRegla"] = "1");
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    if (ModelState.IsValid && Request.QueryString["id"] != string.Empty)
                    {
                        SubRegla subregla = new SubRegla()
                        {
                            regla_id = Convert.ToInt16(collection["regla_id"]),
                            descripcion = collection["descripcion"],
                            principal = Convert.ToBoolean(collection["principal"]),
                            tipoSubregla = int.Parse(tipoConcurso)
                        };
                        idSubRegla = web.AdministracionClient.InsertarSubRegla(subregla, userName);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear la subregla", ex);
                }
                return RedirectToAction("Index", new { valuer = reglavalue, value = concursovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            SubRegla subregla = web.AdministracionClient.ListarSubReglaPorId(id).ToList()[0];
            var viewModel = new SubReglaViewModel()
            {
                SubReglaView = subregla
            };
            ViewData["SubReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string principal = (collection["principal_Edit"] != null ? collection["principal_Edit"] : collection["principal_Edit"] = "false");
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0 || reglavalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    SubRegla subregla = new SubRegla()
                    {
                        descripcion = collection[0],
                        principal = bool.Parse(collection["principal_Edit"])
                    };
                    web.AdministracionClient.ActualizarSubRegla(id, subregla, userName);
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar la subregla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuer = reglavalue, value = concursovalue });
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
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", new { value = concursovalue });
            }

            else
            {
                string mensaje = "";
                try
                {
                    mensaje = web.AdministracionClient.EliminarSubRegla(id, null, userName);
                    if (mensaje != "")
                    {
                        if (mensaje == "1")
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.LiquidacionPorxSubRegla; View(TempData["Mensaje"]);
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]);
                        }
                    }
                    else
                    {
                        Logging.Auditoria("Eliminación del registro " + id + " en la tabla SUBREGLA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion());
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar la subregla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuer = reglavalue, value = concursovalue });
            }
        }
    }
}


