using System.Collections.Generic;
using System.Web.Security;
using PagedList;

namespace ColpatriaSAI.UI.MVC.Areas.UserAdministration.Models.UserAdministration
{
	public class IndexViewModel
	{
		public IPagedList<MembershipUser> Users { get; set; }
		public IEnumerable<string> Roles { get; set; }
        public IDictionary<int,string> TipoDocumentos { get; set; }
        public IDictionary<int, string> Segmentos { get; set; }
	}
}