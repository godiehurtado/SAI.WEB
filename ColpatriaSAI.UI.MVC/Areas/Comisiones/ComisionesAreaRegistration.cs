using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones
{
    public class ComisionesAreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "Comisiones";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            context.MapRoute(
                "Comisiones_default",
                "Comisiones/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
