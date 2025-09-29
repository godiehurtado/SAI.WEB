using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using System.Data.SqlClient;


namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class PremioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty || Request.QueryString["valuer"] != string.Empty || Request.QueryString["valusr"] != string.Empty)
            {
                ViewData["value"]   = Request.QueryString["value"];
                TempData["value"]   = Request.QueryString["value"];

                ViewData["valuer"]  = Request.QueryString["valuer"];
                TempData["valuer"]  = Request.QueryString["valuer"];

                ViewData["valuesr"] = Request.QueryString["valuesr"];
                TempData["valuesr"] = Request.QueryString["valuesr"];
            }

            try
            {
                if (int.Parse(ViewData["valuesr"].ToString()) != null || int.Parse(ViewData["valuer"].ToString()) != null || int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Premios"] = web.AdministracionClient.ListarPremio();
                    Crear();
                    return View(ViewData["Premios"]);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de premio", ex);
            }
            return RedirectToAction("Index", "PremioxSubRegla");            
           
        }

        public ActionResult Crear()
        {
            int tipoConcurso_id = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(ViewData["value"]));

            if (tipoConcurso_id == 1)
            {
                var viewModel = new PremioViewModel()
                {
                    PremioView       = new Premio(),
                    TipoPremiosList  = new SelectList(web.AdministracionClient.ListarTipoPremio().ToList(), "id", "nombre"),
                    OperadorList     = new SelectList(web.AdministracionClient.ListarOperadorMatematico().ToList(), "id", "nombre"),
                    UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadMedida().ToList(), "id", "nombre"),
                    VariableList     = new SelectList(web.AdministracionClient.ListarVariablesPremio().Where(vp => vp.tipoConcurso == 1 || vp.tipoConcurso == 3).ToList(), "id", "nombre")
                };

                ViewData["PremioViewModel"] = viewModel;
                return View(viewModel);
            }

            else
            {
                var viewModel = new PremioViewModel()
                {
                    PremioView       = new Premio(),
                    TipoPremiosList  = new SelectList(web.AdministracionClient.ListarTipoPremio().ToList(), "id", "nombre"),
                    OperadorList     = new SelectList(web.AdministracionClient.ListarOperadorMatematico().ToList(), "id", "nombre"),
                    UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadMedida().ToList(), "id", "nombre"),
                    VariableList     = new SelectList(web.AdministracionClient.ListarVariablesPremio().Where(vp => vp.tipoConcurso == 2 || vp.tipoConcurso == 3).ToList(), "id", "nombre")
                };

                ViewData["PremioViewModel"] = viewModel;
                return View(viewModel); 
            }
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int subReglavalue     = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue        = Convert.ToInt16(TempData["valuer"]);
            int concursovalue     = Convert.ToInt16(TempData["value"]);
            string idVariable     = (collection["variable_id"] != "" ? collection["variable_id"] : collection["variable_id"] = "0");
            string idUnidadMedida = (collection["unidadmedida_id"] != "" ? collection["unidadmedida_id"] : collection["unidadmedida_id"] = "0");
            string regularidad    = (collection["regularidad"] != null ? collection["regularidad"] : collection["regularidad"] = "false");
                        
            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    Premio premio = new Premio()
                    {
                        descripcion        = collection["nombre"],
                        tipoPremio_id      = int.Parse(collection["tipoPremio_id"]),
                        operador_id        = int.Parse(collection["operador_id"]),
                        unidadmedida_id    = int.Parse(collection["unidadmedida_id"]),
                        valor              = double.Parse(collection["valor"].Replace(".", ",")),                        
                        descripcion_premio = collection["descripcion_premio"],
                        variable_id        = int.Parse(collection["variable_id"]),
                        regularidad        = bool.Parse(collection["regularidad"])
                    };
                    if (web.AdministracionClient.InsertarPremio(premio, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + premio.descripcion + " en la tabla PREMIO", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear el premio", ex);
            }
            return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
        }

        public ActionResult Editar(int id)
        {
            Premio premio = web.AdministracionClient.ListarPremioPorId(id).ToList()[0];
            var viewModel = new PremioViewModel()
            {
                PremioView       = premio,
                TipoPremiosList  = new SelectList(web.AdministracionClient.ListarTipoPremio().ToList(), "id", "nombre", premio.tipoPremio_id),
                OperadorList     = new SelectList(web.AdministracionClient.ListarOperadorMatematico().ToList(), "id", "nombre", premio.operador_id),
                UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadMedida().ToList(), "id", "nombre", premio.unidadmedida_id),
                VariableList     = new SelectList(web.AdministracionClient.ListarVariablesPremio().ToList(), "id", "nombre", premio.variable_id)
            };
            ViewData["PremioViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int subReglavalue     = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue        = Convert.ToInt16(TempData["valuer"]);
            int concursovalue     = Convert.ToInt16(TempData["value"]);
            string idVariable     = (collection["variable_id"] != "" ? collection["variable_id"] : collection["variable_id"] = "0");
            string idUnidadMedida = (collection["unidadmedida_id"] != "" ? collection["unidadmedida_id"] : collection["unidadmedida_id"] = "0");
            string regularidad    = (collection["regularidad_Edit"] != null ? collection["regularidad_Edit"] : collection["regularidad_Edit"] = "false");
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                Premio premio = new Premio()
                {
                    descripcion        = collection[0],
                    tipoPremio_id      = int.Parse(collection["tipoPremio_id"]),
                    operador_id        = int.Parse(collection["operador_id"]),
                    unidadmedida_id    = int.Parse(collection["unidadmedida_id"]),
                    valor              = double.Parse(collection[5].Replace(".", ",")),
                    descripcion_premio = collection["descripcion_premio"],
                    variable_id        = int.Parse(collection["variable_id"]),
                    regularidad        = bool.Parse(collection["regularidad_Edit"])
                };
                web.AdministracionClient.ActualizarPremio(id, premio, userName);
                Logging.Auditoria("Actualización del registro " + id + " en la tabla PREMIO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar el premio con id = " + id, ex);
            }
            return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int subReglavalue = Convert.ToInt16(TempData["valuesr"]);
            int reglavalue    = Convert.ToInt16(TempData["valuer"]);
            int concursovalue = Convert.ToInt16(TempData["value"]);

            try
            {
                string mensaje = "";
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarPremio(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PREMIO.", Logging.Prioridad.Baja, Modulo.Concursos , Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar el premio con id = " + id, ex);
            }
            return RedirectToAction("Index", new { valuesr = subReglavalue, valuer = reglavalue, value = concursovalue });
        }
    }
}


