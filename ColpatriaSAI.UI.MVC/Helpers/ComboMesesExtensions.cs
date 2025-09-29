using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using System.Web.Mvc.Html;

namespace ColpatriaSAI.UI.MVC.Helpers
{
    public static class ComboMesesExtensions
    {
        public static MvcHtmlString ComboMeses(this HtmlHelper helper, string id)
        {
            Dictionary<int, string> meses = new Dictionary<int, string>();
            meses.Add(01, "Enero");
            meses.Add(02, "Febrero");
            meses.Add(03, "Marzo");
            meses.Add(04, "Abril");
            meses.Add(05, "Mayo");
            meses.Add(06, "Junio");
            meses.Add(07, "Julio");
            meses.Add(08, "Agosto");
            meses.Add(09, "Septiembre");
            meses.Add(10, "Octubre");
            meses.Add(11, "Noviembre");
            meses.Add(12, "Diciembre");

            IEnumerable<SelectListItem> items =
                from values in meses
                select new SelectListItem
                {
                    Text = values.Value,
                    Value = values.Key.ToString(),
                    Selected = (values.Key.Equals(DateTime.Now.Month))
                };

            return helper.DropDownList(id, items);
        }
    }
}