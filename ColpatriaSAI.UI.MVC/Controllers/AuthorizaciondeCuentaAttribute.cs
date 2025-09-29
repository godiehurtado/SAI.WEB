using System;
using System.Data.Linq;
using System.Data.Objects;
using System.Linq;
using System.Web.Mvc;
using System.Configuration;
using System.Web.Configuration;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Reflection;
using System.ComponentModel;
using System.Web.Routing;
using ColpatriaSAI.Datos;
using ColpatriaSAI.Seguridad.Encripcion;
using System.Data;
using SiteMap = ColpatriaSAI.Negocio.Entidades.SiteMap;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Web;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class AuthorizaciondeCuentaAttribute : System.Web.Mvc.AuthorizeAttribute
    {
        private Autorizado _autorizado;
        private enum Autorizado { Irlogin = 1, IrAutorizado = 2, IrErrores = 3, IrLogOff = 4 };

        protected override bool AuthorizeCore(System.Web.HttpContextBase httpContext)
        {
            bool siono = false;
            _autorizado = Autorizado.IrErrores;

            var a = System.Web.HttpContext.Current.Request.IsAuthenticated;

            System.Web.HttpContext ctx = HttpContext.Current;

            var b = ctx.Session["UserName"];

            if (System.Web.HttpContext.Current.Request.IsAuthenticated && ctx.Session["UserName"] == null)
            {
                _autorizado = Autorizado.IrLogOff;
            }
            else if (ctx.Session["UserName"] == null)
            {
                _autorizado = Autorizado.Irlogin;
            }
            else
            {

                var routeData = httpContext.Request.RequestContext.RouteData;
                var controlador = routeData.GetRequiredString("controller");
                var accion = routeData.GetRequiredString("action");

                // Obtener el código del controlador que determina los roles autorizados del 
                // archivo de configuración Rutas.config
                string valorSeguridad = ConfigurationManager.AppSettings[controlador];

                if (valorSeguridad != null)
                {
                    foreach (string role in getRolesOpcion(valorSeguridad))
                    {
                        if (System.Web.HttpContext.Current.User.IsInRole(role))
                        {
                            _autorizado = Autorizado.IrAutorizado;
                            siono = true;
                            break;
                        }
                    }
                }
            }

            return siono;
        }

        private List<string> getRolesOpcion(string codigosSeguridad)
        {
            List<string> listaRoles = new List<string>();
            char[] separator = { ',' };
            WebPage web = new WebPage();
            List<ColpatriaSAI.Negocio.Entidades.SiteMap> siteMapes = new List<ColpatriaSAI.Negocio.Entidades.SiteMap>();

            // Separar los codigos que se obtienen del archivo de configuración
            // Un controlador puede tener varios controladores padre quien determinan los roles de acceso
            string[] valoresSeguridad = codigosSeguridad.Split(separator);

            // Obtener de la BD los nodos completos del sitemap determinados por los codigos del archivo de configuración
            foreach (string valor in valoresSeguridad)
                siteMapes.AddRange(web.AdministracionClient.ListarSiteMapPorId(valor));

            // Obtener solamente los roles de cada nodo del sitemap
            foreach (SiteMap nodo in siteMapes)
                listaRoles.AddRange(nodo.Roles.ToString().Split(separator));

            // Retorna los roles en una lista. Quita los duplicados dado que 
            // varios nodos del sitemap pueden tener roles repetidos.
            return listaRoles.Distinct().ToList();
        }
        protected override void HandleUnauthorizedRequest(AuthorizationContext filterContext)
        {
            var controllerName = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
            var actionName = filterContext.ActionDescriptor.ActionName;

            if (_autorizado == Autorizado.IrErrores)
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "action", "Index" }, { "controller", "Errores" }, { "Area", String.Empty } });
            }
            if (_autorizado == Autorizado.Irlogin)
            {
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "action", "Index" }, { "controller", "Cuenta/LogOn" }, { "Area", String.Empty } });
            }
            if (_autorizado == Autorizado.IrLogOff)
            {
                var id = filterContext.RouteData.Values["id"];
                filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary { { "action", "Index" }, { "controller", "Cuenta/LogOff" }, { "expired", "true" }, { "Area", String.Empty } });
            }
        }
    }
}
