using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class DetalleFactoresNuevosComisionVariableViewModel : EncabezadoModeloComisionViewModel
    {
        public int? IdFactorSeleccionado { get; set; }
        [Required]
        public int IdModelo { get; set; }
        public string DescripcionModelo { get; set; }
        public DateTime FechaInicioVigenciaModelo { get; set; }
        public List<FactorNuevoComisionVariableViewModel> FactoresComision { get; set; }
        [Required(ErrorMessage = "Se requiere la compañía")]
        public int IdCompaniaSeleccionada { get; set; }
        public List<SelectListItem> Companias { get; set; }
        [Required(ErrorMessage = "Se requiere el ramo")]
        public int IdRamoSeleccionado { get; set; }
        public List<SelectListItem> Ramos { get; set; }
        public int? IdProductoSeleccionado { get; set; }
        public List<SelectListItem> Productos { get; set; }
        public int? IdPlanSeleccionado { get; set; }
        public List<SelectListItem> Planes { get; set; }
        [Required(ErrorMessage = "Se requiere el tipo de contrato")]
        public int? IdTipoContratoSeleccionado { get; set; }
        public List<SelectListItem> TipoContratos { get; set; }        
        [Required(ErrorMessage = "Se requiere el factor"), Range(0, int.MaxValue, ErrorMessage = "Debe ser un valor mayor a 0")]
        public decimal FactorIngresado { get; set; }
        [Required]
        public EstadoBeneficiario ClasificacionRecaudo { get; set; }

        public DetalleFactoresNuevosComisionVariableViewModel()
        {
            this.FactoresComision = new List<FactorNuevoComisionVariableViewModel>();
            this.Companias = new List<SelectListItem>();
            this.Ramos = new List<SelectListItem>();
            this.Productos = new List<SelectListItem>();
            this.Planes = new List<SelectListItem>();
            this.TipoContratos = new List<SelectListItem>();
        }
    }

    public class FactorNuevoComisionVariableViewModel
    {
        public int id { get; set; }
        public int CompaniaId { get; set; }
        public string NombreCompania { get; set; }
        public int TipoContratoId { get; set; }
        public string DescripcionTipoContrato { get; set; }
        public int RamoId { get; set; }
        public string NombreRamo { get; set; }
        public int? ProductoId { get; set; }
        public int? PlanId { get; set; }
        public string NombrePlan { get; set; }
        [Required, Range(0, double.MaxValue)]
        public decimal Factor { get; set; }
        public EstadoBeneficiario ClasificacioRecaudo { get; set; }
        public int ModeloId { get; set; }
    }
}