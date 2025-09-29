using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

using System.Web.Mvc;
using Entidades = ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using System.Data.OleDb;
using System.Text;
using System.Web.Mvc.Html;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using System.Text.RegularExpressions;
using ColpatriaSAI.Negocio.Entidades;
using System.Data.EntityClient;
using System.Data.SqlClient;
using ColpatriaSAI.UI.MVC.Controllers;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ExcepcionesComisionController : ControladorBase //ColpatriaSAI.UI.MVC.Controllers.ControladorBase 
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private AdministracionSvc.AdministracionClient _svcAdmonClient;
        string Username = string.Empty;
        private int _ContadorError = 0;
        int claveInicial = 0;
        int claveFinal = 0;
        int _modelo_actual = 0;

        /// Lista de Errores que se generaron
        private List<_ExcepcionPenalizacion> Penalizacion = new List<_ExcepcionPenalizacion>();

        #region Excepción Penalización

        [Authorize]
        public ActionResult ExcepcionPenalizacion(int id)
        {
            ExcepcionesPenalizacionViewModel vwmodel = new ExcepcionesPenalizacionViewModel()
            {
                IdModelo = id
            };
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vwmodel.SetViewModel(dbmodel);
            vwmodel.DescripcionModelo = dbmodel.descripcion;
            vwmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            //List<_ExcepcionPenalizacion> prueba = _svcModelClient.ListarExcepcionesPenalizacionXModeloComision(vwmodel.IdModelo).ToList();
            vwmodel
                .ExcepcionesPenalizacionModeloComision
                .AddRange(_svcModelClient.ListarExcepcionesPenalizacionXModeloComision(vwmodel.IdModelo)
                .Select(c => new ExcepcionPenalizacionViewModel()
                {
                    Id = c.ID,
                    ModeloId = c.MODELO,
                    NumeroContrato = c.NUMERO_CONTRATO,
                    AsesorClaveOrigenId = c.CLAVE_ORIGEN,
                    AsesorOrigen = c.NOMBRE_ASESOR_ORIGEN,
                    AsesorClaveDestinoId = c.CLAVE_DESTINO,
                    AsesorDestino = c.NOMBRE_ASESOR_DESTINO,
                    Aplica = c.EXCEPCION == "Origen" ? "Clave Origen" : c.EXCEPCION == "Destino" ? "Clave Destino" : "Ambas Claves",
                    Activo = c.ACTIVO
                }));

            return View(vwmodel);
        }

        /// <summary>
        /// Vista cargueMasivoPenalizacion
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        [Authorize]
        public ActionResult CargueExcepcionPenalizacion(int ID)
        {
            ViewBag.Errores = false;
            ViewBag.Id = ID;
            return View(ViewBag);
        }

        /// <summary>
        /// Matodo para realizar la carga masiva de excepciones Penalizacion
        /// </summary>
        /// <param name="uploadFile"></param>
        /// <returns></returns>
        [HttpPost, Authorize]
        public ActionResult CargueExcepcionPenalizacion(int modelo, HttpPostedFileBase uploadFile)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var routeValues = Url.RequestContext.RouteData.Values;
            @ViewBag.Id = modelo;
            int Result_p = 0;

            DataSet ds = new DataSet();
            List<_ExcepcionPenalizacion> lisPenalizacion = new List<_ExcepcionPenalizacion>();
            List<_ExcepcionPenalizacion> lisPenalizacionDuplicados = new List<_ExcepcionPenalizacion>();
            List<_ExcepcionPenalizacion> lisPenalizacionAux = new List<_ExcepcionPenalizacion>();
            string Errores = string.Empty;

            if (Request.Files["uploadFile"].ContentLength > 0)
            {
                string fileExtension = System.IO.Path.GetExtension(Request.Files["uploadFile"].FileName);
                string fileLocation = Server.MapPath("~/App_Data/") + System.IO.Path.GetFileName(Request.Files["uploadFile"].FileName);

                int conteo = 1;
                while (System.IO.File.Exists(fileLocation))
                {
                    fileLocation = Server.MapPath("~/App_Data/") + System.IO.Path.GetFileNameWithoutExtension(Request.Files["uploadFile"].FileName) + conteo.ToString() + fileExtension;
                    conteo++;
                }
                Request.Files["uploadFile"].SaveAs(fileLocation);

                string excelConnectionString = string.Empty;

                excelConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"", fileLocation);

                if (fileExtension == ".xls")
                {
                    excelConnectionString = string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"", fileLocation);
                }
                else if (fileExtension == ".xlsx")
                {
                    excelConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"", fileLocation);
                }

                OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                excelConnection.Open();
                DataTable dt = new DataTable();
                dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (dt == null)
                {
                    return null;
                }

                String[] excelSheets = new String[dt.Rows.Count];
                int t = 0;
                foreach (DataRow row in dt.Rows)
                {
                    excelSheets[t] = row["TABLE_NAME"].ToString();
                    t++;
                }
                OleDbConnection excelConnection1 = new OleDbConnection(excelConnectionString);

                ///Se toman los datos de la tabla cargada
                string query = string.Format("Select * from [{0}]", excelSheets[0]);
                using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection1))
                {
                    dataAdapter.Fill(ds);
                    Regex reg = new Regex("[0-9]");
                    foreach (DataRow item in ds.Tables[0].Rows)
                    {

                        ColpatriaSAI.Negocio.Entidades._ExcepcionPenalizacion a = new ColpatriaSAI.Negocio.Entidades._ExcepcionPenalizacion();
                        claveInicial = (item["clave_origen"] == DBNull.Value ? 0 : int.Parse(item["clave_origen"].ToString()));
                        claveFinal = (item["clave_destino"] == DBNull.Value ? 0 : int.Parse(item["clave_destino"].ToString()));
                        string Excepcion = "";
                        bool _Ncontrato = reg.IsMatch(item["numero_de_contratro"] == DBNull.Value ? string.Empty : item["numero_de_contratro"].ToString());
                        bool _Origuen = reg.IsMatch(Convert.ToString(claveInicial));
                        bool _Destino = reg.IsMatch(Convert.ToString(claveFinal));
                        string excepciontipo = item["excepcion_para"] == DBNull.Value ? string.Empty : item["excepcion_para"].ToString();
                        
                        if(excepciontipo =="Clave Origen"){
                            Excepcion = "Origen";
                        }else if (excepciontipo =="Clave Destino"){
                            Excepcion = "Destino";
                        }
                        else if (excepciontipo == "Ambas Clave")
                        {
                            Excepcion = "Ambas";
                        }
                        else
                        {
                            Excepcion = "Execepcion no existente";
                        }

                        if (_Ncontrato == false || _Origuen == false || _Destino == false)
                        {

                            a.NUMERO_CONTRATO = item["numero_de_contratro"] == DBNull.Value ? string.Empty : item["numero_de_contratro"].ToString();
                            a.CLAVE_ORIGEN = claveInicial;
                            a.CLAVE_DESTINO = claveFinal;
                            a.EXCEPCION = item["excepcion_para"] == DBNull.Value ? string.Empty : item["excepcion_para"].ToString();
                            a.DESCRIPCION_ERROR = "NO";
                            //El número de contratro contiene caracteres que no son númericos
                            a.MODELO = modelo;
                            lisPenalizacion.Add(a);
                            _ContadorError = _ContadorError + 1;
                        }
                        else if (claveInicial == claveFinal)
                        {
                            a.NUMERO_CONTRATO = item["numero_de_contratro"] == DBNull.Value ? string.Empty : item["numero_de_contratro"].ToString();
                            a.CLAVE_ORIGEN = claveInicial;
                            a.CLAVE_DESTINO = claveFinal;
                            a.EXCEPCION = item["excepcion_para"] == DBNull.Value ? string.Empty : item["excepcion_para"].ToString();
                            a.DESCRIPCION_ERROR = "CO";
                            ///la clave origen es igual a la clave destino o alguna de las claves contienen caracateres que no son números
                            a.MODELO = modelo;
                            lisPenalizacion.Add(a);
                            _ContadorError = _ContadorError + 1;

                        }else
                        {
                            a.NUMERO_CONTRATO = item["numero_de_contratro"] == DBNull.Value ? string.Empty : item["numero_de_contratro"].ToString();
                            a.CLAVE_ORIGEN = claveInicial;
                            a.CLAVE_DESTINO = claveFinal;
                            a.EXCEPCION = Excepcion;
                            a.DESCRIPCION_ERROR = "";
                            a.MODELO = modelo;
                            lisPenalizacion.Add(a);

                        }

                    }
                }

                var _ResulP =_svcModelClient.CargueExcepcionesPenalizacion(lisPenalizacion.ToArray());
                Result_p = _ResulP.Count();
                excelConnection.Close();
                System.IO.File.Delete(fileLocation);
            }
            if (Result_p >=0)
            {
                TempData["OperationSuccess"] = true;
                TempData["SuccessMessage"] = "Operacion realizada exitosamente";
            }
            int Ndata;
            if (ds.Tables.Count <= 0)
            {
                 Ndata = 0;
                 TempData["OperationSuccess"] = false;
                 TempData["ErrorMessage"] = "no se a cargado ningun Archivo";
            }

            else
	        {

                Ndata = ds.Tables[0].Rows.Count;
	        }
                @ViewBag.CantResultadosProcesados = Ndata;
                @ViewBag.CantResultadosFallidos = _contError();
                @ViewBag.CantTotales = (Ndata-_contError());
                @ViewBag.Errores = false;
                
                
            //return RedirectToAction("CargueExcepcionPenalizacion", "Excepciones", new { id = modelo });
            return View(ViewBag);

        }

        public FileResult DescargarPruebaPenalizacion()
        {
            string fileLocation = Server.MapPath("~/App_Data/") + "excepciones a la penalizacion.xlsx";
            return File(fileLocation, "application/vnd.ms-excel", "excepciones a la penalizacion.xlsx");
        }

        public int _contError()
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var data = _svcModelClient._lisErrores();
            var result = data.Where(a => a.DESCRIPCION_ERROR != "Registro Exitoso").ToList();
            return result.Count();
        }

        public void DescargarLog() {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var data = _svcModelClient._lisErrores();
            var gv = new GridView();
            gv.DataSource = data.Select(i => new
            {
                i.NUMERO_CONTRATO,
                i.CLAVE_ORIGEN,
                i.CLAVE_DESTINO,
                i.MODELO,
                i.EXCEPCION,
                i.DESCRIPCION_ERROR
            }).ToList();
            gv.DataBind();
            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment; filename=LogErrores.xls");
            Response.ContentType = "application/ms-excel";

            Response.Charset = "";
            StringWriter objStringWriter = new StringWriter();
            HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);

            gv.RenderControl(objHtmlTextWriter);

            Response.Output.Write(objStringWriter.ToString());
            Response.Flush();
            Response.End();
        }

   [HttpPost, Authorize]
        public ActionResult AgregarPenalizacion(ExcepcionesPenalizacionViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.ExcepcionPenalizacion dbobj = new Entidades.ExcepcionPenalizacion()
                {
                    numerocontrato = vmmodel.NumeroContrato,
                    participanteorigen_id = vmmodel.IdAsesorClaveOrigenSeleccionado,
                    participantedestino_id = vmmodel.IdAsesorClaveDestinoSeleccionado,
                    aplica = vmmodel.IdAplicaSeleccionado,
                    modelo_id = vmmodel.IdModelo,
                    activo = true
                };

                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarExcepcionPenalizacion(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Penalización agregada correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel);
            }
            return RedirectToAction("ExcepcionPenalizacion", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [HttpPost, Authorize]
        public ActionResult EditarPenalizacion(ExcepcionesPenalizacionViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.ExcepcionPenalizacion dbobj = new Entidades.ExcepcionPenalizacion()
                {
                    numerocontrato = vmmodel.NumeroContrato,
                    participanteorigen_id = vmmodel.IdAsesorClaveOrigenSeleccionado,
                    participantedestino_id = vmmodel.IdAsesorClaveDestinoSeleccionado,
                    aplica = vmmodel.IdAplicaSeleccionado,
                    modelo_id = vmmodel.IdModelo,
                    id = vmmodel.Id
                };

                if (vmmodel.IdAsesorClaveOrigenSeleccionado.HasValue)
                {
                    dbobj.participanteorigen_id = vmmodel.IdAsesorClaveOrigenSeleccionado.Value;
                }
                if (vmmodel.IdAsesorClaveDestinoSeleccionado.HasValue)
                {
                    dbobj.participantedestino_id = vmmodel.IdAsesorClaveDestinoSeleccionado.Value;
                }

                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarExcepcionPenalizacion(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Penalización modificada correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel,true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel, true);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel, true);
            }
            return RedirectToAction("ExcepcionPenalizacion", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [Authorize]
        public ActionResult EliminarExcepcionPenalizacion(int penalizacionId, int modeloId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res
                    = _svcModelClient.EliminarExcepcionPenalizacion(new Entidades.ExcepcionPenalizacion()
                    {
                        id = penalizacionId,
                        modelo_id = modeloId
                    }, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Penalización eliminada correctamente";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("ExcepcionPenalizacion", new { area = "Comisiones", id = modeloId });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerPenalizacionXId(int penalizacionId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            Entidades.ExcepcionPenalizacion dbobj = _svcModelClient.ObtenerExcepcionPenalizacionXId(penalizacionId);
            result.Data = new
            {
                numerocontrato = dbobj.numerocontrato,
                asesororigen_id = dbobj.participanteorigen_id,
                asesordestino_id = dbobj.participantedestino_id,
                aplica_id = dbobj.aplica,
                modelo_id = dbobj.modelo_id,
                id = dbobj.id,
                asesorOrigen = String.Format("{0} {1} / {2}",
                            dbobj.Participante.nombre.Trim(),
                            dbobj.Participante.apellidos.Trim(),
                            dbobj.Participante.clave.Trim()),
                asesorDestino = String.Format("{0} {1} / {2}",
                            dbobj.Participante1.nombre.Trim(),
                            dbobj.Participante1.apellidos.Trim(),
                            dbobj.Participante1.clave.Trim())
            };
            return result;
        }

        public ActionResult CambiarEstadoExcepcionPenalizacion(int id, int modeloId)
        {
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.CambiarEstadoExcepcionPenalizacion(id, modeloId, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Estado excepción cambiado correctamente";
                }
                else
                {
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    TempData["ErrorMessage"] = res.MensajeError;
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("ExcepcionPenalizacion", new { area = "Comisiones", id = modeloId });
        }

        #endregion

        #region Excepcion Fija/Variable

        [Authorize]
        public ActionResult ExcepcionFijaVariable(int id)
        {
            ExcepcionesFijaVariableViewModel vwmodel = new ExcepcionesFijaVariableViewModel()
            {
                IdModelo = id
            };
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vwmodel.SetViewModel(dbmodel);
            vwmodel.DescripcionModelo = dbmodel.descripcion;
            vwmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            vwmodel.ExcepcionesPor.Insert(0, new SelectListItem() { Text = "Seleccionar", Value = "" });

            vwmodel.ExcepcionesFijaVariableModeloComision
                .AddRange(_svcModelClient.ListarExcepcionesFijaVariableXModeloComision(vwmodel.IdModelo)
                .Select(c => new ExcepcionFijaVariableViewModel()
                {
                    Id = c.id,
                    ModeloId = c.modelo_id,
                    NumeroContrato = c.numerocontrato,
                    TipoExcepcionId = c.tipoexcepcionfijavariable_id,
                    AsesorClaveId = c.participante_id,
                    AsesorClave = String.Format("{0} {1} / {2}", c.Participante.nombre.Trim(), c.Participante.apellidos.Trim(), c.Participante.clave.Trim()),
                    PorcentajeComision = c.porcentajecomision,
                    FechaInicioVigencia = c.fechavigencia,
                    FechaFinVigencia = c.fechafinvigencia,
                    TipoExcepcion = c.tipoexcepcionfijavariable_id == 3 ? "Bloqueo Pago" :c.tipoexcepcionfijavariable_id == 1 ? "Comisión total" : "Comisión fija",
                    ExcepcionPor = c.excepcionpor.Value,
                    DescripcionExcepcionPor = c.excepcionpor.Value == 5 ? "Bloqueo Pago Comisión":c.excepcionpor.Value == 4 ? "Por Clave" :c.excepcionpor.Value == 1 ? "Grupo Asociativo" : c.excepcionpor.Value == 2 ? "Contrato" : "Subcontrato",
                    Activo = !c.activo.HasValue ? false : c.activo.Value
                }));

            return View(vwmodel);
        }

        [HttpPost, Authorize]
        public ActionResult AgregarExcepcionFijaVariable(ExcepcionesFijaVariableViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.ExcepcionFijaVariable dbobj = new Entidades.ExcepcionFijaVariable()
                {
                    numerocontrato = vmmodel.NumeroContrato.ToString(),
                    tipoexcepcionfijavariable_id = vmmodel.IdTipoExcepcionSeleccionado,
                    participante_id = vmmodel.IdAsesorClaveSeleccionado,
                    porcentajecomision = vmmodel.PorcentajeComision,
                    fechafinvigencia = vmmodel.FechaFinVigenciaExcepcion,
                    fechavigencia = vmmodel.FechaInicioVigenciaExcepcion,
                    excepcionpor = vmmodel.IdExcepcionPor,
                    modelo_id = vmmodel.IdModelo,
                    activo = true
                };
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarExcepcionFijaVariable(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Excepción agregada correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel);
            }
            return RedirectToAction("ExcepcionFijaVariable", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [HttpPost, Authorize]
        public ActionResult EditarExcepcionFijaVariable(ExcepcionesFijaVariableViewModel vmmodel)
        {

            if (vmmodel.ParticipanteSeleccionado == null)
            {
                foreach (var key in ModelState.Keys) ModelState[key].Errors.Clear();
            }
            if (ModelState.IsValid)
            {
                Entidades.ExcepcionFijaVariable dbobj = new Entidades.ExcepcionFijaVariable()
                {
                    id = vmmodel.IdExcepcion.Value,
                    numerocontrato = vmmodel.NumeroContrato.ToString(),
                    tipoexcepcionfijavariable_id = vmmodel.IdTipoExcepcionSeleccionado,
                    participante_id = vmmodel.IdAsesorClaveSeleccionado,
                    porcentajecomision = vmmodel.PorcentajeComision,
                    fechafinvigencia = vmmodel.FechaFinVigenciaExcepcion,
                    fechavigencia = vmmodel.FechaInicioVigenciaExcepcion,
                    excepcionpor = vmmodel.IdExcepcionPor,
                    modelo_id = vmmodel.IdModelo
                };

                if (vmmodel.IdTipoExcepcionSeleccionado != 0)
                {
                    dbobj.tipoexcepcionfijavariable_id = vmmodel.IdTipoExcepcionSeleccionado;
                }
                if (vmmodel.IdAsesorClaveSeleccionado != 0)
                {
                    dbobj.participante_id = vmmodel.IdAsesorClaveSeleccionado;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarExcepcionFijaVariable(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Excepción modificada correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["currentAction"] = "/Comisiones/Excepciones/EditarExcepcionFijaVariable";
                        this.FormToTempData(vmmodel, true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    TempData["currentAction"] = "/Comisiones/Excepciones/EditarExcepcionFijaVariable";
                    this.FormToTempData(vmmodel, true);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                TempData["currentAction"] = "/Comisiones/Excepciones/EditarExcepcionFijaVariable";
                this.FormToTempData(vmmodel, true);
            }
            return RedirectToAction("ExcepcionFijaVariable", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [Authorize]
        public ActionResult EliminarExcepcionFijaVariable(int excepcionId, int modeloId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res
                    = _svcModelClient.EliminarExcepcionFijaVariable(new Entidades.ExcepcionFijaVariable()
                    {
                        id = excepcionId,
                        modelo_id = modeloId
                    }, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Excepción eliminada correctamente";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("ExcepcionFijaVariable", new { area = "Comisiones", id = modeloId });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerExcepcionFijaVariableXId(int excepcionFijaVariableId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            Entidades.ExcepcionFijaVariable dbobj = _svcModelClient.ObtenerExcepcionFijaVariableXId(excepcionFijaVariableId);
            result.Data = new
        {
            id = dbobj.id,
            numerocontrato = dbobj.numerocontrato,
            tipoexcepcion_id = dbobj.tipoexcepcionfijavariable_id,
            asesor_id = dbobj.participante_id,
            excepcionpor_id = dbobj.excepcionpor.Value,
            porcentajeexcepcion = dbobj.porcentajecomision,
            fechainiciovigencia = dbobj.fechavigencia,
            fechafinvigencia = dbobj.fechafinvigencia,
            participante = String.Format("{0} {1} / {2}",
                        dbobj.Participante.nombre.Trim(),
                        dbobj.Participante.apellidos.Trim(),
                        dbobj.Participante.clave.Trim())
        };
            return result;
        }

        public ActionResult CambiarEstadoExcepcionFV(int id, int modeloId)
        {
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.CambiarEstadoExcepcionFijaVariable(id, modeloId, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Estado excepción cambiado correctamente";
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
            return RedirectToAction("ExcepcionFijaVariable", new { area = "Comisiones", id = modeloId });
        }

        private void FormToTempData(ExcepcionesFijaVariableViewModel vmmodel, bool editing = false)
        {
            TempData["IdModelo"] = vmmodel.IdModelo.ToString();
            TempData["IdExcepcion"] = vmmodel.IdExcepcion.ToString();
            TempData["IdTipoExcepcionSeleccionado"] = vmmodel.IdTipoExcepcionSeleccionado.ToString();
            TempData["IdExcepcionPor"] = vmmodel.IdExcepcionPor.ToString();
            TempData["NumeroContrato"] = vmmodel.NumeroContrato.ToString();
            TempData["IdAsesorClaveSeleccionado"] = vmmodel.IdAsesorClaveSeleccionado.ToString();

            //Se valida que no venga nulo el nombre del participante 17.12.2018 caam
            if (vmmodel.ParticipanteSeleccionado != null)
            {
                TempData["ParticipanteSeleccionado"] = vmmodel.ParticipanteSeleccionado.ToString();
            }
            else
            {
                TempData["ParticipanteSeleccionado"] = "";
            }
            TempData["PorcentajeComision"] = vmmodel.PorcentajeComision.ToString();
            DateTime d1 = new DateTime(1970, 1, 1);
            DateTime d2 = vmmodel.FechaFinVigenciaExcepcion.ToUniversalTime();
            TimeSpan ts = new TimeSpan(d2.Ticks - d1.Ticks);
            TempData["FechaFinVigencia"] = Math.Round(ts.TotalMilliseconds, 0);
            d2 = vmmodel.FechaInicioVigenciaExcepcion.ToUniversalTime();
            ts = new TimeSpan(d2.Ticks - d1.Ticks);
            TempData["FechaInicioVigencia"] = Math.Round(ts.TotalMilliseconds, 0);
            if (editing)
            {
                TempData["editing"] = true;
            }
        }

        private void FormToTempData(ExcepcionesPenalizacionViewModel vmmodel, bool editing = false)
        {
            TempData["IdModelo"] = vmmodel.IdModelo.ToString();
            TempData["Id"] = vmmodel.Id.ToString();
            TempData["IdAplicaSeleccionado"] = vmmodel.IdAplicaSeleccionado.ToString();
            TempData["IdAsesorClaveOrigenSeleccionado"] = vmmodel.IdAsesorClaveOrigenSeleccionado.ToString();
            TempData["AsesorClaveOrigenSeleccionado"] = vmmodel.AsesorClaveOrigenSeleccionado.ToString();
            TempData["IdAsesorClaveDestinoSeleccionado"] = vmmodel.IdAsesorClaveDestinoSeleccionado.ToString();
            TempData["AsesorClaveDestinoSeleccionado"] = vmmodel.AsesorClaveDestinoSeleccionado.ToString();
            TempData["NumeroContrato"] = vmmodel.NumeroContrato.ToString();
            if (editing)
            {
                TempData["editing"] = true;
            }
        }

        [Authorize]
        public ActionResult CargueExcepcionFijaVariable(int ID)
        {
            ViewBag.Errores = false;
            ViewBag.Id = ID;
            return View(ViewBag);
        }

        [HttpPost, Authorize]
        public ActionResult CargueExcepcionFijaVariable(HttpPostedFileBase uploadFile,int modelo)
        {
            @ViewBag.Id = modelo;
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            DataSet ds = new DataSet();
            string Errores = string.Empty;
            if (Request.Files["uploadFile"].ContentLength > 0)
            {
                string fileExtension = System.IO.Path.GetExtension(Request.Files["uploadFile"].FileName);
                string fileLocation = Server.MapPath("~/App_Data/") + System.IO.Path.GetFileName(Request.Files["uploadFile"].FileName);

                int conteo = 1;
                while (System.IO.File.Exists(fileLocation))
                {
                    fileLocation = Server.MapPath("~/App_Data/") + System.IO.Path.GetFileNameWithoutExtension(Request.Files["uploadFile"].FileName) + conteo.ToString() + fileExtension;
                    conteo++;
                }
                Request.Files["uploadFile"].SaveAs(fileLocation);

                string excelConnectionString = string.Empty;

                excelConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"", fileLocation);

                if (fileExtension == ".xls")
                {
                    excelConnectionString = string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0};Extended Properties=\"Excel 8.0;HDR=Yes;IMEX=2\"", fileLocation);
                }
                else if (fileExtension == ".xlsx")
                {
                    excelConnectionString = string.Format("Provider=Microsoft.ACE.OLEDB.12.0;Data Source={0};Extended Properties=\"Excel 12.0;HDR=Yes;IMEX=2\"", fileLocation);
                }

                OleDbConnection excelConnection = new OleDbConnection(excelConnectionString);
                excelConnection.Open();
                DataTable dt = new DataTable();

                dt = excelConnection.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, null);
                if (dt == null)
                {
                    return null;
                }

                String[] excelSheets = new String[dt.Rows.Count];
                int t = 0;
                foreach (DataRow row in dt.Rows)
                {
                    excelSheets[t] = row["TABLE_NAME"].ToString();
                    t++;
                }
                OleDbConnection excelConnection1 = new OleDbConnection(excelConnectionString);


                string query = string.Format("Select * from [{0}]", excelSheets[0]);
                using (OleDbDataAdapter dataAdapter = new OleDbDataAdapter(query, excelConnection1))
                {
                    dataAdapter.Fill(ds);
                }
                List<Negocio.Componentes.Comision.ResultadoOperacionBD> lResultados = new List<Negocio.Componentes.Comision.ResultadoOperacionBD>();

                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                if (ds.Tables.Count >= 1)
                {
                    ds.Tables[0].Columns.Add("ERROR");
                    lResultados = _svcModelClient.CargarExcepcionesMasivo(out Errores, ds.Tables[0], Username, modelo).ToList();
                }
                else
                    lResultados = _svcModelClient.CargarExcepcionesMasivo(out Errores, new DataTable(), Username,modelo).ToList();

                foreach (Negocio.Componentes.Comision.ResultadoOperacionBD item in lResultados)
                {
                    if (item.MensajeError.Contains("Registro Totales"))
                    {
                        ViewBag.TitleTotales = item.MensajeError;
                        ViewBag.CantTotales = item.RegistrosAfectados;
                    }
                    if (item.MensajeError.Contains("Registro Procesados"))
                    {
                        ViewBag.TitleResultadosProcesados = item.MensajeError;
                        ViewBag.CantResultadosProcesados = item.RegistrosAfectados;
                    }
                    if (item.MensajeError.Contains("Registro No Procesados"))
                    {
                        ViewBag.TitleResultadosFallidos = item.MensajeError;
                        ViewBag.CantResultadosFallidos = item.RegistrosAfectados;
                    }

                }
                if (!string.IsNullOrEmpty(Errores))
                {
                    ViewBag.Errores = true;
                    if (System.IO.File.Exists(string.Format("{0}{1}", Server.MapPath("~/App_Data/"), "Errores.csv")))
                    {
                        System.IO.File.Delete(string.Format("{0}{1}", Server.MapPath("~/App_Data/"), "Errores.csv"));
                    }
                    System.IO.File.WriteAllText(string.Format("{0}{1}", Server.MapPath("~/App_Data/"), "Errores.csv"), Errores);
                }
                else
                {
                    ViewBag.Errores = false;
                }
                excelConnection.Close();
                System.IO.File.Delete(fileLocation);
            }
            
            return View(ViewBag);
        }

        public FileResult DescargarPrueba()
        {
            string fileLocation = Server.MapPath("~/App_Data/") + "Formato de carga masiva de excepciones a la comision.xlsx";
            return File(fileLocation, "application/vnd.ms-excel", "Formato de carga masiva de excepciones a la comision.xlsx");
        }

        public FileResult DescargarErrores()
        {
            string fileLocation = Server.MapPath("~/App_Data/") + "Errores.csv";
            return File(fileLocation, "application/vnd.ms-excel", "Errores.csv");
        }

        #endregion

    }
}
