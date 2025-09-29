using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;


namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class TipoUnidadMedidaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["TipoUnidadMedidas"] = web.AdministracionClient.ListarTipoUnidadMedida();
            Crear();
            return View(ViewData["TipoUnidadMedidas"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {

            var viewModel = new TipoUnidadMedidaViewModel()
            {

                TipoUnidadMedidaView = new TipoUnidadMedida()

            };
            ViewData["TipoUnidadMedidaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    TipoUnidadMedida tipounidadmedida = new TipoUnidadMedida()
                    {
                        nombre = collection[0]

                    };
                    if (web.AdministracionClient.InsertarTipoUnidadMedida(tipounidadmedida, userName) != 0)
                    {
                        web.Liberar();
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
            TipoUnidadMedida tipounidadmedida = web.AdministracionClient.ListaTipoUnidadMedidaPorId(id).ToList()[0];
            var viewModel = new TipoUnidadMedidaViewModel()
            {

            };
            ViewData["TipoUnidadMedidaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    TipoUnidadMedida tipounidadmedida = new TipoUnidadMedida()
                    {
                        nombre = collection[0]

                    };
                    web.AdministracionClient.ActualizarTipoUnidadMedida(id, tipounidadmedida, userName);
                }
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
                string userName = HttpContext.Session["userName"].ToString();
                string mensaje = "";
                mensaje = web.AdministracionClient.EliminarTipoUnidadMedida(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla TIPOUNIDADMEDIDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


