using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using System.ComponentModel.DataAnnotations;
using Foolproof;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class ModeloViewModel
    {
        public List<ModeloComision> ModelosComision { get; set; }

        public int IdModelo { get; set; }
        [Required(ErrorMessage = "Se requiere nombrar el modelo"),StringLength(50,ErrorMessage="Se permiten máximo 20 caracteres")]
        public string Nombre { get; set; }
        [DisplayName("Fecha Inicio"), Required(ErrorMessage = "Se requiere la fecha de inicio")]
        [LessThan("FechaFin", ErrorMessage = "La fecha de inicio debe ser menor a la final")]
        public DateTime? FechaInicio { get; set; }
        [DisplayName("Fecha Fin"), Required(ErrorMessage = "Se requiere la fecha de finalización")]
        [GreaterThan("FechaInicio", ErrorMessage = "La fecha final debe ser mayor a la inicial")]
        public DateTime? FechaFin { get; set; }
        public bool CanalModelo { get; set; }
        public bool JerarquiaModelo { get; set; }
        public int IdCanal { get; set; }
        public int IdJerarquia { get; set; }
        [StringLength(100,ErrorMessage="Se permiten máximo 100 caracteres")]
        public string DescripcionModelo { get; set; }
        [Required(ErrorMessage = "Se requiere definir el tope del modelo"), Range(0, 100, ErrorMessage = "El valor para el tope de comisión debe estar entre 0 y 100")]
        public double ValorMaximoComision { get; set; }

        public List<CanalViewModel> ListaCanales { get; set; }
        public List<string> canalesid { get; set; }

        public List<LiquidacionComision> ListaLiqComision { get; set; }   // se añade RA

        public List<TipoIntermediarioViewModel> ListaTipoIntermediarios { get; set; }  // se añande
        public List<SelectListItem> SelTipoIntermediariolist { get; set; }

        public List<CanalDetalleTipoIntermediarioViewModel> ListaCanalDetalleTipoIntermediario { get; set; }

        public ModeloViewModel()
        {
            this.ModelosComision = new List<ModeloComision>();
            this.ListaCanales = new List<CanalViewModel>();
            this.ListaLiqComision = new List<LiquidacionComision>();  // se añade  RA
            this.ListaTipoIntermediarios = new List<TipoIntermediarioViewModel>();
            this.SelTipoIntermediariolist = new List<SelectListItem>();
            this.ListaCanalDetalleTipoIntermediario = new List<CanalDetalleTipoIntermediarioViewModel>();
            this.canalesid = new List<string>();
        }
    }

    public class LiqComisionClass                                        // se añade
    {                                                                    // se añade
        public int id { get; set; }                                      // se añade
        public string fechaLiquidacion { get; set; }                     // se añade
    }                                                                    //se añade
   
    [Serializable]
    public class TipoIntermediarioViewModel {

        public int id { get; set; }
        public string Nombre { get; set; }
    }

    [Serializable]
    public class CanalDetalleTipoIntermediarioViewModel
    {

        public int idCanalDetalle { get; set; }
        public int idTipoIntermediario { get; set; }
    }

    public class CanalViewModel
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public List<SelectListItem> CanalDetalles { get; set; }

        public CanalViewModel()
        {
            this.CanalDetalles = new List<SelectListItem>();
        }
    }

    [Serializable]
    public class CanalDetalleViewModel
    {
        public int id { get; set; }
        public string Nombre { get; set; }
        public int canal_id { get; set; }        
    }

    public class EncabezadoModeloComisionViewModel
    {
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public DateTime InicioVigencia { get; set; }
        public DateTime FinVigencia { get; set; }
        public double TopeComision { get; set; }

        public static EncabezadoModeloComisionViewModel GetViewModel(string nombre, string descripcion, DateTime inicioVigencia, DateTime finVigencia, double topeComision)
        {
            return new EncabezadoModeloComisionViewModel()
            {
                Descripcion = descripcion,
                FinVigencia = finVigencia,
                InicioVigencia = inicioVigencia,
                Nombre = nombre,
                TopeComision = topeComision
            };
        }

        public void SetViewModel(ColpatriaSAI.Negocio.Entidades.ModeloComision dbmodel)
        {
            this.Descripcion = dbmodel.descripcion;
            this.FinVigencia = dbmodel.fechahasta;
            this.InicioVigencia = dbmodel.fechadesde;
            this.Nombre = dbmodel.nombre;
            this.TopeComision = dbmodel.tope;

        }
    }
}