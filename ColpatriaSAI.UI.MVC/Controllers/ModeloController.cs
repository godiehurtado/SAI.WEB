/*  <copyright file="ModeloController.cs" company="Avantis">
        COPYRIGHT(C), 2011, Avantis S.A.
    </copyright>
    <author>Frank Payares</author>
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.IO;
using System.Data;
using LinqToExcel;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ModeloController : ControladorBase
    {

        WebPage web = new WebPage();
        string mensajeLog = string.Empty;
        string rutaArchivos = System.Configuration.ConfigurationManager.AppSettings["RutaArchivos"] + "Contratacion\\";
        int pagina = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["pagina"]);
        string urlSite = System.Configuration.ConfigurationManager.AppSettings["URLSite"];

        #region Aciones de MODELOS y MODELO X META

        public ActionResult Index(string mensajeLog)
        {
            ViewData["pathArchivoFormato"] = urlSite + "CargueSAI/FormatosCarga/FormatoCargaParticipantes.xlsx";

            ViewData["Mensaje"] = Session["mensajeLog"];

            Session["mensajeLog"] = string.Empty;

            return View(web.AdministracionClient.ListarModelos());
        }

        /// <summary>
        /// Inicia el proceso de cargue de modelos de contatación
        /// </summary>
        /// <param name="archivo">Ruta completa del archivo cliente</param>
        /// <returns>Re</returns>
        public ActionResult Cargue(HttpPostedFileBase archivo)
        {
            Comun.Utilidades.setCarpetaCarge("*.xls*", rutaArchivos);
            ActionResult resultado = View();
            try
            {
                if (archivo.ContentLength > 0)
                {
                    DateTime horaIni = DateTime.Now;

                    string nombreArchivo = "Modelos_" + DateTime.Now.ToShortDateString().Replace('/', '-') + " " + DateTime.Now.Hour + " " + DateTime.Now.Minute + ".xlsx";
                    var rutaLocal = Path.Combine(rutaArchivos, nombreArchivo);
                    archivo.SaveAs(rutaLocal);
                    resultado = CargarModelos(rutaLocal);

                    DateTime horaFin = DateTime.Now; TimeSpan tiempo = horaFin.Subtract(horaIni);
                    TempData["Tiempo"] = tiempo.Hours.ToString().PadLeft(2, '0') + ":" + tiempo.Minutes.ToString().PadLeft(2, '0') + ":" + tiempo.Seconds.ToString().PadLeft(2, '0');
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        /// <summary>
        /// Ejecuta el proceso de cargue de los modelos de contratación del archivo especificado
        /// </summary>
        /// <param name="nombreArchivo"></param>
        /// <returns></returns>
        public ActionResult CargarModelos(string rutaLocalArchivo)
        {
            List<ModelosContratacion> temp = new List<ModelosContratacion>(), temp1 = new List<ModelosContratacion>();
            List<string> hojas = new List<string>();
            int ultimaHoja = 0, paginado = 0, conteo = 0, cod1 = 0, cod2 = 0; List<int> codigosModelo = new List<int>();

            var excel = new LinqToExcel.ExcelQueryFactory(rutaLocalArchivo);
            excel.StrictMapping = false;

            try { hojas = excel.GetWorksheetNames().ToList<string>(); }
            catch (Exception ex) { TempData["Mensaje"] = "error|Error: " + ex.Message; return Json(generarLog(null), 0); }

            try
            {
                // Adiciona todos los elementos de las hojas del excel a una lista
                foreach (var hoja in hojas) temp.AddRange((from pre in excel.Worksheet<ModelosContratacion>(hoja) select pre).ToList());

                // Guarda en una lista los modelos cuyos pesos sumen mayor a 100
                var pesos = (from t in temp
                             group t by t.CodModelo into mxn
                             where Math.Round(mxn.Sum(s => s.Peso), 0) > 100
                             select new ModelosContratacion { CodModelo = mxn.Key }).ToList();

                // Quita de la lista 'temp' los modelos cuyos pesos sumen mayor a 100
                foreach (var item in pesos) temp.RemoveAll(t => t.CodModelo == item.CodModelo);

                // Elimina de la BD los pesos de los modelos que si de deben cargar
                foreach (var item in temp)
                {
                    cod1 = Convert.ToInt32(item.CodModelo);
                    if (cod1 != 0) if (cod1 != cod2) codigosModelo.Add(cod1);
                    cod2 = cod1;
                }
                web.AdministracionClient.EliminarModeloxMetaPorModelos(codigosModelo, HttpContext.Session["userName"].ToString());

                // Carga los elementos reales
                while (paginado <= temp.Count)
                {
                    temp1 = temp.Where(t => t.CodModelo != null).Skip(paginado).Take(pagina).ToList();
                    if (temp1.Count > 0)
                    {
                        web.AdministracionClient.CargarModeloxMeta(temp1, ultimaHoja);
                    }
                    paginado += pagina;
                    conteo++;
                }
            }
            catch { TempData["Mensaje"] = "error|Error en el proceso de cargue. Intente de nuevo!"; Json("", 0); }
            return Json(generarLog(conteo), 0);
        }

        /// <summary>Genera el log de errores de los presupuestos inválidos</summary>
        /// <param name="total">Número de presupuestos leidos</param>
        /// <returns>Número de presupuestos inválidos y URL del log de errores</returns>
        public string generarLog(int? total)
        {
            /*List<LogPresupuesto> logDetalles = web.AdministracionClient.ListarLogPresupuesto();
            TempData["Leidos"] = total;
            TempData["Cargados"] = total - logDetalles.Count;
            TempData["Invalidos"] = logDetalles.Count;
            if (logDetalles.Count > 0) TempData["Log"] = "/Presupuesto/Descargar/?tipo=2";

            if (total > logDetalles.Count) {
                TempData["Mensaje"] = "info|Presupuesto cargado!";
            } else {
                TempData["Mensaje"] = "error|No se cargó ningún presupuesto!";
            }*/
            TempData["Mensaje"] = "info|Proceso completado!";
            return "";
        }


        /// <summary>Descarga archivo de Excel con formato y convenciones del formato</summary>
        /// <returns>Archivo físico del formato de cargue de presupuestos</returns>
        public ActionResult Descargar()
        {
            var Ds = new DataSet();

            var Dt = new DataTable("1.Formato_Cargue");
            Dt.Columns.AddRange(new DataColumn[] { new DataColumn("CodModelo"), new DataColumn("CodMeta"), new DataColumn("NombreMeta"), new DataColumn("Peso"), new DataColumn("CodEscala") });
            Ds.Tables.Add(Dt);

            Dt = new DataTable("2.Modelos");
            Dt.Columns.AddRange(new DataColumn[] { new DataColumn("CodModelo"), new DataColumn("NombreModelo") });
            foreach (var modelo in web.AdministracionClient.ListarModelos()) Dt.Rows.Add(modelo.id, modelo.descripcion.Trim());
            Ds.Tables.Add(Dt);

            Dt = new DataTable("3.Metas");
            Dt.Columns.AddRange(new DataColumn[] { new DataColumn("CodMeta"), new DataColumn("NombreMeta") });
            foreach (var meta in web.AdministracionClient.ListarMetas()) Dt.Rows.Add(meta.id, meta.nombre.Trim());
            Ds.Tables.Add(Dt);

            Dt = new DataTable("4.Escalas Notas");
            Dt.Columns.AddRange(new DataColumn[] { new DataColumn("CodEscala"), new DataColumn("NombreEscala") });
            foreach (var escalas in web.AdministracionClient.ListarFactorxNotas().Where(e => e.tipoescala_id == 2)) Dt.Rows.Add(escalas.id, escalas.nombre);
            Ds.Tables.Add(Dt);

            return Exportar.Excel(Ds, "Formato cargue de Modelos de Contratación.xlsx", Request, Response);
        }

        /// <summary>Inicializa el formaulario de creación de modelos</summary>
        /// <param name="id">Id del modelo (0 para crear un modelo, 1 para editarlo)</param>
        /// <returns>Resultado de la inicialización</returns>
        public ActionResult Crear(int id)
        {
            var factorxNotas = web.AdministracionClient.ListarFactorxNotas().ToList();
            Modelo modelo = new Modelo();
            modelo.ModeloxMetas.Add(new ModeloxMeta() { Meta = new Meta() });

            ViewData["Modelo"] = modelo;
            ViewData["ModelosXMetas"] = new ModeloXMetaViewModel()
            {
                ModeloxMetaView = new ModeloxMeta(),
                MetaList = new SelectList(web.AdministracionClient.ListarMetas().OrderBy(m => m.nombre), "id", "nombre"),
                FactorList = new SelectList(factorxNotas.OrderBy(f => f.nombre), "id", "nombre")
            };
            int? factor = 0;
            if (id != 0)
            {
                Modelo model = web.AdministracionClient.ListarModelosPorId(id)[0];
                factor = model.factorxnota_id;
                modelo.descripcion = web.AdministracionClient.ListarModelosPorId(id)[0].descripcion;
            }
            ViewBag.Factor = new SelectList(factorxNotas.Where(f => f.tipoescala_id == 1).OrderBy(f => f.nombre), "id", "nombre", factor);
            return View();
        }

        /// <summary>Crea un nodelo nuevo</summary>
        /// <param name="collection">Información del modelo a insertar</param>
        /// <returns>Lista de metas asociadas al modelo</returns>
        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            Modelo modelo = new Modelo()
            {
                id = Convert.ToInt32(collection[1]),
                descripcion = collection[0]
            };
            int idModelo = web.AdministracionClient.InsertarModelo(modelo, HttpContext.Session["userName"].ToString());
            var modeloxMeta = web.AdministracionClient.ListarModelosxMetaPorIdModelo(idModelo);
            if (modeloxMeta.Count() == 0) modeloxMeta = new List<ModeloxMeta> { new ModeloxMeta() { Meta = new Meta(), peso = 0, id = 0, modelo_id = idModelo } };

            int? factor = (idModelo != 0 ? web.AdministracionClient.ListarModelosPorId(idModelo)[0].factorxnota_id : 0);
            ViewBag.Factor = new SelectList(web.AdministracionClient.ListarFactorxNotas(), "id", "nombre", factor);

            return Json(modeloxMeta
                .Select(m => new { m.meta_id, m.Meta.nombre, m.peso, m.id, m.modelo_id, factorxNota = (m.FactorxNota != null ? m.FactorxNota.nombre : "") }), 0);
        }

        /// <summary>Asocia una meta con el modelo creado/consultado</summary>
        /// <param name="collection">Información de la asociación a ingresar</param>
        /// <returns>Detalle de la asociación ingresada</returns>
        [HttpPost]
        public ActionResult CrearDetalle(FormCollection collection)
        {
            try
            {
                double? peso = Convert.ToDouble(Request["peso"].Replace('.', ','));
                ModeloxMeta modeloxMeta = new ModeloxMeta()
                {
                    meta_id = Convert.ToInt32(Request["meta_id"]),
                    peso = peso,
                    factorxnota_id = Convert.ToInt32(Request["id_factorxnota"]),
                    modelo_id = Convert.ToInt32(Request["modelo_id"])
                };
                modeloxMeta.id = web.AdministracionClient.InsertarModeloxMeta(modeloxMeta, HttpContext.Session["userName"].ToString());

                var modeloXMetaTemp = web.AdministracionClient.ListarModelosxMetaPorIdModelo(Convert.ToInt32(modeloxMeta.modelo_id)).ToList().Where(m => m.id == modeloxMeta.id).FirstOrDefault();

                modeloxMeta.Meta = new Meta() { nombre = "meta" };

                return Json(new
                {
                    meta_id = modeloXMetaTemp.meta_id,
                    nombre = modeloXMetaTemp.Meta.nombre + "",
                    peso = modeloXMetaTemp.peso,
                    id = modeloXMetaTemp.id,
                    modelo_id = modeloXMetaTemp.modelo_id,
                    factorxNota = (modeloXMetaTemp.FactorxNota != null ? modeloXMetaTemp.FactorxNota.nombre : "")
                }, 0);
            }
            catch { }
            return null;
        }

        /// <summary>Asociar un factor al modelo seleccionado</summary>
        /// <param name="modelo">Id del modelo seleccionado</param>
        /// <param name="factor">Id del factor por nota seleccionado</param>
        /// <returns></returns>
        public ActionResult AsociarFactor(int modelo, int factor)
        {
            web.AdministracionClient.AsociarFactorToModelo(modelo, factor);
            return Json("", 0);
        }

        public ActionResult Editar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        /// <summary>Eliminar la asociación de una meta con un modelo</summary>
        /// <param name="id">Id de la asociación</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult EliminarModeloxMeta(int id)
        {
            string resultado = web.AdministracionClient.EliminarModeloxMeta(id, null, HttpContext.Session["userName"].ToString());
            Response.Write(resultado);
            return null;
        }
        #endregion

        #region Aciones de MODELO POR PARTICIPANTES y CANAL X MODELO

        /// <summary>Inicializa el modulo de gestión de detalles de un modelo</summary>
        /// <param name="id">Id del modelo</param>
        /// <returns>Resultado de la inicialización</returns>
        public ActionResult Participantes(int id)
        {
            ListarModeloxParticipantes(id);
            ListarCanalXModelos(id);
            return View();
        }

        public ActionResult Nodos()
        {
            ViewBag.Canales = new SelectList(web.AdministracionClient.ListarCanals().Select(l => new { l.nombre, l.id }), "id", "nombre");
            return View();
        }

        public ActionResult getNodos(string texto, int inicio, int cantidad, int nivel, int zona, int canal, string codNivel)
        {
            var nodos = web.AdministracionClient.ListarNodosBuscador(0, texto, inicio, cantidad, nivel, zona, canal, codNivel);
            return Json(nodos.Select(p => new
            {
                p.id,
                nombreNodo = p.nombre,
                nombreZona = p.Zona.nombre,
                nombreCanal = (p.Canal != null) ? p.Canal.nombre : "",
                p.codigoNivel,
                nombreNivel = p.Nivel.nombre
            }), 0);
        }

        /// <summary>Obtiene los participantes que pertenecen a un modelo</summary>
        /// <param name="id">Id del modelo</param>
        public void ListarModeloxParticipantes(int id)
        {
            Modelo modelo = web.AdministracionClient.ListarModelosPorId(id).ToList()[0];
            ViewData["ModelosXParticipantes"] = new ModeloxParticipanteViewModel()
            {
                NivelList = new SelectList(web.AdministracionClient.ListarNivels(), "id", "nombre"),
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas(), "id", "nombre"),
                //LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades(), "id", "nombre"),
                //ParticipanteList = new SelectList(web.AdministracionClient.ListarParticipantes(), "id", "nombre"),
                ModeloxParticipanteView = new ModeloxNodo() { Modelo = modelo }
            };
            ViewData["ModelosXParticipanteList"] = web.AdministracionClient.ListarModeloxParticipantesPorId(id);
        }

        /// <summary>Obtiene los canales asociados a un modelo</summary>
        /// <param name="id">Id del modelo</param>
        public void ListarCanalXModelos(int id)
        {
            //Canal canal = web.AdministracionClient.ListarCanalsPorId(id).ToList()[0];
            ViewData["CanalxModelos"] = new CanalxModeloViewModel()
            {
                CanalList = new SelectList(web.AdministracionClient.ListarCanals(), "id", "nombre")
                //CanalxModeloView = new CanalxModelo() { Canal = canal }
            };

        }

        public ActionResult getLocalidades(int idZona)
        {
            return Json(web.AdministracionClient.ListarLocalidadesPorZona(idZona).Select(l => new { l.nombre, l.id }), 0);
        }

        /// <summary>Asocia un participante a un modelo</summary>
        /// <param name="collection">Información de la asociación a ingresar</param>
        /// <returns>Objeto ModeloxParticipante ingresado</returns>
        public ActionResult CrearModeloxParticipante(FormCollection collection)
        {
            try
            {

                //VALIDAMOS SI HAY JERARQUIA PARA DEJAR OTROS CAMPOS EN 0
                if (collection["participante_id"] != "")
                {
                    collection["localidad_id"] = "";
                    collection["nivel_id"] = "";
                    collection["zona_id"] = "";
                }

                ModeloxNodo modeloPart = new ModeloxNodo()
                {
                    modelo_id = Convert.ToInt32((collection["modelo_id"] != "" ? collection["modelo_id"] : "0")),
                    nivel_id = Convert.ToInt32((collection["nivel_id"] != "" ? collection["nivel_id"] : "0")),
                    zona_id = Convert.ToInt32((collection["zona_id"] != "" ? collection["zona_id"] : "0")),
                    localidad_id = Convert.ToInt32((collection["localidad_id"] != "" ? collection["localidad_id"] : "0")),
                    jerarquiaDetalle_id = Convert.ToInt32((collection["participante_id"] != "" ? collection["participante_id"] : "0")),
                    fechaIni = Convert.ToDateTime((collection["fechaIni"] != "" ? collection["fechaIni"] : "0")),
                    fechaFin = Convert.ToDateTime((collection["fechaFin"] != "" ? collection["fechaFin"] : "0"))
                };
                modeloPart.id = web.AdministracionClient.InsertarModeloxParticipante(modeloPart, HttpContext.Session["userName"].ToString());
                return Json(modeloPart, JsonRequestBehavior.AllowGet);
            }
            catch { }
            return null;
        }

        public ActionResult EliminarModelo(int id)
        {
            return Json(web.AdministracionClient.EliminarModelo(id, null, HttpContext.Session["userName"].ToString()), 0);
        }

        /// <summary>Elimina la asociación de un participante con un modelo</summary>
        /// <param name="id">Id de la asociación</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult EliminarModeloPart(int id)
        {
            Response.Write(web.AdministracionClient.EliminarModeloxParticipante(id, null, HttpContext.Session["userName"].ToString()));
            return null;//Json(web.AdministracionClient.EliminarModeloxParticipante(id, null), 0);
        }


        [HttpPost]
        public ActionResult ProcesarCargueParticipantes(HttpPostedFileBase file)
        {
            if (file.ContentLength > 0)
            {
                string fechaCargue = DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();
                DateTime fechaCargueFinal = Convert.ToDateTime(fechaCargue);
                string msjError = string.Empty;

                string nombreArchivo = "Modelos_" + DateTime.Now.ToShortDateString().Replace('/', '-') + " " + DateTime.Now.Hour + " " + DateTime.Now.Minute + ".xlsx";
                var rutaLocal = Path.Combine(rutaArchivos, nombreArchivo);
                file.SaveAs(rutaLocal);

                int nodoId = 0; int nivelId = 0; int zonaId = 0; int localidadId = 0;
                List<CargaParticipantesModelo> temp = new List<CargaParticipantesModelo>();
                List<JerarquiaDetalle> jerarquiaDetalle = web.AdministracionClient.ListarJerarquiaDetalle().ToList();
                List<Nivel> listNivel = web.AdministracionClient.ListarNivels().ToList();
                List<Negocio.Entidades.Zona> listZona = web.AdministracionClient.ListarZonas().ToList();
                List<Localidad> listLocalidad = web.AdministracionClient.ListarLocalidades().ToList();
                List<Modelo> listModelos = web.AdministracionClient.ListarModelos().ToList();

                int registrosProcesados = 0; int registrosError = 0; int registro = 0; int registroHoja = 1;
                Boolean error = false;
                var excel = new ExcelQueryFactory(rutaArchivos + nombreArchivo);
                excel.StrictMapping = false;

                try
                {
                    List<string> hojasCargue = excel.GetWorksheetNames().ToList();

                    foreach (string hoja in hojasCargue)
                    {
                        if (!hoja.Contains("_xlnm"))
                        {

                            temp = (from pre in excel.Worksheet<CargaParticipantesModelo>(hoja) select pre).ToList();

                            registroHoja = 1;

                            foreach (CargaParticipantesModelo cargaParticipantes in temp)
                            {
                                error = false;
                                nodoId = 0;
                                nivelId = 0;
                                zonaId = 0;
                                localidadId = 0;

                                //VALIDAMOS FECHAS
                                if (cargaParticipantes.FechaFinal == DateTime.MinValue || cargaParticipantes.FechaInicial == DateTime.MinValue)
                                {
                                    msjError += "<br/>|Error 101: En Registro " + registroHoja + " Hoja: " + hoja;
                                    error = true;
                                }

                                //VALIDAMOS LOS MODELOS
                                var modeloTotal = listModelos.Where(x => x.id == cargaParticipantes.IdModelo).Count();
                                if (modeloTotal == 0)
                                {
                                    msjError += "<br/>|Error 102: En Registro " + registroHoja + " Hoja: " + hoja;
                                    error = true;
                                }

                                //VALIDAMOS SI EL CODIGO NIVEL EXISTE EN LA JERARQUIA
                                if (!string.IsNullOrEmpty(cargaParticipantes.CodigoNivel))
                                {
                                    var jerarquiaDetalleTotal = jerarquiaDetalle.Where(x => x.codigoNivel == cargaParticipantes.CodigoNivel).Count();
                                    if (jerarquiaDetalleTotal == 0)
                                    {
                                        msjError += "<br/>|Error 103: En Registro " + registroHoja + " Hoja: " + hoja;
                                        error = true;
                                    }
                                    else
                                    {
                                        nodoId = jerarquiaDetalle.Where(x => x.codigoNivel == cargaParticipantes.CodigoNivel).First().id;
                                    }
                                }
                                else
                                {
                                    if (!error)
                                    {
                                        //VALIDAMOS OTRA POSIBLE PARAMETRIZACION
                                        var nivelesTotal = listNivel.Where(x => x.id == cargaParticipantes.IdNivel).ToList().Count();
                                        if (nivelesTotal == 0)
                                        {
                                            msjError += "<br/>|Error 104: En Registro " + registroHoja + " Hoja: " + hoja;
                                            error = true;
                                        }
                                        else
                                            nivelId = cargaParticipantes.IdNivel;

                                        //VALIDAMOS OTRA POSIBLE PARAMETRIZACION
                                        var zonaTotal = listZona.Where(x => x.id == cargaParticipantes.IdZona).ToList().Count();
                                        if (zonaTotal == 0)
                                        {
                                            msjError += "<br/>|Error 105: En Registro " + registroHoja + " Hoja: " + hoja;
                                            error = true;
                                        }
                                        else
                                            zonaId = cargaParticipantes.IdZona;

                                        //VALIDAMOS OTRA POSIBLE PARAMETRIZACION
                                        var localidadTotal = listLocalidad.Where(x => x.id == cargaParticipantes.IdLocalidad).ToList().Count();
                                        if (localidadTotal == 0)
                                        {
                                            msjError += "<br/>|Error 106: En Registro " + registroHoja + " Hoja: " + hoja;
                                            error = true;
                                        }
                                        else
                                            localidadId = cargaParticipantes.IdLocalidad;
                                    }
                                }

                                if (!error)
                                {
                                    ModeloxNodo modeloPart = new ModeloxNodo()
                                    {
                                        modelo_id = cargaParticipantes.IdModelo,
                                        nivel_id = nivelId,
                                        zona_id = zonaId,
                                        localidad_id = localidadId,
                                        jerarquiaDetalle_id = nodoId,
                                        fechaIni = cargaParticipantes.FechaInicial,
                                        fechaFin = cargaParticipantes.FechaFinal
                                    };
                                    modeloPart.id = web.AdministracionClient.InsertarModeloxParticipante(modeloPart, HttpContext.Session["userName"].ToString());

                                    if (modeloPart.id != 0)
                                        registro++;
                                }
                                else
                                    registrosError++;

                                registrosProcesados++;
                                registroHoja++;

                            }
                        }
                    }

                }
                catch (Exception ex)
                {
                    registrosError++;
                    msjError += "<br/>|Error: " + ex.Message;
                }

                mensajeLog = "<br/>|Nodos Procesados: " + registrosProcesados;
                mensajeLog += "<br/>|Registros Insertados con éxito: " + registro;
                mensajeLog += "<br/>|Registros Procesados con error: " + registrosError;

                if (registrosError > 0)
                {
                    mensajeLog += "<br/>|Log de Errores: <br/>";
                    mensajeLog += "<b>|Error 101: Las fechas son obligatorias para la participación.<br/>";
                    mensajeLog += "|Error 102: El modelo no existe en la BD.<br/>";
                    mensajeLog += "|Error 103: El codigo nivel no existe en ninguna jerarquia.<br/>";
                    mensajeLog += "|Error 104: El nivel no existe en la BD.<br/>";
                    mensajeLog += "|Error 105: La zona no existe en la BD.<br/>";
                    mensajeLog += "|Error 106: La localidad no existe en la BD.<br/></b><hr/>";
                    mensajeLog += msjError;
                }
            }

            Session["mensajeLog"] = mensajeLog;
            return RedirectToAction("Index");
        }

        #endregion
    }
}
