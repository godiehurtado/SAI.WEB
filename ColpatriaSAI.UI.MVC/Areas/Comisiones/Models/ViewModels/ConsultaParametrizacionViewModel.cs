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
    public class ConsultaParametrizacionViewModel
    {
        public List<ModeloComision> ModelosComision { get; set; }
        public ConsultaParametrizacionViewModel()
        {
            this.ModelosComision = new List<ModeloComision>();
        }
    }
}