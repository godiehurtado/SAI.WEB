using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using Foolproof;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class DetalleFactoresComisionFijaViewModel : EncabezadoModeloComisionViewModel
    {
        public int? IdFactorSeleccionado { get; set; }
        [Required]
        public int IdModelo { get; set; }
        public string DescripcionModelo { get; set; }
        public DateTime FechaInicioVigenciaModelo { get; set; }
        public List<FactorComisionFijaViewModel> FactoresComision { get; set; }
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
        [Required(ErrorMessage = "Se requiere la edad máxima")]
        [GreaterThan("EdadMinimaIngresada", ErrorMessage = "La edad máxima debe ser mayor que la mínima")]
        public int EdadMaximaIngresada { get; set; }
        [Required(ErrorMessage = "Se requiere la edad mínima"), Range(0, 130.0, ErrorMessage = "La edad mínima debe estar entre 0 y 130")]
        [LessThan("EdadMaximaIngresada", ErrorMessage = "La edad mínima debe ser mayor que la máxima ")]
        public int EdadMinimaIngresada { get; set; }
        [Required(ErrorMessage = "Se requiere el factor"), Range(0, 100.0, ErrorMessage = "Debe ser un valor entre 0 y 100")]
        public double FactorIngresado { get; set; }
        [Required]
        public EstadoBeneficiario ClasificacionRecaudo { get; set; }

        public DetalleFactoresComisionFijaViewModel()
        {
            this.FactoresComision = new List<FactorComisionFijaViewModel>();
            this.Companias = new List<SelectListItem>();
            this.Ramos = new List<SelectListItem>();
            this.Productos = new List<SelectListItem>();
            this.Planes = new List<SelectListItem>();
            this.TipoContratos = new List<SelectListItem>();
        }
    }

    public class FactorComisionFijaViewModel
    {
        public int id { get; set; }
        public int CompaniaId { get; set; }
        public string NombreCompania { get; set; }
        public int? TipoContratoId { get; set; }
        public string DescripcionTipoContrato { get; set; }
        public int RamoId { get; set; }
        public string NombreRamo { get; set; }
        public int? ProductoId { get; set; }
        public int? PlanId { get; set; }
        public string DescripcionPlan { get; set; }
        [Required, Range(0, 100.0)]
        public double Factor { get; set; }
        [Required, Range(0, 150.0)]
        public int EdadMinima { get; set; }
        [Required, Range(0, 150.0)]
        public int EdadMaxima { get; set; }
        public EstadoBeneficiario ClasificacioRecaudo { get; set; }
        public int ModeloId { get; set; }
    }
}