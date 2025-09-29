/*  <copyright file="PresupuestoController.cs" company="Avantis">
        COPYRIGHT(C), 2011, Avantis S.A.
    </copyright>
    <author>Frank Payares</author>
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Globalization;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using LinqToExcel;
using System.IO;
using System.Web.UI;
using System.Collections;
using System.Data;
using ColpatriaSAI.UI.MVC.Comun;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    /// <summary>Gestiona cargue de presupuestos</summary>
    public class PresupuestoController : ControladorBase
    {
        WebPage web = new WebPage();
        string rutaArchivos = System.Configuration.ConfigurationManager.AppSettings["RutaArchivos"] + "Presupuesto\\";
        int pagina = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["pagina"]);

        public ActionResult Index()
        {
            return View();
        }

        /// <summary> Obtiene los presupuestos cargados en el sistema </summary>
        /// <returns>Lista de Presupuestos</returns>
        public ActionResult Presupuestos()
        {
            List<Presupuesto> presupuesto = web.AdministracionClient.ListarPresupuestos();

            return View(presupuesto);
        }

        /// <summary> Obtiene los presupuestos cargados en el sistema </summary>
        /// <returns>Lista de Presupuestos</returns>
        public ActionResult Detalle()
        {
            int idPresupuesto = Convert.ToInt32(RouteData.Values["id"]);
            Presupuesto presupuesto = web.AdministracionClient.ListarPresupuestos().Where(p => p.id == idPresupuesto).First();

            var metasList = (from metas in web.AdministracionClient.ListarMetas().ToList()
                             select new
                                {
                                    id = metas.id,
                                    nombre = metas.nombre + " - ID: " + metas.id
                                }
                            );

            ViewData["MetasList"] = new SelectList(metasList, "id", "nombre", 0);

            var CanalList = web.AdministracionClient.ListarCanals().ToList();
            ViewData["CanalList"] = new SelectList(CanalList, "id", "nombre", 0);

            return View(presupuesto);
        }

        /// <summary> Obtiene los presupuestos cargados en el sistema </summary>
        /// <returns>Lista de Presupuestos</returns>
        public ActionResult Carge()
        {
            List<Presupuesto> presupuesto = web.AdministracionClient.ListarPresupuestos();
            int segmentoUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.Segmentos = new SelectList(web.AdministracionClient.ListarSegmentoes().OrderBy(s => s.nombre), "id", "nombre", segmentoUsuario);

            return View(presupuesto);
        }

        /// <summary> Sube el archivo de Excel seleccionado e inicia la carga de los presupuestos </summary>
        /// <param name="file">Archivo seleccionado</param>
        /// <returns>Cargue de pagina</returns>
        [HttpPost]
        public ActionResult Carge(HttpPostedFileBase file)
        {
            try
            {
                string username = HttpContext.Session["userName"].ToString();
                if (file.ContentLength > 0)
                {
                    string nombreArchivo = "Presupuestos_" + DateTime.Now.ToShortDateString().Replace('/', '-') + " " + DateTime.Now.Hour + " " + DateTime.Now.Minute + ".xlsx";
                    string anio = Request.QueryString["anio"];
                    int segmento_id = Convert.ToInt32(Request.QueryString["segmento_id"]);
                    bool exito = Utilidades.subirArchivoFtp(rutaArchivos, nombreArchivo, file);
                    if (exito)
                    {
                        web.AdministracionClient.BorrarPresupuestoACargar(Convert.ToInt32(anio), segmento_id, username);
                        web.AdministracionClient.CarguePresupuesto(nombreArchivo, anio, segmento_id, username);
                    }
                    else
                        TempData["Mensaje"] = "error|Error: " + "El archivo seleccionado no ha podido ser almacenado";
                }
            }
            catch { }
            return RedirectToAction("Carge");
        }

        /// <summary>Valida información relevante proveniente del archivo de presupuestos</summary>
        /// <param name="pres">Objeto PresupuestoDetalles que contiene los datos a validar</param>
        /// <param name="companias">Lista de companias</param>
        /// <param name="metas">Lista de metas</param>
        /// <param name="documentos">Lista de documentos</param>
        /// <returns>True si el presupuesto es válido, de lo contrario retorna False</returns>
        public bool validarPresupuesto(List<string> pres, List<string> metas, List<string> codsNivel)
        {
            if (pres[2] != "" && pres[4] != "")
            {
                string meta = metas.Find(delegate(string m) { return m == pres[2]; });
                if (meta == null) return false;

                string codnivel = codsNivel.Find(delegate(string c) { return c == pres[4]; });
                if (codnivel == null) return false;

                return true;
            }
            else return false;
        }

        public string getRutaArchivoLog()
        {
            string[] txt = new FileInfo(Directory.GetFiles(rutaArchivos, "*.txt").First()).FullName.Replace('\\', '/').Split('/');
            return '/' + txt[txt.Length - 3] + '/' + txt[txt.Length - 2] + '/' + txt[txt.Length - 1];
        }

        /// <summary>Valida la estructura del archivo comprobando si todos los presupuestos son nulos</summary>
        /// <param name="detalle">Lista de PresupuestoDetalles leidos</param>
        /// <returns>True si la estructura del archivo es válido, de lo contrario retorna False</returns>
        public bool validarIntegridad(List<PresupuestoDetalles> detalle)
        {
            List<int> invalidos = new List<int>();
            foreach (var item in detalle)
            {
                if (item.Codigo_meta == null) invalidos.Add(0);
            }
            if (invalidos.Count == detalle.Count) return false; else return true;
        }

        public JsonResult CalcularMetas()
        {
            String messagge = string.Empty;
            Boolean success = false;
            int idPresupuesto = Convert.ToInt32(Request["idPresupuesto"]);
            //try {
            web.AdministracionClient.CalcularMetasCompuestas(idPresupuesto);
            web.AdministracionClient.CalcularMetasAcumuladas(idPresupuesto);
            web.AdministracionClient.CalcularEjecucionPresupuesto(idPresupuesto);
            messagge = "Calculo del presupuesto terminado con éxito.";
            success = true;
            //}
            //catch { messagge = "error|No se pudo completar el proceso. Intente de nuevo!"; success = false; }

            return Json(new { Success = success, Messagge = messagge });
        }

        /// <summary>Descarga archivo de Excel con formato y convenciones de Compañias y Metas para cargar presupuestos</summary>
        /// <param name="tipo">Tipo de archivo</param>
        /// <returns>Archivo físico del formato de cargue de presupuestos</returns>
        public ActionResult Descargar(int tipo)
        {
            var Ds = new DataSet();
            if (tipo == 1)
            {
                var Dt = new DataTable("1.Formato_Cargue");
                Dt.Columns.AddRange(new DataColumn[] { new DataColumn("Nombre_Nodo"), new DataColumn("CodNivel"), new DataColumn("Nombre_participante"), 
                    new DataColumn("Codigo_meta"), new DataColumn("Año"), new DataColumn("Enero"), new DataColumn("Febrero"), new DataColumn("Marzo"), 
                    new DataColumn("Abril"), new DataColumn("Mayo"), new DataColumn("Junio"), new DataColumn("Julio"), new DataColumn("Agosto"), 
                    new DataColumn("Septiembre"), new DataColumn("Octubre"), new DataColumn("Noviembre"), new DataColumn("Diciembre")
                });
                Ds.Tables.Add(Dt);

                var Dt1 = new DataTable("2.Metas");
                Dt1.Columns.AddRange(new DataColumn[] { new DataColumn("Codigo_meta"), new DataColumn("Nombre_Meta") });
                foreach (var meta in web.AdministracionClient.ListarMetas().Where(m => m.tipoMetaCalculo_id != 2)) Dt1.Rows.Add(meta.id, meta.nombre.Trim());
                Ds.Tables.Add(Dt1);

                var Dt2 = new DataTable("3.Jerarquía Comercial");
                Dt2.Columns.AddRange(new DataColumn[] { new DataColumn("Nombre_Nodo"), new DataColumn("Codigo de Nivel") });
                foreach (var jerarquias in web.AdministracionClient.ListarJerarquiaDetalle().Where(j => j.id > 0 && j.nivel_id > 1))
                    Dt2.Rows.Add(jerarquias.nombre, jerarquias.codigoNivel);
                Ds.Tables.Add(Dt2);

                return Exportar.Excel(Ds, "Formato cargue de Presupuestos.xlsx", Request, Response);
            }
            else return Json("", 0);
        }

        public JsonResult Asincrono()
        {
            var id = Request["idPresupuesto"];
            Dictionary<string, object> parametros = new Dictionary<string, object>();
            parametros.Add("PresupuestoId", id);
            ETLRemota etlRemota = ETL.ObtenerETLRemotaporId(12);
            ETL.EjecutarETL(etlRemota, parametros, Sesion.VariablesSesion());

            return Json(new { Success = true });
        }
    }
}