using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.Negocio.Entidades;
using System.IO;
using LinqToExcel;
using ColpatriaSAI.UI.MVC.Comun;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class EjecucionController : ControladorBase
    {
        //
        // GET: /Ejecucion/
        WebPage web = new WebPage();
        string rutaArchivos = System.Configuration.ConfigurationManager.AppSettings["RutaArchivos"];
        string urlSite = System.Configuration.ConfigurationManager.AppSettings["URLSite"];

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CargueManualEjecucionDetalle()
        {
            ViewData["idPresupuesto"] = RouteData.Values["id"];
            ViewData["partArchivoFormato"] = urlSite + "CargueSAI/FormatosCarga/FormatoCargaEjecucionManual.xlsx";
            return View("EjecucionesManuales");
        }

        [HttpPost]
        public ActionResult ProcesarCargueManualEjecucionDetalle(HttpPostedFileBase file)
        {
            int idPresupuesto = Convert.ToInt32(Request["idPresupuesto"]);
            if (file.ContentLength > 0)
            {
                string nombreArchivo = "Ejecuciones_" + DateTime.Now.ToShortDateString().Replace('/', '-') + " " + DateTime.Now.Hour + " " + DateTime.Now.Minute + ".xlsx";
                bool exito = Utilidades.subirArchivoFtp(rutaArchivos, nombreArchivo, file);
                if (exito)
                {
                    web.AdministracionClient.CargueManualEjecucionDetalle(nombreArchivo, idPresupuesto/*, HttpContext.Session["userName"].ToString()*/);
                }
                else
                    TempData["Mensaje"] = "error|Error: " + "El archivo seleccionado no ha podido ser almacenado";
            }

            ViewData["idPresupuesto"] = idPresupuesto;
            return View("EjecucionesManuales");
        }

        public ActionResult BuscarEjecucionManual()
        {
            int idPresupuesto = Convert.ToInt32(Request["idPresupuesto"]);
            string codigoNivel = Request["codigoNivel"];
            int idMeta = Convert.ToInt32(Request["metaId"]);
            int mes = Convert.ToInt32(Request["mes"]);
            int idCanal = Convert.ToInt32(Request["canalId"]);
            int idEjecucionDetalle = 0;
            Double valor = 0;
            string descripcion = string.Empty;
            string fechaAjuste = string.Empty;
            string usuario = string.Empty;
            bool success = false;
            
            Ejecucion ejecucion = web.AdministracionClient.TraerEjecucionPorPresupuesto(idPresupuesto);
            if (ejecucion != null)
            {
                List<Participante> participantes = web.AdministracionClient.ListarParticipantesTotales().ToList();
                List<JerarquiaDetalle> jerarquiaDetalleList = web.AdministracionClient.ListarJerarquiaDetalle().ToList();
                JerarquiaDetalle jerarquiaDetalle = jerarquiaDetalleList.Where(x => x.codigoNivel == codigoNivel).FirstOrDefault();

                if (jerarquiaDetalle != null)
                {
                    EjecucionDetalle ejecucionDetalle = web.AdministracionClient.TraerEjecucionDetalle(ejecucion.id, idMeta, jerarquiaDetalle.id, mes, idCanal);

                    if (ejecucionDetalle != null)
                    {
                        idEjecucionDetalle = ejecucionDetalle.id;
                        valor = Convert.ToDouble(ejecucionDetalle.valor);
                        descripcion = ejecucionDetalle.descripcion;
                        fechaAjuste = (ejecucionDetalle.fechaAjuste != null)?ejecucionDetalle.fechaAjuste.Value.ToShortDateString():"N/D";
                        usuario = ejecucionDetalle.usuario;
                        success = true;
                    }
                }
            }

            return Json(new { Success = success, IdEjecucionDetalle = idEjecucionDetalle, Valor = valor, Descripcion = descripcion, FechaAjuste = fechaAjuste, Usuario = usuario });
        }

        public ActionResult ActualizarEjecucionManual()
        {
            var idEjecucionDetalle = Request["idEjecucionDetalle"];
            var valor = Request["valor"].Replace(".", ",");
            string descripcion = Request["descripcion"];           

            EjecucionDetalle ejecucionDetalle = web.AdministracionClient.TraerEjecucionDetallePorId(Convert.ToInt32(idEjecucionDetalle));

            descripcion = ejecucionDetalle.descripcion + "<br/><br/>Fecha: " + DateTime.Now.ToShortDateString() + "<br/>Usuario: " + Session["UserName"].ToString() + "<br/>Vr. Anterior: " + ejecucionDetalle.valor.ToString() + " - Vr. Actual: " + valor + "<br/>Descripción:<br/>" + descripcion + "<hr/>";

            ejecucionDetalle.valor =  double.Parse(valor);
            ejecucionDetalle.descripcion = descripcion;
            ejecucionDetalle.fechaAjuste = DateTime.Now;
            ejecucionDetalle.usuario = Session["UserName"].ToString();
            web.AdministracionClient.ActualizarEjecucionDetalle(ejecucionDetalle /*, HttpContext.Session["userName"].ToString()*/);

            return Json(new { Success = true });
        }        
    }
}
