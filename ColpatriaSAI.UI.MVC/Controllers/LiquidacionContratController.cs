using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class LiquidacionContratController : ControladorBase
    {

        enum estadoFranquicia
        {
            Creada = 1,
            Pagada = 2,
            Anulada = 3,
            EnCurso = 4
        }

        WebPage web = new WebPage();
        public ActionResult Index()
        {
            List<ColpatriaSAI.Negocio.Entidades.LiquidacionContratacion> liquidacionContrtacion = new List<ColpatriaSAI.Negocio.Entidades.LiquidacionContratacion>();
            liquidacionContrtacion = web.AdministracionClient.ListarLiquidacionContratacion().ToList();

            return View(liquidacionContrtacion);
        }

        public ActionResult Create()
        {

            LiquidacionContratacion liquidacionContratacion = web.AdministracionClient.ListarLiquidacionContratacion().Where(x => x.estado == 1).ToList().FirstOrDefault();

            Session["idLiquidacion"] = "0";
            ViewData["idLiquidacionContratacion"] = "0";
            if (liquidacionContratacion != null)
                ViewData["idLiquidacionContratacion"] = liquidacionContratacion.id;

            int segmentoUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.Segmentos = new SelectList(web.AdministracionClient.ListarSegmentoes().OrderBy(s => s.nombre), "id", "nombre", segmentoUsuario);

            return View();
        }

        public JsonResult LiquidarContratacion()
        {
            var fechaInicial = Convert.ToDateTime(Request["fechaInicial"]);
            fechaInicial = Convert.ToDateTime(fechaInicial.Year.ToString() + "-" + fechaInicial.Month.ToString() + "-01");
            var segmentoId = Convert.ToInt32(Request["segmento"]);

            LiquidacionContratacion liquidacion = new LiquidacionContratacion()
            {
                fechaLiquidacion = DateTime.Now,
                fechaIni = fechaInicial,
                fechaFin = Convert.ToDateTime(fechaInicial.AddMonths(1).AddDays(-1)),
                usuario = Session["NombreUser"].ToString(),
                estado = Convert.ToInt32(estadoFranquicia.EnCurso)
            };

            int idLiquidacion = web.AdministracionClient.InsertarLiquidacionContrat(liquidacion, HttpContext.Session["userName"].ToString());

            liquidacion.id = idLiquidacion;

            //LiquidarContratacionTotal
            web.AdministracionClient.LiquidarContratacion(liquidacion, segmentoId);

            //web.AdministracionClient.ActualizarLiquidacionContratacionEstado(idLiquidacion, Convert.ToInt32(estadoFranquicia.Creada));

            return Json(new { Success = true, idLiquidacion = idLiquidacion });
        }

        [HttpPost]
        public JsonResult Anular()
        {
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            web.AdministracionClient.ActualizarLiquidacionContratacionEstado(id, Convert.ToInt32(estadoFranquicia.Anulada), HttpContext.Session["userName"].ToString());
            return Json(new { Success = true });
        }

        [HttpPost]
        public JsonResult PagarLiqui()
        {
            string messagge = "";
            Boolean success;
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            LiquidacionContratacion liquidacionContratacion = web.AdministracionClient.TraerLiquidacionContratacion(id);

            if (liquidacionContratacion.estado == Convert.ToInt32(estadoFranquicia.Creada))
            {
                web.AdministracionClient.ActualizarLiquidacionContratacionEstado(id, Convert.ToInt32(estadoFranquicia.Pagada), HttpContext.Session["userName"].ToString());
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

        public JsonResult EliminarLiquidacion()
        {
            int id = Convert.ToInt32(Request["idLiquidacion"]);
            web.AdministracionClient.EliminarLiquidacionContratacion(id, HttpContext.Session["userName"].ToString());
            return Json(new { Success = true });
        }

    }
}