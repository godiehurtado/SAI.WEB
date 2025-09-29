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
    public class UnidadMedidaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["UnidadMedidas"] = web.AdministracionClient.ListarUnidadMedida();
            Crear();
            return View(ViewData["UnidadMedidas"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {

            var viewModel = new UnidadMedidaViewModel()
            {

                UnidadMedidaView = new UnidadMedida(),
                TipoUnidadMedidaList = new SelectList(web.AdministracionClient.ListarTipoUnidadMedida().ToList(), "id", "nombre")

            };
            ViewData["UnidadMedidaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    UnidadMedida unidadmedida = new UnidadMedida()
                    {
                        nombre = collection[0],
                        tipounidadmedida_id = int.Parse(collection["tipounidadmedida_id"])

                    };
                    if (web.AdministracionClient.InsertarUnidadMedida(unidadmedida, userName) != 0)
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
            UnidadMedida unidadmedida = web.AdministracionClient.ListaUnidadMedidaPorId(id).ToList()[0];
            var viewModel = new UnidadMedidaViewModel()
            {
                TipoUnidadMedidaList = new SelectList(web.AdministracionClient.ListarTipoUnidadMedida().ToList(), "id", "nombre", unidadmedida.tipounidadmedida_id)

            };
            ViewData["UnidadMedidaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    UnidadMedida unidadmedida = new UnidadMedida()
                    {
                        nombre = collection[0],
                        tipounidadmedida_id = Convert.ToInt16(collection["tipounidadmedida_id"])

                    };
                    web.AdministracionClient.ActualizarUnidadMedida(id, unidadmedida, userName);
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
                mensaje = web.AdministracionClient.EliminarUnidadMedida(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla UNIDADMEDIDA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


