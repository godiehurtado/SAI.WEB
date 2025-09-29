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
    public class ParticipanteConcursoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {

            if (Request.QueryString["value"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
                TempData["valuec"] = Request.QueryString["value"];
            }

            try
            {
                ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                ViewData["ParticipanteConcursos"] = web.AdministracionClient.ListarParticipanteConcursoes().Where(P => P.concurso_id == int.Parse(ViewData["value"].ToString()));
                Crear();
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de participante concurso", ex);
            }
            return View();
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getLocalidades(int zona_id)
        {
            return Json(web.AdministracionClient.ListarLocalidadesPorZona(zona_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult Participantes()
        {
            int inicio = 0;
            int cantidad = 20;
            if (Request["zona_id"] != string.Empty && Request["zona_id"] != null)
                ViewData["zona_id"] = Request["zona_id"];
            else
                ViewData["zona_id"] = 0;

            if (Request["concurso_id"] != string.Empty && Request["concurso_id"] != null)
                ViewData["concurso_id"] = Request["concurso_id"];
            else
                ViewData["concurso_id"] = 0;

            TempData["valuec1"] = ViewData["concurso_id"];

            ViewBag.tipoConcurso = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(ViewData["concurso_id"]));

            if (ViewBag.tipoConcurso == 1)
            {
                ViewData["Participantes"] = web.AdministracionClient.ListarParticipantesIndex(inicio, cantidad, Convert.ToInt32(ViewData["zona_id"])).Where(p => p.id > 0 && p.nivel_id == 1);
                ViewBag.nivel = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id == 1), "id", "nombre");
            }

            else
            {
                ViewData["Participantes"] = web.AdministracionClient.ListarParticipantesIndex(inicio, cantidad, Convert.ToInt32(ViewData["zona_id"])).Where(p => p.id > 0);
                ViewBag.nivel = new SelectList(web.AdministracionClient.ListarNivels(), "id", "nombre");
            }
            return View(ViewData["Participantes"]);
        }

        public ActionResult Jerarquia()
        {
            int inicio = 0;
            int cantidad = 20;
            if (Request["zona_id"] != string.Empty && Request["zona_id"] != null)
                ViewData["zona_id"] = Request["zona_id"];
            else
                ViewData["zona_id"] = 0;

            if (Request["concurso_id"] != string.Empty && Request["concurso_id"] != null)
                ViewData["concurso_id"] = Request["concurso_id"];
            else
                ViewData["concurso_id"] = 0;

            ViewBag.tipoConcurso = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(ViewData["concurso_id"]));

            if (ViewBag.tipoConcurso == 2)
            {
                ViewData["Jerarquia"] = web.AdministracionClient.ListarJerarquiaIndex(inicio, cantidad, Convert.ToInt32(ViewData["zona_id"])).Where(p => p.id > 0 && p.nivel_id > 1);
                ViewBag.nivel = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id > 1), "id", "nombre");
            }

            else
            {
                ViewData["Jerarquia"] = web.AdministracionClient.ListarJerarquiaIndex(inicio, cantidad, Convert.ToInt32(ViewData["zona_id"])).Where(p => p.id > 0 && p.nivel_id == 1);
                ViewBag.nivel = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id == 1), "id", "nombre");
            }
            return View(ViewData["Jerarquia"]);
        }

        public ActionResult getParticipantes(string texto, int inicio, int cantidad, int nivel, int zona, int? concurso)
        {
            try
            {
                ViewBag.tipoConcurso = web.AdministracionClient.RetornarTipoConcurso((int)concurso);
            }
            catch { }

            if (ViewBag.tipoConcurso == 1)
            {
                var participantes = web.AdministracionClient.ListarParticipantesBuscador(texto, inicio, cantidad, nivel, zona).Where(p => p.nivel_id == 1);
                return Json(participantes.Select(p => new { p.id, p.nombre, p.apellidos, p.clave, nivel = (p.Nivel != null) ? p.Nivel.nombre : "" }), 0);
            }

            else
            {
                var participantes = web.AdministracionClient.ListarParticipantesBuscador(texto, inicio, cantidad, nivel, zona);
                return Json(participantes.Select(p => new { p.id, p.nombre, p.apellidos, p.clave, nivel = (p.Nivel != null) ? p.Nivel.nombre : "" }), 0);
            }

        }

        public ActionResult getJerarquia(string texto, int inicio, int cantidad, int nivel, int zona, int? concurso)
        {
            try
            {
                ViewBag.tipoConcurso = web.AdministracionClient.RetornarTipoConcurso((int)concurso);
            }
            catch (Exception ex)
            {
                throw new Exception("No se retorno valor del tipo concurso consultado en participante concurso, metodo getJerarquia()", ex);
            }

            if (ViewBag.tipoConcurso == 2)
            {
                var jerarquia = web.AdministracionClient.ListarJerarquiaBuscador(texto, inicio, cantidad, nivel, zona).Where(jd => jd.nivel_id > 1);
                return Json(jerarquia.Select(p => new { p.id, p.nombre, p.codigoNivel, nivel = (p.Nivel != null) ? p.Nivel.nombre : "" }), 0);
            }

            else
            {
                var jerarquia = web.AdministracionClient.ListarJerarquiaBuscador(texto, inicio, cantidad, nivel, zona).Where(jd => jd.nivel_id == 1);
                return Json(jerarquia.Select(p => new { p.id, p.nombre, p.codigoNivel, nivel = (p.Nivel != null) ? p.Nivel.nombre : "" }), 0);
            }
        }

        public ActionResult Crear()
        {
            ParticipanteConcursoViewModel viewModel = llenarCollection();
            ViewData["ParticipanteConcursoViewModel"] = viewModel;
            return View(viewModel);
        }

        public ParticipanteConcursoViewModel llenarCollection()
        {
            TempData["tipoConcurso_id"] = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(TempData["value"]));

            if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2)
            {
                ParticipanteConcursoViewModel viewModel2 = new ParticipanteConcursoViewModel()
                {
                    ParticipanteConcursoView = new ParticipanteConcurso(),
                    CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                    SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre"),
                    CanalList = new SelectList(web.AdministracionClient.ListarCanals().ToList(), "id", "nombre"),
                    ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre"),
                    LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre"),
                    NivelList = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id > 1).ToList(), "id", "nombre"),
                    CategoriaList = new SelectList(web.AdministracionClient.ListarCategorias().ToList(), "id", "nombre")
                };
                return viewModel2;
            }

            ParticipanteConcursoViewModel viewModel = new ParticipanteConcursoViewModel()
            {
                ParticipanteConcursoView = new ParticipanteConcurso(),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre"),
                CanalList = new SelectList(web.AdministracionClient.ListarCanals().ToList(), "id", "nombre"),
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre"),
                LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre"),
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id == 1).ToList(), "id", "nombre"),
                CategoriaList = new SelectList(web.AdministracionClient.ListarCategorias().ToList(), "id", "nombre")
            };
            return viewModel;
        }

        [HttpPost]
        public ActionResult Crear(string id, FormCollection collection)
        {
            int concursovalue = 0;
            string idCanal = (collection["canal_id"] != "" ? collection["canal_id"] : collection["canal_id"] = "0");
            string idNivel = (collection["nivel_id"] != "" ? collection["nivel_id"] : collection["nivel_id"] = "0");
            string idZona = (collection["zona_id"] != "" ? collection["zona_id"] : collection["zona_id"] = "0");
            string idLocalidad = (collection["localidad_id"] != "" ? collection["localidad_id"] : collection["localidad_id"] = "0");
            string idParticipante = (collection["participante_id"] != "participante_id" ? collection["participante_id"] : collection["participante_id"] = "0");
            string idParticipante1 = (idParticipante != null ? idParticipante : idParticipante = "0");
            string idCategoria = (collection["categoria_id"] != "" ? collection["categoria_id"] : collection["categoria_id"] = "0");
            string idJerarquia = (collection["jerarquiaDetalle_id"] != "" ? collection["jerarquiaDetalle_id"] : collection["jerarquiaDetalle_id"] = "0");
            string idJerarquia1 = (idJerarquia != null ? idJerarquia : idJerarquia = "0");
            string userName = HttpContext.Session["userName"].ToString();
            try
            {
                if (ModelState.IsValid)
                {
                    ParticipanteConcurso participanteconcurso = new ParticipanteConcurso()
                    {
                        concurso_id = int.Parse(collection[9]),
                        segmento_id = int.Parse(collection["segmento_id"]),
                        canal_id = int.Parse(idCanal),
                        nivel_id = int.Parse(idNivel),
                        zona_id = int.Parse(idZona),
                        localidad_id = int.Parse(idLocalidad),
                        participante_id = int.Parse(idParticipante),
                        categoria_id = int.Parse(idCategoria),
                        compania_id = int.Parse(collection["compania_id"]),
                        jerarquiaDetalle_id = int.Parse(idJerarquia)

                    };
                    concursovalue = int.Parse(collection[9]);
                    if (web.AdministracionClient.InsertarParticipanteConcurso(participanteconcurso, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + participanteconcurso.id + " en la tabla PARTICIPANTECONCURSO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear el participante concurso", ex);
            }
            return RedirectToAction("Index", new { value = concursovalue });
        }

        public ActionResult Editar(int id)
        {
            ParticipanteConcurso participanteconcurso = web.AdministracionClient.ListarParticipanteConcursoesPorId(id).ToList()[0];
            var viewModel = new ParticipanteConcursoViewModel()
            {
                ParticipanteConcursoView = participanteconcurso,
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", participanteconcurso.compania_id),
                SegmentoList = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList(), "id", "nombre", participanteconcurso.segmento_id),
                CanalList = new SelectList(web.AdministracionClient.ListarCanals().ToList(), "id", "nombre", participanteconcurso.canal_id),
                ZonaList = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre", participanteconcurso.zona_id),
                LocalidadList = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre", participanteconcurso.localidad_id),
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().ToList(), "id", "nombre", participanteconcurso.nivel_id),
                CategoriaList = new SelectList(web.AdministracionClient.ListarCategorias().ToList(), "id", "nombre", participanteconcurso.categoria_id)
            };
            ViewData["ParticipanteConcursoViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            string idCompania = (collection["compania_id"] != "" ? collection["compania_id"] : collection["compania_id"] = "0");
            string idCanal = (collection["canal_id"] != "" ? collection["canal_id"] : collection["canal_id"] = "0");
            string idNivel = (collection["nivel_id"] != "" ? collection["nivel_id"] : collection["nivel_id"] = "0");
            string idZona = (collection["zona_id"] != "" ? collection["zona_id"] : collection["zona_id"] = "0");
            string idLocalidad = (collection["localidad_id"] != "" ? collection["localidad_id"] : collection["localidad_id"] = "0");
            string idParticipante = (collection["participante_id"] != "" ? collection["participante_id"] : collection["participante_id"] = "0");
            string idCategoria = (collection["categoria_id"] != "" ? collection["categoria_id"] : collection["categoria_id"] = "0");
            string userName = HttpContext.Session["userName"].ToString();
            int concursovalue = Convert.ToInt16(TempData["value"]);

            if (concursovalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    ParticipanteConcurso participanteconcurso = new ParticipanteConcurso()
                    {
                        segmento_id = Convert.ToInt16(collection["segmento_id"]),
                        canal_id = Convert.ToInt16(collection["canal_id"]),
                        nivel_id = Convert.ToInt16(collection["nivel_id"]),
                        zona_id = Convert.ToInt16(collection["zona_id"]),
                        localidad_id = Convert.ToInt16(collection["localidad_id"]),
                        categoria_id = Convert.ToInt16(collection["categoria_id"]),
                        compania_id = Convert.ToInt16(collection["compania_id"])
                    };
                    web.AdministracionClient.ActualizarParticipanteConcurso(id, participanteconcurso, userName);
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar el participante concurso con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["valuec"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0)
            {
                return RedirectToAction("Index", new { value = concursovalue });
            }

            else
            {
                try
                {
                    string mensaje = "";
                    mensaje = web.AdministracionClient.EliminarParticipanteConcurso(id, null, userName);
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla PARTICIPANTECONCURSO.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar el participante concurso con id = " + id, ex);
                }
                return RedirectToAction("Index", new { value = concursovalue });
            }
        }
    }
}


