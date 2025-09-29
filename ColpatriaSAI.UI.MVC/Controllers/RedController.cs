using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class RedController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Redes"] = web.AdministracionClient.ListarRedes();
            return View(ViewData["Redes"]);
        }

        public ActionResult Create()
        {

            Red red = new Red();

            var idRed = Request["redId"];

            if (!string.IsNullOrEmpty(idRed))
            {
                red = web.AdministracionClient.ListarRedesPorId(Convert.ToInt32(idRed)).FirstOrDefault();
            }

            return View(red);
        }

        [HttpPost]
        public ActionResult SaveRed()
        {
            int resultado = 0;
            string userName = HttpContext.Session["userName"].ToString();
            Red red = new Red()
            {
                id = Convert.ToInt32(Request["redId"]),
                nombre = Request["nombre"]
            };

            if (red.id == 0)
                resultado = web.AdministracionClient.InsertarRed(red, userName);
            else
                resultado = web.AdministracionClient.ActualizarRed(red.id, red, userName);

            return Json(new { Success = true });
        }

        public ActionResult DeleteRed(int idRed)
        {

            Red red = new Red();

            int redDetalleTotal = web.AdministracionClient.ListarRedesDetalle().Where(x => x.red_id == idRed).Count();
            string userName = HttpContext.Session["userName"].ToString();
            int result = 0;
            if (redDetalleTotal <= 0)
            {
                web.AdministracionClient.EliminarRed(idRed, red, userName);
                result = 1;
            }

            return Json(new { Success = true, Result = result });
        }

        public ActionResult Detalle(int idRed)
        {

            Red red = new Red();
            List<RedDetalle> redDetalleList = new List<RedDetalle>();

            red = web.AdministracionClient.ListarRedesPorId(idRed).FirstOrDefault();
            redDetalleList = web.AdministracionClient.ListarRedesDetalle().Where(x => x.red_id == red.id || x.red_id == 0).OrderByDescending(x => x.red_id).ToList();

            ViewData["redDetalleList"] = redDetalleList;

            return View(red);
        }

        [HttpPost]
        public ActionResult guardarRedDetalle()
        {

            String messagge = string.Empty;
            Boolean success = false;
            int redId = int.Parse(Request["redId"]);
            string redes = Request["redes[]"];
            string userName = HttpContext.Session["userName"].ToString();

            char[] delimiterChars = { ',' };

            //BORRAMOS TODA LA AGRUPACION DE LA RED
            web.AdministracionClient.EliminarAgrupacionRedDetalle(redId, userName);

            //VALIDAMOS QUE HAYA REDES
            if (!string.IsNullOrEmpty(redes))
            {
                string[] arrRedes = redes.Split(delimiterChars);

                List<RedDetalle> redDetalleList = web.AdministracionClient.ListarRedesDetalle().Where(x => x.red_id == redId).ToList();

                //RECORREMOS LAS REDES A AGRUPAR
                foreach (string idRedDetalle in arrRedes)
                {
                    //VALIDAMOS SI LA AGRUPACION YA EXISTE
                    var totalRed = redDetalleList.Where(x => x.id == Convert.ToInt32(idRedDetalle)).Count();

                    if (totalRed == 0)
                    {
                        var redDetalle = new RedDetalle()
                        {
                            id = Convert.ToInt32(idRedDetalle),
                            red_id = redId
                        };

                        int registro = web.AdministracionClient.AgruparRedDetalle(redDetalle);
                    }
                }
            }

            return Json(new { Success = true });
        }
    }
}
