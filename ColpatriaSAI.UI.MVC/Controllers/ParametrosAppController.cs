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
    public class ParametrosAppController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["ParametrosApp"] = web.AdministracionClient.ListarParametrosApp().ToList();            
            return View(ViewData["ParametrosApp"]);
        }

        [HttpPost]
        public ActionResult Editar(FormCollection collection)
        {
            try
            {
                List<ParametrosApp> pAplicacion = new List<ParametrosApp>();
                for (int i = 0; i < Convert.ToInt32(collection["Total"]);i++ )
                {
                    ParametrosApp pap = new ParametrosApp()
                    {
                        id = int.Parse(collection["Id"+i]),
                        valor = collection["valor"+i]
                    };
                    pAplicacion.Add(pap);                    
                }
                web.AdministracionClient.ActualizarParametrosApp(pAplicacion, HttpContext.Session["userName"].ToString());                
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar la informacion de parametrosapp", ex);
            }
            return RedirectToAction("Index");
        }
    }
}
