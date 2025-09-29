using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ExtraccionController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase 
    {
        private ComisionesSVC.ComisionesClient _svcclient;
        //
        // GET: /Comisiones/Extraccion/

        [Authorize]
        public ActionResult Index()
        {
            return View();
        }

        [Authorize]
        public ActionResult Manual()
        {
            InvocacionForzadaViewModel vwmodel = new InvocacionForzadaViewModel();
            _svcclient = new ComisionesSVC.ComisionesClient();
            vwmodel.Procesos.AddRange(_svcclient.ListarProcesosExtraccion());
            return View(vwmodel);
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Manual(InvocacionForzadaViewModel vwmodel)
        {

            _svcclient = new ComisionesSVC.ComisionesClient();
            try
            {
                _svcclient.EjecutarPorcesoExtraccion(vwmodel.IdProcesoActual, vwmodel.inicioPeriodo.Value, vwmodel.finPeriodo.Value, vwmodel.CodigoEjecucion);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            vwmodel.Procesos.AddRange(_svcclient.ListarProcesosExtraccion());
            return View(vwmodel);
        }

        [Authorize]
        public ActionResult Programar()
        {
            return View();
        }


        public ActionResult LogExtraccion()
        {
            return View();
        }
    }
}
