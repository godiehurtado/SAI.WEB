using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class SalarioMinimoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["SalarioMinimo"] = web.AdministracionClient.ListarSalariosMinimos();
            return View(ViewData["SalarioMinimo"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {

            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    SalarioMinimo salario = new SalarioMinimo()
                    {
                        anio = Convert.ToInt32(collection[0]),
                        smlv = Convert.ToDouble(collection[1])
                    };
                    if (web.AdministracionClient.InsertarSalarioMinimo(salario, userName) != 0)
                    {
                        web.Liberar();
                        Logging.Auditoria("Creación del registro " + salario.anio + " en la tabla SalarioMinimo.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
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
            SalarioMinimo salario = web.AdministracionClient.ListarSalariosMinimosPorId(id).ToList()[0];
            return View(salario);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                if (ModelState.IsValid)
                {
                    string userName = HttpContext.Session["userName"].ToString();
                    SalarioMinimo salario = new SalarioMinimo() { id = id, smlv = Convert.ToDouble(collection[0]) };
                    mensaje = web.AdministracionClient.ActualizarSalarioMinimo(salario, userName);
                    web.Liberar();
                    if (mensaje == 0) { TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Actualización del registro " + id + " en la tabla SalarioMinimo.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(web.AdministracionClient.ListarSalariosMinimosPorId(id).ToList()[0]);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarSalarioMinimo(new SalarioMinimo() { id = id }, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla SalarioMinimo.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch { }
            return RedirectToAction("Index");
        }
    }
}
