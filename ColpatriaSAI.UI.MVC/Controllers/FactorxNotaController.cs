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
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class FactorxNotaController : ControladorBase
    {
        WebPage web = new WebPage();



        /// <summary>Inicializa el formaulario de administracion de Factores</summary>
        /// <returns>Resultado de la inicialización</returns>
        public ActionResult Index()
        {

            var list = web.AdministracionClient.ListarTipoEscalas().ToList();

            ViewData["FactorModel"] = new FactorxNotaViewModel()
            {
                FactorxNotaView = new FactorxNota(),
                TipoEscalaList = new SelectList(web.AdministracionClient.ListarTipoEscalas().ToList(), "id", "nombre", 0)
            };

            ViewData["FactorxNotas"] = web.AdministracionClient.ListarFactorxNotas();
            //ViewData["Periodos"] = web.AdministracionClient.ListarPeriodoFactorxNotasPorFactor(new int());
            //ViewData["Detalles"] = web.AdministracionClient.ListarFactorxNotaDetallesPorPeriodo(new int());
            return View();
        }

        /// <summary>Obtiene los periodos de un factor</summary>
        /// <param name="id">Id del factor</param>
        /// <returns>Lista de periodos</returns>
        public ActionResult ListarPeriodos(int id)
        {
            List<PeriodoFactorxNota> periodoFactorxNota = web.AdministracionClient.ListarPeriodoFactorxNotasPorFactor(id);
            return Json(periodoFactorxNota.Select(p => new
            {
                id = p.id,
                fechaIni = Convert.ToDateTime(p.fechaIni).ToShortDateString(),
                fechaFin = Convert.ToDateTime(p.fechaFin).ToShortDateString(),
                p.factorxnota_id
            }), 0);
        }

        /// <summary>Obtiene los factores por nota del periodo seleccionado</summary>
        /// <param name="id">Id del periodo</param>
        /// <returns>Lista de factor</returns>
        public ActionResult ListarDetalles(int id)
        {
            List<FactorxNotaDetalle> detalles = web.AdministracionClient.ListarFactorxNotaDetallesPorPeriodo(id).OrderBy(fn => fn.factor).ToList();
            return Json(detalles, 0);
        }

        /// <summary>Ingresa un factor</summary>
        /// <param name="collection">Información del formulario a ingresar</param>
        /// <returns>Objeto FactorxNota ingresado</returns>
        public ActionResult CrearFactorxNota(FormCollection collection)
        {
            FactorxNota factorxNota = new FactorxNota()
            {
                nombre = (collection["nombre"] != "" ? collection["nombre"] : ""),
                tipoescala_id = Convert.ToInt32(collection["tipoescala_id"])
            };
            if ((collection["factorxnota_id"] == "0") || (collection["factorxnota_id"] == ""))
                factorxNota.id = web.AdministracionClient.InsertarFactorxNota(factorxNota, HttpContext.Session["userName"].ToString());
            else
            {
                factorxNota.id = web.AdministracionClient.ActualizarFactorxNota(Convert.ToInt32(collection["factorxnota_id"]), factorxNota, HttpContext.Session["userName"].ToString());
            }
            return Json(factorxNota, 0);
        }

        /// <summary>Ingresa un periodo por factor</summary>
        /// <param name="collection">Información del formulario a ingresar</param>
        /// <returns>Objeto PeriodoFactorxNota ingresado</returns>
        public ActionResult CrearPeriodo(FormCollection collection)
        {
            PeriodoFactorxNota periodo = new PeriodoFactorxNota()
            {
                factorxnota_id = Convert.ToInt32(collection["id_factorxnota"] != "" ? collection["id_factorxnota"] : "0"),
                fechaIni = Convert.ToDateTime(collection["fechaIni"] != "" ? collection["fechaIni"] : "0"),
                fechaFin = Convert.ToDateTime(collection["fechaFin"] != "" ? collection["fechaFin"] : "0")
            };
            string userName = HttpContext.Session["userName"].ToString();
            periodo.id = web.AdministracionClient.InsertarPeriodoFactorxNota(periodo, userName);
            return Json(new
            {
                id = periodo.id,
                fechaIni = Convert.ToDateTime(periodo.fechaIni).ToShortDateString(),
                fechaFin = Convert.ToDateTime(periodo.fechaFin).ToShortDateString(),
                periodo.factorxnota_id
            }, 0);
        }

        /// <summary>Ingresa un periodo por factor</summary>
        /// <param name="collection">Información del formulario a ingresar</param>
        /// <returns>Objeto PeriodoFactorxNota ingresado</returns>
        public ActionResult CrearDetalle(FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            FactorxNotaDetalle detalle = new FactorxNotaDetalle()
            {
                id = Convert.ToInt32(collection["detalle_id"] != "" ? collection["detalle_id"] : "0"),
                factor = Convert.ToDouble(collection["factor"] != "" ? collection["factor"] : "0"),
                nota = Convert.ToDouble(collection["nota"] != "" ? collection["nota"] : "0"),
                periodofactorxnota_id = Convert.ToInt32(collection["id_periodo"] != "" ? collection["id_periodo"] : "0"),
            };
            detalle.id = web.AdministracionClient.InsertarFactorxNotaDetalle(detalle, userName);
            return Json(detalle, 0);
        }

        public ActionResult EliminarFactorxNota(int id)
        {
            string userName = HttpContext.Session["userName"].ToString();
            return Json(web.AdministracionClient.EliminarFactorxNota(id, null, userName), 0);
        }

        public ActionResult EliminarPeriodo(int id)
        {
            string userName = HttpContext.Session["userName"].ToString();
            return Json(web.AdministracionClient.EliminarPeriodoFactorxNota(id, null, userName), 0);
        }

        public ActionResult EliminarDetalle(int id)
        {
            string userName = HttpContext.Session["userName"].ToString();
            return Json(web.AdministracionClient.EliminarFactorxNotaDetalle(id, null, userName), 0);
        }

    }
}