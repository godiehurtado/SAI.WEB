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
    public class PremiosAnterioresController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["PremiosAnteriores"] = web.AdministracionClient.ListarPremioAnterior();
            Crear();
            return View(ViewData["PremiosAnteriores"]);
        }

        public ActionResult Crear()
        {
            var viewModel = new PremiosAnterioresViewModel()
            {
                PremiosAnterioresView = new PremiosAnteriore()
            };
            ViewData["PremiosAnterioresViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            bool tipoF = collection.Get("FASECOLDA") == null ? false : true;
            bool tipoL = collection.Get("LIMRA") == null ? false : true;

            try
            {
                if (ModelState.IsValid)
                {
                    PremiosAnteriore premiosanteriores = new PremiosAnteriore()
                    {
                        clave = collection["clave"],
                        año = int.Parse(collection["anio"]),
                        LIMRA = tipoL,
                        FASECOLDA = tipoF
                    };
                    string valorClave = collection["clave"];
                    int valorAnio = int.Parse(collection["anio"]);
                    string userName = HttpContext.Session["userName"].ToString();
                    if (web.AdministracionClient.InsertarPremioAnterior(premiosanteriores, userName) != 0)
                    {
                        web.AdministracionClient.ActualizarPremioConsolidadoMes(valorClave, valorAnio, 0, userName);
                        Logging.Auditoria("Creación del registro " + premiosanteriores.id + " en la tabla PREMIOSANTERIORES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }

                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }

                }
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear el premio anterior", ex);
            }
        }

        public ActionResult Editar(int id)
        {
            PremiosAnteriore premiosanteriores = web.AdministracionClient.ListarPremioAnteriorPorId(id).ToList()[0];
            ViewBag.FASECOLDA = premiosanteriores.FASECOLDA.Value;
            ViewBag.LIMRA = premiosanteriores.LIMRA.Value;

            var viewModel = new PremiosAnterioresViewModel()
            {
                PremiosAnterioresView = new PremiosAnteriore()
            };
            ViewData["PremiosAnterioresViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            bool tipoF = collection.Get("FASECOLDA_Editar") == null ? false : true;
            bool tipoL = collection.Get("LIMRA_Editar") == null ? false : true;

            try
            {
                if (ModelState.IsValid)
                {
                    PremiosAnteriore premiosanteriores = new PremiosAnteriore()
                    {
                        clave = collection["clave_Editar"],
                        año = int.Parse(collection["anio_Editar"]),
                        LIMRA = tipoL,
                        FASECOLDA = tipoF
                    };
                    string valorClave = collection["clave_Editar"];
                    int valorAnio = int.Parse(collection["anio_Editar"]);
                    string userName = HttpContext.Session["userName"].ToString();
                    if (web.AdministracionClient.ActualizarPremioAnterior(id, premiosanteriores, userName) != 0)
                    {
                        web.AdministracionClient.ActualizarPremioConsolidadoMes(valorClave, valorAnio, 0, userName);
                        Logging.Auditoria("Actualización del registro " + premiosanteriores.id + " en la tabla PREMIOSANTERIORES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }

                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]);
                    }

                }
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar el premio anterior con id = " + id, ex);
            }
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                string valorClave = web.AdministracionClient.RetornarClavePremio(id);
                int valorAnio = web.AdministracionClient.RetornarAnioPremio(id);
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarPremioConsolidadoMes(valorClave, valorAnio, 1, userName);

                mensaje = web.AdministracionClient.EliminarPremioAnterior(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PREMIOSANTERIORES.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar el premio anterior con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }
    }
}
