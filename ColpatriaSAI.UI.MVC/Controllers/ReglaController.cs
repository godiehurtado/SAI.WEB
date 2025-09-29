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
    public class ReglaController : ControladorBase
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
                    ViewData["TipoConcurso"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].tipoConcurso_id;
                    ViewData["Reglas"] = web.AdministracionClient.ListarRegla().Where(P => P.concurso_id == int.Parse(ViewData["value"].ToString()));
                    ViewData["ReglaxConceptoDescuento"] = web.AdministracionClient.ListarReglaxConceptoDescuento();
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de regla", ex);
            }
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new ReglaViewModel()
            {
                ReglaView = new Regla(),
                TipoReglaList = new SelectList(web.AdministracionClient.ListarTipoRegla().ToList(), "id", "nombre"),
                PeriodoReglaList = new SelectList(web.AdministracionClient.ListarPeriodoRegla().ToList(), "id", "periodo"),
                EstrategiaReglaList = new SelectList(web.AdministracionClient.ListarEstrategiaRegla().ToList(), "id", "nombre"),
                ConceptoDescuentoList = new MultiSelectList(web.AdministracionClient.ListarConceptoDescuento().ToList(), "id", "nombre")
            };
            ViewBag.ListaPremios = new SelectList(web.AdministracionClient.ListarPremiosParaAsociar(Convert.ToInt32(Request.QueryString["value"]), 0), "id", "nombre");
            ViewData["ReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int idRegla = 0;
            string nombreRegla = "";
            string conceptoDescuento = "";
            bool principalsubRegla = true;
            int concursovalue = Convert.ToInt16(TempData["value"]);
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
                        Regla regla = new Regla()
                        {
                            concurso_id = Convert.ToInt16(collection["concurso_id"]),
                            nombre = collection["nombre"],
                            fecha_inicio = DateTime.Parse(collection["FechaInicio"]),
                            fecha_fin = DateTime.Parse(collection["FechaFin"]),
                            descripcion = collection["descripcion"],
                            tipoRegla_id = int.Parse(collection["tipoRegla_id"]),
                            periodoRegla_id = int.Parse(collection["periodoRegla_id"]),
                            regla_id = collection["regla_id"] != "" ? int.Parse(collection["regla_id"]) : 0
                        };
                        idRegla = web.AdministracionClient.InsertarRegla(regla, userName);
                        nombreRegla = collection["nombre"];
                        conceptoDescuento = collection["conceptoDescuento_id"];

                        if (conceptoDescuento != null)
                        {
                            web.AdministracionClient.InsertarReglaxConceptoDescuento(conceptoDescuento, idRegla, Sesion.VariablesSesion(), userName);
                        }
                    }

                    if (idRegla != 0)
                    {
                        SubRegla subregla = new SubRegla()
                        {
                            regla_id = idRegla,
                            descripcion = nombreRegla,
                            principal = principalsubRegla,
                            tipoSubregla = 1
                        };
                        web.AdministracionClient.InsertarSubRegla(subregla, userName);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear la regla", ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            Regla regla = web.AdministracionClient.ListarReglaPorId(id).ToList()[0];
            var viewModel = new ReglaViewModel()
            {
                ReglaView = regla,
                TipoReglaList = new SelectList(web.AdministracionClient.ListarTipoRegla().ToList(), "id", "nombre", regla.tipoRegla_id),
                PeriodoReglaList = new SelectList(web.AdministracionClient.ListarPeriodoRegla().ToList(), "id", "periodo", regla.periodoRegla_id),
                EstrategiaReglaList = new SelectList(web.AdministracionClient.ListarEstrategiaRegla().ToList(), "id", "nombre"),
                ConceptoDescuentoList = new MultiSelectList(web.AdministracionClient.ListarConceptoDescuento().ToList(), "id", "nombre")
            };
            ViewBag.ListaPremios = new SelectList(web.AdministracionClient.ListarPremiosParaAsociar(Convert.ToInt32(Request.QueryString["concurso_id"]), regla.id), "id", "nombre", regla.regla_id);
            ViewData["ReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string conceptoDescuento = "";
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }
            else
            {
                try
                {
                    Regla regla = new Regla()
                    {
                        nombre = collection[0],
                        descripcion = collection[5],
                        fecha_inicio = DateTime.Parse(collection[1]),
                        fecha_fin = DateTime.Parse(collection[2]),
                        tipoRegla_id = int.Parse(collection[3]),
                        periodoRegla_id = int.Parse(collection[4]),
                        regla_id = collection[6] != "" ? int.Parse(collection[6]) : 0
                    };
                    web.AdministracionClient.ActualizarRegla(id, regla, userName);
                    conceptoDescuento = collection["conceptoDescuento_idEdit"];

                    if (conceptoDescuento != null)
                    {
                        web.AdministracionClient.InsertarReglaxConceptoDescuento(conceptoDescuento, id, Sesion.VariablesSesion(), userName);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar la regla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }

        public ActionResult Duplicar(int id)
        {
            Regla regla = web.AdministracionClient.ListarReglaPorId(id).ToList()[0];
            TempData["nombreRegla"] = regla.nombre;
            TempData["tipoRegla"] = regla.TipoRegla.nombre;
            TempData["periodoRegla"] = regla.PeriodoRegla.periodo;
            TempData["concurso_id"] = regla.concurso_id;

            int tipoConcurso = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(TempData["concurso_id"]));

            var viewModel = new ReglaViewModel()
            {
                ReglaView = regla,
                TipoReglaList = new SelectList(web.AdministracionClient.ListarTipoRegla().ToList(), "id", "nombre", regla.tipoRegla_id),
                PeriodoReglaList = new SelectList(web.AdministracionClient.ListarPeriodoRegla().ToList(), "id", "periodo", regla.periodoRegla_id),
                ConcursoList = new SelectList(web.AdministracionClient.ListarConcursoes().Where(c => c.tipoConcurso_id == tipoConcurso).ToList(), "id", "nombre", regla.concurso_id)
            };
            ViewData["ReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Duplicar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            Regla regla1 = web.AdministracionClient.ListarReglaPorId(id).ToList()[0];
            ViewBag.regla = regla1.nombre;
            ViewBag.descripcion = regla1.descripcion;
            ViewBag.tipoRegla_id = regla1.tipoRegla_id;
            ViewBag.periodoRegla_id = regla1.periodoRegla_id;
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                Regla regla = new Regla()
                {
                    nombre = ViewBag.regla,
                    descripcion = ViewBag.descripcion,
                    fecha_inicio = DateTime.Parse(collection[0]),
                    fecha_fin = DateTime.Parse(collection[1]),
                    tipoRegla_id = ViewBag.tipoRegla_id,
                    periodoRegla_id = ViewBag.periodoRegla_id,
                    concurso_id = int.Parse(collection["concurso_id_editar"])
                };
                web.AdministracionClient.DuplicarRegla(id, regla, userName);
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo duplicar la regla con id = " + id, ex);
            }
            return RedirectToAction("Index", new { value = concursovalue });
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
                    mensaje = web.AdministracionClient.EliminarRegla(id, null, userName);
                    if (mensaje != "")
                    {
                        if (mensaje == "1")
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.LiquidacionPorRegla; View(TempData["Mensaje"]);
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]);
                        }
                    }
                    else
                    {
                        Logging.Auditoria("Eliminación del registro " + id + " en la tabla PARTICIPANTECONCURSO.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion());
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar la regla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }
    }
}


