using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using Entidades = ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ComisionFijaController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private AdministracionSvc.AdministracionClient _svcAdmonClient;
        string Username = string.Empty;

        [Authorize]
        public ActionResult Detalle(int id)
        {
            DetalleFactoresComisionFijaViewModel vmmodel = new DetalleFactoresComisionFijaViewModel()
            {
                IdModelo = id
            };
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vmmodel.SetViewModel(dbmodel);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            vmmodel.FactoresComision.AddRange(_svcModelClient.ListarFactorComisionFijaXModeloId(vmmodel.IdModelo)
                .Select(x => new FactorComisionFijaViewModel()
                {
                    id = x.id,
                    Factor = x.factor,
                    CompaniaId = x.compania_id,
                    NombreCompania = x.Compania.nombre,
                    EdadMinima = x.edadminima,
                    EdadMaxima = x.edadmaxima,
                    PlanId = x.planDetalle_id,
                    ProductoId = x.productoDetalle_id,
                    RamoId = x.ramoDetalle_id,
                    TipoContratoId = x.tipocontrato_id,
                    NombreRamo = x.RamoDetalle.nombre,
                    DescripcionTipoContrato = x.TipoContrato.nombre,
                    DescripcionPlan = (x.PlanDetalle == null ? "Todos" : x.PlanDetalle.nombre),
                    ClasificacioRecaudo = (EstadoBeneficiario)x.estadoBeneficiario_id,
                    ModeloId = x.modelo_id
                }));
            vmmodel.Companias.AddRange(_svcAdmonClient.ListarCompanias().Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.Companias.Insert(0, new SelectListItem() { Text = "Seleccionar", Value = "" });
            vmmodel.TipoContratos.AddRange(_svcAdmonClient.ListarTipoContratos().Where(x => x.id > 0).Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.TipoContratos.Insert(0, new SelectListItem() { Text = "Seleccionar", Value = "" });

            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult Agregar(DetalleFactoresComisionFijaViewModel vmmodel)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();

            if (ModelState.IsValid)
            {
                //Se valida que la edad maxima esté en el rango permitido
                if (_svcModelClient.ValidarEdadMaxima(vmmodel.EdadMaximaIngresada)==false)
                {
                    TempData["ErrorMessage"] = "La edad ingresada supera la edad máxima permitida";
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(vmmodel);
                    return RedirectToAction("Detalle", new { area = "Comisiones", id = vmmodel.IdModelo });
                }

                Entidades.FactorComisionFija dbobj = new Entidades.FactorComisionFija()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    edadmaxima = vmmodel.EdadMaximaIngresada,
                    edadminima = vmmodel.EdadMinimaIngresada,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    estadoBeneficiario_id = (int)vmmodel.ClasificacionRecaudo,
                    modelo_id = vmmodel.IdModelo
                };
                if (vmmodel.IdPlanSeleccionado.HasValue)
                {
                    dbobj.planDetalle_id = vmmodel.IdPlanSeleccionado.Value;
                }
                if (vmmodel.IdProductoSeleccionado.HasValue)
                {
                    dbobj.productoDetalle_id = vmmodel.IdProductoSeleccionado.Value;
                }
                if (vmmodel.IdTipoContratoSeleccionado.HasValue)
                {
                    dbobj.tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado.Value;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    
                    var res = _svcModelClient.InsertarFactorComisionFija(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión fija agregado correctamente";
                    }
                    else
                    {
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        this.FormToTempData(vmmodel);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(vmmodel);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["OperationSuccess"] = false;
                TempData["openForm"] = true;
                this.FormToTempData(vmmodel);
            }
            return RedirectToAction("Detalle", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [HttpPost, Authorize]
        public ActionResult Editar(DetalleFactoresComisionFijaViewModel vmmodel)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();


            if (ModelState.IsValid)
            {

                //Se valida que la edad maxima esté en el rango permitido
                if (_svcModelClient.ValidarEdadMaxima(vmmodel.EdadMaximaIngresada) == false)
                {
                    TempData["ErrorMessage"] = "La edad ingresada supera la edad máxima permitida";
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(vmmodel);
                    return RedirectToAction("Detalle", new { area = "Comisiones", id = vmmodel.IdModelo });
                }

                Entidades.FactorComisionFija dbobj = new Entidades.FactorComisionFija()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    edadmaxima = vmmodel.EdadMaximaIngresada,
                    edadminima = vmmodel.EdadMinimaIngresada,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado,
                    estadoBeneficiario_id = (int)vmmodel.ClasificacionRecaudo,
                    modelo_id = vmmodel.IdModelo
                };
                if (vmmodel.IdPlanSeleccionado.HasValue)
                {
                    dbobj.planDetalle_id = vmmodel.IdPlanSeleccionado.Value;
                }
                if (vmmodel.IdProductoSeleccionado.HasValue)
                {
                    dbobj.productoDetalle_id = vmmodel.IdProductoSeleccionado.Value;
                }
                if (!vmmodel.IdFactorSeleccionado.HasValue)
                {
                    TempData["ErrorMessage"] = "Error no controlado. Sí el problema persiste contacte al administrador del Sistema";
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    return RedirectToAction("Detalle", new { area = "Comisiones", id = vmmodel.IdModelo });
                }
                else
                {
                    dbobj.id = vmmodel.IdFactorSeleccionado.Value;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarFactorComisionFija(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión fija modificado correctamente";

                    }
                    else
                    {
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        this.FormToTempData(vmmodel, true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(vmmodel,true);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel,true);
            }
            return RedirectToAction("Detalle", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [Authorize]
        public ActionResult Eliminar(int factorId, int modeloId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res
                    = _svcModelClient.EliminarFactorComisionFija(new Entidades.FactorComisionFija()
                    {
                        id = factorId,
                        modelo_id = modeloId
                    }, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Factor de comisión fija eliminado correctamente";

                }
                else
                {
                    TempData["OperationSuccess"] = false;
                    TempData["ErrorMessage"] = res.MensajeError;
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("Detalle", new { area = "Comisiones", id = modeloId });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerRamosXCompaniaId(int companiaId)
        {
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            JsonResult result = new JsonResult();
            result.Data = _svcAdmonClient.ListarRamoDetalleXCompania(companiaId).Select(x => new { id = x.id, nombre = x.nombre });
            return result;
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerProductosXRamoId(int ramoId)
        {
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            JsonResult result = new JsonResult();
            result.Data = _svcAdmonClient.ListarProductoDetalleXRamoDetalle(ramoId).Select(x => new { id = x.id, nombre = x.nombre });
            return result;
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerPlanesXProductoId(int productoId)
        {
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            JsonResult result = new JsonResult();
            result.Data = _svcAdmonClient.ListarPlanDetalleActivosXProductoDetalle(productoId).Select(x => new { id = x.id, nombre = x.nombre });
            return result;
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerFactorXId(int factorId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            Entidades.FactorComisionFija dbobj = _svcModelClient.ObtenerFactorComisionFijaXId(factorId);
            result.Data = dbobj;
            return result;
        }

        private void FormToTempData(DetalleFactoresComisionFijaViewModel vmmodel, bool editing = false)
        {
            TempData["IdCompaniaSeleccionada"] = vmmodel.IdCompaniaSeleccionada;
            TempData["IdTipoContratoSeleccionado"] = vmmodel.IdTipoContratoSeleccionado;
            TempData["IdRamoSeleccionado"] = vmmodel.IdRamoSeleccionado;
            TempData["IdProductoSeleccionado"] = vmmodel.IdProductoSeleccionado;
            TempData["IdPlanSeleccionado"] = vmmodel.IdPlanSeleccionado;
            TempData["EdadMaximaIngresada"] = vmmodel.EdadMaximaIngresada;
            TempData["EdadMinimaIngresada"] = vmmodel.EdadMinimaIngresada;
            TempData["FactorIngresado"] = vmmodel.FactorIngresado;
            TempData["ClasificacionRecaudo"] = (byte)vmmodel.ClasificacionRecaudo;
            if (vmmodel.IdFactorSeleccionado.HasValue)
            {
                TempData["IdFactorSeleccionado"] = vmmodel.IdFactorSeleccionado.Value;
            }
            if (editing)
            {
                TempData["editing"] = true;
            }
        }
    }
}
