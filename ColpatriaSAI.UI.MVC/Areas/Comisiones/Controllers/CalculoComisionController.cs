using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using Entidades = ColpatriaSAI.Negocio.Entidades;
using System.IO;
using System.ComponentModel;
using ColpatriaSAI.Negocio.Entidades.ResultadoProcedimientos;
using System.Threading.Tasks;
using System.Web.Mvc.Async;
using System.Text;
using System.Threading;
using System.Globalization;
using admin = ColpatriaSAI.Negocio.Componentes.Comision.Administracion;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades.Informacion;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class CalculoComisionController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private ComisionesSVC.ComisionesClient _svcComisionesClient;
        private CalculosTalentosComision.CalculosClient _svcCalculosClient;
        [Authorize]
        public ActionResult Historico()
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();


            List<int> factReproceso = _svcCalculosClient.ValReprocesoLiq().ToList();
            if (factReproceso != null && factReproceso.Count > 0)
                TempData["FACT_REP"] = "S";
            else
                TempData["FACT_REP"] = "N";

            return View(_svcCalculosClient.ObtenerHistoricoLiquidaciones());

            //Se valida que no hayan REPROCESO generandose en segudo plano
           
          
        }

        [Authorize]
        public ActionResult CalculoComision(int? IdLiquidacion)
        {
            CalculoComisionViewModel vmmodel = new CalculoComisionViewModel();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            if (IdLiquidacion.HasValue)
            {
                vmmodel.IdLiquidacion = IdLiquidacion;
            }
            vmmodel.Modelos.AddRange(_svcModelClient.ListarModeloComisionVigentes()
                .Select(x => new SelectListItem()
                {
                    Value = x.id.ToString(),
                    Text = x.nombre
                }));

            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            Entidades.CustomEntities.ExtraccionComision extraccionComision = _svcCalculosClient.ValidarUltimaExtraccion();

            PrevisualizacionExtraccionViewModel extraccionViewModel = new PrevisualizacionExtraccionViewModel();
            extraccionViewModel.EstadoExtraccion = extraccionComision.estadoExtraccion_id;
            extraccionViewModel.Anio = (short)extraccionComision.año;
            extraccionViewModel.Mes = (byte)extraccionComision.mes;
            extraccionViewModel.Dia = (byte)extraccionComision.dia;

            vmmodel.Extraccion = extraccionViewModel;

            //Se valida que no hayan facutras generandose en segudo plano

            List<int> factGenerandose = _svcCalculosClient.ValLiqPendientes().ToList();
            if (factGenerandose != null && factGenerandose.Count > 0)
                TempData["FACT_PEND"] = "S";
            else
                TempData["FACT_PEND"] = "N";
           
            return View(vmmodel);
        }

        //[Authorize, HttpPost]
        //public ActionResult CalculoComision(CalculoComisionViewModel vmmodel)
        //{

        //    if (ModelState.IsValid)
        //    {
        //        try
        //        {
        //            //_svcComisionesClient = new ComisionesSVC.ComisionesClient();

        //            //string username = string.Empty;
        //            //if (HttpContext.Session["userName"] != null)
        //            //    username = HttpContext.Session["userName"].ToString();

        //            //_svcCalculosClient = new CalculosTalentosComision.CalculosClient();

        //            //var strres = _svcCalculosClient.ProcesoExtraccionBeneficiarioFacturacionRecaudos("20160923SEDTR", 2016, 9);

        //        }
        //        catch (Exception ex)
        //        {
        //            TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
        //            TempData["OperationSuccess"] = false;
        //        }
        //    }
        //    else
        //    {
        //        TempData["ErrorMessage"] = "Datos inválidos";
        //        TempData["OperationSuccess"] = false;
        //    }
        //    return View();
        //}

        [Authorize, HttpPost]
        public ActionResult ConsultarExtraccion(string anio, string mes, string dia)
        {

            CalculoComisionViewModel vmmodel = new CalculoComisionViewModel();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            
            vmmodel.Modelos.AddRange(_svcModelClient.ListarModeloComisionVigentes()
                .Select(x => new SelectListItem()
                {
                    Value = x.id.ToString(),
                    Text = x.nombre
                }));

            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            PrevisualizacionExtraccionViewModel extraccionViewModel = new PrevisualizacionExtraccionViewModel();

            Entidades.CustomEntities.ExtraccionComision extraccionComision = _svcCalculosClient.ValidarExtraccion(int.Parse(anio), int.Parse(mes), int.Parse(dia));

            if(extraccionComision.id == 0)
            {
                Entidades.CustomEntities.ExtraccionComision ultimaExtraccionComision = _svcCalculosClient.ValidarUltimaExtraccion();
                var fecha = DateTime.Parse(anio + "-" + mes + "-" + dia);
                if(ultimaExtraccionComision.fecha > fecha)
                {
                    extraccionViewModel.EstadoExtraccion = 5;
                    extraccionViewModel.Anio = (short)ultimaExtraccionComision.año;
                    extraccionViewModel.Mes = (byte)ultimaExtraccionComision.mes;
                    extraccionViewModel.Dia = (byte)ultimaExtraccionComision.dia;
                }
                else
                {
                    extraccionViewModel.EstadoExtraccion = 0;
                    extraccionViewModel.Anio = short.Parse(anio);
                    extraccionViewModel.Mes = byte.Parse(mes);
                    extraccionViewModel.Dia = byte.Parse(dia);
                }
            }
            else
            {
                extraccionViewModel.EstadoExtraccion = extraccionComision.estadoExtraccion_id;
                extraccionViewModel.Anio = (short)extraccionComision.año;
                extraccionViewModel.Mes = (byte)extraccionComision.mes;
                extraccionViewModel.Dia = (byte)extraccionComision.dia;
            }

            vmmodel.Extraccion = extraccionViewModel;

            //Se valida que no hayan facutras generandose en segudo plano

            List<int> factGenerandose = _svcCalculosClient.ValLiqPendientes().ToList();
            if (factGenerandose != null && factGenerandose.Count > 0)
                TempData["FACT_PEND"] = "S";
            else
                TempData["FACT_PEND"] = "N";

            return Json(new { Extraccion = vmmodel.Extraccion, Modelos = vmmodel.Modelos });
        }

        [Authorize, HttpPost]
        public ActionResult ConsultarUltimaExtraccion()
        {
            CalculoComisionViewModel vmmodel = new CalculoComisionViewModel();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();

            vmmodel.Modelos.AddRange(_svcModelClient.ListarModeloComisionVigentes()
                .Select(x => new SelectListItem()
                {
                    Value = x.id.ToString(),
                    Text = x.nombre
                }));

            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            PrevisualizacionExtraccionViewModel extraccionViewModel = new PrevisualizacionExtraccionViewModel();

            Entidades.CustomEntities.ExtraccionComision extraccionComision = _svcCalculosClient.ValidarUltimaExtraccion();

            if (extraccionComision.id == 0)
            {
                extraccionViewModel.EstadoExtraccion = 0;
                extraccionViewModel.ExtraccionId = 0;
            }
            else
            {
                extraccionViewModel.EstadoExtraccion = extraccionComision.estadoExtraccion_id;
                switch (extraccionComision.estadoExtraccion_id) 
                { 
                    case 1:
                        extraccionViewModel.EstadoExtraccionName = "En proceso"; 
                        break;
                    case 2:
                        extraccionViewModel.EstadoExtraccionName = "Disponible";
                        break;
                    default:
                        extraccionViewModel.EstadoExtraccionName = "";
                        break;
                }
                extraccionViewModel.Anio = (short)extraccionComision.año;
                extraccionViewModel.Mes = (byte)extraccionComision.mes;
                extraccionViewModel.Dia = (byte)extraccionComision.dia;
                extraccionViewModel.ExtraccionId = extraccionComision.id;
                extraccionViewModel.Fecha = extraccionComision.fecha.ToString("yyyy-MM-dd");
                extraccionViewModel.CodigoExtraccion = extraccionComision.CodigoExt;
                extraccionViewModel.TipoLiquidacionId = (byte)extraccionComision.tipoLiquidacion;
                switch (extraccionComision.tipoLiquidacion)
                {
                    case 1:
                        extraccionViewModel.TipoLiquidacionName = "Comisiones";
                        break;
                    case 2:
                        extraccionViewModel.TipoLiquidacionName = "Comisiones + Reserva";
                        break;
                    default:
                        extraccionViewModel.TipoLiquidacionName = "";
                        break;
                }
            }

            vmmodel.Extraccion = extraccionViewModel;

            // En lugar de devolver la vista con el modelo, devolvemos los datos en formato JSON
            return Json(new { Extraccion = vmmodel.Extraccion, Modelos = vmmodel.Modelos });
        }



        [Authorize, HttpPost]
        public ActionResult LiquidarComision(FormCollection form)
        {
            int modeloId = Convert.ToInt32(form["ModeloId"]);
            short anio = Convert.ToInt16(form["Anio"]);
            byte mes = Convert.ToByte(form["Mes"]);
            int liquidacionComisionId = Convert.ToInt32(form["LiquidacionComisionId"]);
            try
            {
                _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
                var res = _svcCalculosClient.LiquidarComisionSegunModelo(modeloId, anio, mes, liquidacionComisionId);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Liquidación completada correctamente.";
                }
                else
                {
                    TempData["OperationSuccess"] = false;
                    TempData["ErrorMessage"] = res.MensajeError;
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("CalculoComision");
        }

        [Authorize]
        public ActionResult PreVisualizarFacturacion(int idLiquidacion)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            ExportResultListFromTsv(_svcCalculosClient.ObtenerComisionFijaFacturacionPorLiquidacion(idLiquidacion), "Liquidacion Reserva");
            return RedirectToAction("CalculoComision", new { IdLiquidacion = idLiquidacion });
        }

        [Authorize]
        public ActionResult PreVisualizarRecaudos604(int idLiquidacion)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            ExportResultListFromTsv(_svcCalculosClient.ObtenerComisionFijaRecaudosPorLiquidacion604(idLiquidacion), "604");
            return RedirectToAction("CalculoComision", new { IdLiquidacion = idLiquidacion });
        }

        [Authorize]
        public ActionResult PreVisualizarRecaudos(int idLiquidacion)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            ExportResultListFromTsv(_svcCalculosClient.ObtenerComisionFijaRecaudosPorLiquidacion(idLiquidacion), "Liquidacion Comision");
            return RedirectToAction("CalculoComision", new { IdLiquidacion = idLiquidacion });
        }
        public void WriteTsv<T>(IEnumerable<T> data, TextWriter output)
        {
            PropertyDescriptorCollection props = TypeDescriptor.GetProperties(typeof(T));
            foreach (PropertyDescriptor prop in props)
            {
                output.Write(prop.DisplayName); // header
                output.Write("\t");
            }
            output.WriteLine();
            foreach (T item in data)
            {
                foreach (PropertyDescriptor prop in props)
                {
                    output.Write(prop.Converter.ConvertToString(
                         prop.GetValue(item)));
                    output.Write("\t");
                }
                output.WriteLine();
            }
        }
        public void ExportResultListFromTsv(ComisionFijaFacturacion[] data, string filename)
        {

            //var forzarcultura = CultureInfo.CurrentCulture.Clone();
            //forzarcultura = NumberFormatInfo.CurrentInfo.NumberDecimalSeparator = ".";
            //forzarcultura = NumberFormatInfo.CurrentInfo.NumberGroupSeparator = ",";


            //NumberFormatInfo localformat = (NumberFormatInfo)NumberFormatInfo.CurrentInfo.Clone();
            //localformat.CurrencyDecimalSeparator = ".";
            //localformat.CurrencyGroupSeparator = ",";

            //CultureInfo.CurrentCulture.NumberFormat = localformat;

            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".csv");
            Response.AddHeader("Content-Type", "application/vnd.ms-excel");

            //CultureInfo culformat = new CultureInfo("es-ES");
            //
            //culformat.NumberFormat.CurrencyDecimalSeparator = ".";
            //culformat.NumberFormat.NumberDecimalSeparator = ".";
            //culformat.NumberFormat.CurrencyGroupSeparator = ",";
            //Thread.CurrentThread.CurrentCulture = culformat;

            WriteTsv(data, Response.Output);
            Response.End();
        }
        public void ExportResultListFromTsv(ComisionFijaRecaudos[] data, string filename)
        {

                 
                             
            Response.ClearContent();
            Response.AddHeader("content-disposition", "attachment;filename=" + filename + ".csv");
            //Response.ContentType = "application/ms-excel";
            Response.AddHeader("Content-Type", "application/vnd.ms-excel");

            //CultureInfo culformat = new CultureInfo("es-ES");
            ////Thread.CurrentThread.CurrentCulture = culformat;
            //
            //culformat.NumberFormat.NumberDecimalSeparator = ".";
            //culformat.NumberFormat.NumberGroupSeparator = ",";
            //culformat.NumberFormat.CurrencyDecimalSeparator = ".";
            //culformat.NumberFormat.CurrencyGroupSeparator = ",";
            //Thread.CurrentThread.CurrentCulture = culformat;

            WriteTsv(data, Response.Output);
            Response.End();
        }


  
        public  bool ValidaEliminacionLiquidacion(int idliquidacion)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
             
            
            return _svcCalculosClient.ValidaAnularLiquidacion(idliquidacion);

        }
    }

    public class AsyncCalculoComisionController : AsyncController
    {

        private CalculosTalentosComision.CalculosClient _svcCalculosClient;


        public ActionResult levantarEtl(string anio, string mes, string dia, string tipoLiqId, string modeloId)
        {
            try
            {
                string miLog="1>Fecha Ejecucion "+ DateTime.Now.ToString();  
                AsyncManager.OutstandingOperations.Increment();
                miLog+=" 2>";
                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                {    
                    miLog+=" 3>";
                    username = HttpContext.Session["userName"].ToString();
                    miLog+=" 4> Username: " + username;
                }
               
                miLog+=" 5>";
                var task1 = Task<int>.Factory.StartNew(() =>
                {

                  //  miLog+=" 6> " + anio +"-"+ mes +"-"+ tipoLiqId +"-"+ modeloId +"-"+ username ;
                  return calculoComision(anio,mes,dia, tipoLiqId, modeloId, username);
                   
                });
                miLog += " 7> ";

                task1.ContinueWith(t =>
                {
                    miLog += " 8> ";
                    AsyncManager.OutstandingOperations.Decrement();
                });

                miLog += " 9> ";

                //creo el log
                StreamWriter log;
               string ruta = @"E:\SAI\";
                
                if (System.IO.File.Exists(ruta + "logCalculoComision.txt"))
                {
                    log = new StreamWriter(ruta + "logCalculoComision.txt");
                }
                else
                {
                    log = System.IO.File.AppendText(ruta + "logCalculoComision.txt");
                }
             
                log.WriteLine(miLog);
                log.Close();

            }
            catch (Exception ex )
            {
                string ruta = @"E:\SAI\";
               // string ruta = @"C:\SAI\";
                StreamWriter log;

                if (System.IO.File.Exists(ruta + "logCalculoComision1.txt"))
                {
                    log = new StreamWriter(ruta + "logCalculoComision1.txt");
                }
                else {

                    log = System.IO.File.AppendText(ruta + "logCalculoComision1.txt");
                }
 
                log.WriteLine("Excepcion name: " + ex.Message.ToString());
                log.Close();

            }

            return null;
        }

        private int calculoComision(string anio,string mes, string dia, string tipoLiqId, string modeloId, string usuario)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
           
            mes = Convert.ToInt32(mes) < 10 ? "0" + mes : mes;
            dia = Convert.ToInt32(dia) < 10 ? "0" + dia : dia;

            Entidades.CustomEntities.ExtraccionComision extraccionComision = _svcCalculosClient.ValidarExtraccion(int.Parse(anio), int.Parse(mes), int.Parse(dia));

            _svcCalculosClient.LiquidarComision(extraccionComision.id,usuario,int.Parse(modeloId));

            return 1;
        }

        public void Pagar(Int32 NumLiq)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            _svcCalculosClient.LiquidarComisiones(NumLiq);
        }

        public ActionResult LevantarEtlAnulacion(int idliquidacion, string anio, string mes, string dia)
        {
            try
            {

                AsyncManager.OutstandingOperations.Increment();

                //string username = string.Empty;
                //if (HttpContext.Session["userName"] != null)
                //{

                //    username = HttpContext.Session["userName"].ToString();

                //}


                var task1 = Task<int>.Factory.StartNew(() =>
                {

                    //  miLog+=" 6> " + anio +"-"+ mes +"-"+ tipoLiqId +"-"+ modeloId +"-"+ username ;
                    return AnularLiquidacion(idliquidacion,anio,mes,dia);

                });

                task1.ContinueWith(t =>
                {

                    AsyncManager.OutstandingOperations.Decrement();
                });



            }
            catch (Exception ex)
            {


            }

            return null;
        }

        public int AnularLiquidacion(int IdLiquidacion, string anio,string mes, string dia)
        {

            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            Dictionary<string, object> parametrosEtlAnulacion = new Dictionary<string, object>();
            CultureInfo culture = new CultureInfo("es-ES");

              mes = Convert.ToInt32(mes) < 10 ? "0" + mes : mes;

            parametrosEtlAnulacion.Add("IdLiquidacion", IdLiquidacion);
            parametrosEtlAnulacion.Add("CodExt", "EXT-" + anio.Substring(2) + mes + dia + "-" + IdLiquidacion.ToString());
            parametrosEtlAnulacion.Add("CodMacBHF", "MAC-" + dia + mes + anio + "-" + IdLiquidacion + "F");
            parametrosEtlAnulacion.Add("CodMacBHR", "MAC-" + dia + mes + anio + "-" + IdLiquidacion + "R");

            ComisionesSVC.ComisionesClient _svcComisiones = new ComisionesSVC.ComisionesClient();

            var ExtractAnulacion = _svcCalculosClient.ExtractAnulacion(parametrosEtlAnulacion, IdLiquidacion);


            return 1;
        }

        public ActionResult ReprocesarEtl(string anio, string mes, string dia, string idliquidacion, string Tipoliq, string modeloid)
        {
            try
            {

                //se actualiza el estado de liquidacion a reprocesando
                _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

                _svcCalculosClient.ActualizaEstadoReprocesar( Convert.ToInt32(idliquidacion));
                
            }
            catch (Exception ex)
            {


            }

            return null;

            //ActionResult resEtlAnul = LevantarEtlAnulacion(Convert.ToInt32(idliquidacion), anio, mes, dia);

            //ActionResult resEtlLiquidacion = levantarEtl(anio, mes, dia, Tipoliq, modeloid);

            //return null;
        
        }

        public ActionResult IniciarDescarga(string anio, string mes, string dia, string tipoLiqId)
        {
            try
            {
                AsyncManager.OutstandingOperations.Increment();
                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                {
                    username = HttpContext.Session["userName"].ToString();
                }

                var task1 = Task<int>.Factory.StartNew(() =>
                {
                    return DescargaInformacion(anio, mes, dia, tipoLiqId, username);
                });

                task1.ContinueWith(t =>
                {
                    AsyncManager.OutstandingOperations.Decrement();
                });

            }
            catch (Exception ex)
            {
                string ruta = @"E:\SAI\";
                // string ruta = @"C:\SAI\";
                StreamWriter log;

                if (System.IO.File.Exists(ruta + "logCalculoComision1.txt"))
                {
                    log = new StreamWriter(ruta + "logCalculoComision1.txt");
                }
                else
                {

                    log = System.IO.File.AppendText(ruta + "logCalculoComision1.txt");
                }

                log.WriteLine("Excepcion name: " + ex.Message.ToString());
                log.Close();

            }

            return null;
        }

        private int DescargaInformacion(string anio, string mes, string dia, string tipoLiqId, string usuario)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            mes = Convert.ToInt32(mes) < 10 ? "0" + mes : mes;
            dia = Convert.ToInt32(dia) < 10 ? "0" + dia : dia;
            Dictionary<string, object> parametrosEtlCF = new Dictionary<string, object>();
            CultureInfo culture = new CultureInfo("es-ES");

            parametrosEtlCF.Add("FechaFinExtraBenef", anio + "-" + mes + "-" + dia);
            parametrosEtlCF.Add("ExtInvoiceMAC", "MAC" + dia + mes + anio + "F");
            parametrosEtlCF.Add("ExtractCollecctMAC", "MAC" + dia + mes + anio + "R");
            parametrosEtlCF.Add("Homologaciones", "EXT-" + anio.Substring(2) + mes + dia);
            //parametros de novedades - Actualización 02/12/2016
            ComisionesSVC.ComisionesClient _svcComisiones = new ComisionesSVC.ComisionesClient();

            string[] parametrosCOns = new string[4] { "17", "18", "19", "20" };//Novedades Usarios CF, CV, Usuarios Renovados, Beneficiarios Vigentes
            List<admin.ConfigParametros> Parametros = _svcComisiones.ObtenerParametros(parametrosCOns).ToList();
            //Se reemplaza cada valor leido por ; debido a que el SP_EXTRACT_USERS_MAC está configurado para leer los parámetros por ;
            string NOV_CUNCF = Parametros.Where(x => x.id == 17).FirstOrDefault().valor.Replace(',', ';');
            string NOV_CUNCV = Parametros.Where(x => x.id == 18).FirstOrDefault().valor.Replace(',', ';');
            string NOV_CUSRN = Parametros.Where(x => x.id == 19).FirstOrDefault().valor.Replace(',', ';');
            string BEN_NSTATE = Parametros.Where(x => x.id == 20).FirstOrDefault().valor.Replace(',', ';');

            parametrosEtlCF.Add("NOV_CUNCF", NOV_CUNCF);
            parametrosEtlCF.Add("NOV_CUNCV", NOV_CUNCV);
            parametrosEtlCF.Add("NOV_CUSRN", NOV_CUSRN);

            if (BEN_NSTATE == "N")
                parametrosEtlCF.Add("BEN_NSTATE", 1);
            else
                parametrosEtlCF.Add("BEN_NSTATE", 0);

            Dictionary<string, object> parametrosEtlCV = new Dictionary<string, object>();
            if (tipoLiqId == "2")
            {
                //parametros EtlCv Cargue de beneficiarios
                parametrosEtlCV.Add("FechaFinExtraBenef", anio + "-" + mes + "-" + dia);
                parametrosEtlCV.Add("NOV_CUNCF", NOV_CUNCF);
                parametrosEtlCV.Add("NOV_CUNCV", NOV_CUNCV);
                parametrosEtlCV.Add("NOV_CUSRN", NOV_CUSRN);

                if (BEN_NSTATE == "N")
                    parametrosEtlCV.Add("BEN_NSTATE", 1);
                else
                    parametrosEtlCV.Add("BEN_NSTATE", 0);

                //parametro ETLcv SpHomologacion
                parametrosEtlCV.Add("CodExtrHomol", "EXT-" + anio.Substring(2) + mes + dia);
            }


            var ExtracComsiones = _svcCalculosClient.ExtractCf_CV(parametrosEtlCF, parametrosEtlCV, Convert.ToInt16(anio), Convert.ToByte(mes),Convert.ToByte(dia),0, Convert.ToByte(tipoLiqId), usuario, Convert.ToInt32(tipoLiqId), new InfoAplicacion());

            return 1;
        }

        public ActionResult CargarHistoricoDescarga(string anio, string mes, string dia)
        {
            try
            {
                AsyncManager.OutstandingOperations.Increment();
                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                {
                    username = HttpContext.Session["userName"].ToString();
                }

                var task1 = Task<int>.Factory.StartNew(() =>
                {
                    return CargarExtraccionHistorico(anio, mes, dia);
                });

                task1.ContinueWith(t =>
                {
                    AsyncManager.OutstandingOperations.Decrement();
                });

            }
            catch (Exception ex)
            {
                string ruta = @"E:\SAI\";
                // string ruta = @"C:\SAI\";
                StreamWriter log;

                if (System.IO.File.Exists(ruta + "logCalculoComision1.txt"))
                {
                    log = new StreamWriter(ruta + "logCalculoComision1.txt");
                }
                else
                {

                    log = System.IO.File.AppendText(ruta + "logCalculoComision1.txt");
                }

                log.WriteLine("Excepcion name: " + ex.Message.ToString());
                log.Close();

            }

            return null;
        }

        private int CargarExtraccionHistorico(string anio, string mes, string dia)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

            Entidades.CustomEntities.ExtraccionComision extraccionComision = _svcCalculosClient.ValidarExtraccion(int.Parse(anio), int.Parse(mes), int.Parse(dia));

            var ExtracComsiones = _svcCalculosClient.CargarExtraccionHistorico(extraccionComision.id);

            return 1;
        }

    }

    
}
