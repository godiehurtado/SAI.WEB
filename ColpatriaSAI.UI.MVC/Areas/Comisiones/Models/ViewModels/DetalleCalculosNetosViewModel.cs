using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using Foolproof;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class DetalleCalculosNetosViewModel
    {
        [Required(ErrorMessage = "Debe seleccionar un año")]
        public int? Anio { get; set; }
        [Required(ErrorMessage = "Debe seleccionar un mes")]
        public int? Mes { get; set; }
        [Required(ErrorMessage = "Debe seleccionar un modelo")]
        public int? IdModelo { get; set; }

        [Required(ErrorMessage = "*")]
        public int? Asesor { get; set; }
        [Required(ErrorMessage = "Debe seleccionar un asesor")]
        public String AsesorClaveSeleccionado { get; set; }

        public List<SelectListItem> MesesAnio;
        public List<SelectListItem> Anios;
        public List<SelectListItem> ModelosComision;

        public List<ResultadosCalculosViewModel> vmodelpartial { get; set; }

        public DetalleCalculosNetosViewModel()
        {
            this.MesesAnio = new List<SelectListItem>();
            this.Anios = new List<SelectListItem>();
            this.ModelosComision = new List<SelectListItem>();
        }
    }

    public class ResultadosCalculosViewModel
    {
        public string CombinacionQuery { get; set; }
        public List<int> resultados { get; set; }
        public List<string> Combinaciones { get; set; }
    }
}