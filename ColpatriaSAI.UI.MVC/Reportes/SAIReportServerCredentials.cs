using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Reporting.WebForms;
using System.Net;
using System.Security.Principal;
using System.Configuration;

namespace ColpatriaSAI.UI.MVC.Reportes
{
    [Serializable]
    public class SAIReportServerCredentials : IReportServerCredentials
    {
        public WindowsIdentity ImpersonationUser
        {
            get
            {
                // Use the default Windows user.  Credentials will be
                // provided by the NetworkCredentials property.
                return null;
            }
        }

        public ICredentials NetworkCredentials
        {
            get
            {
                // Read the user information from the Web.config file.  
                // By reading the information on demand instead of 
                // storing it, the credentials will not be stored in 
                // session, reducing the vulnerable surface area to the
                // Web.config file, which can be secured with an ACL.

                // User name
                string userName = ConfigurationManager.AppSettings["SAIReportViewerUser"];


                if (string.IsNullOrEmpty(userName))
                    throw new Exception("No se encuentra el usuario de reportes en el archivo de configuración");

                // Password
                string password = ConfigurationManager.AppSettings["SAIReportViewerPassword"];


                if (string.IsNullOrEmpty(password))
                    throw new Exception("No se encuentra el usuario de reportes en el archivo de configuración");

                // Domain
                string domain = ConfigurationManager.AppSettings["SAIReportViewerDomain"];

                if (string.IsNullOrEmpty(domain))
                    throw new Exception("No se encuentra el usuario de reportes en el archivo de configuración");

                return new NetworkCredential(userName, password, domain);
            }
        }

        public bool GetFormsCredentials(out Cookie authCookie,out string userName, out string password,out string authority)
        {
            authCookie = null;
            userName = null;
            password = null;
            authority = null;

            // Not using form credentials
            return false;
        }
    }
}