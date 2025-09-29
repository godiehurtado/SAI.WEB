using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ColpatriaSAI.UI.MVC.Views.Shared
{
    public class WebPage// : IDisposable// : System.Web.UI.Page
    {
        public AdministracionSvc.AdministracionClient AdministracionClient { get; private set; }

        public WebPage()
        {
            if (this.AdministracionClient == null)
                this.AdministracionClient = new AdministracionSvc.AdministracionClient();
        }

        public void Liberar()
        {
            if (this.AdministracionClient != null) {
                if (this.AdministracionClient.State != System.ServiceModel.CommunicationState.Closed)
                    this.AdministracionClient.Close();
            }
        }

        public void MostrarMensaje(Object pagina, string tipo, string mensaje)
        {
            string script = @"Mensajes('" + tipo + "','" + mensaje + "');";
            ScriptManager.RegisterStartupScript((Control)pagina, ((Control)pagina).GetType(), "Notificacion", script, true);
        }
        //public void Dispose()
        //{
        //    Liberar();// throw new NotImplementedException();
        //}
    }
}