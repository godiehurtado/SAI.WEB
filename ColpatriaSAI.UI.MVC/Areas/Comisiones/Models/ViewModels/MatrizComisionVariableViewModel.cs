using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;


namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class MatrizComisionVariableViewModel : EncabezadoModeloComisionViewModel
    {
        public bool HayEjesDefinidos { get; set; }
        [Required]
        public int ModeloId { get; set; }
        [Required]
        public int RangoXNetoSeleccionado { get; set; }
        [Required]
        public int RangoYNuevoSeleccionado { get; set; }
        [Required(ErrorMessage = "Es Requerido"),
        RegularExpression(@"^(\d{1,2})?([,]\d{0,2})*$", 
            ErrorMessage = "Debe ser un número entre 0 y 100 con máximo dos decimales ")]
        public double FactorDefinido { get; set; }


        public DateTime FechaInicioVigenciaModelo { get; set; }
        public string DescripcionModelo { get; set; }
        [Required, Range(1, 20)]
        public int Dimension { get; set; }
        public List<SelectListItem> Dimensiones { get; set; }
        public List<XNetoViewModel> XNetos { get; set; }
        public List<YNuevoViewModel> YNuevos { get; set; }
        public List<XYMatrizVariable> Matriz { get; set; }

        public MatrizComisionVariableViewModel()
        {
            this.Dimension = 2;
            this.Matriz = new List<XYMatrizVariable>();
            this.XNetos = new List<XNetoViewModel>();
            this.YNuevos = new List<YNuevoViewModel>();
            this.Dimensiones = new List<SelectListItem>();
            for (int i = 2; i <= 20; i++)
            {
                this.Dimensiones.Add(new SelectListItem()
                {
                    Text = i.ToString() + " X " + i.ToString(),
                    Value = i.ToString()
                });                
            }
            for (int i = 0; i < this.Dimension; i++)
            {
                this.XNetos.Add(new XNetoViewModel() { });
                this.YNuevos.Add(new YNuevoViewModel() { });
            }
        }

    }

    public class XYMatrizVariable
    {
        public int XId { get; set; }
        public XNetoViewModel X { get; set; }
        public int YId { get; set; }
        public YNuevoViewModel Y { get; set; }
        public double Factor { get; set; }
    }

    public class XNetoViewModel
    {
        public int Id { get; set; }
        public int? LimiteInferior { get; set; }
        public int? LimiteSuperior { get; set; }
    }

    public class YNuevoViewModel
    {
        public int Id { get; set; }
        public int? LimiteInferior { get; set; }
        public int? LimiteSuperior { get; set; }
    }
}