using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Web.Services;
using System.Web.Script.Services;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class EstadisticasController : ControladorBase
    {
        //
        // GET: /Estadisticas/

        WebPage web = new WebPage();

        public ActionResult Index()
        {
            return View();
        }

        public JsonResult ConstruirReporteRecaudosMesPromedio(int anio, int mes)
        {
            try
            {
                var response = web.AdministracionClient.TraerValoresRecaudosMesPromedio(anio,mes).Select(x => new
                {
                    Categoria = x.Compania,
                    TotalRecaudos = x.TotalValorMes,
                    PromedioRecaudos = x.Promedio
                }).ToList();
                
                return Json(new
                {
                    Success = true,
                    ChartData = response
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    Success = false
                });
            }
        }

        public JsonResult ConstruirReporteRegistrosRecaudosMesPromedio(int anio, int mes)
        {
            try
            {
                var response = web.AdministracionClient.TraerRegistrosRecaudosMesPromedio(anio, mes).Select(x => new
                {
                    Categoria = x.Compania,
                    TotalRegistros = x.TotalRegistrosMes,
                    PromedioRegistros = x.PromedioRegistros
                }).ToList();

                return Json(new
                {
                    Success = true,
                    ChartData = response
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    Success = false
                });
            }
        }

        public JsonResult ConstruirReportePrimasMesPromedio(int anio, int mes)
        {
            try
            {
                var response = web.AdministracionClient.TraerValoresPrimasMesPromedio(anio, mes).Select(x => new
                {
                    Categoria = x.Compania,
                    TotalPrimas = x.TotalValorMes,
                    PromedioPrimas = x.Promedio
                }).ToList();

                return Json(new
                {
                    Success = true,
                    ChartData = response
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    Success = false
                });
            }
        }

        public JsonResult ConstruirReporteRegistrosPrimasMesPromedio(int anio, int mes)
        {
            try
            {
                var response = web.AdministracionClient.TraerRegistrosPrimasMesPromedio(anio, mes).Select(x => new
                {
                    Categoria = x.Compania,
                    TotalRegistros = x.TotalRegistrosMes,
                    PromedioRegistros = x.PromedioRegistros
                }).ToList();

                return Json(new
                {
                    Success = true,
                    ChartData = response
                });
            }
            catch (Exception ex)
            {
                return Json(new
                {
                    Success = false
                });
            }
        }
    }
}
