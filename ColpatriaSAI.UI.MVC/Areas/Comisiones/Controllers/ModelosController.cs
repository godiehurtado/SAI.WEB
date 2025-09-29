using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using System.Web.Mvc;
using Entidades = ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ModelosController :  ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private ModeloComisionSVC.ModeloComisionClient _svcModelClient;
        private AdministracionSvc.AdministracionClient adminClient;

        #region Modelo Comision

        [Authorize]
        public ActionResult ModeloComision()
        {
            ModeloViewModel vwmodel = new ModeloViewModel();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            vwmodel.ModelosComision.AddRange(_svcModelClient.ListarModelosComision());

            vwmodel.ListaCanales.AddRange(
                _svcModelClient.ListarCanalesDetalle().OrderBy(x => x.nombre).Select(x => new CanalViewModel()
                {
                    Id = x.id,
                    Nombre = x.nombre,
                    CanalDetalles = new List<SelectListItem>(x.CanalDetalles.OrderBy(y => y.nombre).Select(y => new SelectListItem()
                    {
                        Text = y.nombre,
                        Value = y.id.ToString()
                    }))
                })
            );


            vwmodel.canalesid.AddRange(_svcModelClient.ListarCanalesDetalle().OrderBy(x => x.nombre).Select(x => x.id.ToString()).ToList());

            vwmodel.ListaCanalDetalleTipoIntermediario.AddRange(
                _svcModelClient.ListarCanalDetalleTipoIntermediario().Select(x => new CanalDetalleTipoIntermediarioViewModel()
                {
                    idCanalDetalle = x.CanalDetalle_Id,
                    idTipoIntermediario = x.TipoIntermediario_Id
                }));

             var resultadoTipos = _svcModelClient.ListarTipoIntermediario().OrderBy(x => x.Nombre)
            .Select(x => new SelectListItem()
            {
                Value = x.Id.ToString(),
                Text = x.Nombre
            }).ToList();

            List<TipoIntermediarioViewModel> listaTipos = new List<TipoIntermediarioViewModel>();

            foreach (var item in resultadoTipos.OrderBy(x => x.Text))
            {
                listaTipos.Add(new TipoIntermediarioViewModel() { id = Convert.ToInt32(item.Value), Nombre = item.Text });
            }

            vwmodel.ListaTipoIntermediarios.AddRange(listaTipos);
           

            return View(vwmodel);
        }

        [Authorize]
        public JsonResult GuardarModelo()
        {
            try
            {
                string nombre = Request["nombre"];
                string descripcion = Request["descripcion"];
                string fechainicio = Request["fechainicio"];
                string fechafin = Request["fechafin"];
                string tope = Request["tope"];
                string parametros = Request["parametros"];

                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                    username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                adminClient = new AdministracionSvc.AdministracionClient();

                string[] subparametros = parametros.Substring(0, parametros.Length - 1).Split(';');

                var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();
                var cdtis = new Entidades.TrackableCollection<Entidades.CanalDetalleTipoIntermediario>();

                foreach (string sub in subparametros)
                {
                    string subcanal = sub.Split(':')[0];
                    Entidades.CanalDetalle canal = adminClient.ListarCanalDetalles().Where(x => x.id == int.Parse(subcanal)).FirstOrDefault();
                    canalDetalles.Add(canal);
                    string[] tipointermediario = sub.Split(':')[1].Split(',');
                    foreach (string tipo in tipointermediario)
                    {
                        Entidades.CanalDetalleTipoIntermediario canaldetalletipointermediario = _svcModelClient.ListarCanalDetalleTipoIntermediario().Where(x => x.CanalDetalle_Id == int.Parse(subcanal) && x.TipoIntermediario_Id == int.Parse(tipo)).FirstOrDefault();
                        cdtis.Add(canaldetalletipointermediario);
                    }
                }

                Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                {
                    nombre = nombre,
                    fechadesde = Convert.ToDateTime(fechainicio),
                    fechahasta = Convert.ToDateTime(fechafin),
                    descripcion = descripcion, //Campo codigo Tabla ModeloComision
                    tope = Convert.ToDouble(tope)
                };
                dbobj.CanalDetalles = canalDetalles;
                dbobj.CanalDetalleTipoIntermediarios = cdtis;

                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarModeloComision(dbobj, username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    return Json(new { Success = true});
                }
                else
                {
                    return Json(new { Success = false, ErrorMessage = res.MensajeError });
                }
            }
            catch (Exception ex)
            {
                return Json(new { Success = false, ErrorMessage = "Error no controlado:" + ex.Message });
            }
        }

        [Authorize]
        public JsonResult EditarModelo()
        {
            try
            {
                string idmodelo = Request["IdModelo"];
                string nombre = Request["nombre"];
                string descripcion = Request["descripcion"];
                string fechainicio = Request["fechainicio"];
                string fechafin = Request["fechafin"];
                string tope = Request["tope"];
                string parametros = Request["parametros"];
                // Arreglo para 
                //fechainicio = "3000/01/01";
                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                    username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                adminClient = new AdministracionSvc.AdministracionClient();

                string[] subparametros = parametros.Substring(0, parametros.Length - 1).Split(';');

                var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();
                var cdtis = new Entidades.TrackableCollection<Entidades.CanalDetalleTipoIntermediario>();

                foreach (string sub in subparametros)
                {
                    string subcanal = sub.Split(':')[0];
                    Entidades.CanalDetalle canal = adminClient.ListarCanalDetalles().Where(x => x.id == int.Parse(subcanal)).FirstOrDefault();
                    canalDetalles.Add(canal);
                    string[] tipointermediario = sub.Split(':')[1].Split(',');
                    foreach (string tipo in tipointermediario)
                    {
                        Entidades.CanalDetalleTipoIntermediario canaldetalletipointermediario = _svcModelClient.ListarCanalDetalleTipoIntermediario().Where(x => x.CanalDetalle_Id == int.Parse(subcanal) && x.TipoIntermediario_Id == int.Parse(tipo)).FirstOrDefault();
                        cdtis.Add(canaldetalletipointermediario);
                    }
                }

                Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                {
                    id = int.Parse(idmodelo),
                    nombre = nombre,
                    fechadesde = Convert.ToDateTime(fechainicio),
                    fechahasta = Convert.ToDateTime(fechafin),
                    descripcion = descripcion, //Campo codigo Tabla ModeloComision
                    tope = Convert.ToDouble(tope)
                };
                dbobj.CanalDetalles = canalDetalles;
                dbobj.CanalDetalleTipoIntermediarios = cdtis;

                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarModeloComision(dbobj, username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    return Json(new { Success = true });
                }
                else
                {
                    return Json(new { Success = false, ErrorMessage = res.MensajeError });
                }
            }
            catch (Exception ex)
            {
                return Json(new { Success = false, ErrorMessage = "Error no controlado:" + ex.Message });
            }
        }

        [Authorize]
        public JsonResult DuplicarModelo()
        {
            try
            {
                string idmodelo = Request["IdModelo"];
                string nombre = Request["nombre"];
                string descripcion = Request["descripcion"];
                string fechainicio = Request["fechainicio"];
                string fechafin = Request["fechafin"];
                string tope = Request["tope"];
                string parametros = Request["parametros"];

                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                    username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                adminClient = new AdministracionSvc.AdministracionClient();

                string[] subparametros = parametros.Substring(0, parametros.Length - 1).Split(';');

                var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();
                var cdtis = new Entidades.TrackableCollection<Entidades.CanalDetalleTipoIntermediario>();

                foreach (string sub in subparametros)
                {
                    string subcanal = sub.Split(':')[0];
                    Entidades.CanalDetalle canal = adminClient.ListarCanalDetalles().Where(x => x.id == int.Parse(subcanal)).FirstOrDefault();
                    canalDetalles.Add(canal);
                    string[] tipointermediario = sub.Split(':')[1].Split(',');
                    foreach (string tipo in tipointermediario)
                    {
                        Entidades.CanalDetalleTipoIntermediario canaldetalletipointermediario = _svcModelClient.ListarCanalDetalleTipoIntermediario().Where(x => x.CanalDetalle_Id == int.Parse(subcanal) && x.TipoIntermediario_Id == int.Parse(tipo)).FirstOrDefault();
                        cdtis.Add(canaldetalletipointermediario);
                    }
                }

                Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                {
                    id = int.Parse(idmodelo),
                    nombre = nombre,
                    fechadesde = Convert.ToDateTime(fechainicio),
                    fechahasta = Convert.ToDateTime(fechafin),
                    descripcion = descripcion, //Campo codigo Tabla ModeloComision
                    tope = Convert.ToDouble(tope)
                };
                dbobj.CanalDetalles = canalDetalles;
                dbobj.CanalDetalleTipoIntermediarios = cdtis;

                ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.DuplicarModeloComision(dbobj.id, dbobj, username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    return Json(new { Success = true });
                }
                else
                {
                    return Json(new { Success = false, ErrorMessage = res.MensajeError });
                }
            }
            catch (Exception ex)
            {
                return Json(new { Success = false, ErrorMessage = "Error no controlado:" + ex.Message });
            }
        }

        [HttpPost, Authorize]
        public ActionResult Agregar(FormCollection form)
        {
            if (ModelState.IsValid)
            {
                var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();

                foreach (var canalchk in form.AllKeys.Where(x => x.StartsWith("chk")))
                {
                    foreach (var canalDetalleId in form[canalchk].Split(','))
                    {
                        Entidades.CanalDetalle tmpcanalDetalle = new Entidades.CanalDetalle()
                        {
                            canal_id = Convert.ToInt32(canalchk.Substring(3)),
                            id = Convert.ToInt32(canalDetalleId)
                        };
                        canalDetalles.Add(tmpcanalDetalle);
                    }
                }

                var TipoIntermediario = new Entidades.TrackableCollection<Entidades.TipoIntermediario>();
                foreach (var TipoIntChk in form.AllKeys.Where(x => x.StartsWith("Intchk")))
                {
                    //foreach (var TipoInterId in form[TipoIntChk].Split(','))
                    //{
                        Entidades.TipoIntermediario tmpTipoIntermediario = new Entidades.TipoIntermediario()
                        {
                            Id = Convert.ToInt32(TipoIntChk.Replace("Intchk", ""))
                        };
                        TipoIntermediario.Add(tmpTipoIntermediario);
                    //}
                }


                Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                {
                    nombre = form["Nombre"],
                    fechadesde = Convert.ToDateTime(form["FechaInicio"]),
                    fechahasta = Convert.ToDateTime(form["FechaFin"]),
                    descripcion = form["DescripcionModelo"], //Campo codigo Tabla ModeloComision
                    tope = Convert.ToDouble(form["ValorMaximoComision"])
                };
                dbobj.CanalDetalles = canalDetalles;
                //dbobj.TipoIntermediarios = TipoIntermediario;

                try
                {
                    string username = string.Empty;
                    if (HttpContext.Session["userName"] != null)
                        username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.InsertarModeloComision(dbobj, username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["openForm"] = true;
                        this.FormToTempData(form);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(form);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["OperationSuccess"] = false;
                TempData["openForm"] = true;
                this.FormToTempData(form);
            }
            return RedirectToAction("ModeloComision", new { area = "Comisiones" });
        }

        [HttpPost, Authorize]
        public ActionResult Editar(FormCollection form)
        {
            if (ModelState.IsValid)
            {
                var canales = new Entidades.TrackableCollection<Entidades.Canal>();
                var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();

                foreach (var canalchk in form.AllKeys.Where(x => x.StartsWith("chk")))
                {
                    foreach (var canalDetalleId in form[canalchk].Split(','))
                    {
                        Entidades.CanalDetalle tmpcanalDetalle = new Entidades.CanalDetalle()
                        {
                            canal_id = Convert.ToInt32(canalchk.Substring(3)),
                            id = Convert.ToInt32(canalDetalleId)
                        };
                        canalDetalles.Add(tmpcanalDetalle);
                    }
                }

                var TipoIntermediarios = new Entidades.TrackableCollection<Entidades.TipoIntermediario>();

                foreach (var TipoIntchk in form.AllKeys.Where(x => x.StartsWith("Intchk")))
                {
                    Entidades.TipoIntermediario tmpTipoInter = new Entidades.TipoIntermediario()
                        {
                            Id = Convert.ToInt32(TipoIntchk.Replace("Intchk", ""))
                        };
                       TipoIntermediarios.Add(tmpTipoInter);
                   
                }
              


                Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                {
                    id = Convert.ToInt32(form["IdModelo"]),
                    nombre = form["Nombre"],
                    fechadesde = Convert.ToDateTime(form["FechaInicio"]),
                    fechahasta = Convert.ToDateTime(form["FechaFin"]),
                    descripcion = form["DescripcionModelo"],
                    tope = Convert.ToDouble(form["ValorMaximoComision"])
                };
                dbobj.CanalDetalles = canalDetalles;
                //dbobj.TipoIntermediarios = TipoIntermediarios;
                try
                {
                    string username = string.Empty;
                    if (HttpContext.Session["userName"] != null)
                        username = HttpContext.Session["userName"].ToString();

                    _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                    ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.ActualizarModeloComision(dbobj, username);
                    if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                    {
                        TempData["OperationSuccess"] = true;
                    }
                    else
                    {
                        TempData["OperationSuccess"] = false;
                        TempData["ErrorMessage"] = res.MensajeError;
                        TempData["openForm"] = true;
                        this.FormToTempData(form,true);
                    }
                }
                catch (Exception ex)
                {
                    TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                    TempData["OperationSuccess"] = false;
                    TempData["openForm"] = true;
                    this.FormToTempData(form, true);
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["OperationSuccess"] = false;
                TempData["openForm"] = true;
                this.FormToTempData(form, true);
            }
            return RedirectToAction("ModeloComision", new { area = "Comisiones" });
        }

        [Authorize]
        public ActionResult EliminarModeloComision(int id)
        {
            try
            {
                string username = string.Empty;
                if (HttpContext.Session["userName"] != null)
                    username = HttpContext.Session["userName"].ToString();

                _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                var res = _svcModelClient.EliminarModeloComision(id, username);
                if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                {
                    TempData["OperationSuccess"] = true;
                    TempData["SuccessMessage"] = "Modelo eliminado correctamente";
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
            return RedirectToAction("ModeloComision", new { area = "Comisiones" });
        }

        [HttpPost, Authorize]
        public JsonResult ObtenerModeloComisionXId(int modeloId)
        {
            JsonResult result = new JsonResult();
            _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
            var dbobj = _svcModelClient.ObtenerModeloComisionXId(modeloId);
            ModeloViewModel vmmodel = new ModeloViewModel()
            {
                DescripcionModelo = dbobj.descripcion,
                FechaFin = dbobj.fechahasta,
                FechaInicio = dbobj.fechadesde,
                IdModelo = dbobj.id,
                Nombre = dbobj.nombre,
                ValorMaximoComision = dbobj.tope
            };
          
            List<Entidades.Canal> Canales = new List<Entidades.Canal>();
            foreach (var item in dbobj.CanalDetalles.OrderBy(x => x.Canal.nombre))
            {
                if (Canales.Where(x => x.id == item.canal_id).Count() == 0 && item.Canal != null)
                {
                    Canales.Add(new Entidades.Canal() { id = item.Canal.id, nombre = item.Canal.nombre });
                }
            }
            foreach (var canal in Canales)
            {
                CanalViewModel tmpcvm = new CanalViewModel() { Id = canal.id, Nombre = canal.nombre };
                tmpcvm.CanalDetalles.AddRange(dbobj.CanalDetalles.Where(x => x.canal_id == canal.id)
                    .Select(y => new SelectListItem()
                    {
                        Text = y.nombre,
                        Value = y.id.ToString()
                    }));
                tmpcvm.CanalDetalles = tmpcvm.CanalDetalles.OrderBy(x => x.Text).ToList();
                vmmodel.ListaCanales.Add(tmpcvm);
            }
            vmmodel.ListaCanales = vmmodel.ListaCanales.OrderBy(x => x.Nombre).ToList();
            foreach (var item in dbobj.CanalDetalleTipoIntermediarios)
	        {
                Entidades.TipoIntermediario tipointermediario = _svcModelClient.ListarTipoIntermediario().Where(x => x.Id == item.TipoIntermediario_Id).FirstOrDefault();
                TipoIntermediarioViewModel tempTipoInter = new TipoIntermediarioViewModel() { id = tipointermediario.Id, Nombre = tipointermediario.Nombre };
                vmmodel.SelTipoIntermediariolist.Add(new SelectListItem()
                {
                Text=tipointermediario.Nombre,
                Value=tipointermediario.Id.ToString()
                });

                vmmodel.ListaTipoIntermediarios.Add(tempTipoInter);
	        }
            vmmodel.ListaTipoIntermediarios = vmmodel.ListaTipoIntermediarios.OrderBy(x => x.Nombre).ToList();
           

           //7777777777777777777777777777777777777777777777777777777777777777777777 
           // List<Entidades.TipoIntermediario> TipoIntermediario = new List<Entidades.TipoIntermediario>();
                   
           //foreach (var TipoInter in dbobj.TipoIntermediarios)
           // {
              
           //     if (TipoIntermediario.Where(x=>x.Id==TipoInter.Id).Count()==0 && TipoInter.Participantes != null )
           //     {
           //         TipoIntermediario.Add(new Entidades.TipoIntermediario() { Id=TipoInter.Id,Nombre=TipoInter.Nombre});
           //         TipoIntermediario.AddRange(TipoIntermediario.Select(y=> new SelectListItem() 
           //         {
           //         Text=y.Nombre,
           //         Value=y.Id.ToString()
           //         }));
           //     }
             
           // }

           // List<TipoIntermediarioViewModel> listaTipos = new List<TipoIntermediarioViewModel>();      
           //  foreach (var item in TipoIntermediario)
           //  {
           //      listaTipos.Add(new TipoIntermediarioViewModel() { id = Convert.ToInt32(item.Id), Nombre = item.Nombre });
           //      listaTipos.Select(x => new SelectListItem()
           //          {

           //              Text = x.Nombre,
           //              Value = x.id.ToString()
           //          });
           //  }

           //  vmmodel.ListaTipoIntermediarios=listaTipos;
            result.Data = vmmodel;
            return result;
        }


        private void FormToTempData(FormCollection form, bool editing = false)
        {
            TempData["id"] = Convert.ToInt32(form["IdModelo"]);
            TempData["Nombre"] = form["Nombre"];
            DateTime d1 = new DateTime(1970, 1, 1);
            DateTime d2 = Convert.ToDateTime(form["FechaInicio"]).ToUniversalTime();
            TimeSpan ts = new TimeSpan(d2.Ticks - d1.Ticks);
            TempData["FechaInicio"] = Math.Round(ts.TotalMilliseconds, 0);
            d2 = Convert.ToDateTime(form["FechaFin"]).ToUniversalTime();
            ts = new TimeSpan(d2.Ticks - d1.Ticks);
            TempData["FechaFin"] = Math.Round(ts.TotalMilliseconds, 0);
            TempData["DescripcionModelo"] = form["DescripcionModelo"];
            TempData["ValorMaximoComision"] = Convert.ToDouble(form["ValorMaximoComision"]);


            var canalDetalles = new List<CanalDetalleViewModel>();
            foreach (var canalchk in form.AllKeys.Where(x => x.StartsWith("chk")))
            {
                foreach (var canalDetalleId in form[canalchk].Split(','))
                {
                    CanalDetalleViewModel tmpcanalDetalle = new CanalDetalleViewModel()
                    {
                        canal_id = Convert.ToInt32(canalchk.Substring(3)),
                        id = Convert.ToInt32(canalDetalleId)
                    };
                    canalDetalles.Add(tmpcanalDetalle);
                }
            }
            TempData["canalDetalles"] = canalDetalles.ToArray();

            var TipoIntermediario = new List<TipoIntermediarioViewModel>();
            foreach (var TipoIntchk in form.AllKeys.Where(x => x.StartsWith("Intchk")))
            {
                   TipoIntermediarioViewModel tmpTipoIntermediario = new TipoIntermediarioViewModel()
                    {
                       // canal_id = Convert.ToInt32(TipoIntchk.Substring(3)),
                        id = Convert.ToInt32(TipoIntchk.Replace("Intchk",""))
                    };
                    TipoIntermediario.Add(tmpTipoIntermediario);
               
            }
            TempData["TipoIntermediario"] = TipoIntermediario.ToArray();

            if (editing)
            {
                TempData["editing"] = true;
            }
        }


        [HttpPost, Authorize]
        public ActionResult Duplicar(FormCollection form)
        {
            if (ModelState.IsValid)
            {
                if (!string.IsNullOrEmpty(form["Duplicar"]))
                {
                    var canales = new Entidades.TrackableCollection<Entidades.Canal>();
                    var canalDetalles = new Entidades.TrackableCollection<Entidades.CanalDetalle>();

                    foreach (var canalchk in form.AllKeys.Where(x => x.StartsWith("chk")))
                    {
                        foreach (var canalDetalleId in form[canalchk].Split(','))
                        {
                            Entidades.CanalDetalle tmpcanalDetalle = new Entidades.CanalDetalle()
                            {
                                canal_id = Convert.ToInt32(canalchk.Substring(3)),
                                id = Convert.ToInt32(canalDetalleId)
                            };
                            canalDetalles.Add(tmpcanalDetalle);
                        }
                    }

                    Entidades.ModeloComision dbobj = new Entidades.ModeloComision()
                    {
                        id = Convert.ToInt32(form["IdModelo"]),
                        nombre = form["Nombre"],
                        fechadesde = Convert.ToDateTime(form["FechaInicio"]),
                        fechahasta = Convert.ToDateTime(form["FechaFin"]),
                        descripcion = form["DescripcionModelo"],
                        tope = Convert.ToDouble(form["ValorMaximoComision"])
                    };
                    dbobj.CanalDetalles = canalDetalles;
                    try
                    {
                        string username = string.Empty;
                        if (HttpContext.Session["userName"] != null)
                            username = HttpContext.Session["userName"].ToString();

                        _svcModelClient = new ModeloComisionSVC.ModeloComisionClient();
                        ColpatriaSAI.Negocio.Componentes.Comision.ResultadoOperacionBD res = _svcModelClient.DuplicarModeloComision(dbobj.id, dbobj, username);
                        if (res.Resultado == Negocio.Componentes.Comision.ResultadoOperacion.Exito)
                        {
                            TempData["OperationSuccess"] = true;
                        }
                        else
                        {
                            TempData["OperationSuccess"] = false;
                            TempData["ErrorMessage"] = res.MensajeError;
                            TempData["openForm"] = true;
                            this.FormToTempData(form);
                        }
                    }
                    catch (Exception ex)
                    {
                        TempData["ErrorMessage"] = "Error no controlado:" + ex.Message;
                        TempData["OperationSuccess"] = false;
                        TempData["openForm"] = true;
                        this.FormToTempData(form);
                    }
                }
            }
            else
            {
                TempData["ErrorMessage"] = "Datos inválidos";
                TempData["OperationSuccess"] = false;
                TempData["openForm"] = true;
                this.FormToTempData(form);
            }
            return RedirectToAction("ModeloComision", new { area = "Comisiones" });
        }
        #endregion
    }
}
