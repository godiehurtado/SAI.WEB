using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Entidades = ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ConsultaParametrizacionController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        //
        // GET: /Comisiones/ConsultaParametrizacion/

        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private AdministracionSvc.AdministracionClient _svcAdminClient;

        [Authorize]
        public ActionResult ConsultaParametrizacion()
        {
            ConsultaParametrizacionViewModel vwmodel = new ConsultaParametrizacionViewModel();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            vwmodel.ModelosComision.AddRange(_svcModelClient.ListarModelosComision());
            return View(vwmodel);
        }

        [Authorize]
        public JsonResult Consultar()
        {
            string modeloid = Request["modelo"];
            string htmlresultados1 = ConsultarFija(modeloid);
            string htmlresultados2 = ConsultarVariableNuevo(modeloid);
            string htmlresultados3 = ConsultarVariableNeto(modeloid);
            string htmlresultados4 = ConsultarMatriz(modeloid);
            return Json(new { Success = true, htmlresult1 = htmlresultados1, htmlresult2 = htmlresultados2, htmlresult3 = htmlresultados3, htmlresult4 = htmlresultados4 });
        }

        private string ConsultarFija(string modeloid)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdminClient = new AdministracionSvc.AdministracionClient();
            List<Negocio.Entidades.FactorComisionFija> factorcomisionfija = _svcModelClient.ListarFactorComisionFijaXModeloId(Int32.Parse(modeloid)).ToList();
            List<Negocio.Entidades.Compania> companias = _svcAdminClient.ListarCompanias();
            List<Negocio.Entidades.RamoDetalle> ramos = _svcAdminClient.ListarRamoDetalle(0);
            List<Negocio.Entidades.ProductoDetalle> productos = _svcAdminClient.ListarProductoDetalles(0);
            List<Negocio.Entidades.PlanDetalle> planes = _svcAdminClient.ListarPlanDetalles(0);
            List<Negocio.Entidades.TipoContrato> tipocontrato = _svcAdminClient.ListarTipoContratos();
            string htmlresultados = string.Empty;

            if (factorcomisionfija.Count > 0)
            {
                foreach (Negocio.Entidades.FactorComisionFija factor in factorcomisionfija)
                {
                    htmlresultados += "<tr><td>" + companias.Where(x => x.id == factor.compania_id).FirstOrDefault().nombre +
                        "</td><td>" + ramos.Where(x => x.id == factor.ramoDetalle_id).FirstOrDefault().nombre +
                        "</td><td>" + (factor.productoDetalle_id == null ? "" : productos.Where(x => x.id == factor.productoDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.planDetalle_id == null ? "" : planes.Where(x => x.id == factor.planDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.tipocontrato_id == null ? "" : tipocontrato.Where(x => x.id == factor.tipocontrato_id).FirstOrDefault().nombre) +
                        "</td><td>" + factor.edadminima.ToString() +
                        "</td><td>" + factor.edadmaxima.ToString() +
                        "</td><td>" + (factor.estadoBeneficiario_id == 1 ? "NUEVO" : "RENOVADO") +
                        "</td><td>" + factor.factor.ToString() + "</tr>";
                }
            }
            else
            {
                htmlresultados += "<tr><td>No existe parametrización de comisión fija para este modelo</td><tr>";
            }

            return htmlresultados;
        }

        private string ConsultarVariableNuevo(string modeloid)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdminClient = new AdministracionSvc.AdministracionClient();
            List<Negocio.Entidades.FactorComisionVariableNuevo> factorcomisionvariablenuevo = _svcModelClient.ListarFactorNuevoComisionVariableXModeloId(Int32.Parse(modeloid)).ToList();
            List<Negocio.Entidades.Compania> companias = _svcAdminClient.ListarCompanias();
            List<Negocio.Entidades.RamoDetalle> ramos = _svcAdminClient.ListarRamoDetalle(0);
            List<Negocio.Entidades.ProductoDetalle> productos = _svcAdminClient.ListarProductoDetalles(0);
            List<Negocio.Entidades.PlanDetalle> planes = _svcAdminClient.ListarPlanDetalles(0);
            List<Negocio.Entidades.TipoContrato> tipocontrato = _svcAdminClient.ListarTipoContratos();
            string htmlresultados = string.Empty;

            if (factorcomisionvariablenuevo.Count > 0)
            {
                foreach (Negocio.Entidades.FactorComisionVariableNuevo factor in factorcomisionvariablenuevo)
                {
                    htmlresultados += "<tr><td>" + companias.Where(x => x.id == factor.compania_id).FirstOrDefault().nombre +
                        "</td><td>" + ramos.Where(x => x.id == factor.ramoDetalle_id).FirstOrDefault().nombre +
                        "</td><td>" + (factor.productoDetalle_id == null ? "" : productos.Where(x => x.id == factor.productoDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.planDetalle_id == null ? "" : planes.Where(x => x.id == factor.planDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.tipocontrato_id == null ? "" : tipocontrato.Where(x => x.id == factor.tipocontrato_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.estadoBeneficiario_id == 1 ? "NUEVO" : "RENOVADO") +
                        "</td><td>" + factor.factor.ToString() + "</tr>";
                }
            }
            else
            {
                htmlresultados += "<tr><td>No existe parametrización de comisión variable de nuevos para este modelo</td><tr>";
            }
            return htmlresultados;
        }

        private string ConsultarVariableNeto(string modeloid)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdminClient = new AdministracionSvc.AdministracionClient();
            List<Negocio.Entidades.FactorComisionVariableNeto> factorcomisionvariableneto = _svcModelClient.ListarFactorNetoComisionVariableXModeloId(Int32.Parse(modeloid)).ToList();
            List<Negocio.Entidades.Compania> companias = _svcAdminClient.ListarCompanias();
            List<Negocio.Entidades.RamoDetalle> ramos = _svcAdminClient.ListarRamoDetalle(0);
            List<Negocio.Entidades.ProductoDetalle> productos = _svcAdminClient.ListarProductoDetalles(0);
            List<Negocio.Entidades.PlanDetalle> planes = _svcAdminClient.ListarPlanDetalles(0);
            List<Negocio.Entidades.TipoContrato> tipocontrato = _svcAdminClient.ListarTipoContratos();
            string htmlresultados = string.Empty;

            if (factorcomisionvariableneto.Count > 0)
            {
                foreach (Negocio.Entidades.FactorComisionVariableNeto factor in factorcomisionvariableneto)
                {
                    htmlresultados += "<tr><td>" + companias.Where(x => x.id == factor.compania_id).FirstOrDefault().nombre +
                        "</td><td>" + ramos.Where(x => x.id == factor.ramoDetalle_id).FirstOrDefault().nombre +
                        "</td><td>" + (factor.productoDetalle_id == null ? "" : productos.Where(x => x.id == factor.productoDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.planDetalle_id == null ? "" : planes.Where(x => x.id == factor.planDetalle_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.tipocontrato_id == null ? "" : tipocontrato.Where(x => x.id == factor.tipocontrato_id).FirstOrDefault().nombre) +
                        "</td><td>" + (factor.estadoBeneficiario_id == 1 ? "NUEVO" : "RENOVADO") +
                        "</td><td>" + factor.factor.ToString() + "</tr>";
                }
            }
            else
            {
                htmlresultados += "<tr><td>No existe parametrización de comisión variable de netos para este modelo</td><tr>";
            }
            return htmlresultados;
        }

        private string ConsultarMatriz(string modeloid)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdminClient = new AdministracionSvc.AdministracionClient();
            List<Negocio.Entidades.RangosXNeto> rangosneto = _svcModelClient.ListarRangosXNetoMatrizComisionVariableXModelo(Int32.Parse(modeloid)).OrderBy(x => x.rangomax).ToList();
            List<Negocio.Entidades.RangosYNuevo> rangosnuevo = _svcModelClient.ListarRangosYNuevoMatrizComisionVariableXModelo(Int32.Parse(modeloid)).OrderByDescending(x => x.rangomax).ToList();
            List<Negocio.Entidades.MatrizComisionVariable> valoresmatriz = _svcModelClient.ListarValoresMatrizComisionVariableXModelo(Int32.Parse(modeloid)).ToList();
            List<double> factores = valoresmatriz.Select(x => x.factor).Distinct().ToList();
            List<string> colors = new List<string>();
            colors.Add("#FF110A");
            colors.Add("#FFA400");
            colors.Add("#FFFF0D");
            colors.Add("#0DFF5C");
            colors.Add("#7B0CE8");
            colors.Add("#0091FF");
            colors.Add("#EE05F2");
            colors.Add("#0511F2");
            colors.Add("#0DF205");
            colors.Add("#F2E205");
            colors.Add("#F20505");            
            Dictionary<double, string> colores = new Dictionary<double, string>();
            int idcolor = 0;
            foreach (double fac in factores)
            {
                //Random random = new Random();
                //string color = String.Format("#{0:X6}", random.Next(0x1000000));
                //while (colores.Values.Contains(color))
                //{
                //    color = String.Format("#{0:X6}", random.Next(0x1000000));
                //}
                colores.Add(fac, colors[idcolor]);
                idcolor++;
                if (idcolor > 10) idcolor = 0;
            }
            string htmlresultados = string.Empty;
            foreach (Negocio.Entidades.RangosYNuevo rany in rangosnuevo)
            {
                htmlresultados += "<tr heigth=\"100\"><td>";
                htmlresultados += "<br/><br/><br/>" + rany.rangomin.ToString();
                htmlresultados += "</td>";
                
                foreach (Negocio.Entidades.RangosXNeto ranx in rangosneto)
                {
                    htmlresultados += "<td width=\"100\" style=\"background-color:" + colores[valoresmatriz.Where(x => x.rangoxnetos_id == ranx.id && x.rangoynuevos_id == rany.id).First().factor] + "; text-align:center; vertical-align:middle\">";
                    htmlresultados += valoresmatriz.Where(x => x.rangoxnetos_id == ranx.id && x.rangoynuevos_id == rany.id).First().factor.ToString();
                    htmlresultados += "</td>";
                }
                htmlresultados += "</tr>";
            }

            htmlresultados += "<tr heigth=\"100\"><td></td>";
            foreach (Negocio.Entidades.RangosXNeto ranx in rangosneto)
            {
                htmlresultados += "<td width=\"100\" style=\"text-align:left;\">";
                htmlresultados += ranx.rangomin.ToString();
                htmlresultados += "</td>";
            }
            htmlresultados += "</tr>";


            return htmlresultados;
        }
    }
}
