using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.IO;
using LinqToExcel;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class LiquidacionMonedaController : ControladorBase
    {
        WebPage web = new WebPage();
        string rutaArchivos = System.Configuration.ConfigurationManager.AppSettings["RutaArchivos"];
        string urlSite = System.Configuration.ConfigurationManager.AppSettings["URLSite"];

        public ActionResult Index()
        {
            List<LiquidacionMoneda> liquidacionMoneda = web.AdministracionClient.ListarLiquidacionesMoneda(4);

            var model = new LiquidacionMonedaModel
            {
                LiquidacionMonedaList = liquidacionMoneda
            };

            ViewData["partArchivoFormato"] = urlSite + "CargueSAI/FormatosCarga/FormatoCargaManualColquines.xlsx";
            return View(model);
        }

        public ActionResult ColquinesManuales()
        {
            return View();
        }

        [HttpPost]
        public ActionResult ColquinesManualesGuardar(HttpPostedFileBase file)
        {
            if (file.ContentLength > 0)
            {
                string fechaCargue = DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
                DateTime fechaCargueFinal = Convert.ToDateTime(fechaCargue);
                string msjError = string.Empty;

                string nombreArchivo = "Colquines_" + DateTime.Now.ToShortDateString().Replace('/', '-') + " " + DateTime.Now.Hour + " " + DateTime.Now.Minute + ".xlsx";
                var rutaLocal = Path.Combine(rutaArchivos + "Colquines", nombreArchivo);
                file.SaveAs(rutaLocal);

                List<CargaColquines> temp = new List<CargaColquines>();
                List<Compania> companias = web.AdministracionClient.ListarCompanias().ToList();
                List<Segmento> segmentos = web.AdministracionClient.ListarSegmentoes().ToList();
                List<Participante> participantes = web.AdministracionClient.ListarParticipantesTotales().ToList();
                List<Moneda> monedas = web.AdministracionClient.ListarMonedas().ToList();
                List<LiquidacionMoneda> liquidacionMonedaList = web.AdministracionClient.ListarLiquidacionesMoneda(4);

                int registrosProcesados = 0; int registrosError = 0; int registro = 1;
                Boolean error = false;
                var excel = new ExcelQueryFactory(rutaArchivos + "Colquines\\" + nombreArchivo);
                excel.StrictMapping = false;

                try
                {
                    string primeraHoja = excel.GetWorksheetNames().First<string>();
                    temp = (from pre in excel.Worksheet<CargaColquines>(primeraHoja) select pre).ToList();

                    foreach (CargaColquines cargaColquin in temp)
                    {
                        error = false;

                        if (cargaColquin.Clave != null && cargaColquin.Fecha != null && cargaColquin.SegmentoId != null && cargaColquin.CompaniaId != null && cargaColquin.Cantidad != null)
                        {

                            //VALIDAMOS EL ID DE SEGMENTO
                            var segmentoTotal = segmentos.Where(x => x.id == cargaColquin.SegmentoId).Count();
                            if (segmentoTotal == 0)
                            {
                                registrosError++;
                                msjError += "<br/>|Error 101: Registro " + registro;
                                error = true;
                            }

                            //VALIDAMOS EL ID DE COMPANIA
                            var companiaTotal = companias.Where(x => x.id == cargaColquin.CompaniaId).Count();
                            if (companiaTotal == 0)
                            {
                                registrosError++;
                                msjError += "<br/>|Error 102: Registro " + registro;
                                error = true;
                            }

                            //VALIDAMOS LA CLAVE
                            var participantesTotal = participantes.Where(x => x.clave == Convert.ToString(cargaColquin.Clave)).Count();
                            if (participantesTotal == 0)
                            {
                                registrosError++;
                                msjError += "<br/>|Error 103: Registro " + registro;
                                error = true;
                            }

                            //VALIDAMOS QUE VENGAN TODOS LOS CAMPOS
                            if (cargaColquin.Clave == null || string.IsNullOrEmpty(cargaColquin.Concepto) || cargaColquin.Cantidad == null || cargaColquin.Fecha == null)
                            {
                                registrosError++;
                                msjError += "<br/>|Error 104: Registro " + registro;
                                error = true;
                            }

                            if (!error)
                            {
                                int idParticipante = participantes.Where(x => x.clave == Convert.ToString(cargaColquin.Clave)).First().id;
                                int idMoneda = monedas.Where(x => x.segmento_id == cargaColquin.SegmentoId).First().id;

                                //VALIDAMOS SI EL REGISTRO ESTA DUPLICADO
                                var liquidacionMonedaExiste = (from lm in liquidacionMonedaList
                                                               where lm.participante_id == idParticipante && lm.moneda_id == idMoneda && lm.cantidad == cargaColquin.Cantidad
                                                                   && lm.recaudo_id == 0 && lm.compania_id == cargaColquin.CompaniaId && lm.fechaLiquidacion == cargaColquin.Fecha
                                                                   && lm.tipo == 4
                                                               select lm).ToList();

                                if (liquidacionMonedaExiste != null && liquidacionMonedaExiste.Count() == 0)
                                {
                                    //GUARDAMOS EL REGISTRO
                                    LiquidacionMoneda liquidacionMoneda = new LiquidacionMoneda
                                    {
                                        fechaCargue = fechaCargueFinal,
                                        compania_id = cargaColquin.CompaniaId,
                                        participante_id = idParticipante,
                                        cantidad = cargaColquin.Cantidad,
                                        concepto = cargaColquin.Concepto,
                                        moneda_id = monedas.Where(x => x.segmento_id == cargaColquin.SegmentoId).First().id,
                                        recaudo_id = 0,
                                        fechaLiquidacion = cargaColquin.Fecha,
                                        tipo = 4
                                    };

                                    liquidacionMonedaList.Add(liquidacionMoneda);

                                    web.AdministracionClient.GuardarLiquidacionMoneda(liquidacionMoneda, HttpContext.Session["userName"].ToString());
                                    registrosProcesados++;
                                }
                                else
                                {
                                    registrosError++;
                                    msjError += "<br/>|Error 105: Registro " + registro;
                                }
                            }

                            registro++;
                        }
                    }

                }
                catch (Exception ex)
                {
                    registrosError++;
                    msjError += "<br/>|Error: " + ex.Message;
                }

                ViewData["Mensaje"] = "<br/>|Registros Procesados: " + (registro - 1);
                ViewData["Mensaje"] += "<br/>|Registros Procesados con éxito: " + registrosProcesados;
                ViewData["Mensaje"] += "<br/>|Registros Procesados con error: " + registrosError;
                if (registrosError > 0)
                {
                    ViewData["Mensaje"] += "<br/>|Log de Errores: <br/>";
                    ViewData["Mensaje"] += "<b>|Error 101: El segmento no existe en la BD.<br/>";
                    ViewData["Mensaje"] += "|Error 102: La compañia no existe en la BD.<br/>";
                    ViewData["Mensaje"] += "|Error 103: La clave no corresponde a ningun participante.<br/>";
                    ViewData["Mensaje"] += "|Error 104: Registro mal formado o tiene datos vacios.<br/>";
                    ViewData["Mensaje"] += "|Error 105: Registro duplicado en la BD.<br/></b><hr/>";
                    ViewData["Mensaje"] += msjError;
                }
            }

            return View("ColquinesManuales");
        }

        [HttpPost]
        public ActionResult EliminarCargue()
        {
            string messagge = string.Empty;

            DateTime fechaCargue = Convert.ToDateTime(Request["fechaCargue"]);

            web.AdministracionClient.BorrarColquinesManuales(fechaCargue, HttpContext.Session["userName"].ToString());

            messagge = "El proceso se realizo con éxito.";

            return Json(new { Success = true, Messagge = messagge });
        }
    }
}
