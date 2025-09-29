using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class BancoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Bancos"] = web.AdministracionClient.ListarBancos();
            return View(ViewData["Bancos"]);
        }

        public ActionResult Create()
        {

            Banco banco = new Banco();

            var idBanco = Request["bancoId"];

            if (!string.IsNullOrEmpty(idBanco))
            {
                banco = web.AdministracionClient.ListarBancosPorId(Convert.ToInt32(idBanco)).FirstOrDefault();
            }

            return View(banco);
        }

        [HttpPost]
        public ActionResult SaveBanco()
        {
            int resultado = 0;
            string userName = HttpContext.Session["userName"].ToString();
            Banco banco = new Banco()
            {
                id = Convert.ToInt32(Request["bancoId"]),
                nombre = Request["nombre"]
            };

            if (banco.id == 0)
                resultado = web.AdministracionClient.InsertarBanco(banco, userName);
            else
                resultado = web.AdministracionClient.ActualizarBanco(banco.id, banco, userName);

            return Json(new { Success = true });
        }

        public ActionResult DeleteBanco(int idBanco)
        {

            Banco banco = new Banco();
            string userName = HttpContext.Session["userName"].ToString();
            int bancoDetalleTotal = web.AdministracionClient.ListarBancosDetalle().Where(x => x.banco_id == idBanco).Count();

            int result = 0;
            if (bancoDetalleTotal <= 0)
            {
                web.AdministracionClient.EliminarBanco(idBanco, banco, userName);
                result = 1;
            }

            return Json(new { Success = true, Result = result });
        }

        public ActionResult Detalle(int idBanco)
        {

            Banco banco = new Banco();
            List<BancoDetalle> bancoDetalleList = new List<BancoDetalle>();

            banco = web.AdministracionClient.ListarBancosPorId(idBanco).FirstOrDefault();
            bancoDetalleList = web.AdministracionClient.ListarBancosDetalle().Where(x => x.banco_id == banco.id || x.banco_id == 0).OrderByDescending(x => x.banco_id).ToList();

            ViewData["bancoDetalleList"] = bancoDetalleList;

            return View(banco);
        }

        [HttpPost]
        public ActionResult guardarBancoDetalle()
        {
            string userName = HttpContext.Session["userName"].ToString();
            String messagge = string.Empty;
            Boolean success = false;
            int bancoId = int.Parse(Request["bancoId"]);
            string bancos = Request["bancos[]"];

            char[] delimiterChars = { ',' };

            //BORRAMOS TODA LA AGRUPACION DEL BANCO
            web.AdministracionClient.EliminarAgrupacionBancoDetalle(bancoId, userName);

            //VALIDAMOS QUE HAYA BANCOS
            if (!string.IsNullOrEmpty(bancos))
            {
                string[] arrBancos = bancos.Split(delimiterChars);

                List<BancoDetalle> bancoDetalleList = web.AdministracionClient.ListarBancosDetalle().Where(x => x.banco_id == bancoId).ToList();

                //RECORREMOS LOS BANCOS A AGRUPAR
                foreach (string idBancoDetalle in arrBancos)
                {
                    //VALIDAMOS SI LA AGRUPACION YA EXISTE
                    var totalBanco = bancoDetalleList.Where(x => x.id == Convert.ToInt32(idBancoDetalle)).Count();

                    if (totalBanco == 0)
                    {
                        var bancoDetalle = new BancoDetalle()
                        {
                            id = Convert.ToInt32(idBancoDetalle),
                            banco_id = bancoId
                        };

                        int registro = web.AdministracionClient.AgruparBancoDetalle(bancoDetalle);
                    }
                }
            }

            return Json(new { Success = true });
        }

    }
}
