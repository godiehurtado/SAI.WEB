using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Web;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using System.Web.Caching;
using System.Xml;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.Seguridad.Proveedores;
using Encrypt1_1;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades.Informacion;
using ColpatriaSAI.UI.MVC.wsAutenticacion;
using System.Net;
using System.Configuration;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    [FiltroSessionExpira]
    [HandleError]
    public class CuentaController : Controller
    {
        //Este Constructor es usado por el MVC framework para instanciar el controlador usando
        //la forma default de autenticación y el membershipprovider
        public CuentaController()
            : this(null, null)
        {
        }

        //Este contructor no es usado por el MVC framework, pero es usado con propositos de pruebas unitarias
        //Ver los comentarios al final del archivo para mas información
        public CuentaController(IFormsAuthentication formsAuth, IMembershipService service)
        {
            FormsAuth = formsAuth ?? new FormsAuthenticationService();
            MembershipService = service ?? new AccountMembershipService();
        }

        public IFormsAuthentication FormsAuth
        {
            get;
            private set;
        }

        public IMembershipService MembershipService
        {
            get;
            private set;
        }

        public ActionResult LogOn()
        {
            var sessionexpired = Request["expired"];
            ViewData["sessionexpired"] = sessionexpired;
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1054:UriParametersShouldNotBeStrings",
            Justification = "Needs to take same parameter type as Controller.Redirect()")]

        public ActionResult LogOn(string userName, string password, string returnUrl)
        {
            HttpContext.Session["userName"] = userName;
            if (!ValidateLogOn(userName, password))
            // if (true)//Se cambia para hacer login errorservicioaut
            {
               return View();
            }
            FormsAuth.SignIn(userName);
            if (!String.IsNullOrEmpty(returnUrl))
                return Redirect(returnUrl);
            else
                return RedirectToAction("Index", "Home");
        }

        public ActionResult LogOff()
        {
            var sessionexpired = Request["expired"];
            FormsAuth.SignOut();
            Logging.Auditoria("El usuario " + User.Identity.Name + " ha terminado sesión.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());

            // Eliminar el cache que permite guardar el menu del sitemap. Lo debe refrescar
            ClearCache();
            HttpContext.Session["userName"] = null;
            HttpContext.Session.Abandon();
            return RedirectToAction("LogOn", "Cuenta", new { expired = sessionexpired });
        }

        public ActionResult ActualizarSession()
        {
            //La session se actualiza por medio del FiltroSessionExpira
            DateTime expiresSession = Convert.ToDateTime(Session["expiresSession"]);
            return Json(new { Success = true, anio = expiresSession.Year, mes = expiresSession.Month, dia = expiresSession.Day, hora = expiresSession.Hour, minutos = expiresSession.Minute });
        }

        private void ClearCache()
        {
            Cache cache = HttpRuntime.Cache;
            List<string> keys = new List<string>();
            foreach (DictionaryEntry entry in cache)
            {
                keys.Add((string)entry.Key);
            }
            foreach (string key in keys)
            {
                cache.Remove(key);
            }
        }

        public ActionResult Register()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult Register(string userName, string email, string password, string confirmPassword)
        {

            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

            if (ValidateRegistration(userName, email, password, confirmPassword))
            {
                // Registra el usuario
                MembershipCreateStatus createStatus = MembershipService.CreateUser(userName, password, email);

                if (createStatus == MembershipCreateStatus.Success)
                {
                    FormsAuth.SignIn(userName /* createPersistentCookie */);
                    return RedirectToAction("Index", "Home");
                }
                else
                    ModelState.AddModelError("_FORM", ErrorCodeToString(createStatus));
            }

            // si algo sale mal muestra otra vez el formulario
            return View();
        }

        [Authorize]
        public ActionResult ChangePassword()
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return View();
        }

        [Authorize]
        [AcceptVerbs(HttpVerbs.Post)]
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes",
            Justification = "Exceptions result in password not being changed.")]
        public ActionResult ChangePassword(string currentPassword, string newPassword, string confirmPassword)
        {
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

            if (!ValidateChangePassword(currentPassword, newPassword, confirmPassword))
                return View();
            try
            {
                if (MembershipService.ChangePassword(User.Identity.Name, currentPassword, newPassword))
                    return RedirectToAction("ChangePasswordSuccess");
                else
                {
                    ModelState.AddModelError("_FORM", "The current password is incorrect or the new password is invalid.");
                    return View();
                }
            }
            catch
            {
                ModelState.AddModelError("_FORM", "The current password is incorrect or the new password is invalid.");
                return View();
            }
        }

        public ActionResult ChangePasswordSuccess()
        {
            return View();
        }

        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext.HttpContext.User.Identity is WindowsIdentity)
                throw new InvalidOperationException("Windows authentication is not supported.");
        }

        #region Validation Methods

        /// <summary>
        /// Metodo que se encarga de validar el cambio de contraseña
        /// </summary>
        /// <param name="currentPassword">Primer contraseña</param>
        /// <param name="newPassword">Nueva contraseña</param>
        /// <param name="confirmPassword">Confirmacion de nueva contraseña</param>
        /// <returns>True: Para transaccion con Exito, False para transaccion no existosa</returns>
        private bool ValidateChangePassword(string currentPassword, string newPassword, string confirmPassword)
        {
            if (String.IsNullOrEmpty(currentPassword))
            {
                ModelState.AddModelError("currentPassword", "You must specify a current password.");
            }
            if (newPassword == null || newPassword.Length < MembershipService.MinPasswordLength)
            {
                ModelState.AddModelError("newPassword",
                    String.Format(CultureInfo.CurrentCulture,
                         "You must specify a new password of {0} or more characters.",
                         MembershipService.MinPasswordLength));
            }

            if (!String.Equals(newPassword, confirmPassword, StringComparison.Ordinal))
                ModelState.AddModelError("_FORM", "The new password and confirmation password do not match.");

            return ModelState.IsValid;
        }

        /// <summary>
        /// Metodo que se encarga de validar si el usuario entro con Exito
        /// </summary>
        /// <param name="userName">Usuario logueado</param>
        /// <param name="password">Contraseña de Usuario</param>
        /// <returns>True: Para transaccion con Exito, False para transaccion no existosa</returns>
        private bool ValidateLogOn(string userName, string password)
        {
          //  return true;
            //Instancia la nueva forma de autenticacion para consumir el servicio
            ServiceClient service = new ServiceClient(ConfigurationManager.AppSettings["AUTE_Binding"]);

            //Validacion de Usuario y Contraseña
            if (String.IsNullOrEmpty(userName))
                ModelState.AddModelError("username", "Usted debe especificar el nombre del usuario.");
            if (String.IsNullOrEmpty(password))
                ModelState.AddModelError("password", "Usted debe especificar una contraseña.");

            #region Consume el servicio Nuevo

            // Obtener la IP del servidor
            string myHost = Dns.GetHostName();
            string myIP = Dns.GetHostEntry(myHost).AddressList[0].ToString();
            string IdAplicacion = "b3f7e73f-366f-4b69-8509-ddc58093d2e8";

            //LLama al servicio de autenticacion
            Usuario autenticacion = service.AutenticaPorAplicacion(userName, password, myIP, IdAplicacion);
            HttpContext.Session["IdDocumento"] = autenticacion.NumeroIdentificacion;

            // Cuando se cae el WS de Aut
            // Comentar las (2) líneas de arriba y descomentar las
            // (4) de abajo
            
            
            //1. Usuario autenticacion = new Usuario();
            //2. HttpContext.Session["IdDocumento"] = "";
            //3. HttpContext.Session["userName"] = "";
            //4.    autenticacion.Estado = Estado.OK;

            //Verifica q la la autenticacion sea exitosa
            if (autenticacion.Estado == Estado.OK)
            {
                if (!MembershipService.authenticationOk(autenticacion, userName))
                    ModelState.AddModelError("_FORM", "El nombre de usuario y/o contraseña es incorrecta.");
            }
            else
                ModelState.AddModelError("_FORM", "El nombre de usuario y/o contraseña es incorrecta.");

            #endregion
            #region No Borrar (Consume el servicio viejo)
            /*
                if (!MembershipService.ValidateUser(userName, password))
                {
                    ModelState.AddModelError("_FORM", "El nombre de usuario y/o contraseña es incorrecta.");
                } */
            #endregion

            return ModelState.IsValid;
        }

        /// <summary>
        /// Metodo que se encarga de registrar un nuevo usuario
        /// </summary>
        /// <param name="userName">Nombre de Usuario</param>
        /// <param name="email">Correo de usuario</param>
        /// <param name="password">Constraseña usuario</param>
        /// <param name="confirmPassword">Confirmacion de Contraseña</param>
        /// <returns>True: Para transaccion con Exito, False para transaccion no existosa</returns>
        private bool ValidateRegistration(string userName, string email, string password, string confirmPassword)
        {
            if (String.IsNullOrEmpty(userName))
                ModelState.AddModelError("username", "You must specify a username.");
            if (String.IsNullOrEmpty(email))
                ModelState.AddModelError("email", "You must specify an email address.");
            if (password == null || password.Length < MembershipService.MinPasswordLength)
            {
                ModelState.AddModelError("password",
                    String.Format(CultureInfo.CurrentCulture,
                         "You must specify a password of {0} or more characters.",
                         MembershipService.MinPasswordLength));
            }
            if (!String.Equals(password, confirmPassword, StringComparison.Ordinal))
            {
                ModelState.AddModelError("_FORM", "The new password and confirmation password do not match.");
            }
            return ModelState.IsValid;
        }

        /// <summary>
        /// Validacion Errores
        /// </summary>
        /// <param name="createStatus"></param>
        /// <returns></returns>
        private static string ErrorCodeToString(MembershipCreateStatus createStatus)
        {
            // See http://msdn.microsoft.com/en-us/library/system.web.security.membershipcreatestatus.aspx for
            // a full list of status codes.
            switch (createStatus)
            {
                case MembershipCreateStatus.DuplicateUserName:
                    return "Username already exists. Please enter a different user name.";

                case MembershipCreateStatus.DuplicateEmail:
                    return "A username for that e-mail address already exists. Please enter a different e-mail address.";

                case MembershipCreateStatus.InvalidPassword:
                    return "The password provided is invalid. Please enter a valid password value.";

                case MembershipCreateStatus.InvalidEmail:
                    return "The e-mail address provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidAnswer:
                    return "The password retrieval answer provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidQuestion:
                    return "The password retrieval question provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.InvalidUserName:
                    return "The user name provided is invalid. Please check the value and try again.";

                case MembershipCreateStatus.ProviderError:
                    return "The authentication provider returned an error. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                case MembershipCreateStatus.UserRejected:
                    return "The user creation request has been canceled. Please verify your entry and try again. If the problem persists, please contact your system administrator.";

                default:
                    return "An unknown error occurred. Please verify your entry and try again. If the problem persists, please contact your system administrator.";
            }
        }
        #endregion
    }

    // El tipo de autenticacion por forms es muy cerrada y contiene miembros estaticos , lo que la hace dificil de hacer pruebas unitarias 
    //para llamar sus miembros. La interfaz y la clase helper siguientes demuestran como abstraer este tipo para poder hacer del controlador de cuenta 
    //testeable
    public interface IFormsAuthentication
    {
        void SignIn(string userName);
        void SignOut();
    }

    public class FormsAuthenticationService : IFormsAuthentication
    {
        public void SignIn(string userName)
        {
            FormsAuthentication.SetAuthCookie(userName, false);
        }
        public void SignOut()
        {
            FormsAuthentication.SignOut();
        }
    }

    public interface IMembershipService
    {
        int MinPasswordLength { get; }

        //bool ValidateUser(string userName, string password);
        MembershipCreateStatus CreateUser(string userName, string password, string email);
        bool ChangePassword(string userName, string oldPassword, string newPassword);
        bool authenticationOk(Usuario autenticacion, string userName);
    }

    public class AccountMembershipService : IMembershipService
    {
        private MembershipProvider _provider;

        public AccountMembershipService(): this(null){ }

        public AccountMembershipService(MembershipProvider provider)
        {
            _provider = provider ?? Membership.Provider;
        }

        public int MinPasswordLength
        {
            get { return _provider.MinRequiredPasswordLength; }
        }

        #region NO BORRAR

        //Anterior forma de consumir el servicio para autenticacion
        /// <summary>
        /// Consume el web service de autenticación de Colpatria
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        /*public bool ValidateUser(string userName, string password)
        {
            Autenticacion.AuthenticacionClient au = new Autenticacion.AuthenticacionClient();
            ColpatriaSAI.Negocio.Entidades.stream stream = new stream();
            stream.header = new streamHeader();


            stream.header.Transaccion = System.Configuration.ConfigurationManager.AppSettings["Transaccion"];
            stream.header.IpRequest = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            stream.header.DataSource = System.Configuration.ConfigurationManager.AppSettings["DataSource"];
            stream.header.Company = System.Configuration.ConfigurationManager.AppSettings["Company"];
            stream.header.Aplication = System.Configuration.ConfigurationManager.AppSettings["Aplication"];
            stream.header.DataBase = System.Configuration.ConfigurationManager.AppSettings["DataBase"];
            HttpContext.Current.Session["Ambiente"] = System.Configuration.ConfigurationManager.AppSettings["Ambiente"];

            Encrypt1_1.Encrypt enc = new Encrypt();

            stream.parameters = new streamParameters();
            stream.parameters.NroDoc = userName;
            stream.parameters.TipoDoc = "CC";
            stream.parameters.Pws = enc.Encrypt(password);
            stream.parameters.Perfil = "FN";

            string userxml2 = stream.SerializeObjectToXML(stream);
            //userxml.Replace(

            string resultado = au.ValidateUser(userxml2, null);
            if (resultado != null)
            {
                if (Helper.traerInnerStringNodoXML(resultado, "mensaje").ToUpper() == "OK")
                {
                    MembershipSection section = WebConfigurationManager.GetSection("system.web/membership") as MembershipSection;

                    WebServiceMembershipProvider _provider2 = new WebServiceMembershipProvider();//"AspNetSqlMembershipProvider", section.Providers[0].Parameters);
                    _provider2.Initialize("AspNetSqlMembershipProvider", section.Providers[0].Parameters);

                    if (_provider2.ValidateUser(userName, userName))
                    {
                        HttpContext.Current.Session["NombreUser"] = userName;
                        HttpContext.Current.Session["UltimoIngreso"] = Helper.traerInnerStringNodoXML(resultado, "UltimoIngreso");
                        HttpContext.Current.Session["IPUltimoIngreso"] = Helper.traerInnerStringNodoXML(resultado, "IPUltimoIngreso");
                        return true;
                    }
                    else
                        return false;
                }
                else
                    return false;
            }
            else
                return false;
        }*/

        #endregion

        /// <summary>
        /// Validacion de autenticacion de usario
        /// </summary>
        /// <param name="autenticacion">Clase con sus propiedades</param>
        /// <param name="userName">Nombre Usuario</param>
        /// <returns>True: Para transaccion con Exito, False para transaccion no existosa</returns>
        public bool authenticationOk(Usuario autenticacion, string userName)
        {
            MembershipSection section = WebConfigurationManager.GetSection("system.web/membership") as MembershipSection;

            WebServiceMembershipProvider _provider2 = new WebServiceMembershipProvider();//"AspNetSqlMembershipProvider", section.Providers[0].Parameters);
            _provider2.Initialize("AspNetSqlMembershipProvider", section.Providers[0].Parameters);

            if (_provider2.ValidateUser(userName, userName))
            {
                HttpContext.Current.Session["NombreUser"] = userName;
                HttpContext.Current.Session["UltimoIngreso"] = autenticacion.FechaUltimoIngreso;
                HttpContext.Current.Session["IPUltimoIngreso"] = autenticacion.IPUltimoIngreso;
                return true;
            }
            else
                return false;
        }

        public MembershipCreateStatus CreateUser(string userName, string password, string email)
        {
            MembershipCreateStatus status;
            _provider.CreateUser(userName, password, email, null, null, true, null, out status);
            return status;
        }

        public bool ChangePassword(string userName, string oldPassword, string newPassword)
        {
            MembershipUser currentUser = _provider.GetUser(userName, true /* userIsOnline */);
            return currentUser.ChangePassword(oldPassword, newPassword);
        }

    }
}
