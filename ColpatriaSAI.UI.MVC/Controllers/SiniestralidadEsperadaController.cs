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
    public class SiniestralidadEsperadaController : ControladorBase
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
                ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                ViewData["SiniestralidadEsperadas"] = web.AdministracionClient.ListarSiniestralidadEsperada().Where(SE => SE.concurso_id == int.Parse(ViewData["value"].ToString()));

                Crear();
                return View();
            }
            catch { }
            return RedirectToAction("Index", "Concursos");
        }

        public ActionResult Crear()
        {
            var viewModel = new SiniestralidadEsperadaViewModel()
            {
                SiniestralidadEsperadaView = new SiniestralidadEsperada()
            };
            ViewData["SiniestralidadEsperadaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    SiniestralidadEsperada siniestralidadesperada = new SiniestralidadEsperada()
                    {
                        ramo_id = 8, //Automoviles
                        valor = float.Parse(collection["valor"]),
                        concurso_id = int.Parse(collection["concurso_id"])
                    };
                    if (web.AdministracionClient.InsertarSiniestralidadEsperada(siniestralidadesperada, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + siniestralidadesperada.id + " en la tabla SINIESTRALIDADESPERADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
            catch { }
            return RedirectToAction("Index", new { value = concursovalue });
        }

        public ActionResult Editar(int id)
        {
            SiniestralidadEsperada siniestralidadesperada = web.AdministracionClient.ListarSiniestralidadEsperadaPorId(id).ToList()[0];
            var viewModel = new SiniestralidadEsperadaViewModel()
            {
                SiniestralidadEsperadaView = siniestralidadesperada
            };

            ViewData["SiniestralidadEsperadaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                SiniestralidadEsperada siniestralidadesperada = web.AdministracionClient.ListarSiniestralidadEsperadaPorId(id).ToList()[0];
                {
                    siniestralidadesperada.valor = float.Parse(collection[0]);
                };
                if (web.AdministracionClient.ActualizarSiniestralidadEsperada(id, siniestralidadesperada, userName) != 0)
                {
                    Logging.Auditoria("Actualización del registro " + siniestralidadesperada.id + " en la tabla SINIESTRALIDADESPERADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                }
                else
                {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
            catch { }
            return RedirectToAction("Index", new { value = concursovalue });
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                string mensaje = "";
                mensaje = web.AdministracionClient.EliminarSiniestralidadEsperada(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla SINIESTRALIDADESPERADA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index", new { value = concursovalue });
        }
    }
}
