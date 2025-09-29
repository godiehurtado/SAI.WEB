using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.AdministracionSvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Configuration;
using ColpatriaSAI.UI.MVC.Helpers;
using System.Globalization;
using ColpatriaSAI.UI.MVC.Comun;
using System.Runtime.Remoting.Metadata.W3cXsd2001;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class LiquidacionFranquiController : ControladorBase
    {
        enum estadoFranquicia
        {
            Creada = 1,
            Pagada = 2,
            Anulada = 3,
            EnCurso = 4,
            ReLiquiado = 5
        }

        WebPage web = new WebPage();
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult liquiIndex()
        {
            List<LiquidacionFranquicia> liquidacionFranquicias = web.AdministracionClient.ListarLiquidacionFranquicias().ToList();

            return View(liquidacionFranquicias);
        }

        public ActionResult Create()
        {

            LiquidacionFranquicia liquidacionFranquicias = web.AdministracionClient.ListarLiquidacionFranquicias().Where(x => x.estado == 1).ToList().FirstOrDefault();

            Session["idLiquidacion"] = "0";
            ViewData["idLiquidacionFranquicia"] = "0";
            if (liquidacionFranquicias != null)
                ViewData["idLiquidacionFranquicia"] = liquidacionFranquicias.id;

            return View();
        }

        public ActionResult Pagos(int id)
        {
            LiquidacionFranquicia liquidacionFranquicias = web.AdministracionClient.TraerLiquidacionFranquicia(id);
            ViewData["Estados"] = liquidacionFranquicias.estado.Value;
            return View(liquidacionFranquicias);
        }

        [HttpPost]
        public JsonResult PagarLiqui()
        {
            string messagge = "";
            Boolean success;
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            LiquidacionFranquicia liquidacionFranquicias = web.AdministracionClient.TraerLiquidacionFranquicia(id);
            string username = HttpContext.Session["userName"].ToString();
            if (liquidacionFranquicias.estado == Convert.ToInt32(estadoFranquicia.Creada))
            {
                //Generamos el pago de la liquidacion
                web.AdministracionClient.GenerarPagosLiquidacionFranquicia(id, Session["username"].ToString());
                web.AdministracionClient.ActualizarLiquidacionFranquiciaEstado(id, Convert.ToInt32(estadoFranquicia.Pagada), username);

                //ACTUALIZAMOS EL VALOR PARA QUE NO SE PUEDE RELIQUIDAR LA FRANQUICIA BASE CUANDO SEA PAGADA
                if (liquidacionFranquicias.id_liquidacion_reliquidada != null)
                    web.AdministracionClient.ActualizarLiquidacionFranquiciaReliquidacion(Convert.ToInt32(liquidacionFranquicias.id_liquidacion_reliquidada), 0, username);

                List<ETLRemota> etlRemotas = ETL.ListarETLsRemotasporTipo(1);
                Dictionary<string, object> parametros = new Dictionary<string, object>();
                ETLRemota etl = etlRemotas.Where(e => e.id == 32).First();

                parametros.Add("idliquidacion", id);
                //parametros.Add("clavePago", Request["clave"] );

                ETL.EjecutarETL(etl, parametros, Sesion.VariablesSesion());
                success = true;
                messagge = "El proceso se realizó con éxito.";
            }
            else
            {
                success = false;
                messagge = "Los pagos no se pueden realizar por el estado en que se encuentra la liquidación.";
            }

            return Json(new { Success = success, Messagge = messagge });
        }

        [HttpPost]
        public JsonResult Anular()
        {
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            web.AdministracionClient.ActualizarLiquidacionFranquiciaEstado(id, Convert.ToInt32(estadoFranquicia.Anulada), HttpContext.Session["userName"].ToString());
            return Json(new { Success = true });
        }

        public JsonResult LiquidarFranquicias()
        {

            var Annio = Request["annio"];
            var Day = "1";
            var Separator = "-";
            var fechaInicial = Annio + Separator + Request["fechaInicial"] + Separator + Day;
            var fechaFinal = Annio + Separator + Request["fechaFinal"] + Separator + Day; ;
          

            LiquidacionFranquicia liquidacion = new LiquidacionFranquicia()
            {
                fechaLiquidacion = DateTime.Now,
                periodoLiquidacionIni = Convert.ToDateTime(fechaInicial),
                periodoLiquidacionFin = Convert.ToDateTime(fechaFinal),
                estado = Convert.ToInt32(estadoFranquicia.EnCurso),
                permite_reliquidar = 1
            };

            Session["idLiquidacion"] = "0";
            int idLiquidacion = web.AdministracionClient.InsertarLiquidacionFranquicia(liquidacion, HttpContext.Session["userName"].ToString());
            Session["idLiquidacion"] = idLiquidacion;

            liquidacion.id = idLiquidacion;

            //LiquidarFranquiciasDetalleTotal
            web.AdministracionClient.LiquidarFranquiciasDetalleTotal(liquidacion);

            //LiquidarFranquiciasExcepciones
            web.AdministracionClient.LiquidarFranquiciasExcepciones(liquidacion);

            //LiquidarFranquiciasPorcentajes
            web.AdministracionClient.LiquidarFranquiciasParticipaciones(liquidacion);

            //LiquidarFranquiciasRangos
            
           web.AdministracionClient.LiquidarFranquiciasPorRangos(liquidacion);

            
            web.AdministracionClient.ActualizarLiquidacionFranquiciaEstado(idLiquidacion, Convert.ToInt32(estadoFranquicia.Creada), HttpContext.Session["userName"].ToString());

            //Borrramos tabla que controla el proceso de la liquidacion
            //Lo borramos desde el sp de Participaciones.
            //web.AdministracionClient.EliminarLiquidacionProceso(idLiquidacion);

            return Json(new { Success = true, idLiquidacion = idLiquidacion, reliquidacion = false });
        }

        public JsonResult Reliquidar(int id)
        {
            var idLiquidacionReliquidar = id;
            string username = HttpContext.Session["userName"].ToString();
            LiquidacionFranquicia liquidacionReliquidar = web.AdministracionClient.TraerLiquidacionFranquicia(idLiquidacionReliquidar);

            //Validamos si hay liquidaciones en estado creado
            List<LiquidacionFranquicia> liquidacionesCreadas = web.AdministracionClient.ListarLiquidacionFranquicias().Where(x => x.periodoLiquidacionIni.Value.Year == liquidacionReliquidar.periodoLiquidacionIni.Value.Year && x.estado == Convert.ToInt32(estadoFranquicia.Creada)).ToList();

            if (liquidacionesCreadas.Count() <= 0)
            {

                //Obtenemos las liquidaciones posteriores a la reliquidación para mostrarle un mensaje al usuario
                List<LiquidacionFranquicia> liquidacionesPosteriores = web.AdministracionClient.ListarLiquidacionFranquicias().Where(x => x.periodoLiquidacionIni.Value.Year == liquidacionReliquidar.periodoLiquidacionIni.Value.Year && x.periodoLiquidacionIni.Value.Month > liquidacionReliquidar.periodoLiquidacionIni.Value.Month && (x.estado == Convert.ToInt32(estadoFranquicia.Pagada) || x.estado == Convert.ToInt32(estadoFranquicia.ReLiquiado))).OrderBy(x => x.id).ToList();

                string mesesReliquidar = string.Empty;
                var msjReliquidacion = string.Empty;
                if (liquidacionesPosteriores != null)
                {
                    foreach (LiquidacionFranquicia liquidacionPosterior in liquidacionesPosteriores)
                    {

                        DateTimeFormatInfo dtinfo = new CultureInfo("es-ES", false).DateTimeFormat;

                        mesesReliquidar += dtinfo.GetMonthName(liquidacionPosterior.periodoLiquidacionIni.Value.Month) + ",";

                        web.AdministracionClient.ActualizarLiquidacionFranquiciaReliquidacion(liquidacionPosterior.id, 0, username);
                    }

                    msjReliquidacion = "Recuerde que debe volver a reliquidar los meses de " + mesesReliquidar.ToUpper() + " para que los acumulados sean actualizados.";
                }

                var fechaInicial = liquidacionReliquidar.periodoLiquidacionIni;
                var fechaFinal = liquidacionReliquidar.periodoLiquidacionFin;

                LiquidacionFranquicia liquidacion = new LiquidacionFranquicia()
                {
                    fechaLiquidacion = DateTime.Now,
                    periodoLiquidacionIni = Convert.ToDateTime(fechaInicial),
                    periodoLiquidacionFin = Convert.ToDateTime(fechaFinal),
                    estado = Convert.ToInt32(estadoFranquicia.EnCurso),
                    id_liquidacion_reliquidada = idLiquidacionReliquidar,
                    permite_reliquidar = 1
                };

                Session["idLiquidacion"] = "0";
                int idLiquidacion = web.AdministracionClient.InsertarLiquidacionFranquicia(liquidacion, username);
                Session["idLiquidacion"] = idLiquidacion;

                liquidacion.id = idLiquidacion;

                //LiquidarFranquiciasDetalleTotal
                web.AdministracionClient.LiquidarFranquiciasDetalleTotal(liquidacion);

                //LiquidarFranquiciasExcepciones
                web.AdministracionClient.LiquidarFranquiciasExcepciones(liquidacion);

                //LiquidarFranquiciasPorcentajes
                web.AdministracionClient.LiquidarFranquiciasParticipaciones(liquidacion);

                //LiquidarFranquiciasRangos
                web.AdministracionClient.LiquidarFranquiciasPorRangos(liquidacion);

                web.AdministracionClient.ActualizarLiquidacionFranquiciaEstado(idLiquidacion, Convert.ToInt32(estadoFranquicia.Creada), username);

                //Borrramos tabla que controla el proceso de la liquidacion
                //Lo borramos desde el sp de Rangos.
                //web.AdministracionClient.EliminarLiquidacionProceso(idLiquidacion);

                return Json(new { Success = true, idLiquidacion = idLiquidacion, reliquidacion = true, mjsReliquidacion = msjReliquidacion });
            }
            else
            {
                return Json(new { Success = false });
            }

        }

        public JsonResult Reliquidado()
        {
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            string username = HttpContext.Session["userName"].ToString();
            LiquidacionFranquicia liquidacionReliquidada = web.AdministracionClient.TraerLiquidacionFranquicia(id);

            //ACTUALIZAMOS EL VALOR PARA QUE NO SE PUEDE RELIQUIDAR LA FRANQUICIA BASE
            if (liquidacionReliquidada.id_liquidacion_reliquidada != null)
                web.AdministracionClient.ActualizarLiquidacionFranquiciaReliquidacion(Convert.ToInt32(liquidacionReliquidada.id_liquidacion_reliquidada), 0, username);

            //ACTUALIZAMOS EL ESTADO DE LA FRANQUICIA RELIQUIDADA
            web.AdministracionClient.ActualizarLiquidacionFranquiciaEstado(liquidacionReliquidada.id, Convert.ToInt32(estadoFranquicia.ReLiquiado), username);

            return Json(new { Success = true });
        }

        public JsonResult ValidarLiquidaciones(int id)
        {
            var idLiquidacionReliquidar = id;

            LiquidacionFranquicia liquidacionReliquidar = web.AdministracionClient.TraerLiquidacionFranquicia(idLiquidacionReliquidar);

            //Validamos si hay liquidaciones en estado creado
            List<LiquidacionFranquicia> liquidacionesCreadas = web.AdministracionClient.ListarLiquidacionFranquicias().Where(x => x.periodoLiquidacionIni.Value.Year == liquidacionReliquidar.periodoLiquidacionIni.Value.Year && x.estado == Convert.ToInt32(estadoFranquicia.Creada)).ToList();

            if (liquidacionesCreadas.Count() <= 0)
            {
                return Json(new { Success = true });
            }
            else
            {
                return Json(new { Success = false });
            }
        }
    }

}
