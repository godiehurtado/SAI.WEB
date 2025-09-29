using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Web.Mvc.Ajax;
using System.IO;
using LinqToExcel;
using System.Globalization;
using ColpatriaSAI.UI.MVC.Comun;



namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ConcursosController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index(string concurso, int? id)
        {
            int segmentodelUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.segmentoUsuario = web.AdministracionClient.RetornarNombreSegmentoUsuario(segmentodelUsuario);
            string nombreUsuario = (string)Session["username"];
            ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(c => c.segmento_id == segmentodelUsuario);
            return View(ViewData["Concursos"]);
        }

        public ActionResult Crear()
        {
            int segmentodelUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.segmentoUsuario = web.AdministracionClient.RetornarNombreSegmentoUsuario(segmentodelUsuario);

            var viewModel = new ConcursoViewModel()
            {
                ConcursoView = new Concurso(),
                TipoConcursoList = new SelectList(web.AdministracionClient.ListarTipoConcursoes().ToList(), "id", "nombre"),
            };
            ViewData["ConcursoViewModel"] = viewModel;

            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            string principal = (collection["principal"] != null ? collection["principal"] : collection["principal"] = "false");
            int tipoConcurso_id = Convert.ToInt16(collection["tipoConcurso_id"]);
            DateTime fecha_inicio = Convert.ToDateTime(collection[1]);
            DateTime fecha_fin = Convert.ToDateTime(collection[2]);
            int cantidadConcurso = 0;// Variable que toma la respuesta del servicio que consulta si ya existe un concurso principal de asesores.

            if (principal == "True")
            {
                if (tipoConcurso_id == 1)
                {
                    cantidadConcurso = web.AdministracionClient.ValidarConcursoPrincipal(tipoConcurso_id, fecha_inicio.Year, fecha_fin.Year);
                    if (cantidadConcurso >= 1)
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.ConcursoPrincipalxAsesores; View(TempData["Mensaje"]);
                        return RedirectToAction("Crear");
                    }
                }

                else if (tipoConcurso_id == 2)
                {
                    cantidadConcurso = web.AdministracionClient.ValidarConcursoPrincipal(tipoConcurso_id, fecha_inicio.Year, fecha_fin.Year);
                    if (cantidadConcurso >= 1)
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.ConcursoPrincipalxEjecutivos; View(TempData["Mensaje"]);
                        return RedirectToAction("Crear");
                    }
                }
            }

            int idConcurso = 0;
            int segmentodelUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            try
            {
                if (ModelState.IsValid && Request.QueryString["id"] != string.Empty)
                {
                    Concurso concurso = new Concurso()
                    {
                        nombre = collection[0],
                        fecha_inicio = Convert.ToDateTime(collection[1]),
                        fecha_fin = Convert.ToDateTime(collection[2]),
                        tipoConcurso_id = int.Parse(collection["tipoConcurso_id"]),
                        descripcion = collection["descripcion"],
                        segmento_id = segmentodelUsuario,
                        principal = bool.Parse(collection["principal"])
                    };
                    idConcurso = web.AdministracionClient.InsertarConcurso(concurso, HttpContext.Session["userName"].ToString());
                }
                return RedirectToAction("Index", "ParticipanteConcurso", new { value = idConcurso });
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear el concurso", ex);
            }
        }

        public ActionResult Editar(int id)
        {
            int segmentodelUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.segmentoUsuario = web.AdministracionClient.RetornarNombreSegmentoUsuario(segmentodelUsuario);
            TempData["tipoConcurso_id_Edit"] = web.AdministracionClient.RetornarTipoConcurso(id);
            Concurso concurso = web.AdministracionClient.ListarConcursoesPorId(id).ToList()[0];
            TempData["segmento_id_Edit"] = concurso.segmento_id;

            var viewModel = new ConcursoViewModel()
            {
                ConcursoView = concurso,
                TipoConcursoList = new SelectList(web.AdministracionClient.ListarTipoConcursoes().ToList(), "id", "nombre", concurso.tipoConcurso_id),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", concurso.segmento_id)
            };
            ViewData["ConcursoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string principal = (collection["principal_Edit"] != null ? collection["principal_Edit"] : collection["principal_Edit"] = "false");

            try
            {
                Concurso concurso = new Concurso()
                {
                    nombre = collection[0],
                    fecha_inicio = Convert.ToDateTime(collection[1]),
                    fecha_fin = Convert.ToDateTime(collection[2]),
                    descripcion = collection[3],
                    principal = bool.Parse(collection["principal_Edit"]),
                    tipoConcurso_id = int.Parse(collection["tipoConcurso_id_Edit"]),
                    segmento_id = int.Parse(collection["segmento_id_Edit"])
                };
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarConcurso(id, concurso, userName);
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar el concurso con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Duplicar(int id)
        {
            Concurso concurso = web.AdministracionClient.ListarConcursoesPorId(id).ToList()[0];
            int segmentodelUsuario = Comun.Utilidades.TraerSegmentodelUsuario();
            ViewBag.segmentoUsuario = web.AdministracionClient.RetornarNombreSegmentoUsuario(segmentodelUsuario);
            TempData["nombreConcurso"] = concurso.nombre;
            TempData["tipoConcurso"] = concurso.TipoConcurso.nombre;
            TempData["descripcion"] = concurso.descripcion;
            TempData["tipoConcursoDup"] = concurso.tipoConcurso_id;

            var viewModel = new ConcursoViewModel()
            {
                ConcursoView = concurso,
                TipoConcursoList = new SelectList(web.AdministracionClient.ListarTipoConcursoes().ToList(), "id", "nombre", concurso.tipoConcurso_id),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", concurso.segmento_id)
            };
            ViewData["ConcursoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Duplicar(int id, FormCollection collection)
        {
            Concurso concurso1 = web.AdministracionClient.ListarConcursoesPorId(id).ToList()[0];
            ViewBag.concurso = concurso1.nombre;
            ViewBag.tipoConcurso = concurso1.tipoConcurso_id;
            ViewBag.descripcion = concurso1.descripcion;
            ViewBag.segmento = concurso1.segmento_id;
            string userName = HttpContext.Session["userName"].ToString();
            DateTime fecha_inicio = Convert.ToDateTime(collection[0]);
            DateTime fecha_fin = Convert.ToDateTime(collection[1]);

            try
            {
                Concurso concurso = new Concurso()
                {
                    nombre = ViewBag.concurso,
                    fecha_inicio = Convert.ToDateTime(collection[0]),
                    fecha_fin = Convert.ToDateTime(collection[1]),
                    tipoConcurso_id = ViewBag.tipoConcurso,
                    descripcion = ViewBag.descripcion,
                    segmento_id = ViewBag.segmento,
                    principal = false  // Se edita luego de haber duplicado el concurso.
                };
                int idConcurso = web.AdministracionClient.DuplicarConcurso(id, concurso, userName);
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo duplicar el concurso con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarConcursos(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla CONCURSO.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar el concurso con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public String getParametroCodificado(String parametro)
        {
            return (System.Web.HttpUtility.UrlEncode(parametro));
        }
        public String getParametroDecodificado(String parametro_codificado_url)
        {
            return (System.Web.HttpUtility.UrlDecode(parametro_codificado_url));
        }


        #region "Excepciones"

        // Cargamos la vista de excepciones 

        public ActionResult Excepciones()
        {

            var lstExcepciones = web.AdministracionClient.ListarExcepcionesGeneralesXcompanyXTipoMedida();
            var lstcompania = new SelectList(web.AdministracionClient.ListarCompanias().Where(c => c.id > 0), "id", "nombre");

            // Cargamos las excepciones.

            ViewData["LstExcepciones"] = lstExcepciones;

            // Listamos las compañias

            ViewData["lstcompania"] = lstcompania;

            return View();
        }

        // Cargamos la vista de Crear excepciones 

        public ActionResult CrearExcepcion()
        {

            // Listamos las compañias
            var lstcompany = new SelectList(web.AdministracionClient.ListarCompanias().Where(c => c.id > 0), "id", "nombre");

            // Listamos los tipo de medidas
            var lstTipoMedida = new SelectList(web.AdministracionClient.ListarTipoMedidas().Where(t => t.id > 0 && t.tieneExcepcion != false), "id", "nombre");

            ViewData["LstCompany"] = lstcompany;

            ViewData["LstTipoMoneda"] = lstTipoMedida;

            return View();
        }

        // Vista de Reporte Asesor, tambien carga las zonas

        public ActionResult ReporteAsesor()
        {

            var lstzona = new SelectList(web.AdministracionClient.ListarZonas().Where(z => z.id > 0), "id", "nombre");
            ViewData["zona"] = lstzona;
            return View();
        }

        // Vista de Reprte Ejecutivo

        public ActionResult ReporteEjecutivo()
        {
            return View();
        }

        // Metodo para editar las excepciones.
        public ActionResult EditarExcepciones()
        {
            int id = !string.IsNullOrEmpty(Request["id"]) ? Convert.ToInt32(Request["id"]) : 0;
            var lstExcGen = web.AdministracionClient.ListarExcepcionesGeneralesXcompanyXTipoMedida().Where(e => e.id == id && e.id > 0).First();

            return View(lstExcGen);
        }

        [HttpPost]

        // Metodo para crear las excepciones.

        public ActionResult saveExepcion()
        {
            int resultado = 0;
            int monedaid = 1;
            DateTime Finicio, Ffin;
            string userName = HttpContext.Session["userName"].ToString();
            if (Convert.ToInt32(Request["ddlTipoMedida"]) == 2)
            {
                monedaid = 1;
            }
            else
            {
                monedaid = 0;
            }

            Finicio = Convert.ToDateTime(Request["FechaInicio"]);
            Ffin = Convert.ToDateTime(Request["FechaFin"]);

            var excepcionesG = new ExcepcionesGenerale()
            {
                compania_id = !string.IsNullOrEmpty(Request["ddlcompany"]) ? Convert.ToInt32(Request["ddlcompany"]) : 0,
                ramo_id = !string.IsNullOrEmpty(Request["ddlramo"]) ? Convert.ToInt32(Request["ddlramo"]) : 0,
                tipomedida_id = Convert.ToInt32(Request["ddlTipoMedida"]),
                clave = Request["clave"],
                numeroNegocio = !string.IsNullOrEmpty(Request["numeroDeNegocio"]) ? Convert.ToInt32(Request["numeroDeNegocio"]) : 0,
                fechaInicio = Finicio,
                fechaFin = Ffin,
                moneda_id = monedaid,
                factor = !string.IsNullOrEmpty(Request["factor"]) ? Convert.ToInt32(Request["factor"]) : 0,
                usuario = (string)Session["username"],
                fechacreacion = DateTime.Now,
                fechamodificacion = DateTime.Now,
                ano = Request["ano"]
            };
            // validamos que la excepcion no exista.
            if (web.AdministracionClient.validarExcepcionesGenerales(excepcionesG) != true)
            {
                resultado = web.AdministracionClient.CrearExcepcionesGenerales(excepcionesG, userName);
            }

            return Json(new { Success = true, result = resultado });

        }

        // Metodo para cargar las compañias por ramo
        public ActionResult ListarCompaniaRamo(int idcompani)
        {

            int idcompany = idcompani != 0 ? idcompani : 0;


            return Json(web.AdministracionClient.ListarRamosPorCompania(idcompany).Select(cr => new { cr.nombre, cr.id }), JsonRequestBehavior.AllowGet);
        }

        // Metodo para cargar las localidades por zona
        public ActionResult ListarLocalidadesZona(int zonaid)
        {

            return Json(web.AdministracionClient.ListarLocalidadesPorZona(zonaid).Select(l => new { l.nombre, l.id }), JsonRequestBehavior.AllowGet);
        }


        [HttpPost]

        // Metodo para eliminar las exepciones.

        public ActionResult eliminarExcepcion(int idexcepcion)
        {

            int resultado = 0;
            string userName = HttpContext.Session["userName"].ToString();
            resultado = web.AdministracionClient.EliminarExcepcionGenerales(idexcepcion, userName);

            return Json(new { Success = true, result = resultado });
        }

        [HttpPost]

        // Metodo para actualizar la excepciones,
        // se actualizan los campos numeronegocio,fechainicio,fechafin,año

        public ActionResult ActualizarExcepcion()
        {
            int resultado = 0;
            DateTime Finicio, Ffin;

            Finicio = Convert.ToDateTime(Request["FechaInicio"]);
            Ffin = Convert.ToDateTime(Request["FechaFin"]);

            var excepcionG = new ExcepcionesGenerale()
            {
                id = Convert.ToInt32(Request["id"]),
                numeroNegocio = !string.IsNullOrEmpty(Request["negocio"]) ? Convert.ToInt32(Request["negocio"]) : 0,
                fechaInicio = Finicio,
                fechaFin = Ffin,
                usuario = (string)Session["username"],
                fechamodificacion = DateTime.Now,
                ano = Request["ano"]

            };
            string userName = HttpContext.Session["userName"].ToString();
            resultado = web.AdministracionClient.ActualizarExcepcionesGenerales(excepcionG, userName);

            return Json(new { Success = true, result = resultado });
        }

        [HttpPost]

        // Metodo para generar el reporte Sea De ejecutivo o Asesor.

        public ActionResult GenerarReporte()
        {

            return Json(new { Success = true });

        }
        #endregion

        #region Liquidacion Asesor

        public ActionResult LiquidacionAsesor()
        {

            var model = new ReglaViewModel()
            {
                ConcursoList = new SelectList(web.AdministracionClient.ListarConcursoes(), "id", "nombre")
            };

            return View("LiquidacionAsesores", model);
        }

        public ActionResult ListarReglas()
        {
            int idConcurso = Convert.ToInt32(Request["concurso_id"]);

            return Json(web.AdministracionClient.ListarReglaPorConcursoId(idConcurso).Select(cr => new { cr.nombre, cr.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult ListarSubReglas()
        {
            int idRegla = Convert.ToInt32(Request["regla_id"]);

            return Json(web.AdministracionClient.ListarSubRegla().Where(x => x.regla_id == idRegla && x.principal == true).Select(cr => new { cr.descripcion, cr.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult GenerarLiquidacionAsesor()
        {
            int idConcurso = Convert.ToInt32(Request["concurso_id"]);
            int idRegla = Convert.ToInt32(Request["regla_id"]);
            int idSubRegla = Convert.ToInt32(Request["subregla_id"]);

            //EL ID DE LA ETL REMOTA EN PRODUCCION ES LA 22 EN PRUEBAS ES LA 20
            int idEtl = 22;
            ETLRemota etl = ETL.ListarETLsRemotas().Where(x => x.id == idEtl).FirstOrDefault();

            if (etl != null)
            {
                Dictionary<string, object> parametros = new Dictionary<string, object>();
                parametros.Add("Concurso", idConcurso);
                parametros.Add("Regla", idRegla);
                parametros.Add("SubRegla", idSubRegla);

                ETL.EjecutarETL(etl, parametros, Sesion.VariablesSesion());
            }

            return Json(new { Success = true });
        }

        #endregion
    }
}