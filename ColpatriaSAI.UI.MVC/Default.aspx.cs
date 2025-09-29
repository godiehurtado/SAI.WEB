using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI;
using System.Web.UI.WebControls;
using ColpatriaSAI.Negocio.Entidades.Informacion;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC
{
    public partial class Default : System.Web.UI.Page
    {
        public InfoAplicacion InformacionAplicacion
        {
            get {
                return Sesion.VariablesSesion();
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //Logging.Auditoria("Mensaje de Prueba de Auditoria", Logging.Prioridad.Baja, Modulo.General, InformacionAplicacion);
            //Logging.Error("Mensaje de Prueba de Correo", Logging.Prioridad.MuyAlta, Modulo.General, TipoEvento.Error, InformacionAplicacion);
            // Change the current path so that the Routing handler can correctly interpret
            // the request, then restore the original path so that the OutputCache module  
            // can correctly process the response (if caching is enabled).  
            string originalPath = Request.Path;
            HttpContext.Current.RewritePath(Request.ApplicationPath, false);
            IHttpHandler httpHandler = new MvcHttpHandler();
            httpHandler.ProcessRequest(HttpContext.Current);
            HttpContext.Current.RewritePath(originalPath, false);
        }
    }
}
