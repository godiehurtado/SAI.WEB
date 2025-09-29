using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Web.Mvc.Ajax;


namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class MonedaxNegocioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
            }

            try
            {
                if (int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["MaestroMonedaxNegocios"] = web.AdministracionClient.ListarMaestroMonedaxNegocio().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].Moneda.nombre;
                    ViewData["MonedaxNegocios"] = web.AdministracionClient.ListarMonedaxNegocio().Where(P => P.maestromoneda_id == int.Parse(ViewData["value"].ToString()));
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de moneda x negocio", ex);
            }
            return View();
        }

        /// <summary>
        /// Funcion q se encarga de traer los ramos
        /// </summary>
        /// <param name="compania_id">Compañia para traer sus respectivos Ramos</param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getRamos(int compania_id)
        {
            return Json(web.AdministracionClient.ListarRamosPorCompania(compania_id).Select(r => new { r.nombre, r.id }), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Funcion q se encarga de traer los Productos
        /// </summary>
        /// <param name="ramo_id">Ramo para filtrar los procutos</param>
        /// <returns></returns>
        public ActionResult getProductos(int ramo_id)
        {
            return Json(web.AdministracionClient.ListarProductosporRamo(ramo_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Funcion que se encarga de traer los Vehiculos
        /// </summary>
        /// <param name="ramo_id">Ramo para filtrar los vehiculos</param>
        /// <returns></returns>
        public ActionResult getTiposVehiculo(int ramo_id)
        {
            return Json(web.AdministracionClient.ListarTipoVehiculosporRamo(ramo_id).Select(tipovehiculo => new { tipovehiculo.Nombre, tipovehiculo.id }), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Funcion que se encarga de traer los planes
        /// </summary>
        /// <param name="producto_id">Producto para filtrsr los planes</param>
        /// <returns></returns>
        public ActionResult getPlanes(int producto_id)
        {
            return Json(web.AdministracionClient.ListarPlanPorProducto(producto_id).Select(plan => new { plan.nombre, plan.id }), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Funcion que se encarga de traer la localidades
        /// </summary>
        /// <param name="zona_id">Zona para filtrar las localicalidades</param>
        /// <returns></returns>
        public ActionResult getLocalidades(int zona_id)
        {
            return Json(web.AdministracionClient.ListarLocalidadesPorZona(zona_id).Select(l => new { l.nombre, l.id }), JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// Funcion que se encarga de traer las Actividades Economicas por compañia
        /// </summary>
        /// <param name="companiaID">Compañia por la que se desea filtrar</param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getActividaEconomicaByCompany(int companiaID)
        {
            return Json(web.AdministracionClient.ListarActividadEconomicasPorCompania(companiaID).Select(r => new { r.nombre, r.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult Crear()
        {
            MonedaxNegocioViewModel viewModel = llenarCollection();

            ViewData["MonedaxNegocioViewModel"] = viewModel;
            return View(viewModel);
        }

        public MonedaxNegocioViewModel llenarCollection()
        {
            MonedaxNegocioViewModel viewModel = new MonedaxNegocioViewModel()
            {
                MonedaxNegocioView = new MonedaxNegocio(),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductoes().ToList(), "id", "nombre"),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre"),
                RamoList = new SelectList(web.AdministracionClient.ListarRamos().ToList(), "id", "nombre"),
                AmparoList = new SelectList(web.AdministracionClient.ListarAmparoes().ToList(), "id", "nombre"),
                CoberturaList = new SelectList(web.AdministracionClient.ListarCoberturas().ToList(), "id", "nombre"),
                ActividadEconomicaList = new SelectList(web.AdministracionClient.ListarActividadEconomicasPorCompania(0), "id", "nombre"),
                ModalidadPagoList = new SelectList(web.AdministracionClient.ListarModalidadPagoes().ToList(), "id", "nombre"),
                PlanList = new SelectList(web.AdministracionClient.ListarPlans().ToList(), "id", "nombre"),
                RedList = new SelectList(web.AdministracionClient.ListarRedes().ToList(), "id", "nombre"),
                BancoList = new SelectList(web.AdministracionClient.ListarBancos().ToList(), "id", "nombre"),
                ComboList = new SelectList(web.AdministracionClient.ListarCombos().ToList(), "id", "nombre"),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre"),
                TipoVehiculoList = new SelectList(web.AdministracionClient.ListarTipoVehiculos().ToList(), "id", "Nombre"),
                LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre"),
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "Nombre")
            };

            return viewModel;
        }

        [HttpPost]
        public ActionResult Crear(string id, FormCollection collection)
        {
            string idLineaNegocio = (collection["lineaNegocio_id"] != string.Empty ? collection["lineaNegocio_id"] : collection["lineaNegocio_id"] = "0");
            string idSegmento = (collection["segmento_id"] != string.Empty ? collection["segmento_id"] : collection["segmento_id"] = "0");
            string idProducto = (collection["producto_id"] != string.Empty ? collection["producto_id"] : collection["producto_id"] = "0");
            string idActividadEconomica = (collection["actividadEconomica_id"] != string.Empty /*&& collection["actividadEconomica_id"] != "null"*/) ? collection["actividadEconomica_id"] : collection["actividadEconomica_id"] = "0";
            string idAmparo = (collection["amparo_id"] != string.Empty ? collection["amparo_id"] : collection["amparo_id"] = "0");
            string idModalidadPago = (collection["modalidadPago_id"] != string.Empty ? collection["modalidadPago_id"] : collection["modalidadPago_id"] = "0");
            string idPlan = (collection["plan_id"] != string.Empty && collection["plan_id"] != null) ? collection["plan_id"] : collection["plan_id"] = "0";
            string idPlan1 = (idPlan != string.Empty && idPlan != null ? idPlan : idPlan = "0");
            string idRed = (collection["red_id"] != string.Empty ? collection["red_id"] : collection["red_id"] = "0");
            string idBanco = (collection["banco_id"] != string.Empty ? collection["banco_id"] : collection["banco_id"] = "0");
            string factor = collection["factor"].Replace(".", ",");
            string idTipoVehiculo = (collection["tipoVehiculo_id"] != string.Empty ? collection["tipoVehiculo_id"] : collection["tipoVehiculo_id"] = "0");
            string idLocalidad = (collection["localidad_id"] != string.Empty ? collection["localidad_id"] : collection["localidad_id"] = "0");
            string idZona = (collection["zona_id"] != string.Empty ? collection["zona_id"] : collection["zona_id"] = "0");

            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);

            if (maestromonedaxnegociovalue == 0)
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        MonedaxNegocio monedaxnegocio = new MonedaxNegocio()
                        {
                            maestromoneda_id = int.Parse(collection["maestromoneda_id"]),
                            producto_id = int.Parse(idProducto),
                            compania_id = int.Parse(collection["compania_id"]),
                            lineaNegocio_id = int.Parse(collection["lineaNegocio_id"]),
                            ramo_id = int.Parse(collection["ramo_id"]),
                            amparo_id = int.Parse(idAmparo),
                            factor = double.Parse(factor),
                            actividadeconomica_id = int.Parse(idActividadEconomica),
                            modalidadPago_id = int.Parse(idModalidadPago),
                            plan_id = int.Parse(idPlan),
                            red_id = int.Parse(idRed),
                            banco_id = int.Parse(idBanco),
                            combo_id = 0,
                            segmento_id = int.Parse(idSegmento),
                            tipoVehiculo_id = int.Parse(idTipoVehiculo),
                            localidad_id = int.Parse(idLocalidad),
                            zona_id = int.Parse(idZona)
                        };
                        web.AdministracionClient.InsertarMonedaxNegocio(monedaxnegocio, HttpContext.Session["userName"].ToString());
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear la moneda x negocio", ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }
        }

        [HttpPost]
        public ActionResult CrearCombo(string id, FormCollection collection)
        {
            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);
            string factorCombo = collection["factorCombo"].Replace(".", ",");

            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            }

            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        MonedaxNegocio monedaxnegocio = new MonedaxNegocio()
                        {
                            maestromoneda_id = maestromonedaxnegociovalue,
                            producto_id = 0,
                            compania_id = 0,
                            lineaNegocio_id = 0,
                            ramo_id = 0,
                            amparo_id = 0,
                            factor = double.Parse(factorCombo),
                            actividadeconomica_id = 0,
                            modalidadPago_id = 0,
                            plan_id = 0,
                            red_id = 0,
                            banco_id = 0,
                            combo_id = int.Parse(collection["combo_id"]),
                            segmento_id = 0,
                            tipoVehiculo_id = 0,
                            localidad_id = 0,
                            zona_id = 0

                        };
                        web.AdministracionClient.InsertarMonedaxNegocio(monedaxnegocio, HttpContext.Session["userName"].ToString());
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear el combo", ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }
        }

        public ActionResult Editar(int id)
        {
            MonedaxNegocio monedaxnegocio = web.AdministracionClient.ListarMonedaxNegocioPorId(id).ToList()[0];
            ViewBag.Combo = monedaxnegocio.combo_id;
            ViewData["compania"] = monedaxnegocio.compania_id;
            ViewData["ramo"] = monedaxnegocio.ramo_id;
            ViewData["producto"] = monedaxnegocio.producto_id;
            ViewData["tipovehiculo"] = monedaxnegocio.tipoVehiculo_id;
            ViewData["zona"] = monedaxnegocio.zona_id;

            if (ViewBag.Combo == 0)
            {
                if (Convert.ToInt16(ViewData["producto"]) == 0)
                {
                    var viewModel = new MonedaxNegocioViewModel()
                    {
                        MonedaxNegocioView = monedaxnegocio,
                        ProductoList = new SelectList(web.AdministracionClient.ListarProductoes().Where(p => p.ramo_id == Convert.ToInt16(ViewData["ramo"])).ToList(), "id", "nombre", monedaxnegocio.producto_id),
                        TipoVehiculoList = new SelectList(web.AdministracionClient.ListarTipoVehiculos().Where(tv => tv.ramo_id == Convert.ToInt16(ViewData["ramo"])).ToList(), "id", "Nombre", monedaxnegocio.tipoVehiculo_id),
                        CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", monedaxnegocio.compania_id),
                        LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre", monedaxnegocio.lineaNegocio_id),
                        RamoList = new SelectList(web.AdministracionClient.ListarRamos().Where(r => r.compania_id == Convert.ToInt16(ViewData["compania"])).ToList(), "id", "nombre", monedaxnegocio.ramo_id),
                        AmparoList = new SelectList(web.AdministracionClient.ListarAmparoes().ToList(), "id", "nombre", monedaxnegocio.amparo_id),
                        CoberturaList = new SelectList(web.AdministracionClient.ListarCoberturas().ToList(), "id", "nombre", monedaxnegocio.cobertura_id),
                        ActividadEconomicaList = new SelectList(web.AdministracionClient.ListarActividadEconomicasPorCompania(Convert.ToInt16(ViewData["compania"])).ToList(),/*.ListarActividadEconomicas().ToList(),*/ "id", "nombre", monedaxnegocio.actividadeconomica_id),
                        ModalidadPagoList = new SelectList(web.AdministracionClient.ListarModalidadPagoes().ToList(), "id", "nombre", monedaxnegocio.modalidadPago_id),
                        PlanList = new SelectList(new List<string>()),
                        RedList = new SelectList(web.AdministracionClient.ListarRedes().ToList(), "id", "nombre", monedaxnegocio.red_id),
                        BancoList = new SelectList(web.AdministracionClient.ListarBancos().ToList(), "id", "nombre", monedaxnegocio.banco_id),
                        SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", monedaxnegocio.segmento_id),
                        LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(l => l.zona_id == Convert.ToInt16(ViewData["zona"])).ToList(), "id", "nombre", monedaxnegocio.localidad_id),
                        ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre", monedaxnegocio.zona_id)
                    };
                    ViewData["MonedaxNegocioViewModel"] = viewModel;
                    return View(viewModel);
                }

                else
                {
                    var viewModel = new MonedaxNegocioViewModel()
                    {
                        MonedaxNegocioView = monedaxnegocio,
                        ProductoList = new SelectList(web.AdministracionClient.ListarProductoes().Where(p => p.ramo_id == Convert.ToInt16(ViewData["ramo"])).ToList(), "id", "nombre", monedaxnegocio.producto_id),
                        CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", monedaxnegocio.compania_id),
                        LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios().ToList(), "id", "nombre", monedaxnegocio.lineaNegocio_id),
                        RamoList = new SelectList(web.AdministracionClient.ListarRamos().Where(r => r.compania_id == Convert.ToInt16(ViewData["compania"])).ToList(), "id", "nombre", monedaxnegocio.ramo_id),
                        AmparoList = new SelectList(web.AdministracionClient.ListarAmparoes().ToList(), "id", "nombre", monedaxnegocio.amparo_id),
                        CoberturaList = new SelectList(web.AdministracionClient.ListarCoberturas().ToList(), "id", "nombre", monedaxnegocio.cobertura_id),
                        ActividadEconomicaList = new SelectList(web.AdministracionClient.ListarActividadEconomicasPorCompania(Convert.ToInt16(ViewData["compania"])).ToList(),/*.ListarActividadEconomicas().ToList(),*/ "id", "nombre", monedaxnegocio.actividadeconomica_id),
                        ModalidadPagoList = new SelectList(web.AdministracionClient.ListarModalidadPagoes().ToList(), "id", "nombre", monedaxnegocio.modalidadPago_id),
                        PlanList = new SelectList(web.AdministracionClient.ListarPlans().Where(pl => pl.producto_id == Convert.ToInt16(ViewData["producto"])).ToList(), "id", "nombre", monedaxnegocio.plan_id),
                        RedList = new SelectList(web.AdministracionClient.ListarRedes().ToList(), "id", "nombre", monedaxnegocio.red_id),
                        BancoList = new SelectList(web.AdministracionClient.ListarBancos().ToList(), "id", "nombre", monedaxnegocio.banco_id),
                        SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", monedaxnegocio.segmento_id),
                        TipoVehiculoList = new SelectList(web.AdministracionClient.ListarTipoVehiculos().Where(tv => tv.ramo_id == Convert.ToInt16(ViewData["ramo"])).ToList(), "id", "Nombre", monedaxnegocio.tipoVehiculo_id),
                        ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre", monedaxnegocio.zona_id),
                        LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(l => l.zona_id == Convert.ToInt16(ViewData["zona"])).ToList(), "id", "Nombre", monedaxnegocio.localidad_id)
                    };
                    ViewData["MonedaxNegocioViewModel"] = viewModel;
                    return View(viewModel);
                }
            }

            else
            {
                var viewModel = new MonedaxNegocioViewModel()
                {
                    MonedaxNegocioView = monedaxnegocio,
                    ComboList = new SelectList(web.AdministracionClient.ListarCombos().ToList(), "id", "nombre", monedaxnegocio.combo_id)
                };
                ViewData["MonedaxNegocioViewModel"] = viewModel;
                return View(viewModel);
            }
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string idLineaNegocio = (collection["lineaNegocio_id_Edit"] != "" ? collection["lineaNegocio_id_Edit"] : collection["lineaNegocio_id_Edit"] = "0");
            string idSegmento = (collection["segmento_id_Edit"] != "" ? collection["segmento_id_Edit"] : collection["segmento_id_Edit"] = "0");
            string idProducto = (collection["producto_id_Edit"] != "" ? collection["producto_id_Edit"] : collection["producto_id_Edit"] = "0");
            string idActividadEconomica = (collection["actividadEconomica_id_Edit"] != "" ? collection["actividadEconomica_id_Edit"] : collection["actividadEconomica_id_Edit"] = "0");
            string idRamo = (collection["ramo_id_Edit"] != "" ? collection["ramo_id_Edit"] : collection["ramo_id_Edit"] = "0");
            string idAmparo = (collection["amparo_id_Edit"] != "" ? collection["amparo_id_Edit"] : collection["amparo_id_Edit"] = "0");
            string idModalidadPago = (collection["modalidadPago_id_Edit"] != "" ? collection["modalidadPago_id_Edit"] : collection["modalidadPago_id_Edit"] = "0");
            string idPlan = (collection["plan_id_Edit"] != "" ? collection["plan_id_Edit"] : collection["plan_id_Edit"] = "0");
            string idPlan1 = (idPlan != null ? idPlan : idPlan = "0");
            string idRed = (collection["red_id_Edit"] != "" ? collection["red_id_Edit"] : collection["red_id_Edit"] = "0");
            string idBanco = (collection["banco_id_Edit"] != "" ? collection["banco_id_Edit"] : collection["banco_id_Edit"] = "0");
            string idCombo = (collection["combo_id_Edit"] != null ? collection["combo_id_Edit"] : collection["combo_id_Edit"] = "0");
            string idTipoVehiculo = (collection["tipoVehiculo_id_Edit"] != "" ? collection["tipoVehiculo_id_Edit"] : collection["tipoVehiculo_id_Edit"] = "0");
            string idZona = (collection["zona_id_Edit"] != "" ? collection["zona_id_Edit"] : collection["zona_id_Edit"] = "0");
            string idLocalidad = (collection["localidad_id_Edit"] != "" ? collection["localidad_id_Edit"] : collection["localidad_id_Edit"] = "0");

            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);

            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", "MaestroMonedaxNegocio");
            }

            else
            {
                if (int.Parse(idCombo) == 0)
                {
                    try
                    {
                        MonedaxNegocio monedaxnegocio = new MonedaxNegocio()
                        {
                            factor = double.Parse(collection["factor"].Replace(".", ",")),
                            producto_id = int.Parse(idProducto),
                            compania_id = int.Parse(collection["compania_id_Edit"]),
                            lineaNegocio_id = int.Parse(collection["lineaNegocio_id_Edit"]),
                            ramo_id = int.Parse(idRamo),
                            amparo_id = int.Parse(idAmparo),
                            actividadeconomica_id = int.Parse(idActividadEconomica),
                            modalidadPago_id = int.Parse(idModalidadPago),
                            plan_id = int.Parse(idPlan),
                            red_id = int.Parse(idRed),
                            banco_id = int.Parse(idBanco),
                            combo_id = int.Parse(idCombo),
                            segmento_id = int.Parse(idSegmento),
                            tipoVehiculo_id = int.Parse(idTipoVehiculo),
                            zona_id = int.Parse(idZona),
                            localidad_id = int.Parse(idLocalidad)
                        };
                        web.AdministracionClient.ActualizarMonedaxNegocio(id, monedaxnegocio, HttpContext.Session["userName"].ToString());
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("No se pudo editar el registro de moneda x negocio y combo con id = " + id, ex);
                    }
                    return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
                }

                else
                {
                    try
                    {
                        MonedaxNegocio monedaxnegocio = new MonedaxNegocio()
                        {
                            factor = double.Parse(collection["factor_Edit"].Replace(".", ",")),
                            producto_id = 0,
                            compania_id = 0,
                            lineaNegocio_id = 0,
                            ramo_id = 0,
                            amparo_id = 0,
                            actividadeconomica_id = 0,
                            modalidadPago_id = 0,
                            plan_id = 0,
                            red_id = 0,
                            banco_id = 0,
                            combo_id = int.Parse(collection["combo_id_Edit"]),
                            segmento_id = 0,
                            tipoVehiculo_id = 0,
                            localidad_id = 0,
                            zona_id = 0
                        };
                        web.AdministracionClient.ActualizarMonedaxNegocio(id, monedaxnegocio, HttpContext.Session["userName"].ToString());
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("No se pudo editar el registro de moneda x negocio y combo con id = " + id, ex);
                    }
                    return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
                }
            }
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int maestromonedaxnegociovalue = Convert.ToInt16(TempData["value"]);

            if (maestromonedaxnegociovalue == 0)
            {
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }

            else
            {
                string mensaje = "";
                mensaje = web.AdministracionClient.EliminarMonedaxNegocio(id, null, HttpContext.Session["userName"].ToString());
                try
                {
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla MONEDAXNEGOCIO.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar el registro de moneda x negocio con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = maestromonedaxnegociovalue });
            }
        }
    }
}


