using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Web.Configuration;
using System.Web.Mvc;
using System.Web.Security;
using ColpatriaSAI.Seguridad.Proveedores;
using ColpatriaSAI.UI.MVC.Views.Shared;
using MvcMembership;
using ColpatriaSAI.UI.MVC.Areas.UserAdministration.Models.UserAdministration;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.UserAdministration.Controllers
{
    //[Authorize(Roles = "Administrator")]
    public class UserAdministrationController : Controller
    {
        private const int PageSize = 10;
        private const string ResetPasswordBody = "Su nuevo  password es: ";
        private const string ResetPasswordFromAddress = "from@domain.com";
        private const string ResetPasswordSubject = "Su nuevo password";
        private readonly IRolesService _rolesService;
        private readonly ISmtpClient _smtpClient;
        private readonly IUserService _userService;
        private readonly IPasswordService _passwordService;
        static MembershipSection section = WebConfigurationManager.GetSection("system.web/membership") as MembershipSection;
        WebPage web = new WebPage();

        static WebServiceMembershipProvider _provider2 = new WebServiceMembershipProvider();

        static WebServiceRoleProvider rol2 = new WebServiceRoleProvider();
        public UserAdministrationController()
            : this(
                new AspNetMembershipProviderWrapper(_provider2),
                new AspNetMembershipProviderWrapper(_provider2),
                new AspNetRoleProviderWrapper(rol2),
                new SmtpClientProxy(new SmtpClient()))

        //public UserAdministrationController()
        //    : this(
        //        new AspNetMembershipProviderWrapper(Membership.Provider),
        //        new AspNetMembershipProviderWrapper(Membership.Provider),
        //        new AspNetRoleProviderWrapper(Roles.Provider),
        //        new SmtpClientProxy(new SmtpClient()))
        {

        }

        public UserAdministrationController(
            IUserService userService,
            IPasswordService passwordService,
            IRolesService rolesService,
            ISmtpClient smtpClient)
        {
            _provider2.Initialize("AspNetSqlMembershipProvider", section.Providers[0].Parameters);
            _userService = userService;
            _passwordService = passwordService;
            _rolesService = rolesService;
            _smtpClient = smtpClient;
        }

        public ViewResult Index(int? index)
        {
            WebPage web = new WebPage();
            List<Negocio.Entidades.TipoDocumento> documentos = web.AdministracionClient.ListarTipodocumentoes();
            List<Negocio.Entidades.Segmento> segmentos = web.AdministracionClient.ListarSegmentoes();
            return View(new IndexViewModel
                            {
                                Users = _userService.FindAll(index ?? 0, PageSize),
                                Roles = _rolesService.FindAll(),
                                TipoDocumentos = documentos.ToDictionary(doc => doc.id, doc => doc.nombre),
                                Segmentos = segmentos.ToDictionary(seg => seg.id, seg => seg.nombre)
                            });
        }

        [HttpPost]
        public PartialViewResult buscar(string filter, int index = 0)
        {
            return PartialView("_UsersPagedList", _userService.GetUsersByAllFilter(filter, index, PageSize));
        }


        public JsonResult CreateUser()
        {
            string nombreUsuario = Request["nombreUsuario"];
            string tipoDocumento = Request["tipoDocumento"];
            string numeroDocumento = Request["numeroDocumento"];
            string email = Request["email"];
            string rol = Request["rol"];
            string segmento = Request["segmento"];
            int idsegmento = web.AdministracionClient.ListarSegmentoes().Where(x => x.nombre == segmento).FirstOrDefault().id;
            string abrtipodoc = web.AdministracionClient.ListarTipodocumentoes().Where(x => x.nombre == tipoDocumento).FirstOrDefault().abreviatura;
            web.AdministracionClient.CrearUsuario(nombreUsuario, abrtipodoc, numeroDocumento, email, rol, idsegmento, HttpContext.Session["userName"].ToString());
            return Json(new { Success = true });
        }

        public JsonResult CreateRole()
        {
            string nombreRol = Request["nombreRol"];
            _rolesService.Create(nombreRol);
            Logging.Auditoria("Creación del registro: " + nombreRol + " en la tabla: " + "aspnet_Roles", Logging.Prioridad.Baja,
              Modulo.General, Sesion.VariablesSesion());
            return Json(new { Success = true });
        }

        //[AcceptVerbs(HttpVerbs.Post)]
        //public RedirectToRouteResult CreateRole(string id)
        //{
        //    _rolesService.Create(id);
        //    Logging.Auditoria("Creación del registro: " + id + " en la tabla: " + "aspnet_Roles", Logging.Prioridad.Baja,
        //      Modulo.General, Sesion.VariablesSesion());
        //    return RedirectToAction("Index");
        //}

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult DeleteRole(string id)
        {
            _rolesService.Delete(id);
            Logging.Auditoria("Eliminación del registro: " + id + " en la tabla: " + "aspnet_Roles", Logging.Prioridad.Baja,
             Modulo.General, Sesion.VariablesSesion());
            return RedirectToAction("Index");
        }

        public ViewResult Role(string id)
        {
            return View(new RoleViewModel
                            {
                                Role = id,
                                Users = _rolesService.FindUserNamesByRole(id).Select(username => _userService.Get(username))
                            });
        }

        public ViewResult Details(Guid id)
        {
            var user = _userService.Get(id);
            var userRoles = _rolesService.FindByUser(user);
            var userSegmentos = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == user.UserName);
            var segmentos = web.AdministracionClient.ListarSegmentoes();
            return View(new DetailsViewModel
                            {
                                DisplayName = user.UserName,
                                User = user,
                                Roles = _rolesService.FindAll().ToDictionary(role => role, role => userRoles.Contains(role)),
                                Status = user.IsOnline
                                            ? DetailsViewModel.StatusEnum.Online
                                            : !user.IsApproved
                                                ? DetailsViewModel.StatusEnum.Unapproved
                                                : user.IsLockedOut
                                                    ? DetailsViewModel.StatusEnum.LockedOut
                                                    : DetailsViewModel.StatusEnum.Offline,
                                Segmentos = segmentos.ToDictionary(seg => seg.nombre, seg => userSegmentos.Select(x => x.segmento_id).Contains(seg.id))
                            });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult Details(Guid id,
                                    [Bind(Prefix = "User.Email")] string email,
                                    [Bind(Prefix = "User.Comment")] string comment)
        {
            var user = _userService.Get(id);
            user.Email = email;
            user.Comment = comment;
            _userService.Update(user);
            return RedirectToAction("Details", new { id });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult DeleteUser(Guid id)
        {
            _userService.Delete(_userService.Get(id));
            Logging.Auditoria("Eliminación del registro: " + id + " en la tabla: " + "aspnet_Users", Logging.Prioridad.Baja,
            Modulo.General, Sesion.VariablesSesion());
            return RedirectToAction("Index");
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult ChangeApproval(Guid id, bool isApproved)
        {
            var user = _userService.Get(id);
            string registroanterior = "";
            foreach (KeyValuePair<string, object> keyValuePair in ViewData)
            {
                registroanterior = keyValuePair.Key + "=" + keyValuePair.Value;
            }
            user.IsApproved = isApproved;
            _userService.Update(user);
            Logging.Auditoria("Actualización del registro: " + id + " en la tabla: " + "aspnet_Users" + " registroanterior:" + registroanterior, Logging.Prioridad.Baja,
          Modulo.General, Sesion.VariablesSesion());
            return RedirectToAction("Details", new { id });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult Unlock(Guid id)
        {
            _passwordService.Unlock(_userService.Get(id));
            return RedirectToAction("Details", new { id });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult ResetPassword(Guid id, string answer)
        {
            var user = _userService.Get(id);
            var newPassword = _passwordService.ResetPassword(user, answer);

            var body = ResetPasswordBody + newPassword;
            _smtpClient.Send(new MailMessage(ResetPasswordFromAddress, user.Email, ResetPasswordSubject, body));

            return RedirectToAction("Details", new { id });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult AddToRole(Guid id, string role)
        {

            _rolesService.AddToRole(_userService.Get(id), role);
            Logging.Auditoria("Creacion del registro: " + id + " en la tabla: " + "aspnet_Roles",
                              Logging.Prioridad.Baja,
                              Modulo.General, Sesion.VariablesSesion());
            return RedirectToAction("Details", new { id });

        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult RemoveFromRole(Guid id, string role)
        {
            _rolesService.RemoveFromRole(_userService.Get(id), role);
            Logging.Auditoria("Actualizacion del registro: " + id + " en la tabla: " + "aspnet_UsersInRoles" + " Con el Rol:" + role, Logging.Prioridad.Baja,
      Modulo.General, Sesion.VariablesSesion());
            return RedirectToAction("Details", new { id });
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult AddToSegmento(Guid id, string username, string seg)
        {
            string userName = HttpContext.Session["userName"].ToString();
            username = username.ToLower();
            UsuarioxSegmento usuarioxsegmento = new UsuarioxSegmento();
            usuarioxsegmento.userName = username;
            usuarioxsegmento.segmento_id = web.AdministracionClient.ListarSegmentoes().Where(x => x.nombre == seg).FirstOrDefault().id;
            web.AdministracionClient.InsertarSegmentodeUsuario(usuarioxsegmento, username);

            return RedirectToAction("Details", new { id });

        }

        [AcceptVerbs(HttpVerbs.Post)]
        public RedirectToRouteResult RemoveFromSegmento(Guid id, string username, string seg)
        {
            string userName = HttpContext.Session["userName"].ToString();
            username = username.ToLower();
            UsuarioxSegmento usuarioxsegmento = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == username && x.Segmento.nombre == seg).FirstOrDefault();
            web.AdministracionClient.EliminarSegmentodeUsuario(usuarioxsegmento, username);

            return RedirectToAction("Details", new { id });
        }
    }
}