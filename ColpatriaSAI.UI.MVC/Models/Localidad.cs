using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Models
{
    [MetadataType(typeof(LocalidadMetaData))]
    public partial class LocalidadES
    {
        [Bind(Exclude = "id")]
        public class LocalidadMetaData
        {
            [ScaffoldColumn(false)]
            public object id { get; set; }

            [Required(ErrorMessage = "Un nombre de localidad es requerido")]
            [DisplayFormat(ConvertEmptyStringToNull = false)]
            [StringLength(100)]
            public object nombre { get; set; }

            [DisplayName("Seleccione una zona")]
            public object zona_id { get; set; }
        }
    }
}