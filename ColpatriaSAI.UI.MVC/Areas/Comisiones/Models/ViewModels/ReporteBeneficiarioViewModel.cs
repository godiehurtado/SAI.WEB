using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using Foolproof;
using Componentes = ColpatriaSAI.Negocio.Componentes;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class ReporteBeneficiarioViewModel
    {
        [Required(ErrorMessage = "Debe seleccionar un año de consulta")]
        public int anio { get; set; }
        [Required(ErrorMessage = "Debe seleccionar un mes de consulta")]
        public int mes { get; set; }
        public string ClavesAsesor { get; set; }
        public string IdAsesores { get; set; }
        public string NombreDirector { get; set; }
        public string IdDirector { get; set; }
        public string NombreGerente { get; set; }
        public string IdGerente { get; set; }
        public string Sucursale { get; set; }
        public int CanalVentas { get; set; }
        public int SubCanal { get; set; }
        public int TipoPlan { get; set; }
        public int Documento_D { get; set; }
        public int Documento_G { get; set; }
        public string Contrato { get; set; }
        public string SubContrato { get; set; }
        public int TipoContrato { get; set; }
        public int Estado { get; set; }
        public int EdadDesde { get; set; }
        public int Edadhasta { get; set; }
        public int Visualizar { get; set; }
        public int TipoReporte { get; set; }
        public string Apellidogerente { get; set; }
        public string ApellidoDirector { get; set; }
        public int sucursal { get; set; }
        public int modelo { get; set; }
        public int esdirector { get; set; }

        public List<SelectListItem> AnioList;
        public List<SelectListItem> MesList;
        public List<SelectListItem> Modelo;
        public List<SelectListItem> Canales;
        public List<SelectListItem> Sucursal;
        public List<SelectListItem> SubCanales;
        public List<SelectListItem> Planes;
        public List<SelectListItem> Contratos;
        public List<Componentes.Comision.Reportes.ReporteBeneficiarioClass> lDatos;

        public ReporteBeneficiarioViewModel()
        {
            this.AnioList = new List<SelectListItem>();
            this.MesList = new List<SelectListItem>();
            this.Modelo = new List<SelectListItem>();
            this.Sucursal = new List<SelectListItem>();
            this.Canales = new List<SelectListItem>();
            this.SubCanales = new List<SelectListItem>();
            this.Planes = new List<SelectListItem>();
            this.Contratos = new List<SelectListItem>();
            this.lDatos = new List<Componentes.Comision.Reportes.ReporteBeneficiarioClass>();
        }
    }
}