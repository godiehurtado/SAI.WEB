using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Controllers;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class AsesoresController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private AdministracionSvc.AdministracionClient _adminSvc;

        [Authorize]
        public PartialViewResult _BuscarAsesores()
        {
            return PartialView();
        }

        [Authorize, HttpPost]
        public JsonResult BuscarAsesoresJSON(string textoBusqueda, int inicio, int cantidad, int nivel = default(int))
        {
            _adminSvc = new AdministracionSvc.AdministracionClient();
            string documento = HttpContext.Session["IdDocumento"].ToString();
            Participante p = _adminSvc.ListarParticipantes(null).Where(x => x.documento == documento && x.nivel_id == 2).FirstOrDefault();
            
            JsonResult res = new JsonResult();
            if (p == null)
            {
                if (nivel == 0)
                {
                    res.Data = _adminSvc.ListarParticipantesBuscador(textoBusqueda, inicio, cantidad, 1, 0)
                        .Select(x => new
                        {
                            id = x.id,
                            nombre = x.nombre.Trim(),
                            apellidos = x.apellidos.Trim(),
                            clave = x.clave.Trim(),
                            documento = x.documento.Trim()
                        });
                }
                else
                {
                    res.Data = _adminSvc.ListarParticipantesBuscador(textoBusqueda, inicio, cantidad, nivel, 0)
                           .Select(x => new
                           {
                               id = x.id,
                               nombre = x.nombre.Trim(),
                               apellidos = x.apellidos.Trim(),
                               clave = (string.IsNullOrEmpty(x.clave) ? string.Empty : x.clave.Trim()),
                               documento = (string.IsNullOrEmpty(x.documento) ? string.Empty : x.documento.Trim())
                           });

                }
            }
            else
            {
                List<int> idsParticipantes = _adminSvc.ListarJerarquiaDetalle().Where(x => x.padre_id == _adminSvc.ListarJerarquiaDetalle().Where(y => y.participante_id == p.id).FirstOrDefault().id).Select(x => x.participante_id).ToList();
                if (nivel == 0)
                {
                    res.Data = _adminSvc.ListarParticipantesBuscador(textoBusqueda, inicio, cantidad, 1, 0).Where(x => idsParticipantes.Contains(x.id))
                        .Select(x => new
                        {
                            id = x.id,
                            nombre = x.nombre.Trim(),
                            apellidos = x.apellidos.Trim(),
                            clave = x.clave.Trim(),
                            documento = x.documento.Trim()
                        });
                }
                else
                {
                    res.Data = _adminSvc.ListarParticipantesBuscador(textoBusqueda, inicio, cantidad, nivel, 0)
                           .Select(x => new
                           {
                               id = x.id,
                               nombre = x.nombre.Trim(),
                               apellidos = x.apellidos.Trim(),
                               clave = (string.IsNullOrEmpty(x.clave) ? string.Empty : x.clave.Trim()),
                               documento = (string.IsNullOrEmpty(x.documento) ? string.Empty : x.documento.Trim())
                           });

                }
            }
            return res;
        }
    }
}
