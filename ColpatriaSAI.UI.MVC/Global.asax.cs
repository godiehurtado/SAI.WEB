using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Globalization;
using System.Web.Routing;
using System.Web.Security;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Comun;
using ColpatriaSAI.Negocio.Entidades.Informacion;
using System.Web.Mvc;
using JsonValueProviderFactory = System.Web.Mvc.JsonValueProviderFactory;

namespace ColpatriaSAI.UI.MVC
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new NoCacheFilterAttribute());
        }

        public static void RegisterRoutes(RouteCollection routes)
        {
           


            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("{resource}.aspx/{*pathInfo}");
           

           // routes.MapRoute(
           //    "Login", // Route name
           //    "Login", // URL with parameters
           //    new { controller = "Cuenta", action = "LogOn", id = UrlParameter.Optional } // Parameter defaults
           //);
            routes.MapRoute(
               "Errores", // Route name
               "Errores", // URL with parameters
               new { controller = "Errores", action = "Index", id = UrlParameter.Optional } // Parameter defaults
           );

         //   routes.MapRoute(
         //    "Register", // Route name
         //    "Register", // URL with parameters
         //    new { controller = "Cuenta", action = "Register", id = UrlParameter.Optional } // Parameter defaults
         //);

            routes.MapRoute(
                 "Default",                                              // Route name
                 "{controller}/{action}/{id}",                           // URL with parameters
                 new { controller = "Home", action = "Index", id = "" }  // Parameter defaults
             );

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            ModelBinders.Binders.Add(typeof(double), 
                new ColpatriaSAI.UI.MVC.Areas.Comisiones.CustomModelBinders.DoubleModelBinder());

            RegisterGlobalFilters(GlobalFilters.Filters);
            RegisterRoutes(RouteTable.Routes);
            ValueProviderFactories.Factories.Add(new JsonValueProviderFactory());
            MvcHandler.DisableMvcResponseHeader = true; //Remover Encabezado Respuesta X-AspNetMvc-Version -- Issue 2016_CO021_PC_PwC_SAICOL_004: Platform exposure
        }

        protected void Application_AuthenticateRequest()
        {
            if (HttpContext.Current.User != null) {
                Membership.GetUser(true);
            }
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            if (HttpContext.Current.User != null)
                Membership.GetUser(true);
        }

        protected void Session_OnEnd(object sender, EventArgs e)
        {
            var a = 1;
 
        }
        protected void Application_Error(object sender, EventArgs e)
        {
            Exception error = Server.GetLastError().GetBaseException();
            string err = "Error en '" + Request.Url.ToString() + "'.<br /> Mensaje de error: '" + error.Message.ToString() + "'";
        }

        /// <summary>
        /// Remover Encabezado Respuesta Server Issue 2016_CO021_PC_PwC_SAICOL_004: Platform exposure
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Application_BeginRequest(object sender, EventArgs e) 
        {
            try
            {
                //Response.Headers.Set("Server", "Temporal");
                var application = sender as HttpApplication;
                if (application != null && application.Context != null)
                {
                    application.Context.Response.Headers.Remove("Server");
                }
            }
            catch (PlatformNotSupportedException) { }
        }

        /// <summary>
        /// Resuelve el Issue de Auditoria de Cookies, en desarrollo se debe dejar el Secure=false para que permita el ingreso
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        //protected void Application_EndRequest(object sender, EventArgs e) 
        //{
        //    if (Response.Cookies.Count > 0)
        //    {
        //        foreach (string s in Response.Cookies.AllKeys)
        //        {
        //             Response.Cookies[s].Secure = true;
        //        }
        //    }
        //}
        
    }
}
