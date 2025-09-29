using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    [SessionState(SessionStateBehavior.Disabled)]
    public class SessionLessController : Controller
    {
        //
        // GET: /SessionLess/

        WebPage web = new WebPage();

        public ActionResult ValidarProceso()
        {
            int idProceso = 0;

            idProceso = web.AdministracionClient.ObtenerProcesoLiquidacion();

            return Json(new { Success = true, idProceso = idProceso });
        }

        public ActionResult ValidarProcesos()
        {
            var lista = web.AdministracionClient.ObtenerProcesosEnCurso();
            return Json(lista, 0);
        }

        public ActionResult ValidarProcesosACancelar()
        {
            var idLiquidacion = Convert.ToInt32(Request["idLiquidacion"]);
            var lista = web.AdministracionClient.ObtenerProcesosEnCurso();
            var success = false;

            var proceso = lista.Where(x => x.id == idLiquidacion).FirstOrDefault();

            if (proceso == null)
                success = true;                    

            return Json(new {Success = success});
        }

        public ActionResult ValidarProcesosACancelarxTipo()
        {
            var idTipo = Convert.ToInt32(Request["idTipo"]);
            var lista = web.AdministracionClient.ObtenerProcesosEnCurso();
            var success = false;

            var proceso = lista.Where(x => x.tipo == idTipo).FirstOrDefault();

            if (proceso == null)
                success = true;

            return Json(new { Success = success });
        }

        public ActionResult EliminarProcesos()
        {
            //Eliminamos todos los proceso de estado 4 de la tabla de procesos. Estado 4 indica que ya termino el proceso
           var lista = ""; //web.AdministracionClient.EliminarProcesosEnCurso(HttpContext.Session["userName"].ToString());
            return Json(lista, 0);
        }

        public ActionResult CancelarProceso(int id)
        {
            web.AdministracionClient.CancelarProceso(id, HttpContext.Session["userName"].ToString());
            return Json("", 0);
        }

        public ActionResult ActualizarSession()
        {
            //La session se actualiza por medio del FiltroSessionExpira
            DateTime expiresSession = DateTime.Now.AddMinutes(4);
            return Json(new { Success = true, anio = expiresSession.Year, mes = expiresSession.Month, dia = expiresSession.Day, hora = expiresSession.Hour, minutos = expiresSession.Minute });
        }

    }
}
