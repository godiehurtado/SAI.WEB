using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using ColpatriaSAI.UI.MVC.Controllers;
using ColpatriaSAI.UI.MVC.Views.Shared;
using SiteMap = ColpatriaSAI.Negocio.Entidades.SiteMap;

namespace ColpatriaSAI.UI.MVC.Reportes
{
    public class BasePage : System.Web.UI.Page
    {


        protected void Page_Init(object sender, EventArgs e)
        {
             if (System.Web.HttpContext.Current.Request.IsAuthenticated==false)
             {
                 Response.Redirect("/Cuenta/LogOn");
             }

            if (System.Web.HttpContext.Current.Request.IsAuthenticated && System.Web.HttpContext.Current.Session["UltimoIngreso"] == null)
            {
              
                Response.Redirect("/Cuenta/LogOff");
            }
            else
            {

                AuthorizeUser(HttpContext.Current.User.Identity.Name);
            }
         

            //ValidateSubmittedData();
        }

        protected virtual void AuthorizeUser(string user)
        {
            var controlador = "Reportes";
            string valorSeguridad = ConfigurationManager.AppSettings[controlador];
            foreach (string role in getRolesOpcion(valorSeguridad))
            {
                if (System.Web.HttpContext.Current.User.IsInRole(role))
                {
                    return;
                }
            }
            Response.Redirect("/Errores");

          
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
    }
}