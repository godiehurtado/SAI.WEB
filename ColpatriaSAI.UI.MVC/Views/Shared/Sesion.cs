using System;
using System.Collections.Specialized;
using System.Web;
using ColpatriaSAI.Negocio.Entidades.Informacion;

namespace ColpatriaSAI.UI.MVC.Views.Shared
{
    public static class Sesion
    {
        //private static System.Web.SessionState.HttpSessionState EstadoSesion;

        ///// <summary>
        ///// Obtiene en la sesión actual información guardada por tipo
        ///// </summary>
        ///// <typeparam name="T"></typeparam>
        ///// <param name="valorSesion">Tipo de información a obtener de la sesión</param>
        ///// <returns>Valor del tipo de sesión solicitado</returns>
        //internal static T ObtenerValorSession<T>(ValoresSesion valorSesion)
        //{
        //    T valor = default(T);
        //    if (HttpContext.Current.Session != null)
        //    {
        //        EstadoSesion = HttpContext.Current.Session;
        //        if (EstadoSesion[valorSesion.ToString()] != null)
        //        {
        //            try
        //            {
        //                valor = (T)EstadoSesion[valorSesion.ToString()];
        //            }
        //            catch
        //            { }
        //        }
        //        else
        //        {
        //            EstadoSesion[valorSesion.ToString()] = valor;
        //        }
        //    }
        //    //else {
        //    //    AsignarValorSession<T>(valorSesion,
        //    //}
        //    return valor;
        //}

        ///// <summary>
        ///// Establece en la sesión actual información según tipo
        ///// </summary>
        ///// <typeparam name="T"></typeparam>
        ///// <param name="valorSesion">Tipo de información a establecer en la sesión</param>
        ///// <param name="valor">Valor de la información a establecer en la sesión</param>
        //internal static void AsignarValorSession<T>(ValoresSesion valorSesion, T valor)
        //{
        //    if (HttpContext.Current.Session != null)
        //    {
        //        EstadoSesion = HttpContext.Current.Session;
        //        EstadoSesion[valorSesion.ToString()] = valor;
        //    }
        //    else {
        //        HttpContext.Current.Session.Add(valorSesion.ToString(), valor);
        //    }    
        //}

        public static InfoAplicacion InfoApp;

        //public Sesion() {
        //    InfoApp = VariablesSesion(HttpContext.Current.Request.ServerVariables);
        //}

        /// <summary>
        /// Obtiene valores de la sesión remota
        /// </summary>
        /// <param name="variable">Variable de sesión a obtener</param>
        /// <returns>Valor de la sesión obtenida</returns>
        public static InfoAplicacion VariablesSesion()
        {
            NameValueCollection variables = HttpContext.Current.Request.ServerVariables;
            InfoApp = new InfoAplicacion();

            var IpCliente = HttpContext.Current.Request.UserHostAddress.ToString();
            if (!string.IsNullOrEmpty(IpCliente))
            {
                var IPs = variables["HTTP_X_FORWARDED_FOR"];
                if (!string.IsNullOrEmpty(IPs))
                    IpCliente = IPs.Split(',')[0].Trim();
                else
                    IpCliente = variables["REMOTE_ADDR"];
            }

            InfoApp.NombreUsuario = (variables["AUTH_USER"] != null ? variables["AUTH_USER"] : "").ToLower();
            InfoApp.DireccionIP = IpCliente;
            return InfoApp;
        }
        //Sesion.VariablesSesion(HttpContext.Current.Request.ServerVariables)
    }
}