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
    public class ParticipanteController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index(int? id)
        {
            string userName = HttpContext.Session["userName"].ToString();
            // Segmentos se retiro de la compañia , arreglo para editar los participantes de la jerarquia 
            List<int> segmentosusuario = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == userName).Select(x => (int)x.segmento_id).ToList();
            ViewData["Participantes"] = web.AdministracionClient.ListarParticipantes(id)/*.Where(x => segmentosusuario.Contains((int)x.segmento_id))*/;
            return View();
        }

        public ActionResult Listar(int? nivelGP)
        {
            var participantes = web.AdministracionClient.ListarParticipantes(nivelGP);
            return Json(participantes.Select(p => new {
                id1           = "",
                id            = p.id,
                tipoDocumento = p.TipoDocumento.nombre.Trim(),
                documento     = p.documento.Trim(),
                nombre        = p.nombre.Trim(),
                apellidos     = p.apellidos.Trim(),
                nivel         = p.Nivel.nombre,
                segmento      = p.Segmento.nombre.Trim()
            }), 0);
        }

        public JsonResult getInfoParticipante(string cedula)
        {
            var participante = web.AdministracionClient.ListarParticipanteXCedula(cedula);
            return Json(participante.Select(p => new {
                nombrePpante     = p.nombre + " " + p.apellidos,
                tipoDocPpante    = p.TipoDocumento.nombre,
                docPpante        = p.documento,
                estadoPpante     = p.EstadoParticipante.nombre,
                fecIngresoPpante = p.fechaIngreso.Value.ToShortDateString(),
                fecRetiroPpante  = p.fechaRetiro.Value.ToShortDateString(),
                fecNacPpante     = p.fechaNacimiento.Value.ToShortDateString(),
                companiaPpante   = p.Compania.nombre,
                nivelPpante      = p.Nivel.nombre,
                zonaPpante       = p.Zona.nombre,
                localidadPpante  = p.Localidad.nombre,
                tipoPpante       = p.TipoParticipante.nombre,
                categoriaPpante  = p.Categoria.nombre,
                segmentoPpante   = p.Segmento.nombre,
                canalPpante      = p.Canal.nombre,
                clavePpante      = p.clave,
                codPpante        = p.codProductor,
                emailPpante      = p.email,
                salarioPpante    = p.salario,
                telefonoPpante   = p.telefono,
                direccionPpante  = p.direccion
            }), 0);
            
        }

        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getCanales(int segmento_id)
        {
            return Json(web.AdministracionClient.ListarCanals().Select(r => new { r.nombre, r.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult getLocalidades(int zona_id)
        {
            return Json(web.AdministracionClient.ListarLocalidadesPorZona(zona_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult Crear()
        {
            string userName = HttpContext.Session["userName"].ToString();
            List<int> segmentosusuario = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == userName).Select(x => (int)x.segmento_id).ToList();
            var viewModel = new ParticipanteViewModel() {
                ParticipanteView       = new Participante(),
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id > 1).ToList(), "id", "nombre"),  // Evita crear asesores desde la aplicación ya que estos se cargan desde la integración.
                CompaniaList           = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre"),
                ZonaList               = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre"),
                LocalidadList          = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre"),
                CanalList              = new SelectList(web.AdministracionClient.ListarCanals().ToList(), "id", "nombre"),
                CategoriaList          = new SelectList(web.AdministracionClient.ListarCategorias().ToList(), "id", "nombre"),
                TipoDocumentoList      = new SelectList(web.AdministracionClient.ListarTipodocumentoes().ToList(), "id", "nombre"),
                TipoParticipanteList   = new SelectList(web.AdministracionClient.ListarTipoparticipantes().ToList(), "id", "nombre"),
                SegmentoList           = new SelectList(web.AdministracionClient.ListarSegmentoes().Where(x => segmentosusuario.Contains(x.id)).ToList(), "id", "nombre"),
                EstadoParticipanteList = new SelectList(web.AdministracionClient.ListarEstadoparticipantes().ToList(), "id", "nombre")
            };
            ViewData["ParticipanteViewModel"] = viewModel;
            return View(viewModel);
        } 


        [HttpPost]
        public ActionResult Crear(string id, FormCollection collection)
        {
            string idCategoria       = (collection["categoria_id"] != "" ? collection["categoria_id"] : collection["categoria_id"] = "0");
            string idZona            = (collection["zona_id"] != "" ? collection["zona_id"] : collection["zona_id"] = "0");
            string idLocalidad       = (collection["localidad_id"] != "" ? collection["localidad_id"] : collection["localidad_id"] = "0");
            string idSalario         = (collection["salario"] != "" ? collection["salario"] : collection["salario"] = "0");
            string idIngresosMínimos = (collection["ingresosMinimos"] != "" ? collection["ingresosMinimos"] : collection["ingresosMinimos"] = "0");
            string idNivel           = (collection["nivel_id"] != "" ? collection["nivel_id"] : collection["nivel_id"] = "0");
            string idFechaIngreso    = (collection["fechaIngreso"] != "" ? collection["fechaIngreso"] : collection["fechaIngreso"] = "1900-01-01 00:00:00.000");
            string idFechaRetiro     = (collection["fechaRetiro"] != "" ? collection["fechaRetiro"] : collection["fechaRetiro"] = "1900-01-01 00:00:00.000");
            string idFechanacimiento = (collection["fechaNacimiento"] != "" ? collection["fechaNacimiento"] : collection["fechaNacimiento"] = "1900-01-01 00:00:00.000");

            try {
                if (ModelState.IsValid) {
                    Participante participante = new Participante() {
                        clave                 = collection["clave"],
                        codProductor          = collection["codProductor"],
                        nombre                = collection["nombre"],
                        apellidos             = collection["apellidos"],
                        documento             = collection["documento"],
                        email                 = collection["email"],
                        estadoParticipante_id = int.Parse(collection["estadoParticipante_id"]),
                        fechaIngreso          = DateTime.Parse(collection["fechaIngreso"]),
                        fechaRetiro           = DateTime.Parse(collection["fechaRetiro"]),
                        fechaNacimiento       = DateTime.Parse(collection["fechaNacimiento"]),
                        nivel_id              = int.Parse(collection["nivel_id"]),
                        compania_id           = int.Parse(collection["compania_id"]),
                        zona_id               = int.Parse(collection["zona_id"]),
                        localidad_id          = int.Parse(collection["localidad_id"]),
                        canal_id              = int.Parse(collection["canal_id"]),
                        categoria_id          = int.Parse(collection["categoria_id"]),
                        ingresosMinimos       = 0, //float.Parse(collection["ingresosMinimos"]),
                        tipoParticipante_id   = 0, //int.Parse(collection["tipoParticipante_id"]),
                        salario               = float.Parse(collection["salario"]),
                        tipoDocumento_id      = int.Parse(collection["tipoDocumento_id"]),
                        telefono              = collection["telefono"],
                        direccion             = collection["direccion"],
                        segmento_id           = int.Parse(collection["segmento_id"]),
                        GP                    = false,
                        porcentajeParticipacion = (collection["porcentaje_participacion"] != "" ? int.Parse(collection["porcentaje_participacion"]) : 0),
                        porcentajeSalario = (collection["porcentaje_salario"] != "" ? int.Parse(collection["porcentaje_salario"]) : 0)
                    };
                    if (web.AdministracionClient.InsertarParticipante(participante, HttpContext.Session["userName"].ToString()) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + participante.id + " en la tabla PARTICIPANTE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        TempData["Mensaje"] = "exito|" + Mensajes.Exito_Insert;
                    } else {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }         
                return RedirectToAction("Index");
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Editar(int id)
        {
            string userName = HttpContext.Session["userName"].ToString();
            List<int> segmentosusuario = web.AdministracionClient.ListarSegmentodelUsuario().Where(x => x.userName == userName).Select(x => (int)x.segmento_id).ToList();
            Participante participante = web.AdministracionClient.ListarParticipantesPorId(id).ToList()[0];
            var viewModel = new ParticipanteViewModel() {
                ParticipanteView       = participante,
                NivelList              = new SelectList(web.AdministracionClient.ListarNivels().Where(n => n.id > 1).ToList(), "id", "nombre", participante.nivel_id), // Evita crear asesores desde la aplicación ya que estos se cargan desde la integración.
                CompaniaList           = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", participante.compania_id),
                ZonaList               = new SelectList(web.AdministracionClient.ListarZonas().ToList(), "id", "nombre", participante.zona_id),
                LocalidadList          = new SelectList(web.AdministracionClient.ListarLocalidades().ToList(), "id", "nombre", participante.localidad_id),
                CanalList              = new SelectList(web.AdministracionClient.ListarCanals().ToList(), "id", "nombre", participante.canal_id),
                CategoriaList          = new SelectList(web.AdministracionClient.ListarCategorias().ToList(), "id", "nombre", participante.categoria_id),
                TipoDocumentoList      = new SelectList(web.AdministracionClient.ListarTipodocumentoes().ToList(), "id", "nombre", participante.tipoDocumento_id),
                SegmentoList           = new SelectList(web.AdministracionClient.ListarSegmentoes().ToList().Where(x => segmentosusuario.Contains(x.id)), "id", "nombre", participante.segmento_id),
                EstadoParticipanteList = new SelectList(web.AdministracionClient.ListarEstadoparticipantes().ToList(), "id", "nombre", participante.estadoParticipante_id),
                TipoParticipanteList   = new SelectList(web.AdministracionClient.ListarTipoparticipantes().ToList(), "id", "nombre", participante.tipoParticipante_id)
            };
            ViewData["ParticipanteViewModel"] = viewModel;
            ViewBag.participante_id = id;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            try {
                string idCategoria = (collection["categoria_id"] != "" ? collection["categoria_id"] : collection["categoria_id"] = "0");
                string idZona = (collection["zona_id"] != "" ? collection["zona_id"] : collection["zona_id"] = "0");
                string idLocalidad = (collection["localidad_id"] != "" ? collection["localidad_id"] : collection["localidad_id"] = "0");
                string idNivel = (collection["nivel_id"] != "" ? collection["nivel_id"] : collection["nivel_id"] = "0");

                Participante participante = new Participante() {
                    id                    = int.Parse(collection["id"]),
                    nombre                = collection["nombre"],
                    apellidos             = collection["apellidos"],
                    tipoDocumento_id      = int.Parse(collection["tipoDocumento_id"]),
                    documento             = collection["documento"],
                    estadoParticipante_id = int.Parse(collection["estadoParticipante_id"]),
                    fechaIngreso          = collection["fechaIngreso"] != "" ? DateTime.Parse(collection["fechaIngreso"]) : DateTime.Now,
                    fechaRetiro           = collection["fechaRetiro"] != "" ? DateTime.Parse(collection["fechaRetiro"]) : DateTime.Now,
                    fechaNacimiento       = collection["fechaNacimiento"] != "" ? DateTime.Parse(collection["fechaNacimiento"]) : DateTime.Now,
                    compania_id           = int.Parse(collection["compania_id"]),
                    nivel_id              = collection["nivel_id"] != "" ? int.Parse(collection["nivel_id"]) : 0,
                    zona_id               = collection["zona_id"] != "" ? int.Parse(collection["zona_id"]) : 0,
                    localidad_id          = collection["localidad_id"] != "" ? collection["localidad_id"] != null ? int.Parse(collection["localidad_id"]) : 0 : 0,
                    tipoParticipante_id   = 0, //int.Parse(collection["tipoParticipante_id"]),
                    categoria_id          = collection["categoria_id"] != "" ? int.Parse(collection["categoria_id"]) : 0,
                    segmento_id           = int.Parse(collection["segmento_id"]),
                    canal_id              = int.Parse(collection["canal_id"]),
                    clave                 = collection["clave"],
                    codProductor          = collection["codProductor"],
                    email                 = collection["email"],
                    salario               = collection["salario"] != "" ? float.Parse(collection["salario"]) : 0,
                    telefono              = collection["telefono"],
                    direccion             = collection["direccion"],
                    porcentajeParticipacion = (collection["porcentaje_participacion"] != "" ? int.Parse(collection["porcentaje_participacion"]) : 0),
                    porcentajeSalario = (collection["porcentaje_salario"] != "" ? int.Parse(collection["porcentaje_salario"]) : 0)
                };
                if (web.AdministracionClient.ActualizarParticipante(id, participante, HttpContext.Session["userName"].ToString()) != 0)
                {
                    Logging.Auditoria("Creación del registro " + participante.id + " en la tabla PARTICIPANTE.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    TempData["Mensaje"] = "exito|" + Mensajes.Exito_Edit;
                } else {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                }
            }
            catch { }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            ViewData["id"] = id;
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            try {
                string mensaje = "";
                mensaje = web.AdministracionClient.EliminarParticipante(id, null, HttpContext.Session["userName"].ToString());
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; }
                else {
                    Logging.Auditoria("Eliminación del registro " + id + " en la tabla PARTICIPANTE.", Logging.Prioridad.Baja, Modulo.Jerarquia, Sesion.VariablesSesion());
                    TempData["Mensaje"] = "exito|" + Mensajes.Exito_Delete;
                }
            }
            catch { }
            return RedirectToAction("Index");
            
        }
    }
}