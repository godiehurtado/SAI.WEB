using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ParticipacionFranquiciasController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index(int? id)
        {
            if (!id.HasValue) return View();

            List<ParticipacionFranquicia> participacionFranquicias = web.AdministracionClient.ListarPartFranquiciasPorlocalidad(id.Value);
            Session["idfranquicia"] = id;
            TempData["nombreFranquicia"] = web.AdministracionClient.ListarLocalidadesPorId(Convert.ToInt32(id)).First().nombre.ToString();
            return View(participacionFranquicias);
        }

        public ActionResult Detalle(int id)
        {
            List<DetallePartFranquicia> partfranquicias = web.AdministracionClient.DetalleFranquiciaPorPartFranqId(id);
            if (partfranquicias.Count > 0)
            {
                DetallePartFranquicia partfranquicia = web.AdministracionClient.DetalleFranquiciaPorPartFranqId(id).First();
                return View(partfranquicia);
            }
            return null;
        }

        public DetalleParticipacionFranquicia generarObjecto(ParticipacionFranquicia partfranquicia, bool inicial)
        {
            ViewBag.salarioMinimo = web.AdministracionClient.obtenerSalarioMinimo();
            List<SelectListItem> items = new SelectList(web.AdministracionClient.ListarLineaNegocios(), "id", "nombre", 0).ToList();
            //items.Insert(0, (new SelectListItem { Text = "Seleccione un Valor", Value = "0" }));
            List<SelectListItem> itemsAmparos = new SelectList(web.AdministracionClient.ListarAmparoes(), "id", "nombre", 0).ToList();
            //itemsAmparos.Insert(0, (new SelectListItem { Text = "Seleccione un Valor", Value = "0" }));

            List<Ramo> ramos = web.AdministracionClient.ListarRamos();
            List<Producto> productos = web.AdministracionClient.ListarProductoes();
            List<Plan> planes = web.AdministracionClient.ListarPlans();

            var viewModel = new ColpatriaSAI.UI.MVC.Models.DetalleParticipacionFranquicia()
            {
                ParticipacionFranquiciaView = partfranquicia,
                DetParticipacionFranquiciaView = partfranquicia.DetallePartFranquicias,
                Compania = new SelectList(web.AdministracionClient.ListarCompanias(), "id", "nombre", 0),
                LineaNegocio = items,
                Ramo = new SelectList(ramos, "id", "nombre", 0),//
                Producto = new SelectList(productos, "id", "nombre", 0),//
                TipoVehiculo = new SelectList(web.AdministracionClient.ListarTipoVehiculos(), "id", "nombre", 0),
                Plan = new SelectList(planes, "id", "nombre", 0),
                Amparo = itemsAmparos
            };
            return viewModel;
        }

        public ParticipacionFranquicia obtenerObjecto(FormCollection collect)
        {
            ParticipacionFranquicia partFranq = new ParticipacionFranquicia()
            {
                id = collect["idpartfranq"] != "" ? Int32.Parse(collect["idpartfranq"]) : 0,
                fecha_ini = DateTime.Parse(collect["FechaInicio"]),
                fecha_fin = DateTime.Parse(collect["FechaFin"]),
                Localidad_id = Session["Localidadid"] != null ? int.Parse(Session["Localidadid"].ToString()) : 0,
                fecha_actualizacion = DateTime.Now
            };

            DetallePartFranquicia detallePartFranquicia = new DetallePartFranquicia();
            detallePartFranquicia.id = collect["idDetPartFranq"] != "" ? Int32.Parse(collect["idDetPartFranq"]) : 0;
            detallePartFranquicia.part_franquicia_id = partFranq.id;
            detallePartFranquicia.compania_id = Int32.Parse(collect["compania_id"]);
            detallePartFranquicia.ramo_id = Int32.Parse(collect["ramo_id"]);
            detallePartFranquicia.producto_id = Int32.Parse(collect["producto_id"]);
            string porcentaje = collect["Porcentaje"].Replace(".", ","); // Convertir el punto en coma para guardar en BD - GLOBALIZATION ES
            detallePartFranquicia.porcentaje = Double.Parse(porcentaje);
            if (collect["Rangoinferior"] != "" && collect["Rangoinferior"] != null)
                detallePartFranquicia.rangoinferior = Double.Parse(collect["Rangoinferior"]);

            if (collect["Rangosuperior"] != "" && collect["Rangoinferior"] != null)
                detallePartFranquicia.rangosuperior = Double.Parse(collect["Rangosuperior"]);

            if (collect["planes_id"] != "" && collect["planes_id"] != null)
                detallePartFranquicia.plan_id = Int16.Parse(collect["planes_id"]);
            else
                detallePartFranquicia.plan_id = 0;

            detallePartFranquicia.lineaNegocio_id = collect["lineaNegocio_id"] != "" ? Int16.Parse(collect["lineaNegocio_id"]) : 0;

            if (collect["TipoVehiculo"] != "" && collect["TipoVehiculo"] != null)
                detallePartFranquicia.tipoVehiculo_id = Int16.Parse(collect["TipoVehiculo"]);
            else
                detallePartFranquicia.tipoVehiculo_id = 0;

            detallePartFranquicia.amparo_id = collect["Amparo_id"] != "" ? collect["Amparo_id"] != null ? Int16.Parse(collect["Amparo_id"]) : 0 : 0;

            partFranq.DetallePartFranquicias.Add(detallePartFranquicia);
            return partFranq;
        }

        public ActionResult Create(int id)
        {
            Session["Localidadid"] = id.ToString();
            Session["detpartfranid"] = 0;

            Localidad localidad = web.AdministracionClient.ListarLocalidadesPorId(Convert.ToInt32(id)).First();

            ParticipacionFranquicia partfranquicia = new ParticipacionFranquicia();
            var viewModel = generarObjecto(partfranquicia, true);

            ViewData["ParticipacionFranquiciaViewModel"] = viewModel;
            ViewData["FechaInicio"] = "";
            ViewData["FechaFin"] = "";
            ViewData["FechaActualizacion"] = DateTime.Now.ToString();
            ViewData["Title"] = "Crear Porcentaje ";
            ViewData["Localidad"] = localidad.nombre;

            return View("Crear", viewModel);
        }

        [HttpPost]
        public ActionResult Create(FormCollection collect)
        {
            Session["detpartfranid"] = 0;
            string userName = HttpContext.Session["userName"].ToString();
            ParticipacionFranquicia partFranq = obtenerObjecto(collect);
            var Success = false;
            if (partFranq.id == 0)
            {
                partFranq = web.AdministracionClient.InsertarPartFranquicia(partFranq, userName);
                Success = true;
            }
            else
            {
                Success = web.AdministracionClient.InsertarDetallePartFranquicia(partFranq.DetallePartFranquicias.First(), userName);
            }
            var viewModel = generarObjecto(partFranq, false);
            ViewData["ParticipacionFranquiciaViewModel"] = viewModel;
            ViewData["FechaInicio"] = "";
            ViewData["FechaFin"] = "";
            ViewData["FechaActualizacion"] = DateTime.Now.ToString();
            ViewData["Title"] = "Crear Porcentaje";

            return Json(new { PartFranq_id = partFranq.id, Success = Success });
        }

        public ActionResult Edit(int id)
        {
            Session["detpartfranid"] = id;
            ViewData["IdLastFranquicia"] = id;
            List<DetallePartFranquicia> detallePartFranquicias = web.AdministracionClient.DetalleFranquicias(id);
            ParticipacionFranquicia partfranquicia = new ParticipacionFranquicia();

            if (detallePartFranquicias.Count != 0)
            {
                partfranquicia = detallePartFranquicias[0].ParticipacionFranquicia;
                Session["Localidadid"] = partfranquicia.Localidad_id;
            }
            if (partfranquicia == null || partfranquicia.DetallePartFranquicias.Count == 0) partfranquicia = new ParticipacionFranquicia();

            var viewModel = generarObjecto(partfranquicia, true);

            ViewData["ParticipacionFranquiciaViewModel"] = viewModel;
            ViewData["FechaInicio"] = partfranquicia.fecha_ini.ToString();
            ViewData["FechaFin"] = partfranquicia.fecha_fin.ToString();
            ViewData["FechaActualizacion"] = DateTime.Now.ToString();
            ViewData["Title"] = "Editar Porcentaje";
            string nombreLocalidad = string.Empty;
            if (viewModel.ParticipacionFranquiciaView.Localidad_id != 0 && viewModel.ParticipacionFranquiciaView.Localidad_id != null)
            {
                Localidad localidad = web.AdministracionClient.ListarLocalidadesPorId(Convert.ToInt32(viewModel.ParticipacionFranquiciaView.Localidad_id)).First();
                nombreLocalidad = localidad.nombre;
            }
            ViewData["Localidad"] = nombreLocalidad;

            return View("Crear", viewModel);
        }

        [HttpPost]
        public ActionResult Edit(FormCollection collect)
        {
            try
            {
                ParticipacionFranquicia nuevaPartFranq = obtenerObjecto(collect);
                DetallePartFranquicia detallePartFranquicia = new DetallePartFranquicia();/**/
                ViewData["IdLastFranquicia"] = nuevaPartFranq.id;
                string userName = HttpContext.Session["userName"].ToString();
                var actualizacionRegistro = 0;
                actualizacionRegistro = web.AdministracionClient.ActualizarPartFranquicia(nuevaPartFranq, userName);

                foreach (var item in web.AdministracionClient.DetalleFranquicias(nuevaPartFranq.id))
                    nuevaPartFranq.DetallePartFranquicias.Add(item);

                var viewModel = generarObjecto(nuevaPartFranq, false);

                ViewData["ParticipacionFranquiciaViewModel"] = viewModel;
                ViewData["FechaInicio"] = nuevaPartFranq.fecha_ini.ToString();
                ViewData["FechaFin"] = nuevaPartFranq.fecha_fin.ToString();
                ViewData["FechaActualizacion"] = DateTime.Now.ToString();
                ViewData["Title"] = "Editar Porcentaje";
                return Json(new { Success = (actualizacionRegistro == 1) ? true : false });
            }
            catch
            {
                return Json(new { Success = false });
            }
        }

        public ActionResult Delete(int id)
        {
            List<ColpatriaSAI.Negocio.Entidades.ParticipacionFranquicia> detallePartFranquicias = new List<ParticipacionFranquicia>();
            ParticipacionFranquicia partfranquicia = web.AdministracionClient.DetalleFranquicia(id);
            return View("Eliminar", partfranquicia);
        }

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.EliminarPartFranquicia(id, userName);
                return RedirectToAction("Index/" + Session["idfranquicia"].ToString());
            }
            catch
            {
                return View("Eliminar");
            }
        }


        public ActionResult CopiarParametrizacionFranquicia(int id)
        {
            ParticipacionFranquicia partFranquicia = web.AdministracionClient.ListarPartFranquicias().Where(x => x.id == id).First();

            //TRAEMOS LAS LOCALIDADES
            List<Localidad> localidadList = web.AdministracionClient.ListarLocalidades().Where(x => x.tipo_localidad_id == 2 && x.id != partFranquicia.Localidad_id).ToList();

            ViewData["localidad"] = partFranquicia.Localidad.id;
            ViewData["parameorigen"] = id;
            ViewData["nombreFranq"] = partFranquicia.Localidad.nombre;
            ViewData["FechaInicio"] = partFranquicia.fecha_ini.ToShortDateString();
            ViewData["FechaFin"] = partFranquicia.fecha_fin.Value.ToShortDateString();
            return View(localidadList);
        }

        [HttpPost]
        public ActionResult CopiarParametrizacionFranquicia(FormCollection collect)
        {
            String messagge = string.Empty;
            Boolean success = true;
            string paramedestinoFranquicias = collect["franquicia_destino[]"];
            int parameorigen = int.Parse(collect["franquicia_origen"]);

            char[] delimiterChars = { ',' };
            string[] franquiciass = paramedestinoFranquicias.Split(delimiterChars);
            List<int> idDestinosCopiados = new List<int>();
            List<int> idDestinosNoCopiados = new List<int>();


            //COPIAMOS LAS FRANQUICIAS A TODOS LOS DESTINOS SELECCIONADOS
            foreach (string idfranq in franquiciass)
            {
                if (!string.IsNullOrEmpty(idfranq))
                {
                    int copioParametrizacion = CopiarParametrizacionFranquicia(parameorigen, Convert.ToInt32(idfranq));

                    if (copioParametrizacion == 1)
                        idDestinosCopiados.Add(Convert.ToInt32(idfranq));
                    else if (copioParametrizacion == 2)
                        idDestinosNoCopiados.Add(Convert.ToInt32(idfranq));
                    else
                        idDestinosNoCopiados.Add(Convert.ToInt32(idfranq));
                }
            }

            //Destinos Copiados
            var messageCopiados = string.Empty;
            var messageNoCopiados = string.Empty;
            foreach (int destinoCopiado in idDestinosCopiados)
            {
                var localidad = web.AdministracionClient.ListarLocalidadesPorId(destinoCopiado).First();
                messageCopiados += "<br/>" + localidad.nombre;
            }

            //Destinos No Copiados
            foreach (int destinoNoCopiado in idDestinosNoCopiados)
            {
                var localidad = web.AdministracionClient.ListarLocalidadesPorId(destinoNoCopiado).First();
                messageNoCopiados += "<br/>" + localidad.nombre;
            }

            messagge = "El proceso se completo con éxito. <br/>";

            if (!string.IsNullOrEmpty(messageCopiados))
            {
                messagge += "<hr/>Franquicias Copiadas.";
                messagge += messageCopiados;
            }

            if (!string.IsNullOrEmpty(messageNoCopiados))
            {
                messagge += "<hr/>Franquicias No Copiadas por duplicidad en fechas.";
                messagge += messageNoCopiados;
            }

            return Json(new { Success = success, Messagge = messagge });
        }

        private int CopiarParametrizacionFranquicia(int parameorigen, int paramedestino)
        {
            try
            {
                return web.AdministracionClient.CopiarParticipacionFranquicia(parameorigen, paramedestino, HttpContext.Session["userName"].ToString());
            }
            catch
            {
                return 0;
            }
        }

        public ActionResult ActualizacionMasivaPartFranquicias()
        {
            Session["detpartfranid"] = 0;

            ParticipacionFranquicia partfranquicia = new ParticipacionFranquicia();
            var viewModel = generarObjecto(partfranquicia, true);

            var localidades = web.AdministracionClient.ListarFranquicias();

            ViewBag.Localidades = new SelectList(localidades, "id", "nombre");
            ViewData["ParticipacionFranquiciaViewModel"] = viewModel;
            ViewData["FechaInicio"] = "";
            ViewData["FechaFin"] = "";
            ViewData["FechaActualizacion"] = DateTime.Now.ToString();
            ViewData["Title"] = "Actualización ";

            return View("ActualizacionMasivaPartFranquicias", viewModel);
        }

        [HttpPost]
        public JsonResult ActualizacionMasivaPartFranquicias(FormCollection collect)
        {
            var fecha_ini = DateTime.Parse(collect["FechaInicio"]);
            var fecha_fin = DateTime.Parse(collect["FechaFin"]);
            var franquiciasIds = collect["franquicias[]"];
            string userName = HttpContext.Session["userName"].ToString();
            DetallePartFranquicia detallePartFranquicia = new DetallePartFranquicia();
            detallePartFranquicia.compania_id = Int32.Parse(collect["compania_id"]);
            detallePartFranquicia.ramo_id = Int32.Parse(collect["ramo_id"]);
            detallePartFranquicia.producto_id = Int32.Parse(collect["producto_id"]);
            detallePartFranquicia.porcentaje = Double.Parse(collect["Porcentaje"]);
            if (collect["Rangoinferior"] != "" && collect["Rangoinferior"] != null)
                detallePartFranquicia.rangoinferior = Double.Parse(collect["Rangoinferior"]);

            if (collect["Rangosuperior"] != "" && collect["Rangoinferior"] != null)
                detallePartFranquicia.rangosuperior = Double.Parse(collect["Rangosuperior"]);

            detallePartFranquicia.plan_id = collect["planes_id"] != "" ? Int16.Parse(collect["planes_id"]) : 0;
            detallePartFranquicia.lineaNegocio_id = collect["lineaNegocio_id"] != "" ? Int16.Parse(collect["lineaNegocio_id"]) : 0;
            detallePartFranquicia.tipoVehiculo_id = collect["TipoVehiculo"] != "" ? Int16.Parse(collect["TipoVehiculo"]) : 0;
            detallePartFranquicia.amparo_id = collect["Amparo_id"] != "" ? collect["Amparo_id"] != "" ? Int16.Parse(collect["Amparo_id"]) : 0 : 0;

            int regact = web.AdministracionClient.ActualizarDetallePartFranquicias(detallePartFranquicia, fecha_ini, fecha_fin, franquiciasIds, userName);

            return Json(new { Success = true, totalActualizacion = regact });
        }

        public ActionResult ConfirmacionActualizacionPartFranquicias()
        {
            var partfranquicias = Session["ParticipacionFranquiciaViewModel"] as ParticipacionFranquicia2Model;
            ColpatriaSAI.Negocio.Entidades.ParticipacionFranquicia participacionFranquicia = new ParticipacionFranquicia();
            ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia detallePartFranquicia = new DetallePartFranquicia();

            participacionFranquicia.fecha_ini = DateTime.Parse(partfranquicias.Fechaini);
            participacionFranquicia.fecha_fin = DateTime.Parse(partfranquicias.Fechafin);

            detallePartFranquicia.compania_id = int.Parse(partfranquicias.DetalleParticipacion2Franquicia[0].Compania.ToString());
            detallePartFranquicia.lineaNegocio_id = partfranquicias.DetalleParticipacion2Franquicia[0].LineaNegocio;

            detallePartFranquicia.porcentaje = Double.Parse(partfranquicias.DetalleParticipacion2Franquicia[0].Porcentaje);
            detallePartFranquicia.producto_id = partfranquicias.DetalleParticipacion2Franquicia[0].Producto;
            detallePartFranquicia.ramo_id = partfranquicias.DetalleParticipacion2Franquicia[0].Ramo;
            if (partfranquicias.DetalleParticipacion2Franquicia[0].RangoInf != null)
                detallePartFranquicia.rangoinferior = Double.Parse(partfranquicias.DetalleParticipacion2Franquicia[0].RangoInf.ToString());
            if (partfranquicias.DetalleParticipacion2Franquicia[0].RangoSup != null)
                detallePartFranquicia.rangosuperior = Double.Parse(partfranquicias.DetalleParticipacion2Franquicia[0].RangoSup.ToString());
            detallePartFranquicia.tipoVehiculo_id = partfranquicias.DetalleParticipacion2Franquicia[0].TipoVehiculo;
            detallePartFranquicia.amparo_id = partfranquicias.DetalleParticipacion2Franquicia[0].Amparo;
            participacionFranquicia.DetallePartFranquicias.Add(detallePartFranquicia);

            List<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia> detallePartFranquicias = new List<DetallePartFranquicia>();
            detallePartFranquicias = web.AdministracionClient.GetDetallePartFranquiciasActualizar(participacionFranquicia, partfranquicias.Franquicias);

            Session["PartFranquicias"] = participacionFranquicia;
            Session["detallePartFranquicias"] = participacionFranquicia.DetallePartFranquicias;
            return View(detallePartFranquicias);
        }

        [HttpPost]
        public ActionResult SaveParticipacionFechas(FormCollection collect)
        {
            try
            {
                int id = Convert.ToInt32(collect["ParticipacionFranquiciaId"]);
                string userName = HttpContext.Session["userName"].ToString();
                ParticipacionFranquicia participacionFranquicia = web.AdministracionClient.ListarPartFranquicias().Where(x => x.id == id).First();

                participacionFranquicia.fecha_ini = DateTime.Parse(collect["FechaInicio"]);
                participacionFranquicia.fecha_fin = DateTime.Parse(collect["FechaFin"]);
                participacionFranquicia.fecha_actualizacion = DateTime.Now;

                var actualizacionRegistro = 0;
                actualizacionRegistro = web.AdministracionClient.ActualizarParticipacionFranquicia(participacionFranquicia, userName);

                return Json(new { Success = (actualizacionRegistro == 1) ? true : false });
            }
            catch
            {
                return Json(new { Success = false });
            }
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getRamos(int compania_id)
        {
            return Json(web.AdministracionClient.ListarRamosPorCompania(compania_id).Select(r => new { r.nombre, r.id }), 0);
        }

        public ActionResult getProductos(int ramo_id)
        {
            return Json(web.AdministracionClient.ListarProductosporRamo(ramo_id).Select(p => new { p.nombre, p.id }), 0);
        }

        public ActionResult getTipoVehiculos(int ramo_id)
        {
            return Json(web.AdministracionClient.ListarTipoVehiculosporRamo(ramo_id).Select(p => new { p.Nombre, p.id }), 0);
        }
    }
}
