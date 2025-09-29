using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Models
{
    [MetadataType(typeof(ZonaMetaData))]
    public partial class Zona
    {
        [Bind(Exclude = "id")]
        public class ZonaMetaData
        {
            [ScaffoldColumn(false)]
            public object id { get; set; }

            [Required(ErrorMessage = "Un nombre de zona es requerido")]
            [DisplayFormat(ConvertEmptyStringToNull = false)]
            [StringLength(100)]
            public object nombre { get; set; }
        }
    }

}