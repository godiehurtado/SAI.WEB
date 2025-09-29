using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Datos;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class JerarquiaController : ControladorBase
    {
        WebPage web = new WebPage();

        #region Acciones para los Nodos

        public ViewResult Index()
        {
            return View();
        }

        public ActionResult Detalle(int id)
        {
            //ViewBag.Jerarquia = web.AdministracionClient.ListarJerarquiaPorId(id);
            TempData["jerarquia_id"] = id;
            CrearNodo();
            ViewData["CompaniaList"] = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", 0);
            var metasList = web.AdministracionClient.ListarMetas().OrderBy(x => x.nombre).ToList();
            ViewData["MetasList"] = new SelectList(metasList.Where(m => m.tipoMetaCalculo_id == 2).ToList(), "id", "nombre", 0);
            ViewData["MetasListExcepciones"] = metasList.Where(m => m.tipoMetaCalculo_id == 1 && m.meta_id == null).ToList();
            return View();
        }

        public ActionResult getJerarquiaPorId(int id, int padre_id)
        {
            var arbol = web.AdministracionClient.ListarArbol(id, padre_id);
            return Json(arbol.Select(a => new
                {
                    attr = new { id = a.attr.id, rel = a.attr.rel, cod = a.attr.cod },
                    data = new
                    {
                        title = a.data
                    },
                    state = "closed",
                    children = a.children
                }), 0);
        }

        public ActionResult Crear()
        {
            string userName = HttpContext.Session["userName"].ToString();
            List<int> segmentosusuario = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == userName).Select(x => (int)x.segmento_id).ToList();
            ViewBag.Jerarquias = web.AdministracionClient.ListarJerarquias().Where(x => segmentosusuario.Contains(x.segmento_id)).ToList();
            ViewBag.segmento_id = new SelectList(web.AdministracionClient.ListarSegmentoes(), "id", "nombre");
            ViewBag.tipoJerarquia_id = new SelectList(web.AdministracionClient.ListarTiposJerarquia(), "id", "nombre");
            return View();
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collect)
        {
            Jerarquia jerarquia = new Jerarquia();
            UpdateModel(jerarquia, collect);
            web.AdministracionClient.InsertarJerarquia(jerarquia, HttpContext.Session["userName"].ToString());
            return RedirectToAction("Crear");
        }

        [HttpPost]
        public ActionResult Editar(FormCollection collect)
        {
            Jerarquia jerarquia = new Jerarquia();
            UpdateModel(jerarquia, collect);
            jerarquia.id = Convert.ToInt32(collect["jerarquia_id"]);
            web.AdministracionClient.ActualizarJerarquia(jerarquia.id, jerarquia, HttpContext.Session["userName"].ToString());
            return RedirectToAction("Crear");
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost, ActionName("Eliminar")]
        public ActionResult DeleteConfirmed(int id)
        {
            web.AdministracionClient.EliminarJerarquia(id,HttpContext.Session["userName"].ToString());
            return RedirectToAction("Crear");
        }
        #endregion
        /*********************************************************************************************/
        #region Acciones para un Item determinado
        [HttpPost]
        public ActionResult ConsultarNodo(int id)
        {
            var nodo = web.AdministracionClient.ListarNodoArbol(id);
            return Json(new
            {
                nombre = nodo.nombre,
                descripcion = nodo.descripcion,
                zona_id = nodo.zona_id,
                localidad_id = nodo.localidad_id,
                canal_id = nodo.canal_id,
                participante_id = nodo.participante_id,
                nivel_id = nodo.nivel_id,
                codigoNivel = nodo.codigoNivel,
                nombrePpante = nodo.Participante.nombre + " " + nodo.Participante.apellidos,
                nombreZona = nodo.Zona.nombre,
                nombreLocalidad = nodo.Localidad.nombre,
                nombreCanal = nodo.Canal.nombre,
                nombreNivel = nodo.Nivel.nombre,
                codJerarquia = nodo.codJerarquia
            }, 0);
        }

        public ActionResult CrearNodo()
        {
            //List<Nivel> niveles = web.AdministracionClient.ListarNivels().Where(n => n.id != 1).ToList();
            //niveles.RemoveAt(1);
            ViewBag.JerarquiaDetalle = new JerarquiaDetalle();
            ViewBag.padre_id = new SelectList(web.AdministracionClient.ListarJerarquiaDetalle(), "id", "nombre");
            ViewBag.zona_id = new SelectList(web.AdministracionClient.ListarZonas(), "id", "nombre");
            ViewBag.localidad_id = new SelectList(new List<string>() { "Seleccione..." });
            ViewBag.canal_id = new SelectList(web.AdministracionClient.ListarCanals(), "id", "nombre");
            //ViewBag.participante_id = new SelectList(new List<string>() { "Seleccione..." });
            ViewBag.nivel_id = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id != 1), "id", "nombre");
            return View();
        }

        [HttpPost]
        public ActionResult CrearNodo(FormCollection collect)
        {
            JerarquiaDetalle detalle = new JerarquiaDetalle()
            {
                id = Convert.ToInt32(collect["detalle_id"]),
                jerarquia_id = Convert.ToInt32(collect["jerarquia_id"]),
                nombre = collect["nombre"],
                descripcion = collect["descripcion"],
                padre_id = collect["padre_id"] != "0" ? Convert.ToInt32(collect["padre_id"]) : new Nullable<int>(),
                zona_id = collect["zona_id"] != "" ? Convert.ToInt32(collect["zona_id"]) : 0,
                localidad_id = collect["localidad_id"] != "" ? Convert.ToInt32(collect["localidad_id"]) : 0,
                canal_id = collect["canal_id"] != "" ? Convert.ToInt32(collect["canal_id"]) : 0,
                participante_id = collect["participante_id"] != "" ? Convert.ToInt32(collect["participante_id"]) : 0,
                nivel_id = Convert.ToInt32(collect["nivel_id"]),
                codigoNivel = Convert.ToString(collect["codigoNivel"])
            };
            //UpdateModel(detalle, collect);
            var result = web.AdministracionClient.InsertarJerarquiaDetalle(detalle, HttpContext.Session["userName"].ToString());
            return Json(result, 0);
        }

        [HttpPost]
        public ActionResult GuardarNodos(string jerarquia)
        {
            return Json("OK", 0);
        }

        [HttpPost]
        public ActionResult ActualizarNodos(FormCollection collect)
        {
            JerarquiaDetalle detalle = new JerarquiaDetalle()
            {
                id = Convert.ToInt32(collect["id"]),
                padre_id = collect["padre_id"] != "0" ? Convert.ToInt32(collect["padre_id"]) : new Nullable<int>()
            };
            int result = (detalle.padre_id != null) ? web.AdministracionClient.ActualizarOrdenNodo(detalle, HttpContext.Session["userName"].ToString()) : 0;
            return Json(new { status = result }, 0);
        }

        [HttpPost]
        public ActionResult EliminarNodo(int id)
        {
            var result = web.AdministracionClient.EliminarJerarquiaDetalle(id, HttpContext.Session["userName"].ToString());
            return Json(result, 0);
        }

        [HttpPost]
        public ActionResult guardarExcepcion()
        {

            String messagge = string.Empty;
            Boolean success = false;
            string jerarquiasDestino = Request["destinoIds"];
            int jerarquiaOrigen = int.Parse(Request["origenId"]);
            string metas = Request["metas[]"];

            char[] delimiterChars = { ',' };
            string[] arrJerarquiaDestino = jerarquiasDestino.Split(delimiterChars);

            //VALIDAMOS QUE HAYA METAS
            if (!string.IsNullOrEmpty(metas))
            {
                string[] arrMetas = metas.Split(delimiterChars);

                List<ExcepcionJerarquiaDetalle> excepcionJerarquiaDetalleList = web.AdministracionClient.ListarExcepcionesJerarquiaporId(jerarquiaOrigen);

                //RECORREMOS LOS DESTINOs
                foreach (string idJerarquiaDestino in arrJerarquiaDestino)
                {
                    if (!string.IsNullOrEmpty(idJerarquiaDestino) && idJerarquiaDestino != "0")
                    {

                        //RECORREMOS LAS METAS SELECCIONADAS Y LAS INSERTAMOS POR CADA DESTINO
                        foreach (string idMeta in arrMetas)
                        {
                            if (!string.IsNullOrEmpty(idMeta) && idMeta != "0")
                            {
                                //VALIDAMOS SI LA EXCEPCION YA EXISTE
                                var totalExcepcion = excepcionJerarquiaDetalleList.Where(x => x.excepcionJerarquiaOrigen_id == jerarquiaOrigen && x.excepcionJerarquiaDestino_id == Convert.ToInt32(idJerarquiaDestino) && x.meta_id == Convert.ToInt32(idMeta)).Count();

                                if (totalExcepcion == 0)
                                {
                                    var expecionJerarquia = new ExcepcionJerarquiaDetalle()
                                    {
                                        excepcionJerarquiaOrigen_id = jerarquiaOrigen,
                                        excepcionJerarquiaDestino_id = Convert.ToInt32(idJerarquiaDestino),
                                        meta_id = Convert.ToInt32(idMeta),
                                    };

                                    int registro = web.AdministracionClient.InsertarExceptionJerarquia(expecionJerarquia, HttpContext.Session["userName"].ToString());
                                }
                            }
                        }
                    }
                }
            }

            return Json(new { Success = true });
        }

        [HttpPost]
        public ActionResult listadoExcepcionesJerarquia()
        {
            int idJerarquia = Convert.ToInt32(Request["idJerarquia"]);

            //OBTENEMOS EL LISTADO DE EXCEPCIONES POR JERARQUIA
            List<ExcepcionJerarquiaDetalle> excepcionJerarquiaDetalleList = web.AdministracionClient.ListarExcepcionesJerarquiaporId(idJerarquia);

            var model = new ExcepcionJerarquiaDetalleModel()
            {
                ExcepcionJerarquiaDetalleList = excepcionJerarquiaDetalleList
            };

            return View("ExcepcionesJerarquiaList", model);
        }

        [HttpPost]
        public ActionResult eliminarExcepcionJerarquia()
        {
            int idExcepcionJerarquia = Convert.ToInt32(Request["idExcepcionJerarquia"]);

            web.AdministracionClient.EliminarExceptionJerarquia(idExcepcionJerarquia, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true });
        }

        [HttpPost]
        public ActionResult eliminarExcepcionJerarquiaAll()
        {
            int idNodoOrigen = Convert.ToInt32(Request["idNodoOrigen"]);

            List<ExcepcionJerarquiaDetalle> excepcionJerarquiaDetalleList = web.AdministracionClient.ListarExcepcionesJerarquiaporId(idNodoOrigen);

            foreach (ExcepcionJerarquiaDetalle excepcionJerarquiaDetalle in excepcionJerarquiaDetalleList)
            {
                web.AdministracionClient.EliminarExceptionJerarquia(excepcionJerarquiaDetalle.id, HttpContext.Session["userName"].ToString());
            }

            return Json(new { Success = true });
        }


        [HttpPost]
        public ActionResult guardarMeta()
        {
            String messagge = string.Empty;

            int jerarquiaOrigen = int.Parse(Request["origenId"]);

            var metaJerarquia = new MetaxNodo()
            {
                meta_id = int.Parse(Request["metaId"]),
                jerarquiaDetalle_id = int.Parse(Request["origenId"]),
                anio = int.Parse(Request["anio"])
            };

            web.AdministracionClient.InsertarMetaNodo(metaJerarquia, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true });
        }

        [HttpPost]
        public ActionResult listadoMetasJerarquia()
        {
            int idJerarquia = Convert.ToInt32(Request["idJerarquia"]);

            //OBTENEMOS EL LISTADO DE METAS POR JERARQUIA
            List<MetaxNodo> metaJerarquiaList = web.AdministracionClient.ListarMetasxJerarquiaId(idJerarquia);

            var model = new MetaJerarquiaModel()
            {
                MetaJerarquiaList = metaJerarquiaList
            };

            return View("MetasJerarquiaList", model);
        }

        [HttpPost]
        public ActionResult eliminarMetaJerarquia()
        {
            int idMetaJerarquia = Convert.ToInt32(Request["idMetaJerarquia"]);

            web.AdministracionClient.EliminarMetaNodo(idMetaJerarquia, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true });
        }

        #endregion

        protected override void Dispose(bool disposing)
        {
            base.Dispose(disposing);
        }
    }
}
