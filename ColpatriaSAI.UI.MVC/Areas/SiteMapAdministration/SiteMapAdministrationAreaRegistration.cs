using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Areas.SiteMapAdministration
{
    public class SiteMapAdministrationAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "SiteMapAdministration";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "SiteMapAdministration_default",
                "SiteMapAdministration/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
