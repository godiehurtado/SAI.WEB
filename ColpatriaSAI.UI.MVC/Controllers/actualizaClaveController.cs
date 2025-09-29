using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.Negocio.Componentes.Utilidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Globalization;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class actualizaClaveController : ControladorBase
    {
        //
        // GET: /actualizaClave/
        WebPage web = new WebPage();

        public ActionResult Index()
        {


            try
            {
                ViewData["GetHistricoCambioClave"] = web.AdministracionClient.GetHistricoCambioClave();
                return View(ViewData["GetHistricoCambioClave"]);

            }
            catch (Exception ex)
            {
                return Json(new { Result = "ERROR", Message = ex.Message });
            }
      }

        //
        // GET: /actualizaClave/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            string userName = HttpContext.Session["userName"].ToString();
            Result.result result = new Result.result();
            int ok = 2;
            try
            {
                if ((Convert.ToBoolean(collection["idreversa"])) == true)
                {

                }
                else
                {
                    ok = 4;
                }
            }
            catch
            {

                ok = 2;
            }

            clave_historico parametros = new clave_historico()
                {
                    //ver como se pasa el ind_actualizacion en el SP

                    clave_new = collection["ClaveNew"],
                    clave_old = collection["ClaveOld"],
                    fecha = Convert.ToDateTime(DateTime.Now),
                    usuario = User.Identity.Name.ToString(),
                    ind_actualizacion = ok


                };

            if (parametros.clave_new != null && parametros.clave_old != null)
            {

                result = web.AdministracionClient.InsertParametrizacionCambioClave(parametros, userName);
                if (result.resultado == Result.tipoResultado.resultOK)
                    return Json(new { Success = true, string.Empty });
                else
                    return Json(new { Success = true, result.message });

            }
            else
            {
                string message = "Todos los Campos son Requeridos";
                return Json(new { Success = false, message });
            }



        }

        //
        // GET: /actualizaClave/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /actualizaClave/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /actualizaClave/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /actualizaClave/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
