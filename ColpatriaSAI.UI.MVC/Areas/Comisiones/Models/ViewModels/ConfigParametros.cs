using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using System.ComponentModel;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class ConfigParametros
    {
        public int id { get; set; }
        public string parametro { get; set; }
        
        [StringLength(500, ErrorMessage="La longitud máxima permitida es de 500 caracteres")]
        public string valor { get; set; }
        public string descripcion { get; set; }


    }
}