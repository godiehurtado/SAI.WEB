using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class AuditoriaController : ControladorBase
    {
        //
        // GET: /Auditoria/

        WebPage web = new WebPage();

        public ActionResult Index()
        {
            WebPage web = new WebPage();
            List<Negocio.Entidades.TablaAuditada> tablas = web.AdministracionClient.ListarTablasAuditadas();
            return View(new AuditoriaViewModel
            {
                Tablas = tablas.ToDictionary(x => x.id, x => x.Tabla)
            });
        }

        public JsonResult Consultar()
        {
            string userName = HttpContext.Session["userName"].ToString();
            List<int> segmentosusuario = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == userName).Select(x => (int)x.segmento_id).ToList();
            string tabla = Request["tabla"];
            string fechainicio = Request["fechainicio"];
            string fechafin = Request["fechafin"];
            int idtabla = web.AdministracionClient.ListarTablasAuditadas().Where(x => x.Tabla == tabla).FirstOrDefault().id;
            DateTime fechaini = DateTime.Parse(fechainicio);
            DateTime fechafi = DateTime.Parse(fechafin).AddDays(1);
            List<Negocio.Entidades.Auditoria> auditorias = web.AdministracionClient.ListarAuditoria(idtabla, fechaini, fechafi, 0, segmentosusuario);
            string htmlresultados = string.Empty;
            if (auditorias.Count > 0)
            {
                foreach (Negocio.Entidades.Auditoria audi in auditorias)
                {
                    htmlresultados += "<tr><td>" + (web.AdministracionClient.ListarTablasAuditadas().Where(x => x.id == audi.id_TablaAuditada).FirstOrDefault().Tabla) +
                        "</td><td>" + audi.Usuario +
                        "</td><td>" + audi.Fecha.ToString() +
                        "</td><td>" + (web.AdministracionClient.ListarEventosTabla().Where(x => x.id == audi.id_EventoTabla).FirstOrDefault().Evento) +
                        "</td><td>" + audi.Version_Anterior +
                        "</td><td>" + audi.Version_Nueva + "</tr>";
                }
            }
            else
            {
                htmlresultados += "<tr><td>No se obtuvieron resultados</td><tr>";
            }
            return Json(new { Success = true, htmlresult = htmlresultados });
        }

    }
}
