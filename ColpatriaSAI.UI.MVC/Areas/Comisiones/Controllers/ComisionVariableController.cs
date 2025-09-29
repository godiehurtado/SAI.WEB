using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using Entidades = ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    [Authorize]
    public class ComisionVariableController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private AdministracionSvc.AdministracionClient _svcAdmonClient;
        string Username = string.Empty;

        #region Factores Netos
        public ActionResult FactoresNetos(int id)
        {
            DetalleFactoresNetosComisionVariableViewModel vmmodel = new DetalleFactoresNetosComisionVariableViewModel()
            {
                IdModelo = id
            };
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vmmodel.SetViewModel(dbmodel);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            vmmodel.FactoresComision.AddRange(_svcModelClient.ListarFactorNetoComisionVariableXModeloId(vmmodel.IdModelo)
                .Select(x => new FactorNetoComisionVariableViewModel()
                {
                    id = x.id,
                    Factor = x.factor,
                    CompaniaId = x.compania_id,
                    NombreCompania = x.Compania.nombre,
                    PlanId = x.planDetalle_id,
                    NombrePlan = x.PlanDetalle == null ? "Todos": x.PlanDetalle.nombre,
                    ProductoId = x.productoDetalle_id,
                    RamoId = x.ramoDetalle_id,
                    TipoContratoId = x.tipocontrato_id,
                    NombreRamo = x.RamoDetalle.nombre,
                    DescripcionTipoContrato = x.TipoContrato.nombre,
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
        public ActionResult AgregarFactorNeto(DetalleFactoresNetosComisionVariableViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.FactorComisionVariableNeto dbobj = new Entidades.FactorComisionVariableNeto()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado.Value,
                    estadoBeneficiario_id = 4,
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
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarFactorNetoComisionVariable(dbobj, Username);

                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión variable neto agregado correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["openForm"] = true;
                        this.FormToTempData(vmmodel);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                this.FormToTempData(vmmodel);
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("FactoresNetos", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [HttpPost, Authorize]
        public ActionResult EditarFactorNeto(DetalleFactoresNetosComisionVariableViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.FactorComisionVariableNeto dbobj = new Entidades.FactorComisionVariableNeto()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado.Value,
                    estadoBeneficiario_id = 4,
                    modelo_id = vmmodel.IdModelo
                };
                if (!vmmodel.IdFactorSeleccionado.HasValue)
                {
                    TempData["ErrorMessage"] = "Error no controlado. Sí el problema persiste contacte al administrador del Sistema";
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel,true);
                    return RedirectToAction("FactoresNetos", new { area = "Comisiones", id = vmmodel.IdModelo });
                }
                else
                {
                    dbobj.id = vmmodel.IdFactorSeleccionado.Value;
                }
                if (vmmodel.IdPlanSeleccionado.HasValue)
                {
                    dbobj.planDetalle_id = vmmodel.IdPlanSeleccionado.Value;
                }
                if (vmmodel.IdProductoSeleccionado.HasValue)
                {
                    dbobj.productoDetalle_id = vmmodel.IdProductoSeleccionado.Value;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarFactorNetoComisionVariable(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión variable neto modificado correctamente";

                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel,true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
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
            return RedirectToAction("FactoresNetos", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [Authorize]
        public ActionResult EliminarFactorNeto(int factorId, int modeloId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res
                    = _svcModelClient.EliminarFactorNetoComisionVariable(new Entidades.FactorComisionVariableNeto()
                    {
                        id = factorId,
                        modelo_id = modeloId
                    }, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Factor de comisión variable neto eliminado correctamente";

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
            return RedirectToAction("FactoresNetos", new { area = "Comisiones", id = modeloId });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerFactorNetoXId(int factorId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            Entidades.FactorComisionVariableNeto dbobj = _svcModelClient.ObtenerFactorNetoComisionVariableXId(factorId);
            result.Data = dbobj;
            return result;
        }

        #endregion

        #region Factores Nuevos
        public ActionResult FactoresNuevos(int id)
        {
            DetalleFactoresNuevosComisionVariableViewModel vmmodel = new DetalleFactoresNuevosComisionVariableViewModel()
            {
                IdModelo = id
            };
            _svcAdmonClient = new AdministracionSvc.AdministracionClient();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vmmodel.SetViewModel(dbmodel);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            vmmodel.FactoresComision.AddRange(_svcModelClient.ListarFactorNuevoComisionVariableXModeloId(vmmodel.IdModelo)
                .Select(x => new FactorNuevoComisionVariableViewModel()
                {
                    id = x.id,
                    Factor = x.factor,
                    CompaniaId = x.compania_id,
                    NombreCompania = x.Compania.nombre,
                    PlanId = x.planDetalle_id,
                    ProductoId = x.productoDetalle_id,
                    NombrePlan = x.PlanDetalle == null ? "Todos" : x.PlanDetalle.nombre,
                    RamoId = x.ramoDetalle_id,
                    TipoContratoId = x.tipocontrato_id,
                    NombreRamo = x.RamoDetalle.nombre,
                    DescripcionTipoContrato = x.TipoContrato.nombre,
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
        public ActionResult AgregarFactorNuevo(DetalleFactoresNuevosComisionVariableViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.FactorComisionVariableNuevo dbobj = new Entidades.FactorComisionVariableNuevo()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado.Value,
                    estadoBeneficiario_id = 1,
                    modelo_id = vmmodel.IdModelo
                };
                if (vmmodel.IdPlanSeleccionado.HasValue && vmmodel.IdPlanSeleccionado.Value != -1)
                {
                    dbobj.planDetalle_id = vmmodel.IdPlanSeleccionado.Value;
                }
                if (vmmodel.IdProductoSeleccionado.HasValue && vmmodel.IdProductoSeleccionado.Value != -1)
                {
                    dbobj.productoDetalle_id = vmmodel.IdProductoSeleccionado.Value;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarFactorNuevoComisionVariable(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión variable nuevo agregado correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel);
            }
            return RedirectToAction("FactoresNuevos", new { area = "Comisiones", id = vmmodel.IdModelo });
        }


        [HttpPost, Authorize]
        public ActionResult EditarFactorNuevo(DetalleFactoresNuevosComisionVariableViewModel vmmodel)
        {
            if (ModelState.IsValid)
            {
                Entidades.FactorComisionVariableNuevo dbobj = new Entidades.FactorComisionVariableNuevo()
                {
                    compania_id = vmmodel.IdCompaniaSeleccionada,
                    factor = vmmodel.FactorIngresado,
                    ramoDetalle_id = vmmodel.IdRamoSeleccionado,
                    tipocontrato_id = (byte)vmmodel.IdTipoContratoSeleccionado.Value,
                    estadoBeneficiario_id = 1,
                    modelo_id = vmmodel.IdModelo
                };
                if (!vmmodel.IdFactorSeleccionado.HasValue)
                {
                    TempData["ErrorMessage"] = "Error no controlado. Sí el problema persiste contacte al administrador del Sistema";
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel,true);
                    return RedirectToAction("FactoresNuevos", new { area = "Comisiones", id = vmmodel.IdModelo });
                }
                else
                {
                    dbobj.id = vmmodel.IdFactorSeleccionado.Value;
                }
                if (vmmodel.IdPlanSeleccionado.HasValue && vmmodel.IdPlanSeleccionado.Value != -1)
                {
                    dbobj.planDetalle_id = vmmodel.IdPlanSeleccionado.Value;
                }
                if (vmmodel.IdProductoSeleccionado.HasValue && vmmodel.IdProductoSeleccionado.Value != -1)
                {
                    dbobj.productoDetalle_id = vmmodel.IdProductoSeleccionado.Value;
                }
                try
                {
                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarFactorNuevoComisionVariable(dbobj, Username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Factor de comisión variable neto modificado correctamente";
                    }
                    else
                    {
                        TempData["openForm"] = true;
                        TempData["OperationSuccess"] = false;
                        TempData["ErrorMessage"] = res.MensajeError;
                        this.FormToTempData(vmmodel,true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["openForm"] = true;
                    TempData["OperationSuccess"] = false;
                    this.FormToTempData(vmmodel,true);
                }
            }
            else
            {
                TempData["openForm"] = true;
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel, true);
            }
            return RedirectToAction("FactoresNuevos", new { area = "Comisiones", id = vmmodel.IdModelo });
        }

        [Authorize]
        public ActionResult EliminarFactorNuevo(int factorId, int modeloId)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res
                    = _svcModelClient.EliminarFactorNuevoComisionVariable(new Entidades.FactorComisionVariableNuevo()
                    {
                        id = factorId,
                        modelo_id = modeloId
                    }, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Factor de comisión variable neto eliminado correctamente";
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
            return RedirectToAction("FactoresNuevos", new { area = "Comisiones", id = modeloId });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerFactorNuevoXId(int factorId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            Entidades.FactorComisionVariableNuevo dbobj = _svcModelClient.ObtenerFactorNuevoComisionVariableXId(factorId);
            result.Data = dbobj;
            return result;
        }
        #endregion

        private void FormToTempData(DetalleFactoresNuevosComisionVariableViewModel vmmodel, bool editing = false)
        {
            TempData["IdCompaniaSeleccionada"] = vmmodel.IdCompaniaSeleccionada;
            TempData["IdTipoContratoSeleccionado"] = vmmodel.IdTipoContratoSeleccionado;
            TempData["IdRamoSeleccionado"] = vmmodel.IdRamoSeleccionado;
            TempData["IdProductoSeleccionado"] = vmmodel.IdProductoSeleccionado;
            TempData["IdPlanSeleccionado"] = vmmodel.IdPlanSeleccionado;
            TempData["FactorIngresado"] = vmmodel.FactorIngresado;
            TempData["EstadoBeneficiario"] = vmmodel.ClasificacionRecaudo;
            if (vmmodel.IdFactorSeleccionado.HasValue)
            {
                TempData["IdFactorSeleccionado"] = vmmodel.IdFactorSeleccionado.Value;
            }
            if (editing)
            {
                TempData["editing"] = true;
            }
        }
        private void FormToTempData(DetalleFactoresNetosComisionVariableViewModel vmmodel, bool editing = false)
        {
            TempData["IdCompaniaSeleccionada"] = vmmodel.IdCompaniaSeleccionada;
            TempData["IdTipoContratoSeleccionado"] = vmmodel.IdTipoContratoSeleccionado;
            TempData["IdRamoSeleccionado"] = vmmodel.IdRamoSeleccionado;
            TempData["IdProductoSeleccionado"] = vmmodel.IdProductoSeleccionado;
            TempData["IdPlanSeleccionado"] = vmmodel.IdPlanSeleccionado;
            TempData["FactorIngresado"] = vmmodel.FactorIngresado;
            TempData["EstadoBeneficiario"] = vmmodel.ClasificacionRecaudo;
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
