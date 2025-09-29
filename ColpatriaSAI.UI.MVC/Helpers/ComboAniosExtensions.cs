using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace ColpatriaSAI.UI.MVC.Helpers
{
    public static class ComboAniosExtensions
    {
        public static MvcHtmlString ComboAnios(this HtmlHelper helper, string id)
        {
            List<string> anios = new List<string>();
            int anio = DateTime.Now.Year - 1;
            while (anios.Count <= 10) anios.Add(Convert.ToString(anio++));

            IEnumerable<SelectListItem> items = from value in anios
                select new SelectListItem {
                    Text = value.ToString(),
                    Value = value.ToString(),
                    Selected = (value.Equals(Convert.ToString(DateTime.Now.Year)))
                };

            return helper.DropDownList(id, items);
        }
    }
}