using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class ParametrosVencimientoViewModel
    {
        public int PeriodoDetallado { get; set; }
        public int ConsolidadoMensual { get; set; }
        public int ConsolidadoAnual { get; set; }
        public DateTime FechaRotacion { get; set; }
    }
}