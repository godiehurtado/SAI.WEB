using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class AjustesController : ControladorBase
    {
        WebPage web = new WebPage();
        #region "Concursos"
        public ActionResult AjustesConcursos(int id, int regla_id)
        {
            ViewBag.regla_id = regla_id;
            var viewModel = new AjustesModel()
            {
                listaPagosConcurso = web.AdministracionClient.ListarPagosConcurso(id)
            };
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ActualizarConcursos(FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                if (ModelState.IsValid)
                {
                    int concurso_id = 0;
                    double valor = 0;
                    String causal = "";
                    DetallePagosRegla dpr;
                    List<DetallePagosRegla> listaPagosConcurso = new List<DetallePagosRegla>();

                    foreach (String key in collection.AllKeys)
                    {
                        if (int.TryParse(key, out concurso_id))
                        {
                            if (double.TryParse(collection[concurso_id.ToString()], out valor))
                            {
                                causal = collection["ta_" + concurso_id];

                                dpr = new DetallePagosRegla();
                                dpr.id = concurso_id;
                                dpr.valorAjuste = valor;
                                AuditoriaAjuste aa = new AuditoriaAjuste();
                                aa.descripcion = String.IsNullOrEmpty(causal) ? "No ingresada" : causal;
                                dpr.AuditoriaAjustes.Add(aa);

                                listaPagosConcurso.Add(dpr);
                            }
                        }
                    }

                    if (listaPagosConcurso.Count > 0)
                    {
                        mensaje = web.AdministracionClient.ActualizarPagosConcurso(Session["username"].ToString(), listaPagosConcurso, HttpContext.Session["userName"].ToString());
                        web.Liberar();
                        if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Edit; View(TempData["Mensaje"]); }
                        else { Logging.Auditoria("Actualización de registros en las tablas DetallePagosRegla y AuditoriaAjuste.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                    }
                }
            }
            catch { }
            return RedirectToAction("Liquidaciones", "LiquidacionConcurso");
        }
        #endregion

        #region "Contratacion"
        public ActionResult AjustesContratos(int id)
        {
            var viewModel = new AjustesModel()
            {
                listaPagosContratos = web.AdministracionClient.ListarPagosContratos(id)
            };
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ActualizarContratos(FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                if (ModelState.IsValid)
                {
                    int contrato_id = 0;
                    double valor = 0;
                    String causal = "";
                    LiquiContratFactorParticipante lcfp;
                    List<LiquiContratFactorParticipante> listaPagosContratos = new List<LiquiContratFactorParticipante>();

                    foreach (String key in collection.AllKeys)
                    {
                        if (int.TryParse(key, out contrato_id))
                        {
                            if (double.TryParse(collection[contrato_id.ToString()], out valor))
                            {
                                causal = collection["ta_" + contrato_id];

                                lcfp = new LiquiContratFactorParticipante();
                                lcfp.id = contrato_id;
                                lcfp.valorAjuste = valor;
                                AuditoriaAjuste aa = new AuditoriaAjuste();
                                aa.descripcion = String.IsNullOrEmpty(causal) ? "No ingresada" : causal;
                                lcfp.AuditoriaAjustes.Add(aa);

                                listaPagosContratos.Add(lcfp);
                            }
                        }
                    }

                    if (listaPagosContratos.Count > 0)
                    {
                        mensaje = web.AdministracionClient.ActualizarPagosContratos(Session["username"].ToString(), listaPagosContratos, HttpContext.Session["userName"].ToString());
                        web.Liberar();
                        if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Edit; View(TempData["Mensaje"]); }
                        else { Logging.Auditoria("Actualización de registros en las tablas DetallePagosRegla y AuditoriaAjuste.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                    }
                }
            }
            catch { }
            return RedirectToAction("Index", "LiquidacionContrat");
        }
        #endregion

        #region "Franquicias"
        public ActionResult AjustesFranquicias(int id)
        {
            var viewModel = new AjustesModel()
            {
                listaPagosFranquicia = web.AdministracionClient.ListarPagosFranquicia(id)
            };
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult ActualizarFranquicias(FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                if (ModelState.IsValid)
                {
                    int franquicia_id = 0;
                    double valor = 0;
                    String causal = "";
                    DetallePagosFranquicia dpf;
                    List<DetallePagosFranquicia> listaPagosFranquicia = new List<DetallePagosFranquicia>();

                    foreach (String key in collection.AllKeys)
                    {
                        if (int.TryParse(key, out franquicia_id))
                        {
                            if (double.TryParse(collection[franquicia_id.ToString()], out valor))
                            {
                                causal = collection["ta_" + franquicia_id];

                                dpf = new DetallePagosFranquicia();
                                dpf.id = franquicia_id;
                                dpf.valorAjuste = valor;
                                AuditoriaAjuste aa = new AuditoriaAjuste();
                                aa.descripcion = String.IsNullOrEmpty(causal) ? "No ingresada" : causal;
                                dpf.AuditoriaAjustes.Add(aa);

                                listaPagosFranquicia.Add(dpf);
                            }
                        }
                    }

                    if (listaPagosFranquicia.Count > 0)
                    {
                        mensaje = web.AdministracionClient.ActualizarPagosFranquicia(Session["username"].ToString(), listaPagosFranquicia, HttpContext.Session["userName"].ToString());
                        web.Liberar();
                        if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Edit; View(TempData["Mensaje"]); }
                        else { Logging.Auditoria("Actualización de registros en las tablas DetallePagosFranquicia y AuditoriaAjuste.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                    }
                }
            }
            catch { }
            return RedirectToAction("liquiIndex", "LiquidacionFranqui");
        }
        #endregion
    }
}