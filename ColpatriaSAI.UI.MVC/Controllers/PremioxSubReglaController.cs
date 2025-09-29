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
    public class PremioxSubReglaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty || Request.QueryString["valuer"] != string.Empty || Request.QueryString["valusr"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
                ViewData["valuer"] = Request.QueryString["valuer"];
                TempData["valuer"] = Request.QueryString["valuer"];
                ViewData["valuesr"] = Request.QueryString["valuesr"];
                TempData["valuesr"] = Request.QueryString["valuesr"];
            }

            try
            {
                if (int.Parse(ViewData["valuesr"].ToString()) != null || int.Parse(ViewData["valuer"].ToString()) != null || int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                    ViewData["Reglas"] = web.AdministracionClient.ListarRegla().Where(e => e.id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].nombre;
                    ViewData["subReglas"] = web.AdministracionClient.ListarSubRegla().Where(P => P.regla_id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].descripcion;
                    ViewData["PremioxSubReglas"] = web.AdministracionClient.ListarPremioxSubregla().Where(P => P.subregla_id == int.Parse(ViewData["valuesr"].ToString()));
                    ViewData["CondicionPremio"] = web.AdministracionClient.ListarCondicionxPremioSubRegla();
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de premioxsubregla", ex);
            }
            return View();
        }

        public ActionResult Premio()
        {
            ViewData["Premios"] = web.AdministracionClient.ListarPremio();
            return View(ViewData["Premios"]);
        }

        public ActionResult Premio1()
        {
            ViewData["Premios"] = web.AdministracionClient.ListarPremio();
            return View(ViewData["Premios"]);
        }

        public ActionResult Crear()
        {
            var viewModel = new PremioxSubReglaViewModel()
            {
                PremioxSubReglaView = new PremioxSubregla(),
                PremioList = new SelectList(web.AdministracionClient.ListarPremio().ToList(), "id", "descripcion")
            };
            ViewData["PremioxSubReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int subReglavalue = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);

            if (subReglavalue == 0 || reglavalue == 0 || concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            if (int.Parse(collection["premio_id"]) == 0)
            {
                TempData["Mensaje"] = "error|" + Mensajes.MensajePremioxSubRegla; View(TempData["Mensaje"]);

                return RedirectToAction("Index", "PremioxSubRegla", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
            }

            else
            {
                try
                {
                    if (ModelState.IsValid && Request.QueryString["id"] != string.Empty)
                    {
                        PremioxSubregla premioxsubregla = new PremioxSubregla()
                        {
                            subregla_id = Convert.ToInt16(collection["subregla_id"]),
                            premio_id = int.Parse(collection["premio_id"]),
                            mesinicio = int.Parse(collection["ddlMesInicio"]),
                            mesfin = int.Parse(collection["ddlMesFin"])

                        };
                        string userName = HttpContext.Session["userName"].ToString();
                        if (web.AdministracionClient.InsertarPremioxSubregla(premioxsubregla, userName) != 0)
                        {
                            Logging.Auditoria("Creación del registro " + premioxsubregla.id + " en la tabla PREMIOXSUBREGLA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.PremioSubregla; View(TempData["Mensaje"]);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear el premioxsubregla", ex);
                }
                return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            PremioxSubregla premioxsubregla = web.AdministracionClient.ListaPremioxSubreglaPorId(id).ToList()[0];
            TempData["PremioxSubRegla"] = premioxsubregla.Premio.descripcion;
            TempData["mesinicio"] = premioxsubregla.mesinicio;
            TempData["mesfin"] = premioxsubregla.mesfin;
            var viewModel = new PremioxSubReglaViewModel()
            {
                PremioxSubReglaView = premioxsubregla,
                PremioList = new SelectList(web.AdministracionClient.ListarPremio().ToList(), "id", "descripcion", premioxsubregla.premio_id)
            };
            ViewData["PremioxSubReglaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int subReglavalue = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            PremioxSubregla premiosub1 = web.AdministracionClient.ListaPremioxSubreglaPorId(id).ToList()[0];
            int premiovalue = (int)premiosub1.premio_id;

            if (concursovalue == 0 || reglavalue == 0 || subReglavalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            //if (int.Parse(collection["premio_id_Edit"]) == 0)
            //{
            //    TempData["Mensaje"] = "error|" + Mensajes.MensajePremioxSubRegla; View(TempData["Mensaje"]);

            //    return RedirectToAction("Index", "PremioxSubRegla", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
            //}

            else
            {
                try
                {
                    PremioxSubregla premioxsubregla = new PremioxSubregla()
                    {
                        premio_id = premiovalue,
                        subregla_id = subReglavalue,
                        mesinicio = int.Parse(collection["ddlMesInicio_Edit"]),
                        mesfin = int.Parse(collection["ddlMesFin_Edit"])
                    };
                    web.AdministracionClient.ActualizarPremioxSubregla(id, premioxsubregla, userName);
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar el premioxsubregla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
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
            int subReglavalue = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);


            if (concursovalue == 0 || reglavalue == 0 || subReglavalue == 0)
            {
                return RedirectToAction("Index", new { value = concursovalue });
            }

            else
            {
                try
                {
                    string mensaje = "";
                    string userName = HttpContext.Session["userName"].ToString();
                    mensaje = web.AdministracionClient.EliminarPremioxSubregla(id, null, userName);
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PREMIOXSUBREGLA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar el premioxsubregla con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
            }
        }
    }
}


