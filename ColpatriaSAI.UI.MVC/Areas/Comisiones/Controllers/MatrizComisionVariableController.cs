using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using Entidades = ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class MatrizComisionVariableController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        string Username = string.Empty;

        [Authorize]
        public ActionResult Index(int id)
        {
            MatrizComisionVariableViewModel vmmodel = new MatrizComisionVariableViewModel() { ModeloId = id };
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vmmodel.SetViewModel(dbmodel);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            try
            {
                var matrizDb = _svcModelClient.ListarValoresMatrizComisionVariableXModelo(vmmodel.ModeloId);
                if (matrizDb.Count() > 0)
                {
                    vmmodel.HayEjesDefinidos = true;
                    foreach (var mcvPunto in matrizDb)
                    {
                        vmmodel.Matriz.Add(new XYMatrizVariable()
                        {
                            Factor = mcvPunto.factor,
                            X = new XNetoViewModel()
                            {
                                Id = mcvPunto.rangoxnetos_id,
                                LimiteInferior = mcvPunto.RangosXNeto.rangomin,
                                LimiteSuperior = mcvPunto.RangosXNeto.rangomax
                            },
                            XId = mcvPunto.rangoxnetos_id,
                            Y = new YNuevoViewModel()
                            {
                                Id = mcvPunto.rangoynuevos_id,
                                LimiteInferior = mcvPunto.RangosYNuevo.rangomin,
                                LimiteSuperior = mcvPunto.RangosYNuevo.rangomax
                            },
                            YId = mcvPunto.rangoynuevos_id
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["OperationSuccess"] = false;
                TempData["ErrorMessage"] = "Error no controlado. " + ex.Message;
            }
            return View(vmmodel);
        }

        [Authorize]
        public ActionResult ConfigurarEjes(int id)
        {
            MatrizComisionVariableViewModel vmmodel = new MatrizComisionVariableViewModel() { ModeloId = id };
            vmmodel = CargarEjesMatriz(vmmodel);
            return View(vmmodel);
        }

        [HttpPost]
        [Authorize]
        public ActionResult ConfigurarEjes(FormCollection form)
        {
            MatrizComisionVariableViewModel vmmodel = new MatrizComisionVariableViewModel() { ModeloId = Convert.ToInt32(form["ModeloId"]) };
            bool hasErrors = false;
            List<string> errores = new List<string>();
            try
            {
                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                var dbmodel = _svcModelClient.ObtenerModeloComisionXId(vmmodel.ModeloId);
                vmmodel.DescripcionModelo = dbmodel.descripcion;
                vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
                vmmodel.Dimension = Convert.ToInt32(form["DimensionInicial"]);
                if (ModelState.IsValid)
                {
                    List<Entidades.RangosXNeto> ejex = new List<Entidades.RangosXNeto>();
                    List<Entidades.RangosYNuevo> ejey = new List<Entidades.RangosYNuevo>();
                    for (int i = 1; i <= vmmodel.Dimension; i++)
                    {
                        Entidades.RangosXNeto tmprxn = new Entidades.RangosXNeto()
                        {
                            rangomin = Convert.ToInt32(form["xinf" + i.ToString()]),
                            rangomax = Convert.ToInt32(form["xsup" + i.ToString()])
                        };
                        if (tmprxn.rangomin < tmprxn.rangomax)
                        {
                            ejex.Add(tmprxn);
                        }
                        else
                        {
                            hasErrors = true;
                            errores.Add(string.Format("El rango mínimo es mayor al máximo en el eje x{0}.", i));
                        }
                        Entidades.RangosYNuevo tmpryn = new Entidades.RangosYNuevo()
                        {
                            rangomin = Convert.ToInt32(form["yinf" + i.ToString()]),
                            rangomax = Convert.ToInt32(form["ysup" + i.ToString()])
                        };
                        if (tmpryn.rangomin < tmpryn.rangomax)
                        {
                            ejey.Add(tmpryn);
                        }
                        else
                        {
                            hasErrors = true;
                            errores.Add(string.Format("El rango mínimo es mayor al máximo en el eje y{0}.", i));
                        }
                    }
                    if (!hasErrors)
                    {
                        if (HttpContext.Session["userName"] != null)
                            Username = HttpContext.Session["userName"].ToString();

                        var res = _svcModelClient.AdicionarRangosMatriz(vmmodel.ModeloId, ejex.ToArray(), ejey.ToArray(), Username);
                        if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                        {
                            TempData["OperationSuccess"] = true;
                            TempData["SuccessMessage"] = "Matriz de comisión variable guardada correctamente";
                        }
                        else
                        {
                            TempData["OperationSuccess"] = false;
                            TempData["ErrorMessage"] = res.MensajeError;
                        }
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["ErrorMessage"] = "Se encontraron los siguientes errores: ";
                        foreach (var item in errores)
                        {
                            TempData["ErrorMessage"] += item;
                        }
                    }
                }
                else
                {
                    TempData["ErrorMessage"] = "Datos inválidos";
                    TempData["OperationSuccess"] = false;
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["OperationSuccess"] = false;
            }
            return RedirectToAction("ConfigurarEjes", new { id = vmmodel.ModeloId });
        }

        [Authorize]
        public ActionResult LimpiarMatriz(int id)
        {
            try
            {
                if (HttpContext.Session["userName"] != null)
                    Username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                var res = _svcModelClient.EliminarMatrizComisionVariableXModeloId(id, Username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Matriz de comisión variable eliminada correctamente";

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
            return RedirectToAction("ConfigurarEjes", new { id = id });
        }

        [Authorize]
        public ActionResult ConfigurarFactores(int id)
        {
            MatrizComisionVariableViewModel vmmodel = new MatrizComisionVariableViewModel() { ModeloId = id };
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(id);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            CargarEjesMatriz(vmmodel);

            try
            {
                var matrizDb = _svcModelClient.ListarValoresMatrizComisionVariableXModelo(vmmodel.ModeloId);
                if (matrizDb.Count() > 0)
                {
                    vmmodel.HayEjesDefinidos = true;
                    foreach (var mcvPunto in matrizDb)
                    {
                        vmmodel.Matriz.Add(new XYMatrizVariable()
                        {
                            Factor = mcvPunto.factor,
                            X = new XNetoViewModel()
                            {
                                Id = mcvPunto.rangoxnetos_id,
                                LimiteInferior = mcvPunto.RangosXNeto.rangomin,
                                LimiteSuperior = mcvPunto.RangosXNeto.rangomax
                            },
                            XId = mcvPunto.rangoxnetos_id,
                            Y = new YNuevoViewModel()
                            {
                                Id = mcvPunto.rangoynuevos_id,
                                LimiteInferior = mcvPunto.RangosYNuevo.rangomin,
                                LimiteSuperior = mcvPunto.RangosYNuevo.rangomax
                            },
                            YId = mcvPunto.rangoynuevos_id
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["OperationSuccess"] = false;
                TempData["ErrorMessage"] = "Error no controlado. " + ex.Message;
            }

            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult GuardarFactor(MatrizComisionVariableViewModel vmmodel)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    Entidades.MatrizComisionVariable dbobj = new Entidades.MatrizComisionVariable()
                    {
                        modelo_id = vmmodel.ModeloId,
                        rangoxnetos_id = vmmodel.RangoXNetoSeleccionado,
                        rangoynuevos_id = vmmodel.RangoYNuevoSeleccionado,
                        factor = vmmodel.FactorDefinido
                    };

                    if (HttpContext.Session["userName"] != null)
                        Username = HttpContext.Session["userName"].ToString();

                    var result = _svcModelClient.ActualizarFactorMatrizComisionVariable(dbobj, Username);
                    if (result.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                        TempData["SuccessMessage"] = "Matriz de comisión variable guardada correctamente";
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        TempData["ErrorMessage"] = result.MensajeError;
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
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                TempData["openForm"] = true;
                TempData["OperationSuccess"] = false;
                this.FormToTempData(vmmodel);
            }
            return RedirectToAction("ConfigurarFactores", "MatrizComisionVariable", new { area = "Comisiones", id = vmmodel.ModeloId });
        }

        private void FormToTempData(MatrizComisionVariableViewModel vmmodel)
        {
            TempData["ModeloId"] = vmmodel.ModeloId;
            TempData["RangoXNetoSeleccionado"] = vmmodel.RangoXNetoSeleccionado;
            TempData["RangoYNuevoSeleccionado"] = vmmodel.RangoYNuevoSeleccionado;
            TempData["FactorDefinido"] = vmmodel.FactorDefinido;
        }

        [Authorize]
        private MatrizComisionVariableViewModel CargarEjesMatriz(MatrizComisionVariableViewModel vmmodel)
        {
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbmodel = _svcModelClient.ObtenerModeloComisionXId(vmmodel.ModeloId);
            vmmodel.SetViewModel(dbmodel);
            vmmodel.DescripcionModelo = dbmodel.descripcion;
            vmmodel.FechaInicioVigenciaModelo = dbmodel.fechadesde;
            try
            {
                var ejex = _svcModelClient.ListarRangosXNetoMatrizComisionVariableXModelo(vmmodel.ModeloId);
                var ejey = _svcModelClient.ListarRangosYNuevoMatrizComisionVariableXModelo(vmmodel.ModeloId);
                if (ejex.Count() > 0)
                {
                    vmmodel.HayEjesDefinidos = true;
                    vmmodel.Dimension = ejex.Count();
                    vmmodel.XNetos = new List<XNetoViewModel>();
                    vmmodel.YNuevos = new List<YNuevoViewModel>();
                    foreach (var mcvPunto in ejex)
                    {
                        vmmodel.XNetos.Add(new XNetoViewModel()
                        {
                            Id = mcvPunto.id,
                            LimiteInferior = mcvPunto.rangomin,
                            LimiteSuperior = mcvPunto.rangomax
                        });
                    }
                    foreach (var mcvPunto in ejey)
                    {
                        vmmodel.YNuevos.Add(new YNuevoViewModel()
                        {
                            Id = mcvPunto.id,
                            LimiteInferior = mcvPunto.rangomin,
                            LimiteSuperior = mcvPunto.rangomax
                        });
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["OperationSuccess"] = false;
                TempData["ErrorMessage"] = "Error no controlado. " + ex.Message;
            }
            return vmmodel;
        }
    }
}
