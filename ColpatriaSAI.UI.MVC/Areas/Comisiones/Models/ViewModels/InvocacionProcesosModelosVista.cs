using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class InvocacionManualViewModel
    {
    }

    public class InvocacionForzadaViewModel
    {
        public List<CPRO_ProcesosExtraccion> Procesos { get; set; }

        public byte IdProcesoActual { get; set; }
        [DisplayName("Inicio periodo")]
        public DateTime? inicioPeriodo { get; set; }
        [DisplayName("Fin periodo")]
        public DateTime? finPeriodo { get; set; }
        [DisplayName("Código")]
        public string CodigoEjecucion { get; set; }

        public InvocacionForzadaViewModel()
        {
            this.Procesos = new List<CPRO_ProcesosExtraccion>();
        }
    }
}