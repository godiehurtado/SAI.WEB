using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Comun;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ExcepcionesController : ControladorBase
    {
        //
        // GET: /Excepciones/
        WebPage web = new WebPage();
        string urlSite = System.Configuration.ConfigurationManager.AppSettings["URLSite"];
        public ActionResult Index(int? id)
        {
            if (!id.HasValue)
                return View();

            List<Excepcion> excepcionFranquicias = web.AdministracionClient.ListarExcepciones(id.Value);
            ViewBag.nombreFranquicia = web.AdministracionClient.ListarLocalidadesPorId(id.Value).First().nombre;
            ViewBag.excepcionEspecial = false;
            return View(excepcionFranquicias);
        }

        public ActionResult ExcepcionesEspeciales()
        {
            List<Excepcion> excepcionFranquicias = web.AdministracionClient.ListarExcepcionesEspeciales();
            ViewBag.nombreFranquicia = string.Empty;
            ViewBag.excepcionEspecial = true;
            return View("Index", excepcionFranquicias);
        }

        public ActionResult Create()
        {
            var franquiciaModel = new ExcepcionFranquiciaModel()
            {
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", 0),
                RamoList = new SelectList(web.AdministracionClient.ListarRamosPorCompania(-1), "id", "nombre", 0),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductosporRamo(-1), "id", "nombre", 0),
                LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios(), "id", "nombre", 0),
                TipoVehiculoList = new SelectList(web.AdministracionClient.ListarTipoVehiculosporRamo(-1), "id", "nombre", 0)
            };

            ViewBag.localidadId = RouteData.Values["id"];
            Localidad localidad = web.AdministracionClient.ListarLocalidadesPorId(Convert.ToInt32(RouteData.Values["id"])).First();
            ViewData["Localidad"] = localidad.nombre;
            ViewData["Title"] = "Crear";
            return View(franquiciaModel);
        }

        public ActionResult CargueMasivoExcepciones()
        {
            ViewData["partArchivoFormato"] = urlSite + "CargueSAI/FormatosCarga/cargaMasiva.xlsx";
            return View();
        }

        //
        // POST: /Excepciones/SaveException

        [HttpPost]
        public ActionResult SaveException(FormCollection collection)
        {
            //DETERMINAMOS SI ESTA GUARDANDO UNA EXCEPCION ESPECIAL
            string pathReturn = "Index/" + collection["Localidad_id"];
            string username = HttpContext.Session["userName"].ToString();
            if (collection["excepcionRecaudo"] == "1")
            {
                pathReturn = "/ExcepcionesEspeciales";
            }

            try
            {
                string porcentaje = collection["Porcentaje"].Replace(".", ","); // Convertir el punto en coma para guardar en BD - GLOBALIZATION ES
                Excepcion excepcion = new Excepcion()
                {
                    id = Convert.ToInt32(collection["ExcepcionId"]),
                    fecha_ini = (!string.IsNullOrEmpty(collection["fecha_ini"])) ? DateTime.Parse(collection["fecha_ini"]) : DateTime.Parse("01/01/1900"),
                    fecha_fin = (!string.IsNullOrEmpty(collection["fecha_fin"])) ? DateTime.Parse(collection["fecha_fin"]) : DateTime.MaxValue,
                    compania_id = Convert.ToInt32(collection["compania_id"]),
                    ramo_id = (!string.IsNullOrEmpty(collection["ramo_id"])) ? Convert.ToInt32(collection["ramo_id"]) : 0,
                    producto_id = (!string.IsNullOrEmpty(collection["producto_id"])) ? Convert.ToInt32(collection["producto_id"]) : 0,
                    lineaNegocio_id = (!string.IsNullOrEmpty(collection["lineaNegocio_id"])) ? Convert.ToInt32(collection["lineaNegocio_id"]) : 0,
                    tipoVehiculo_id = (!string.IsNullOrEmpty(collection["TipoVehiculo"])) ? Convert.ToInt32(collection["TipoVehiculo"]) : 0,
                    negocio_id = collection["negocio_id"],
                    poliza = collection["poliza"],
                    Porcentaje = double.Parse(porcentaje),
                    Estado = (string.IsNullOrEmpty(collection["Estado"]) ? false : true),
                    Localidad_id = Convert.ToInt32(collection["Localidad_id"]),
                    localidad_de_id = (!string.IsNullOrEmpty(collection["Localidad_de_id"])) ? Convert.ToInt32(collection["Localidad_de_id"]) : 0,
                    codigoAgrupador = collection["codigoAgrupador"],
                    participante_id = (!string.IsNullOrEmpty(collection["participante_id"])) ? Convert.ToInt32(collection["participante_id"]) : 0,
                    clave = collection["clave"],
                    excepcion_recaudo = (collection["excepcionRecaudo"] == "1") ? true : false

                };

                if (excepcion.id <= 0)
                    web.AdministracionClient.InsertarException(excepcion, username);
                else if (excepcion.id > 0)
                    web.AdministracionClient.ActualizarExcepcion(excepcion, username);
            }
            catch
            {
                return RedirectToAction(pathReturn);
            }

            return RedirectToAction(pathReturn);
        }


        public ActionResult Edit(int id)
        {
            Excepcion excepcion = web.AdministracionClient.ListarExcepcionesporId(id).First();

            int localidadSeleccionada = (excepcion.Localidad_id != null) ? (int)excepcion.Localidad_id : 0;
            int localidadDeSeleccionada = (excepcion.localidad_de_id != null) ? (int)excepcion.localidad_de_id : 0;
            int productoSeleccionado = (excepcion.producto_id != null) ? (int)excepcion.producto_id : 0;
            int ramoSeleccionado = (excepcion.ramo_id != null) ? (int)excepcion.ramo_id : 0;
            int lineaSelecionada = (excepcion.lineaNegocio_id != null) ? (int)excepcion.lineaNegocio_id : 0;
            int tipoVehiculoSeleccionado = (excepcion.tipoVehiculo_id != null) ? (int)excepcion.tipoVehiculo_id : 0;
            int participanteActual = (excepcion.participante_id != null) ? (int)excepcion.participante_id : 0;
            string codigoagrup = (excepcion.codigoAgrupador != null) ? excepcion.codigoAgrupador : "";
            List<Participante> listaParticipantes = web.AdministracionClient.ListarParticipantesPorId(participanteActual);
            Participante participante = new Participante();

            if (listaParticipantes.Count() != 0)
                participante = listaParticipantes.First();

            var excepcionModel = new ExcepcionFranquiciaModel()
            {
                Excepcion = excepcion,
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", excepcion.compania_id),
                RamoList = new SelectList(web.AdministracionClient.ListarRamosPorCompania(Convert.ToInt32(excepcion.compania_id)), "id", "nombre", ramoSeleccionado),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductosporRamo(Convert.ToInt32(excepcion.ramo_id)), "id", "nombre", productoSeleccionado),
                LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios(), "id", "nombre", lineaSelecionada),
                TipoVehiculoList = new SelectList(web.AdministracionClient.ListarTipoVehiculosporRamo(Convert.ToInt32(excepcion.ramo_id)), "id", "nombre", tipoVehiculoSeleccionado),
                LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(x => x.tipo_localidad_id == 2).OrderBy(x => x.nombre).ToList(), "id", "nombre", localidadSeleccionada),
                LocalidadDeList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(x => x.tipo_localidad_id != 2).OrderBy(x => x.nombre).ToList(), "id", "nombre", localidadDeSeleccionada),
                participante = participante
            };

            ViewBag.localidadId = excepcionModel.Excepcion.Localidad_id;
            Localidad localidad = web.AdministracionClient.ListarLocalidadesPorId(excepcionModel.Excepcion.Localidad_id).First();
            ViewData["Localidad"] = localidad.nombre;
            ViewData["Title"] = "Editar";

            //DETERMINAMOS SI LA EXCEPCION ES ESPECIAL
            string view = "Create";
            if (Request["excepcionEspecial"] == "True")
                view = "CreateEspeciales";

            return View(view, excepcionModel);
        }

        public ActionResult CreateEspeciales()
        {
            var franquiciaModel = new ExcepcionFranquiciaModel()
            {
                LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(x => x.tipo_localidad_id == 2).OrderBy(x => x.nombre).ToList(), "id", "nombre", 0),
                LocalidadDeList = new SelectList(web.AdministracionClient.ListarLocalidades().Where(x => x.tipo_localidad_id != 2).OrderBy(x => x.nombre).ToList(), "id", "nombre", 0)
            };
            ViewData["Title"] = "Crear";
            return View(franquiciaModel);
        }

        //
        // GET: /Excepciones/Delete/5

        public ActionResult Delete(int id)
        {
            Excepcion excepcion = web.AdministracionClient.ListarExcepcionesporId(id).FirstOrDefault();

            return View("Eliminar", excepcion);
        }

        //
        // POST: /Excepciones/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                web.AdministracionClient.EliminarException(id, HttpContext.Session["userName"].ToString());

                string path = "Index/" + collection["idLocalidad"];
                if (collection["excepcionRecaudo"] == "True")
                    path = "/ExcepcionesEspeciales";

                return RedirectToAction(path);
            }
            catch
            {
                return View("Eliminar");
            }
        }

        /// <summary> Sube el archivo de Excel seleccionado e inicia la carga de los presupuestos </summary>
        /// <param name="file">Archivo seleccionado</param>
        /// <returns>Cargue de pagina</returns>
        [HttpPost]
        public ActionResult Carge(HttpPostedFileBase file)
        {
            try
            {
                if (file.ContentLength > 0)
                {
                    //Variables
                    Boolean success;
                    string nombreArchivo = "cargaMasiva.xlsx";

                    bool exito = Utilidades.subirArchivoFtp(string.Empty, nombreArchivo, file);
                    if (exito)
                    {
                        List<ETLRemota> etlRemotas = ETL.ListarETLsRemotasporTipo(1);
                        Dictionary<string, object> parametros = new Dictionary<string, object>();
                        ETLRemota etl = etlRemotas.Where(e => e.id == 37).First();

                        ETL.EjecutarETL(etl, parametros, Sesion.VariablesSesion());
                        success = true;

                        TempData["Mensaje"] = "exito|Exito: " + "La tarea se ejecuto con Exito";
                    }
                    else
                        TempData["Mensaje"] = "error|Error: " + "El archivo seleccionado no ha podido ser almacenado";
                }
            }
            catch { }
            return RedirectToAction("../Franquicias");
        }
    }
}
