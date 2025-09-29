using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class FiltroSessionExpiraAttribute : ActionFilterAttribute, IExceptionFilter 
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;
            
            // verficacion que session es soportada
            if (ctx.Session != null)
            {

                HttpCookie cogeCookie = ctx.Request.Cookies.Get("ASP.NET_SessionId");

                if (cogeCookie != null)
                {
                    var path = ctx.Request.CurrentExecutionFilePath;
                    int incrementoTimeout = 1;

                    if (path.Contains("/LiquidacionFranqui/") || path.Contains("/LiquidacionFranqui/LiquidarFranquicias") || path.Contains("/LiquidacionContrat/Create") || path.Contains("/LiquidacionContrat/LiquidarContratacion") || path.Contains("/Presupuesto/Carge") || path.Contains("/Presupuesto/CalcularMetas") || path.Contains("/Presupuesto/Detalle") || path.Contains("/Ejecucion/CargueManualEjecucionDetalle") || path.Contains("/Ejecucion/ProcesarCargueManualEjecucionDetalle"))
                        incrementoTimeout = 10;

                    cogeCookie.Expires = DateTime.Now.AddMinutes(ctx.Session.Timeout * incrementoTimeout);

                    ctx.Response.Cookies.Set(cogeCookie);

                    ctx.Session["expiresSession"] = cogeCookie.Expires;
                }
            }

            base.OnActionExecuting(filterContext);
        }

        /*
         * Controla el manejo de excepciones y enviarlos a log.
         */
        public void OnException(ExceptionContext filterContext)
        {
            HttpContext ctx = HttpContext.Current;
            string description = "Error generado en: Controller: " + ctx.Request.RequestContext.RouteData.GetRequiredString("controller") + " / Action : " + ctx.Request.RequestContext.RouteData.GetRequiredString("action") + " - Detalle Error: " + filterContext.Exception.Message + " " + filterContext.Exception.StackTrace;
            string modulo = ctx.Request.RequestContext.RouteData.GetRequiredString("controller");

            ColpatriaSAI.UI.MVC.Views.Shared.Logging.Error(description, Logging.Prioridad.Alta, modulo, TipoEvento.Error, Sesion.VariablesSesion());
        }

    }
}
