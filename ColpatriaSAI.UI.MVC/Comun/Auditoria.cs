using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class Auditoria : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var texto = ""; //var controlador = filterContext.RouteData.Values["controller"].ToString();
            var action = filterContext.RouteData.Values["action"].ToString();
            string modulo = ""; string fechaHora = " Fecha y Hora: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToLongTimeString();
            switch (action) {
                case "LiquidarContratacion":
                    texto = "Inició Liquidación de la Contratación." + fechaHora;
                    modulo = Modulo.Contratacion;
                    break;
                case "LiquidarFranquicias":
                    texto = "Inició Liquidación de Franquicias." + fechaHora;
                    modulo = Modulo.Franquicias;
                    break;
            }
            if (modulo != "") Logging.Auditoria(texto, Logging.Prioridad.Alta, modulo, Sesion.VariablesSesion());
            base.OnActionExecuting(filterContext);
        }

        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            var texto = ""; //var controlador = filterContext.RouteData.Values["controller"].ToString();
            var action = filterContext.RouteData.Values["action"].ToString();
            string modulo = ""; string fechaHora = " Fecha y Hora: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToLongTimeString();
            switch (action) {
                case "LiquidarContratacion":
                    texto = "Finalizó Liquidación de la Contratación." + fechaHora;
                    modulo = Modulo.Contratacion;
                    break;
                case "LiquidarFranquicias":
                    texto = "Finalizó Liquidación de Franquicias." + fechaHora;
                    modulo = Modulo.Franquicias;
                    break;
            }
            if (modulo != "") Logging.Auditoria(texto, Logging.Prioridad.Alta, modulo, Sesion.VariablesSesion());
            base.OnActionExecuted(filterContext);
        }
    }
}