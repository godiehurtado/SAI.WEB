using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.Reporting.WebForms;
using System.Data;
using System.Reflection;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using ReportesModel = ColpatriaSAI.Negocio.Componentes.Comision.Reportes;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using ColpatriaSAI.Negocio.Entidades;




namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ReportesController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase 
    {
        private Reportes.ReportesClient _svcreporte;

        private AdministracionSvc.AdministracionClient _svcAdmonClient;
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private CalculosTalentosComision.CalculosClient _svcCalculosClient;

        [Authorize]
        public ActionResult ReporteDetalleBeneficiario()
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            string documento = HttpContext.Session["IdDocumento"].ToString();
            Participante p = _svcAdmonClient.ListarParticipantes(null).Where(x => x.documento == documento && x.nivel_id == 2).FirstOrDefault();

            ReporteDetalleBeneficiarioViewModel vmmodel = new ReporteDetalleBeneficiarioViewModel();
            

            if (p == null)
                vmmodel.esdirector = 0;
            else
                vmmodel.esdirector = 1;

            List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

            List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

            vmmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
            vmmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            List<int> modelosLiquidacion = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.modelo_id).Distinct().ToList();

            vmmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0 && modelosLiquidacion.Contains(x.id))
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
            .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Visualizar = 0;
            vmmodel.TipoReporte = 1;
            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult ReporteDetalleBeneficiario(ReporteDetalleBeneficiarioViewModel vwmodel)
        {
            if (ModelState.IsValid)
            {
                _svcreporte = new Reportes.ReportesClient();
                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                _svcAdmonClient = new AdministracionSvc.AdministracionClient();
                _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

                string documento = HttpContext.Session["IdDocumento"].ToString();
                Participante p = _svcAdmonClient.ListarParticipantes(null).Where(x => x.documento == documento && x.nivel_id == 2).FirstOrDefault();

                if (p == null)
                    vwmodel.esdirector = 0;
                else
                    vwmodel.esdirector = 1;

                List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

                List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

                vwmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
                vwmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                List<int> modelosLiquidacion = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.modelo_id).Distinct().ToList();

                vwmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0 && modelosLiquidacion.Contains(x.id))
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
                vwmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
                vwmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


                vwmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.CanalVentas) }));
                vwmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección" });

                vwmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoPlan) }));
                vwmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoContrato) }));
                vwmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Visualizar = 1;

                if (p != null)
                    vwmodel.IdDirector = p.id.ToString();

                var lData = _svcreporte.GetReporteDetalleBeneficiarios(vwmodel.anio, vwmodel.mes, vwmodel.ClavesAsesor, vwmodel.IdDirector, vwmodel.IdGerente, vwmodel.CanalVentas, vwmodel.SubCanal, vwmodel.TipoPlan, vwmodel.TipoContrato, vwmodel.modelo, vwmodel.sucursal, vwmodel.Contrato, vwmodel.Estado);
                vwmodel.lDatos = lData.ToList();
                var gv = new GridView();
                gv.DataSource = lData;
                gv.DataBind();

                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=ReporteDetalleBeneficiarios.xls");
                Response.ContentType = "application/ms-excel";

                Response.Charset = "";
                StringWriter objStringWriter = new StringWriter();
                HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);

                gv.RenderControl(objHtmlTextWriter);

                Response.Output.Write(objStringWriter.ToString());
                Response.Flush();
                Response.End();
                return View(vwmodel);
            }
            else
            {
                return RedirectToAction("ReportesBeneficiario");
            }

        }

        [Authorize]
        public ActionResult ReportesBeneficiario()
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            string documento = HttpContext.Session["IdDocumento"].ToString();
            Participante p = _svcAdmonClient.ListarParticipantes(null).Where(x => x.documento == documento && x.nivel_id == 2).FirstOrDefault();

            ReporteBeneficiarioViewModel vmmodel = new ReporteBeneficiarioViewModel();

            if (p == null)
                vmmodel.esdirector = 0;
            else
                vmmodel.esdirector = 1;

            List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

            List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

            vmmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
            vmmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            List<int> modelosLiquidacion = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.modelo_id).Distinct().ToList();

            vmmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0 && modelosLiquidacion.Contains(x.id))
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            
            vmmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
            .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            
            vmmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Visualizar = 0;
            vmmodel.TipoReporte = 1;
            return View(vmmodel);
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public JsonResult CargarMeses(string anioId)
        {
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            
            List<int> meses = _svcCalculosClient.ObtenerHistoricoLiquidaciones().Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2 && x.año == int.Parse(anioId))
                .Select(x => (int)(x.mes)).ToList();
            Dictionary<int, string> mesess = new Dictionary<int, string>();
            foreach (int mes in meses)
            {
                string nombremes = "";
                switch (mes)
                {
                    case 1:
                        nombremes = "Enero";
                        break;
                    case 2:
                        nombremes = "Febrero";
                        break;
                    case 3:
                        nombremes = "Marzo";
                        break;
                    case 4:
                        nombremes = "Abril";
                        break;
                    case 5:
                        nombremes = "Mayo";
                        break;
                    case 6:
                        nombremes = "Junio";
                        break;
                    case 7:
                        nombremes = "Julio";
                        break;
                    case 8:
                        nombremes = "Agosto";
                        break;
                    case 9:
                        nombremes = "Septiembre";
                        break;
                    case 10:
                        nombremes = "Octubre";
                        break;
                    case 11:
                        nombremes = "Noviembre";
                        break;
                    case 12:
                        nombremes = "Diciembre";
                        break;
                    default:
                        nombremes = "Enero";;
                        break;
                }
                mesess.Add(mes, nombremes);
            }


            var phyData = mesess.Select(m => new SelectListItem()
            {
                Text = m.Value.ToString(),
                Value = m.Key.ToString(),
            });
            return Json(phyData, JsonRequestBehavior.AllowGet);
        }

        [HttpPost, Authorize]
        public ActionResult ReportesBeneficiario(ReporteBeneficiarioViewModel vwmodel)
        {
            if (ModelState.IsValid)
            {
                _svcreporte = new Reportes.ReportesClient();
                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                _svcAdmonClient = new AdministracionSvc.AdministracionClient();
                _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

                string documento = HttpContext.Session["IdDocumento"].ToString();
                Participante p = _svcAdmonClient.ListarParticipantes(null).Where(x => x.documento == documento && x.nivel_id == 2).FirstOrDefault();

                if (p == null)
                    vwmodel.esdirector = 0;
                else
                    vwmodel.esdirector = 1;

                List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

                List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

                vwmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
                vwmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                List<int> modelosLiquidacion = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.modelo_id).Distinct().ToList();

                vwmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0 && modelosLiquidacion.Contains(x.id))
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
                vwmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
                vwmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


                vwmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.CanalVentas) }));
                vwmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección" });

                vwmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoPlan) }));
                vwmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoContrato) }));
                vwmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Visualizar = 1;

                if (p != null)
                    vwmodel.IdDirector = p.id.ToString();
                
                var lData = _svcreporte.GetReporteBeneficiarios(vwmodel.anio, vwmodel.mes, vwmodel.ClavesAsesor, vwmodel.IdDirector,vwmodel.IdGerente, vwmodel.CanalVentas,vwmodel.SubCanal, vwmodel.TipoPlan, vwmodel.TipoContrato,vwmodel.modelo,vwmodel.sucursal);
                vwmodel.lDatos = lData.ToList();
                var gv = new GridView();
                gv.DataSource = lData;
                gv.DataBind();

                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=ReporteBeneficiarios.xls");
                Response.ContentType = "application/ms-excel";

                Response.Charset = "";
                StringWriter objStringWriter = new StringWriter();
                HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);

                gv.RenderControl(objHtmlTextWriter);

                Response.Output.Write(objStringWriter.ToString());
                Response.Flush();
                Response.End();
                return View(vwmodel);
            }
            else
            {
                return RedirectToAction("ReportesBeneficiario");
            }

        }

        [HttpPost]
        public JsonResult ObtenerSubcanalesxCanal(int CanalId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            JsonResult result = new JsonResult();
            var canal = _svcModelClient.ListarCanalesDetalle().Where(x => x.id == CanalId).FirstOrDefault();
            result.Data = canal.CanalDetalles.Select(y => new { id = y.id, nombre = y.nombre });
            return result;
        }

        public ActionResult ReporteTransferencias()
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            ReportesModel.ReporteTransferenciasViewModel vmmodel = new ReportesModel.ReporteTransferenciasViewModel();

            vmmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
         .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Sucursal.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });



            vmmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Modelo.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });


            vmmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Canales.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

            vmmodel.SubCanales.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

            vmmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Planes.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

            vmmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Contratos.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

            vmmodel.Visualizar = 0;
            vmmodel.TipoReporte = 2;
            return View(vmmodel);
        }

            [HttpPost, Authorize]
        public ActionResult ReporteTransferencias(ReportesModel.ReporteTransferenciasViewModel vwmodel)
        {
            if (vwmodel.Canal_Venta <= 0)
            {
                return RedirectToAction("ReporteTransferencias");
            }

               _svcreporte = new Reportes.ReportesClient();
              _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                _svcAdmonClient = new AdministracionSvc.AdministracionClient();

                vwmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.Canal_Venta) }));
                vwmodel.Canales.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección" });

                vwmodel.SubCanales.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

                vwmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.Tipo_Plan) }));
                vwmodel.Planes.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

                vwmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.Tipo_Contrato) }));
                vwmodel.Contratos.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

                vwmodel.TipoTransferencias.ForEach(x => x.Selected = (x.Value == vwmodel.Tipo_Transferencia.ToString()));

                var lData = _svcreporte.GetReporteTransferencias(vwmodel.Fecha_Periodo, vwmodel.Clave_Inicial_Asesor, vwmodel.Clave_Final_Asesor, vwmodel.Canal_Venta, vwmodel.SubCanal, vwmodel.Id_Director, vwmodel.Id_GerenteOficina,
                    vwmodel.Id_GerenteRegional, vwmodel.Contrato, vwmodel.Subcontrato, vwmodel.Tipo_Plan, vwmodel.Tipo_Contrato, vwmodel.Tipo_Transferencia, vwmodel.modelo,vwmodel.sucursal);
                vwmodel.Visualizar = 1;
                vwmodel.lDatos = lData.ToList();
                var gv = new GridView();
                gv.DataSource = lData;
                gv.DataBind();

                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=Transferencias.xls");
                Response.ContentType = "application/ms-excel";

                Response.Charset = "";
                StringWriter objStringWriter = new StringWriter();
                HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);

                gv.RenderControl(objHtmlTextWriter);

                Response.Output.Write(objStringWriter.ToString());
                Response.Flush();
                Response.End();
                return View(vwmodel);
           
        }



        public ActionResult ReporteAsesores()
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcCalculosClient = new CalculosTalentosComision.CalculosClient();
            
            ReportesModel.ReporteAsesoresViewModel vmmodel = new ReportesModel.ReporteAsesoresViewModel();

            List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

            List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

            vmmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
            vmmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            
            vmmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
            .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));

            vmmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0)
            .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));

            vmmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            //vmmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
            //    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            //vmmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            //vmmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            //vmmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

            vmmodel.Visualizar = 0;
            vmmodel.TipoReporte = 3;
            return View(vmmodel);
        }

        

        public ActionResult ReportsBH()
        {
           

            ReportesModel.ReportBHViewModel vmmodel = new ReportesModel.ReportBHViewModel();
            Dictionary<int, string> Result = new Dictionary<int, string>();
            //Fomrato Extracción
            vmmodel.FormatList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            vmmodel.FormatList.Insert(1, new SelectListItem() { Value = "1", Text = "TXT", Selected = false });
            vmmodel.FormatList.Insert(2, new SelectListItem() { Value = "2", Text = "EXCEL", Selected = false });


            //Reportes BH: 
            vmmodel.ProcessTypeList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            vmmodel.ProcessTypeList.Insert(1, new SelectListItem() { Value = "1", Text = "DIFERIDO", Selected = false });
            vmmodel.ProcessTypeList.Insert(2, new SelectListItem() { Value = "2", Text = "DEVENGADO", Selected = false });

            // Lee Periodos Cargados Por la ETL: ReporteDiferidoDevengado_SAI_BH - Tabla: [ReportPeriodBH_SAI]


            _svcreporte = new Reportes.ReportesClient();
            
            Result = _svcreporte.GetAvaliablePeriodsBH();
            vmmodel.AvaliablePeriodsReport.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            foreach (var Period in Result)
            {
                vmmodel.AvaliablePeriodsReport.Insert((Period.Key), new SelectListItem() { Value = (Period.Value).ToString(), Text = Period.Value, Selected = false });
            }
            
            return View(vmmodel);
        }

        public ActionResult ReporteComercial() {
            ReportesModel.ReporteAsesoresViewModel vmmodel = new ReportesModel.ReporteAsesoresViewModel();

            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcreporte = new Reportes.ReportesClient();

            string idDocumento= HttpContext.Session["IdDocumento"].ToString();
            //idDocumento = "19450520";
            vmmodel.IdDirector = _svcreporte.ValidaDirector(idDocumento);


            vmmodel.LiquidacionComision.AddRange(_svcModelClient.ListarLiquidacionComision().Where(x => x.idLiqComision != "0")
               .Select(x => new SelectListItem() { Value = x.idLiqComision.ToString(), Text = x.Fecha }));

            vmmodel.LiquidacionComision.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección", Selected = true });

            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult ReporteComercial(ReportesModel.ReporteAsesoresViewModel vwmodel)
        {
            //ReportesModel.ReporteAsesoresViewModel vmmodel = new ReportesModel.ReporteAsesoresViewModel();

            _svcreporte = new Reportes.ReportesClient();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();

            //vwmodel.FechaPeriodo = Convert.ToDateTime("01/04/2016");
            vwmodel.LiquidacionComision.AddRange(_svcModelClient.ListarLiquidacionComision().Where(x => x.idLiqComision != "0")
               .Select(x => new SelectListItem() { Value = x.idLiqComision.ToString(), Text = x.Fecha }));

            vwmodel.LiquidacionComision.Insert(0, new SelectListItem() { Value = "-1", Text = "Sin Selección" });


            string idDocumento= HttpContext.Session["IdDocumento"].ToString();
            //idDocumento = "19450520";
            int idDirector;
            idDirector = _svcreporte.ValidaDirector(idDocumento);
           
           if (idDirector !=0) {

               vwmodel.IdDirector = idDirector;
           }

           var lData = _svcreporte.GetReporteLiderComercial(vwmodel.anio, vwmodel.mes, vwmodel.ClavesAsesor, vwmodel.CanalVentas, vwmodel.SubCanal, vwmodel.IdGerente, vwmodel.IdDirector,
                   vwmodel.modelo, vwmodel.sucursal);

            //if (lData != null && lData.Length > 0)
            //{
                //genera reporte
                string DirectorioReporterelativo = "~/Areas/Comisiones/Reports/";
                string Urlarchivo = string.Format("{0}.{1}", "ReporteLiderComercial", "rdlc");

                String FullPathReport = string.Format("{0}{1}", this.HttpContext.Server.MapPath(DirectorioReporterelativo), Urlarchivo);

                ReportViewer Reporte = new ReportViewer();
                Reporte.LocalReport.ReportPath = FullPathReport;

                ReportDataSource DataSource = new ReportDataSource("DsRepLidercomercial", lData); // dataset y lista de datos
                Reporte.LocalReport.DataSources.Add(DataSource);
                Reporte.LocalReport.Refresh();


                byte[] file = Reporte.LocalReport.Render("Excel");

                return File(new MemoryStream(file).ToArray(), System.Net.Mime.MediaTypeNames.Application.Octet,
                            string.Format("{0}.{1}", "ReporteLiderComercial", "xls"));
            //}
            //else
            //{

            //    ViewBag.Message = "No se encontraron datos para generar el reporte";
            //   // TempData["RptLider_Mensaje"] = "No se encontraron datos para generar el reprote";
            //    return View();
            //    //return RedirectToAction("ReporteComercial");
            //    //return Content("<script languague='javascript' type='text/javascript'>alert('No se encontraron datos para generar el reporte');</script>");
            //    //return JavaScript('alert("No se encontraron datos para generar el reporte")');
              
            //}

            //return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult ReporteAsesores(ReportesModel.ReporteAsesoresViewModel vwmodel)
        {
          
                _svcreporte = new Reportes.ReportesClient();
                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                _svcAdmonClient = new AdministracionSvc.AdministracionClient();
                _svcCalculosClient = new CalculosTalentosComision.CalculosClient();

                List<LiquidacionComision> liquidaciones = _svcCalculosClient.ObtenerHistoricoLiquidaciones().ToList();

                List<int> Anios = liquidaciones.Where(x => x.tipoLiquidacion == 2 && x.estadoliquidacion_id == 2).Select(x => (int)x.año).Distinct().ToList();

                vwmodel.AnioList.AddRange(Anios.Select(x => new SelectListItem() { Value = x.ToString(), Text = x.ToString() }));
                vwmodel.AnioList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.MesList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                vwmodel.Sucursal.AddRange(_svcAdmonClient.ListarLocalidades().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));

                vwmodel.Sucursal.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


                vwmodel.Modelo.AddRange(_svcModelClient.ListarModelosComision().Where(x => x.id > 0)
                .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));

                vwmodel.Modelo.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


                vwmodel.Canales.AddRange(_svcModelClient.ListarCanalesDetalle().Where(x => x.id > 0)
                    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.CanalVentas) }));

                vwmodel.Canales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección" });


                vwmodel.SubCanales.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                //vwmodel.Planes.AddRange(_svcAdmonClient.ListarPlanDetalles(0).Where(x => x.id > 0)
                //    .Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoPlan) }));
                //vwmodel.Planes.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });

                //vwmodel.Contratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == vwmodel.TipoContrato) }));
                //vwmodel.Contratos.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


                var lData = _svcreporte.GetReporteAsesores(
                    vwmodel.anio, vwmodel.mes, vwmodel.ClavesAsesor, vwmodel.CanalVentas, vwmodel.SubCanal,vwmodel.IdGerente,vwmodel.IdDirector,
                    vwmodel.modelo, vwmodel.sucursal);

                vwmodel.Visualizar = 0;
                vwmodel.lDatos = lData.ToList();

                var gv = new GridView();
                gv.DataSource = lData;
                gv.DataBind();

                Response.ClearContent();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=Asesores.xls");
                Response.ContentType = "application/ms-excel";

                Response.Charset = "";
                StringWriter objStringWriter = new StringWriter();
                HtmlTextWriter objHtmlTextWriter = new HtmlTextWriter(objStringWriter);

                gv.RenderControl(objHtmlTextWriter);

                Response.Output.Write(objStringWriter.ToString());
                Response.Flush();
                Response.End();

                
                return View(vwmodel);
            }


        [HttpPost, Authorize]
        public ActionResult ReportsBH(ReportesModel.ReportBHViewModel vwmodel)
        {
             
            _svcreporte = new Reportes.ReportesClient();
            DateTime DateTemp = new DateTime();
            //Fomrato Extracción
            vwmodel.FormatList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            //Reportes BH: 
            vwmodel.ProcessTypeList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });


            vwmodel.FormatList.Insert(1, new SelectListItem() { Value = "1", Text = "TXT", Selected = false });
            vwmodel.FormatList.Insert(2, new SelectListItem() { Value = "2", Text = "EXCEL", Selected = false });


            //Reportes BH: 
            vwmodel.ProcessTypeList.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            vwmodel.ProcessTypeList.Insert(1, new SelectListItem() { Value = "1", Text = "DIFERIDO", Selected = false });
            vwmodel.ProcessTypeList.Insert(2, new SelectListItem() { Value = "2", Text = "DEVENGADO", Selected = false });

            // Lee Periodos Cargados Por la ETL: ReporteDiferidoDevengado_SAI_BH - Tabla: [ReportPeriodBH_SAI]

            Dictionary<int, string> Result = new Dictionary<int, string>();
            _svcreporte = new Reportes.ReportesClient();

            Result = _svcreporte.GetAvaliablePeriodsBH();
            vwmodel.AvaliablePeriodsReport.Insert(0, new SelectListItem() { Value = "0", Text = "Sin Selección", Selected = true });
            foreach (var Period in Result)
            {
                vwmodel.AvaliablePeriodsReport.Insert((Period.Key), new SelectListItem() { Value = (Period.Value).ToString(), Text = Period.Value, Selected = false });
            }


            string[] subs = vwmodel.Period.Split('/');

            vwmodel.DateIni = Convert.ToDateTime(vwmodel.Period);
            vwmodel.DateFin = Convert.ToDateTime(vwmodel.Period);
            var gv = new GridView();

            switch (vwmodel.ProcessType)
            {
                case 1:
                    //DIFERIDOS
                  var   lData = _svcreporte.GetReportBHDeferred(vwmodel.DateIni, vwmodel.DateFin, vwmodel.Format, vwmodel.ProcessType, HttpContext.Session["userName"].ToString());
                   // vwmodel.lDatos = lData.ToList();

                    //gv.DataSource = lData;
                    break;
                case 2:
                   var   lData2 = _svcreporte.GetReportBHAccrued(vwmodel.DateIni, vwmodel.DateFin, vwmodel.Format, vwmodel.ProcessType, HttpContext.Session["userName"].ToString());
                        //vwmodel.lDatos2 = lData2.ToList();
                        // gv.DataSource = lData2;
                    break;
            }
            
                 
                            return View(vwmodel);
        }



    }
}