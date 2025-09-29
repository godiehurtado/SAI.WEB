using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;


namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class PeriodoCierreController : ControladorBase
    {

        enum estadoPeriodo
        {
            Pendiente = 0,
            Abierto = 1,
            Cerrado = 2
        }

        WebPage web = new WebPage();
        public ActionResult Index()
        {
            var modelPeriodo = new PeriodoCierreModel()
            {
                PeriodoCierreList = web.AdministracionClient.ListarPeriodos().ToList()
            };

            return View(modelPeriodo);
        }

        public ActionResult Create()
        {
            List<Compania> companias = web.AdministracionClient.ListarCompanias().ToList();
            companias.Add(new Compania { id = 0, nombre = "Recaudos SISE"});

            var periodoModel = new PeriodoCierreModel()
            {
                CompaniaList = companias
            };

            return View(periodoModel);
        }

        public ActionResult Edit(int id)
        {
            PeriodoCierre periodo = web.AdministracionClient.TraerPeriodoCierrePorId(id).FirstOrDefault();
            List<Compania> companias = web.AdministracionClient.ListarCompanias().ToList();
            companias.Add(new Compania { id = 0, nombre = "Recaudos SISE" });

            var periodoModel = new PeriodoCierreModel()
            {
                PeriodoCierre = periodo,
                CompaniaList = companias
            };

            return View("Create", periodoModel);
        }

        public ActionResult SavePeriodoCierre()
        {

            string messagge = string.Empty;
            Boolean success = false;
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                PeriodoCierre periodoCierre = new PeriodoCierre()
                {
                    id = Convert.ToInt32(Request["periodoId"]),
                    compania_id = Convert.ToInt32(Request["companiaId"]),
                    fechaInicio = DateTime.Parse(Request["fechaInicio"]),
                    fechaFin = DateTime.Parse(Request["fechaFin"]),
                    fechaCierre = DateTime.Parse(Request["fechaCierre"]),
                    mesCierre =  Convert.ToInt32(Request["mes"]),
                    anioCierre =  Convert.ToInt32(Request["anio"]),
                };

                List<PeriodoCierre> listPeriodosCompania = web.AdministracionClient.ListarPeriodosPorCompania(Convert.ToInt32(periodoCierre.compania_id));

                //DETERMINAMOS SI YA EXISTE UN PERIODO PARA LA COMPAÑIA
                if (listPeriodosCompania.Where(x => x.mesCierre == periodoCierre.mesCierre && x.anioCierre == periodoCierre.anioCierre && x.id != periodoCierre.id).Count() > 0)
                {
                    messagge = "El periodo ya existe para la compania seleccionada.";
                    success = false;
                }
                else{

                    //DETERMINAMOS SI YA EXISTE UN PERIODO ABIERTO PARA LA COMPAÑIA
                    periodoCierre.estado = Convert.ToInt32(estadoPeriodo.Abierto);
                    if (listPeriodosCompania.Where(x => x.estado == Convert.ToInt32(estadoPeriodo.Abierto)).Count() > 0)
                        periodoCierre.estado = Convert.ToInt32(estadoPeriodo.Pendiente);

                    if (periodoCierre.id <= 0)
                        web.AdministracionClient.InsertarPeriodoCierre(periodoCierre, userName);
                    else if (periodoCierre.id > 0)
                        web.AdministracionClient.ActualizarPeriodoCierre(periodoCierre, userName); //En este proceso nunca se actualiza el estado

                    messagge = "El proceso se realizó con éxito";
                    success = true;
                }

            }
            catch
            {
                messagge = "El proceso no se pudo completar.";
            }

            return Json(new { Success = success, Messagge = messagge });
        }

        public ActionResult Delete(int id)
        {
            web.AdministracionClient.EliminarPeriodoCierre(id, HttpContext.Session["userName"].ToString());

            return RedirectToAction("Index");
        }

        public ActionResult ReabrirPeriodo()
        {
            string messagge = string.Empty;
            Boolean success = true;
            string userName = HttpContext.Session["userName"].ToString();
            //Actualizamos el periodo
            PeriodoCierre periodoCierre = web.AdministracionClient.TraerPeriodoCierrePorId(Convert.ToInt32(Request["PeriodoIdCerrado"])).FirstOrDefault();
            periodoCierre.fechaCierre = DateTime.Parse(Request["fechaCierre"]);

            web.AdministracionClient.ActualizarPeriodoCierre(periodoCierre, userName);

            //Reabrimos el periodo
            web.AdministracionClient.ActualizarEstadoPeriodoCierre(Convert.ToInt32(periodoCierre.id), Convert.ToInt32(estadoPeriodo.Abierto),userName);

            //Dejamos en pendiente el abierto
            web.AdministracionClient.ActualizarEstadoPeriodoCierre(Convert.ToInt32(Request["PeriodoIdAbierto"]), Convert.ToInt32(estadoPeriodo.Pendiente), userName);            
            
            //Llamamos sp para reabrir periodo
            web.AdministracionClient.SPPeriodoCierre(Convert.ToInt32(periodoCierre.compania_id), Convert.ToInt32(periodoCierre.mesCierre),  Convert.ToInt32(periodoCierre.anioCierre));

            return Json(new { Success = success, Messagge = "El proceso se realizó con éxito." });
        }

        public ActionResult ReprocesaPeriodo(string periodo)
        {
            string userName = HttpContext.Session["userName"].ToString();
            int anioCierre = Int32.Parse(periodo.Split('-')[0]);
            int mesCierre = Int32.Parse(periodo.Split('-')[1]);
            List<PeriodoCierre> periodosAbrir = web.AdministracionClient.ListarPeriodos().Where(x => x.anioCierre == anioCierre && x.mesCierre == mesCierre).ToList();
            List<PeriodoCierre> periodosCerrar = web.AdministracionClient.ListarPeriodos().Where(x => x.estado == 1).ToList();

            foreach (PeriodoCierre per in periodosAbrir)
            {               
                    per.estado = 1;
                    per.fechaCierre = DateTime.Parse(DateTime.Now.AddDays(2).ToShortDateString());
                    web.AdministracionClient.ActualizarPeriodoCierre(per, userName);
                    web.AdministracionClient.DeleteReprocesos(mesCierre, anioCierre);                
            }

            foreach (PeriodoCierre per in periodosCerrar)
            {
                per.estado = 2;                
                web.AdministracionClient.ActualizarPeriodoCierre(per, userName);
            }

            return Json(new { Success = true, Messagge = "El proceso se realizó con éxito." });
        }

        public ActionResult CerrarPeriodo(string periodo)
        {
            string userName = HttpContext.Session["userName"].ToString();
            int anioCierre = Int32.Parse(periodo.Split('-')[0]);
            int mesCierre = Int32.Parse(periodo.Split('-')[1]);
            List<PeriodoCierre> periodosCerrar = web.AdministracionClient.ListarPeriodos().Where(x => x.anioCierre == anioCierre && x.mesCierre == mesCierre).ToList();
            DateTime fechaminima = web.AdministracionClient.ListarPeriodos().Where(x => x.estado == 0).Min(x => (DateTime)x.fechaCierre);
            List<PeriodoCierre> cerrarPeriodosPendientes = web.AdministracionClient.ListarPeriodos().Where(x => x.estado == 0 && x.fechaCierre == fechaminima).ToList();

            foreach (PeriodoCierre per in periodosCerrar)
            {
                per.estado = 2;
                web.AdministracionClient.ActualizarPeriodoCierre(per, userName);
            }

            foreach (PeriodoCierre per in cerrarPeriodosPendientes)
            {
                per.estado = 2;
                web.AdministracionClient.ActualizarPeriodoCierre(per, userName);
            }

            return Json(new { Success = true, Messagge = "El proceso se realizó con éxito." });
        }
    }
}
