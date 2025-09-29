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
    public class CompañiaController : ControladorBase
    {
        WebPage web = new WebPage();
       
        public ActionResult Index()
        {
            ViewData["Compañias"] = web.AdministracionClient.ListarCompanias();
            Crear();
            return View(ViewData["Companias"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new CompaniaViewModel()
            {
                CompaniaView = new Compania()
                
            };
            ViewData["CompaniaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try {
                if (ModelState.IsValid) {
                    Compania compania = new Compania() {
                        nombre = collection[0]
                    };
                    if (web.AdministracionClient.InsertarCompania(compania, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + compania.nombre + " en la tabla COMPAÑIA", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Editar(int id)
        {
            Compania compania = web.AdministracionClient.ListarCompaniasPorId(id).ToList()[0];
            var viewModel = new CompaniaViewModel() {
                CompaniaView = compania
            };
            ViewData["CompaniaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                Compania compania = new Compania() {
                    nombre = collection[0]
                };
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarCompania(id, compania,userName);
                Logging.Auditoria("Actualización del registro " + id + " en la tabla COMPAÑIA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
          
            try
            {
                 }
            catch (Exception ex)
            {
                                                  
                                
            }

            return RedirectToAction("Index");
        }
    }
}


