using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using System.ComponentModel.DataAnnotations;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    #region Penalizaciones
    public class ExcepcionesPenalizacionViewModel : EncabezadoModeloComisionViewModel
    {
        public List<ExcepcionPenalizacionViewModel> ExcepcionesPenalizacionModeloComision { get; set; }

        public string DescripcionModelo { get; set; }
        public int Id { get; set; }
        public DateTime FechaInicioVigenciaModelo { get; set; }
        [Required]
        public int IdModelo { get; set; }
        [Required]
        public string NumeroContrato { get; set; }
        [Required]
        public int? IdAsesorClaveOrigenSeleccionado { get; set; }
        [Required]
        public string AsesorClaveOrigenSeleccionado { get; set; }
        [Required]
        public int? IdAsesorClaveDestinoSeleccionado { get; set; }
        [Required]
        public string AsesorClaveDestinoSeleccionado { get; set; }
        [Required]
        public string IdAplicaSeleccionado { get; set; }
        public List<SelectListItem> ListaAplicas { get; set; }

        public ExcepcionesPenalizacionViewModel()
        {
            this.ExcepcionesPenalizacionModeloComision = new List<ExcepcionPenalizacionViewModel>();
            this.ListaAplicas = new List<SelectListItem>();
            this.ListaAplicas.Add(new SelectListItem() { Text = "Clave Origen", Value = "Origen" });
            this.ListaAplicas.Add(new SelectListItem() { Text = "Clave Destino", Value = "Destino" });
            this.ListaAplicas.Add(new SelectListItem() { Text = "Ambas Claves", Value = "Ambos" });
        }
    }

    public class ExcepcionPenalizacionViewModel
    {
        public int Id { get; set; }
        public int? ModeloId { get; set; }
        public string NumeroContrato { get; set; }
        public int? AsesorClaveOrigenId { get; set; }
        public string AsesorOrigen { get; set; }
        public int? AsesorClaveDestinoId { get; set; }
        public string AsesorDestino { get; set; }
        public string Aplica { get; set; }
        public bool Activo { get; set; }
    }
    #endregion

    #region ExcepcionFijaVariable
    public class ExcepcionesFijaVariableViewModel : EncabezadoModeloComisionViewModel
    {
        public DateTime FechaInicioVigenciaModelo { get; set; }
        public List<ExcepcionFijaVariableViewModel> ExcepcionesFijaVariableModeloComision { get; set; }
        public string DescripcionModelo { get; set; }
        public int? IdExcepcion { get; set; }
        [Required]
        public int IdModelo { get; set; }
        [Required(ErrorMessage = "La referencia es requerida")]
        public Decimal NumeroContrato { get; set; }
        [Required(ErrorMessage="El porcentaje de comisión es requerido"), Range(0.0, 100.0, ErrorMessage = "El valor del porcentaje de comisión debe ser 0 ó mayor y menor a 100")]
        public double PorcentajeComision { get; set; }
        [DisplayName("Fecha Inicio Vigencia"), Required(ErrorMessage = "El inicio de vigencia es requerido")]
        public DateTime FechaInicioVigenciaExcepcion { get; set; }
        [DisplayName("Fecha Fin Vigencia"), Required(ErrorMessage = "El fin de vigencia es requerido")]
        public DateTime FechaFinVigenciaExcepcion { get; set; }
        [Required(ErrorMessage = "Se debe selecionar el tipo de excepción")]
        public byte IdTipoExcepcionSeleccionado { get; set; }
        [Required(ErrorMessage = "Se debe seleccionar un asesor")]
        public int IdAsesorClaveSeleccionado { get; set; }
        [Required(ErrorMessage = "Se debe seleccionar un asesor")]
        public string ParticipanteSeleccionado { get; set; }
        [Required(ErrorMessage = "Se debe selecionar el tipo de excepción")]
        public byte IdExcepcionPor { get; set; }
        public List<SelectListItem> ExcepcionesPor { get; set; }
        public List<SelectListItem> TiposExcepcion { get; set; }
        public bool Activo { get; set; }

        public ExcepcionesFijaVariableViewModel()
        {
            this.ExcepcionesFijaVariableModeloComision = new List<ExcepcionFijaVariableViewModel>();
            this.TiposExcepcion = new List<SelectListItem>();
            this.TiposExcepcion.Add(new SelectListItem() { Text = "Comisión Total", Value = "1" });
            this.TiposExcepcion.Add(new SelectListItem() { Text = "Comisión Fija", Value = "2" });
            this.TiposExcepcion.Add(new SelectListItem() { Text = "Bloqueo Pago", Value = "3" });
            this.ExcepcionesPor = new List<SelectListItem>();
            this.ExcepcionesPor.Add(new SelectListItem() { Text = "Grupo Asociativo", Value = "1" });
            this.ExcepcionesPor.Add(new SelectListItem() { Text = "Contrato", Value = "2" });
            this.ExcepcionesPor.Add(new SelectListItem() { Text = "SubContrato", Value = "3" });
            this.ExcepcionesPor.Add(new SelectListItem() { Text = "Solo Clave", Value = "4" });
            this.ExcepcionesPor.Add(new SelectListItem() { Text = "Bloqueo Pago Comisión", Value = "5" });
        }
    }

    public class ExcepcionFijaVariableViewModel
    {
        public int Id { get; set; }
        public int? ModeloId { get; set; }
        public byte? TipoExcepcionId { get; set; }
        public string TipoExcepcion { get; set; }
        public string NumeroContrato { get; set; }
        public int? AsesorClaveId { get; set; }
        public string AsesorClave { get; set; }
        public double? PorcentajeComision { get; set; }
        public DateTime? FechaInicioVigencia { get; set; }
        public DateTime? FechaFinVigencia { get; set; }
        public byte ExcepcionPor { get; set; }
        public string DescripcionExcepcionPor { get; set; }
        public bool Activo { get; set; }
    }
    #endregion
}