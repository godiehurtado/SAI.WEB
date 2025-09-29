using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Web.Mvc.Ajax;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class AmparoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index() 
        {
            ViewData["Amparos"] = Listar();
            return View();

        }

        public ActionResult Listar()
        {
            List<Amparo> amparoes = web.AdministracionClient.ListarAmparoes().ToList();
                       return View(amparoes);
        }

        public ActionResult Detalle(int idAmparo)
        {
            Amparo amparo = new Amparo();
            amparo = web.AdministracionClient.ListarAmparoesPorId(idAmparo).FirstOrDefault();

            var lstDetalleAmparo = web.AdministracionClient.ListarAmparoDetalle().Where(ad => ad.amparo_id == idAmparo || ad.amparo_id == 0 && ad.id > 0).OrderByDescending(ads => ads.amparo_id).ToList();
                //(idAmparo).OrderByDescending(a => a.id).ToList();
            ViewData["amparoDetalleList"] = lstDetalleAmparo;
           
            return View(amparo);
        }

        public ActionResult Create()
        {

            Amparo amparo = new Amparo();

            var idamparo = Request["AmparoId"];

            if (!string.IsNullOrEmpty(idamparo))
                amparo = web.AdministracionClient.ListarAmparoesPorId(Convert.ToInt32(idamparo)).FirstOrDefault();

            return View(amparo);
        }

        public ActionResult Editar(int amparoId)
        {

            Amparo amparo = new Amparo();

            var idamparo = Request["amparoId"];

            if (!string.IsNullOrEmpty(idamparo))
            {
                amparo = web.AdministracionClient.ListarAmparoesPorId(Convert.ToInt32(idamparo)).FirstOrDefault();
            }

            return View(amparo);
        }


        [HttpPost]
        public ActionResult Save()
        {
            int resultado = 0;
            string mensajeDeError = string.Empty;
            string userName = HttpContext.Session["userName"].ToString();
            Amparo _amparo = new Amparo()
            {
                id = Convert.ToInt32(Request["AmparoId"]),
                nombre = Request["nombre"]
            };

            if (_amparo.id == 0)
                resultado = web.AdministracionClient.InsertarAmparo(_amparo, ref mensajeDeError, userName);
            else
                resultado = web.AdministracionClient.InsertarAmparo(_amparo, ref mensajeDeError, userName);
           
            return Json(new { Success = true, result = resultado });
        }

        [HttpPost]
        public ActionResult Actualizar()
        {
            int resultado = 0;
            string mensajeDeError = string.Empty;
            string userName = HttpContext.Session["userName"].ToString();
            Amparo _amparo = new Amparo()
            {
                id = Convert.ToInt32(Request["AmparoId"]),
                nombre = Request["nombre"]
            };

            if (_amparo.id != 0)
               resultado = web.AdministracionClient.InsertarAmparo(_amparo, ref mensajeDeError, userName);

            return Json(new { Success = true, result = resultado });
        }

        public ActionResult DeleteAmparo(int idAmparo)
        {

            Amparo _amparo = new Amparo();
            string mensajeDeError = string.Empty;
            string userName = HttpContext.Session["userName"].ToString();

            int result = 0;
            if (idAmparo != 0)
            {
                web.AdministracionClient.EliminarAmparo(idAmparo, ref mensajeDeError, userName);
                if (string.IsNullOrEmpty(mensajeDeError)) result = 1; else result = 0;

            }
           

            return Json(new { Success = true, Result = result });
        }

        [HttpPost]
        public ActionResult SaveAmparoDetalle()
        {

            int amparoId = int.Parse(Request["amparoId"]);
            string amparos = Request["amparos[]"];
            string MensajeDeError = string.Empty; 
            string userName = HttpContext.Session["userName"].ToString();

            web.AdministracionClient.EliminarAmparoDetalle(amparoId, ref MensajeDeError, userName);

            if (!string.IsNullOrEmpty(amparos))
            {

                string[] amp = amparos.Split(',');

                var ListDetalleAmparo = web.AdministracionClient.ListarAmparoDetallePorId(amparoId);

                foreach (string item in amp)
                {

                    var count = ListDetalleAmparo.Where(ad => ad.id == Convert.ToInt32(item)).ToList().Count();
                    if (count == 0)
                    {
                        var ampaodetalle = new AmparoDetalle()
                        {
                            id = Convert.ToInt32(item),
                            amparo_id = amparoId
                        };

                        int registro = web.AdministracionClient.InsertarAmparoDetalle(ampaodetalle, userName);
                    }

                }
            }


           
            return Json(new { Success = true });
        }

    }
}