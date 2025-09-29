using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Web.Mvc.Ajax;
using ColpatriaSAI.UI.MVC.Models;
using PagedList;
using System.Data;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class LiquidacionConcursoController : ControladorBase
    {

        WebPage web = new WebPage();

        enum estadoLiquidacion
        {
            Creada = 1,
            Pagada = 2,
            Anulada = 3
        }

        public ActionResult Index()
        {
            TempData["value"] = Request.QueryString["value"];
            TempData["valuec"] = Request.QueryString["value"];

            if (Request.QueryString["value"] != string.Empty)
                ViewBag.concurso_id = Request.QueryString["value"];

            ViewBag.cuentaParticipante = web.AdministracionClient.validarParticipantesxConcurso(Convert.ToInt32(TempData["value"]));

            if (ViewBag.cuentaParticipante == 0)
            {
                TempData["Mensaje"] = "error|" + Mensajes.CantidadParticipantesxConcurso; View(TempData["Mensaje"]);
            }

            ViewBag.concursos = web.AdministracionClient.ListarConcursoesPorId(Convert.ToInt32(ViewBag.concurso_id));
            ViewBag.reglas = web.AdministracionClient.ListarReglaPorConcursoId(Convert.ToInt32(ViewBag.concurso_id));
            return View(ViewBag);
        }

        [HttpPost]
        public ActionResult ReporteLiquidacionRegla(int idLiquidacion)
        {
            web.AdministracionClient.BeginGenerarReporteLiquidacionAsesor(idLiquidacion, null, 1);
            //web.AdministracionClient.GenerarReporteLiquidacionAsesorAsync(idLiquidacion);
            Boolean success = true;
            string messagge = "El proceso se realizó con éxito.";
            return Json(new { Success = success, Messagge = messagge });
        }

        [HttpPost]
        public ActionResult ReporteLiquidacion(int liquidacionReglaId)
        {
            DataTable reporte = (DataTable)web.AdministracionClient.GenerarReporteLiquidacionAsesor(liquidacionReglaId);
            List<object> colModels = new List<object>();
            List<string> nombres = new List<string>();

            foreach (DataColumn col in reporte.Columns)
            {
                nombres.Add(col.ColumnName);

                var obj = new
                {
                    name = col.ColumnName,
                    index = col.ColumnName,
                    width = 150,
                    hidden = false,
                    resizable = false,
                    sortable = true
                };
                colModels.Add(obj);
            }

            List<string> grid = new List<string>();

            foreach (DataRow row in reporte.Rows)
            {
                string algo = "{";

                foreach (DataColumn col in reporte.Columns)
                {
                    algo += "\"" + col.ColumnName + "\":\"" + row[col].ToString() + "\",";
                }

                algo = algo.Substring(0, algo.Length - 1) + "}";

                grid.Add(algo);
            }

            var data = new
            {
                error = false,
                namesCol = nombres.ToArray(),
                modelCol = colModels.ToArray(),
                grid = grid
            };

            return Json(data);
        }

        public ActionResult getLiquidacionesRegla(int id)
        {
            return Json(web.AdministracionClient.ListarLiquidaciones(id), 0);
        }

        [HttpPost]
        public ActionResult ReglasConcurso(int concurso_id)
        {
            return Json(web.AdministracionClient.ListarReglaPorConcursoId(concurso_id));
        }

        [HttpPost]
        public ActionResult LiquidarRegla(FormCollection collection)
        {
            ViewData["nombreRegla"] = web.AdministracionClient.ListarReglaPorId(Convert.ToInt32(collection["regla"])).First().nombre.ToString();
            ViewData["reglaId"] = collection["regla"];
            ViewBag.notificacion = "Proceso en curso: Liquidación de la regla " + ViewData["nombreRegla"] + ".";
            return View();
        }

        [HttpGet]
        public ActionResult LiquidarReglaSave()
        {
            Boolean success = true;
            string messagge = "El proceso se realizó con éxito.";
            DateTime fechaInicial = Convert.ToDateTime(Request["fechaInicial"]);
            DateTime fechaFinal = Convert.ToDateTime(Request["fechaFinal"]);
            int idRegla = Convert.ToInt32(Request["reglaId"]);

            //DateTime fechaInicial = Convert.ToDateTime(collection["periodoLiquidacionIni"]);
            //DateTime fechaFinal = Convert.ToDateTime(collection["periodoLiquidacionFin"]);
            //int idRegla = Convert.ToInt32(collection["reglaId"]);

            var regla = web.AdministracionClient.ListarReglaPorId(idRegla).First();

            /// Se llama de manera asincrona a la liquidación de la Regla
            //web.AdministracionClient.GenerarLiquidacionRegla_IniciarAsync(fechaInicial, fechaFinal, idRegla, Convert.ToInt32(regla.concurso_id));
            web.AdministracionClient.BeginGenerarLiquidacionRegla_Iniciar(fechaInicial, fechaFinal, idRegla, Convert.ToInt32(regla.concurso_id), null, 1);
            return Json(new { Success = success, Messagge = messagge });
        }


        [HttpPost]
        public ActionResult Liquidaciones(FormCollection collection)
        {
            TempData["Mensaje"] = null;
            Regla regla = web.AdministracionClient.ListarReglaPorId(Convert.ToInt32(collection["regla"])).First();
            ViewBag.regla = regla;
            int concurso_id = (int)regla.concurso_id;
            ViewBag.concurso_id = concurso_id;

            List<LiquidacionRegla> liquidaciones = web.AdministracionClient.ListarLiquidacionesRegla(Convert.ToInt32(ViewBag.regla.id));
            ViewBag.cantidadLiquidaciones = liquidaciones.Count();
            liquidaciones = liquidaciones.OrderBy(l => l.fecha_liquidacion).ToList();
            TempData["resultadoLiq"] = web.AdministracionClient.validarEstadoLiquidacion(int.Parse(collection["regla"]), concurso_id);
            if (Convert.ToInt16(TempData["resultadoLiq"]) == 0)
            {
                TempData["Mensaje"] = "error|" + Mensajes.MensajeErrorLiquidacion; View(TempData["Mensaje"]);
            }

            TempData["tipoConcurso_id"] = web.AdministracionClient.RetornarTipoConcurso(concurso_id);
            return View(liquidaciones);
        }

        [HttpPost]
        public ActionResult GenerarPagos()
        {
            Boolean success = true;
            string messagge = "El proceso se realizó con éxito.";
            int idLiquidacion = Convert.ToInt32(Request["idLiquidacion"]);

            web.AdministracionClient.LiquidarPagosRegla(idLiquidacion);
            web.AdministracionClient.ActualizarLiquidacionReglaEstado(idLiquidacion, Convert.ToInt32(estadoLiquidacion.Pagada), HttpContext.Session["userName"].ToString());

            return Json(new { Success = success, Messagge = messagge });
        }

        /// <summary>
        /// Permite obtener el detalle de una liquidación especifica de una regla para un participante.
        /// </summary>
        /// <param name="id">Código de la liquidación actual (liquidacionRegla_id)</param>
        /// <param name="participante_id">Código del participante</param>
        /// <returns>Retorna la vista</returns>
        public ActionResult DetalleLiquidacionRegla(int id = 0, int participante_id = 0)
        {
            List<VistaDetalleLiquidacionReglaParticipante> detalleLiquidacion = new List<VistaDetalleLiquidacionReglaParticipante>();
            try
            {
                detalleLiquidacion = web.AdministracionClient.ListarDetalleLiquidacionReglaParticipante(id, participante_id);
                ViewBag.regla = detalleLiquidacion.First().Regla.ToString();
                ViewBag.participante = detalleLiquidacion.First().nombre.ToString() + " " + detalleLiquidacion.First().apellidos.ToString();
                ViewBag.detalle = detalleLiquidacion;
            }
            catch { }
            return View(ViewBag);
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public JsonResult Eliminar()
        {
            Boolean success = true;
            string messagge = "El proceso se realizó con éxito.";
            int idLiquidacion = Convert.ToInt32(Request["idLiquidacion"]);

            try
            {
                int resultado = 0;
                resultado = web.AdministracionClient.EliminarLiquidacionConcurso(idLiquidacion, HttpContext.Session["userName"].ToString());
                Logging.Auditoria("Eliminación del registro " + idLiquidacion + " en la tabla LIQUIDACIONREGLA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
            }
            catch (Exception ex) { }
            return Json(new { Success = success, Messagge = messagge });
        }
    }
}

