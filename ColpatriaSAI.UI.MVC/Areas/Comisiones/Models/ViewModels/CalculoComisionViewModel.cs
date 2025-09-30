using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using System.ComponentModel;
using ColpatriaSAI.Negocio.Entidades.ResultadoProcedimientos;
using PagedList;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class CalculoComisionViewModel
    {
        [Required, DisplayName("Modelo")]
        public int ModeloId { get; set; }
        public List<SelectListItem> Modelos { get; set; }
        [Required, DisplayName("Año")]
        public short Anio { get; set; }
        public List<SelectListItem> Anios { get; set; }

        public int? IdLiquidacion { get; set; }
        public DateTime FechaCorte { get; set; }

        [Required, DisplayName("Mes")]
        public byte Mes { get; set; }
        public List<SelectListItem> Meses { get; set; }

        [Required, DisplayName("Tipo Liquidación")]
        public byte TipoLiquidacionId { get; set; }
        public List<SelectListItem> TipoLiquidaciones { get; set; }

        public int EstadoLiquidacion { get; set; }
        public PrevisualizacionExtraccionViewModel Extraccion { get; set; }

        public List<PrevisualizacionExtraccionViewModel> ListaExtracciones { get; set; }

        public PrevisualizacionComisionesViewModel Comisiones { get; set; }

        public CalculoComisionViewModel()
        {
            this.Anios = new List<SelectListItem>();
            for (int i = -3; i < 1; i++)
            {
                this.Anios.Add(new SelectListItem() {
                    Text = (DateTime.Now.Year + i).ToString(),
                    Value = (DateTime.Now.Year + i).ToString(),
                    Selected = (DateTime.Now.Year + i) == DateTime.Now.Year ? true : false
                });
            }
            this.Meses = new List<SelectListItem>();
            this.Meses.Add(new SelectListItem() { Text = "Enero", Value = "1" });
            this.Meses.Add(new SelectListItem() { Text = "Febrero", Value = "2" });
            this.Meses.Add(new SelectListItem() { Text = "Marzo", Value = "3" });
            this.Meses.Add(new SelectListItem() { Text = "Abril", Value = "4" });
            this.Meses.Add(new SelectListItem() { Text = "Mayo", Value = "5" });
            this.Meses.Add(new SelectListItem() { Text = "Junio", Value = "6" });
            this.Meses.Add(new SelectListItem() { Text = "Julio", Value = "7" });
            this.Meses.Add(new SelectListItem() { Text = "Agosto", Value = "8" });
            this.Meses.Add(new SelectListItem() { Text = "Septiembre", Value = "9" });
            this.Meses.Add(new SelectListItem() { Text = "Octubre", Value = "10" });
            this.Meses.Add(new SelectListItem() { Text = "Noviembre", Value = "11" });
            this.Meses.Add(new SelectListItem() { Text = "Diciembre", Value = "12" });
            this.TipoLiquidaciones = new List<SelectListItem>();
            this.TipoLiquidaciones.Add(new SelectListItem() { Text = "Comisiones", Value = "1" });
            this.TipoLiquidaciones.Add(new SelectListItem() { Text = "Comisiones + Reserva", Value = "2" });

            this.Modelos = new List<SelectListItem>();
            this.Comisiones = new PrevisualizacionComisionesViewModel();
        }
    }

    public class ComisionVariableAsesorViewModel
    {
        public int Id { get; set; }
        public int LiquidacionComisionId { get; set; }
        public int ParticipanteId { get; set; }
        public string Participante { get; set; }
        public int? RangoXInferior { get; set; }
        public int? RangoXSuperior { get; set; }
        public int? TalentosNetos { get; set; }
        public int? RangoYInferior { get; set; }
        public int? RangoYSuperior { get; set; }
        public int TalentosNuevos { get; set; }
        public double ComisionVariable { get; set; }

    }  

    public class PrevisualizacionComisionesViewModel
    {
        public int LiquidacionComisionId { get; set; }
        public int ModeloId { get; set; }
        public short Anio { get; set; }
        public byte Mes { get; set; }
        public byte TipoLiquidacionId { get; set; }
        public int EstadoLiquidacion { get; set; }
        public List<ComisionVariableAsesorViewModel> ComisionesVariables { get; set; }
        public List<ComisionFijaFacturacion> ComisionesFijasFacturacion { get; set; }
        public List<ComisionFijaRecaudos> ComisionesFijaRecaudos { get; set; }

        public PrevisualizacionComisionesViewModel()
        {
            this.ComisionesVariables = new List<ComisionVariableAsesorViewModel>();
            this.ComisionesFijaRecaudos = new List<ComisionFijaRecaudos>();
            this.ComisionesFijasFacturacion = new List<ComisionFijaFacturacion>();
        }
    }

    public class PrevisualizacionExtraccionViewModel
    {
        public int ExtraccionId { get; set; }
        public short Anio { get; set; }
        public byte Mes { get; set; }
        public byte Dia { get; set; }
        public byte TipoLiquidacionId { get; set; }
        public string TipoLiquidacionName { get; set; }
        public int EstadoExtraccion { get; set; }
        public string EstadoExtraccionName { get; set; }
        public string Fecha { get; set; }
        public string CodigoExtraccion { get; set; }
    }
}
