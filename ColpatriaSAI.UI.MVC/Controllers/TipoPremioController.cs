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
    public class TipoPremioController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["TipoPremios"] = web.AdministracionClient.ListarTipoPremio();
            Crear();
            return View(ViewData["TipoPremios"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {

            var viewModel = new TipoPremioViewModel()
            {

                TipoPremioView = new TipoPremio(),
                UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadMedida().ToList(), "id", "nombre"),
                PagoList = new SelectList(new List<string>() { { "Si" }, { "No" } })
            };
            ViewData["TipoPremioViewModel"] = viewModel;
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
                    TipoPremio tipopremio = new TipoPremio()
                    {
                        nombre = collection[0],
                        unidadMedida_id = int.Parse(collection[1]),
                        generapago = (collection[2] == "Si") ? "Si" : "No"
                    };
                    if (web.AdministracionClient.InsertarTipoPremio(tipopremio, userName) != 0)
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
            TipoPremio tipopremio = web.AdministracionClient.ListarTipoPremioPorId(id).ToList()[0];
            var viewModel = new TipoPremioViewModel()
            {
                UnidadMedidaList = new SelectList(web.AdministracionClient.ListarUnidadMedida().ToList(), "id", "nombre", tipopremio.unidadMedida_id),
                PagoList = new SelectList(new List<string>() { { "Si" }, { "No" } }, tipopremio.generapago)
            };
            ViewData["TipoPremioViewModel"] = viewModel;
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
                    TipoPremio tipopremio = new TipoPremio()
                    {
                        nombre = collection[0],
                        unidadMedida_id = Convert.ToInt16(collection["unidadmedida_id"]),
                        generapago = (collection[2] == "Si") ? "Si" : "No"
                    };
                    web.AdministracionClient.ActualizarTipoPremio(id, tipopremio, userName);
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
                string mensaje = "";
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarTipoPremio(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla TIPOPREMIO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex) { }
            return RedirectToAction("Index");
        }
    }
}


