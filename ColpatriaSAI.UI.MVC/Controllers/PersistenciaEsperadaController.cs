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
    public class PersistenciaEsperadaController : ControladorBase
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
                    ViewData["Concursos"]             = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                    ViewData["PersistenciaEsperadas"] = web.AdministracionClient.ListarPersistenciaEsperada().Where(PE => PE.concurso_id == int.Parse(ViewData["value"].ToString()));

                    Crear();
                    return View();                
            }
            catch { }
            return RedirectToAction("Index", "Concursos"); 
        }

        public ActionResult Crear()
        {
            var viewModel = new PersistenciaEsperadaViewModel()
            {
                PersistenciaEsperadaView = new PersistenciaEsperada(),
                PlazoList                = new SelectList(web.AdministracionClient.ListarPlazoes().ToList(), "id", "nombre")
            };
            ViewData["PersistenciaEsperadaViewModel"] = viewModel;
            return View(viewModel);
        } 

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string idPlazo    = (collection["plazo_id"] != null ? collection["plazo_id"] : collection["plazo_id"] = "0");

            if (collection.Get("tipoPersistencia") == null)
            {
                TempData["Mensaje"] = "error|" + Mensajes.ErrorPersistenciaEsperada; View(TempData["Mensaje"]);
                return RedirectToAction("Index", new { value = concursovalue });
            }

            else
            {
                bool tipo = bool.Parse(collection.Get("tipoPersistencia"));
                string userName = HttpContext.Session["userName"].ToString();
                try
                {
                    if (ModelState.IsValid)
                    {
                        PersistenciaEsperada persistenciaesperada = new PersistenciaEsperada()
                        {
                            tipoPersistencia = tipo,
                            valor            = float.Parse(collection["valor"]),
                            concurso_id      = int.Parse(collection["concurso_id"]),
                            plazo_id         = int.Parse(idPlazo)
                        };
                        if (web.AdministracionClient.InsertarPersistenciaEsperada(persistenciaesperada, userName) != 0)
                        {
                            Logging.Auditoria("Creación del registro " + persistenciaesperada.id + " en la tabla PERSISTENCIAESPERADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                        }
                    }
                    return RedirectToAction("Index", new { value = concursovalue });
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear el registro de persistencia esperada", ex);
                }
            }            
        }
        
        public ActionResult Editar(int id, bool tipo)
        {
            PersistenciaEsperada persistenciaesperada = web.AdministracionClient.ListarPersistenciaEsperadaPorId(id).ToList()[0];
            var viewModel = new PersistenciaEsperadaViewModel()
            {
                PersistenciaEsperadaView = persistenciaesperada,
                PlazoList                = new SelectList(web.AdministracionClient.ListarPlazoes().ToList(), "id", "nombre", persistenciaesperada.plazo_id),
            };
            viewModel.PersistenciaEsperadaView.tipoPersistencia = tipo;
            ViewData["PersistenciaEsperadaViewModel"]           = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            bool tipo         = bool.Parse(collection.Get("tipoPersistencia_Edit"));
            string idPlazo    = (collection["plazo_id_edit"] != null ? collection["plazo_id_edit"] : collection["plazo_id_edit"] = "0");
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                PersistenciaEsperada persistenciaesperada = new PersistenciaEsperada()
                {
                    tipoPersistencia = tipo,
                    valor            = float.Parse(collection[1]),
                    plazo_id         = int.Parse(idPlazo)
                };
                if (web.AdministracionClient.ActualizarPersistenciaEsperada(id, persistenciaesperada, userName) != 0)
                {
                    Logging.Auditoria("Actualización del registro " + persistenciaesperada.id + " en la tabla PERSISTENCIAESPERADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                }
                else
                {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
            catch  (Exception ex)
            {
                throw new Exception("No se pudo editar el registro de persistencia esperada con id = " + id, ex);
            }
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);

            try
            {
                string mensaje = "";
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarPersistenciaEsperada(id, null, userName);
                if (mensaje != "") 
                { 
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); 
                }
                else 
                { 
                    Logging.Auditoria("Eliminación del registro " + id + " en la tabla PERSISTENCIAESPERADA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); 
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar el registro de persistencia esperada con id = " + id, ex);
            }
            return RedirectToAction("Index", new { value = concursovalue });
        }
    }
}
