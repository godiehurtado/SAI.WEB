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
    public class CondicionController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["value"] != string.Empty || Request.QueryString["valuer"] != string.Empty || Request.QueryString["valuesr"] != string.Empty)
            {
                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];

                ViewData["valuer"] = Request.QueryString["valuer"];
                TempData["valuer"] = Request.QueryString["valuer"];

                ViewData["valuesr"] = Request.QueryString["valuesr"];
                TempData["valuesr"] = Request.QueryString["valuesr"];

            }

            try
            {
                if (int.Parse(ViewData["valuesr"].ToString()) != null && int.Parse(ViewData["valuer"].ToString()) != null && int.Parse(ViewData["value"].ToString()) != null)
                {
                    ViewData["Concursos"] = web.AdministracionClient.ListarConcursoes().Where(e => e.id == int.Parse(ViewData["value"].ToString())).ToList()[0].nombre;
                    ViewData["Reglas"] = web.AdministracionClient.ListarRegla().Where(e => e.id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].nombre;
                    ViewData["subReglas"] = web.AdministracionClient.ListarSubRegla().Where(e => e.id == int.Parse(ViewData["valuesr"].ToString())).ToList()[0].descripcion;
                    ViewData["Condiciones"] = web.AdministracionClient.ListarCondicion().Where(P => P.subregla_id == int.Parse(ViewData["valuesr"].ToString()));
                    if (web.AdministracionClient.RetornarTipoSubRegla(int.Parse(ViewData["valuesr"].ToString())) != 3)
                    {
                        if (web.AdministracionClient.ContarVariablexLiquidacion(int.Parse(ViewData["value"].ToString()), int.Parse(ViewData["valuer"].ToString()), int.Parse(ViewData["valuesr"].ToString())) == 0)
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.MensajeVariablesTipoLiquidacion; View(TempData["Mensaje"]);
                        }
                    }
                    Crear();
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de condicion", ex);
            }
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new CondicionViewModel()
            {
                CondicionView = new Condicion(),
                VariableList = new SelectList(web.AdministracionClient.ListarVariables().ToList(), "id", "nombre"),
                OperadorList = new SelectList(web.AdministracionClient.ListarOperadorLogico().ToList(), "id", "nombre"),
                tablaList = new SelectList(new List<string>())
            };
            ViewData["CondicionViewModel"] = viewModel;
            return View(viewModel);
        }

        public ActionResult Variable()
        {
            if (Request["concurso_idEdit"] != string.Empty && Request["concurso_idEdit"] != null)
                ViewData["concurso_idEdit"] = Request["concurso_idEdit"];
            else
                ViewData["subregla_idEdit"] = 0;

            if (Request["subregla_idEdit"] != string.Empty && Request["subregla_idEdit"] != null)
                ViewData["subregla_idEdit"] = Request["subregla_idEdit"];
            else
                ViewData["subregla_idEdit"] = 0;

            ViewBag.concurso = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(ViewData["concurso_idEdit"]));
            ViewBag.subregla = web.AdministracionClient.RetornarTipoSubRegla(Convert.ToInt16(ViewData["subregla_idEdit"]));

            if (ViewBag.concurso == 1)
            {
                if (ViewBag.subregla == 3)
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 1 || v.tipoConcurso == 3) && v.esFiltro == true);
                }
                else
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 1 || v.tipoConcurso == 3));
                }
            }

            else
            {
                if (ViewBag.subregla == 3)
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 2 || v.tipoConcurso == 3) && v.esFiltro == true);
                }
                else
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 2 || v.tipoConcurso == 3));
                }
            }
            return View(ViewData["Variables"]);
        }

        public ActionResult Variable1()
        {
            if (Request["concurso_id"] != string.Empty && Request["concurso_id"] != null)
                ViewData["concurso_id"] = Request["concurso_id"];
            else
                ViewData["concurso_id"] = 0;

            if (Request["subregla_id"] != string.Empty && Request["subregla_id"] != null)
                ViewData["subregla_id"] = Request["subregla_id"];
            else
                ViewData["subregla_id"] = 0;

            ViewBag.concurso = web.AdministracionClient.RetornarTipoConcurso(Convert.ToInt16(ViewData["concurso_id"]));
            ViewBag.subregla = web.AdministracionClient.RetornarTipoSubRegla(Convert.ToInt16(ViewData["subregla_id"]));

            if (ViewBag.concurso == 1)
            {
                if (ViewBag.subregla == 3)
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 1 || v.tipoConcurso == 3) && v.esFiltro == true);
                }
                else
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 1 || v.tipoConcurso == 3)).OrderBy(x => x.nombre);
                }
            }

            else
            {
                if (ViewBag.subregla == 3)
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 2 || v.tipoConcurso == 3) && v.esFiltro == true);
                }

                else
                {
                    ViewData["Variables"] = web.AdministracionClient.ListarVariables().Where(v => v.id > 0 && (v.tipoConcurso == 2 || v.tipoConcurso == 3));
                }
            }
            return View(ViewData["Variables"]);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int subreglavalue = Convert.ToInt16(TempData["valuesr"]);

            string seleccion = (collection["seleccion"] != null ? collection["seleccion"] : collection["seleccion"] = "");
            string idtabla = (collection["tabla_id"] != null ? collection["tabla_id"] : collection["tabla_id"] = "0");
            string FechaInicio = (collection["FechaInicio"] != "" ? collection["FechaInicio"] : collection["FechaInicio"] = "1900-01-01 00:00:00.000");
            string Valor = (collection["valor"] != "" ? collection["valor"] : collection["valor"] = "0");
            string tipoVariable = web.AdministracionClient.ListarVariablesPorId(int.Parse(collection["variable_id"])).First().tipoDato.ToString();
            string mesinicio = (tipoVariable == "Numero" ? collection["ddlMesInicio"] : "1");
            string mesfin = (tipoVariable == "Numero" ? collection["ddlMesFin"] : "1");

            if (concursovalue == 0 || reglavalue == 0 || subreglavalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    if (ModelState.IsValid)
                    {
                        Condicion condicion = new Condicion()
                        {
                            subregla_id = int.Parse(collection["subregla_id"]),
                            variable_id = int.Parse(collection["variable_id"]),
                            operador_id = int.Parse(collection["operador_id"]),
                            valor = Valor,
                            tabla_id = int.Parse(idtabla),
                            seleccion = seleccion,
                            textoSeleccion = collection["textoSeleccion"].Trim(),
                            fecha = DateTime.Parse(FechaInicio),
                            mesinicio = int.Parse(mesinicio),
                            mesfin = int.Parse(mesfin)
                        };

                        if (web.AdministracionClient.InsertarCondicion(condicion, HttpContext.Session["userName"].ToString()) != 0)
                        {
                            Logging.Auditoria("Creación del registro " + condicion.id + " en la tabla CONDICION.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                        }
                        else
                        {
                            TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                        }
                    }

                    return RedirectToAction("Index", new { valuesr = subreglavalue, valuer = reglavalue, value = concursovalue });
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo crear la condicion", ex);
                }
            }
        }

        public ActionResult Editar(int id)
        {
            Condicion condicion = web.AdministracionClient.ListarCondicionPorId(id).ToList()[0];
            TempData["VariableNombre"] = condicion.Variable.nombre;
            TempData["TipoVariable"] = condicion.Variable.tipoDato;
            TempData["valor"] = condicion.valor;
            TempData["fecha"] = condicion.fecha;
            TempData["seleccionado"] = condicion.seleccion;
            TempData["idVariable"] = condicion.variable_id;
            TempData["mesinicio"] = condicion.mesinicio;
            TempData["mesfin"] = condicion.mesfin;
            ViewData["valuesr"] = Request["subregla_id"];
            ViewData["value"] = Request["concurso_id"];
            var viewModel = new CondicionViewModel()
            {
                CondicionView = new Condicion(),
                OperadorList = new SelectList(web.AdministracionClient.ListarOperadorLogico().ToList(), "id", "nombre", condicion.operador_id),
                tablaList = new SelectList(new List<string>())
            };
            ViewData["CondicionViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int subreglavalue = Convert.ToInt16(TempData["valuesr"]);
            Condicion condicion1 = web.AdministracionClient.ListarCondicionPorId(id).ToList()[0];
            int idvariableEdit = (int)condicion1.variable_id;
            string userName = HttpContext.Session["userName"].ToString();
            string idtabla = (collection["tabla_id"] != null ? collection["tabla_id"] : collection["tabla_id"] = "0");
            string idVariable = (collection["variable_id_Edit"] != "0" ? collection["variable_id_Edit"] : collection["variable_id_Edit"] = idvariableEdit.ToString());




            if (web.AdministracionClient.RetornarTipoDato(int.Parse(idVariable)) == "Seleccion")
            {
                collection["valor_Edit"] = "";
                collection["FechaInicio_Edit"] = "";
                collection["ddlMesInicio_Edit"] = "";
                collection["ddlMesFin_Edit"] = "";
            }

            else if (web.AdministracionClient.RetornarTipoDato(int.Parse(idVariable)) == "Numero")
            {
                collection["seleccion_Edit"] = null;
                collection["FechaInicio_Edit"] = "";
            }

            else if (web.AdministracionClient.RetornarTipoDato(int.Parse(idVariable)) == "Fecha")
            {
                collection["seleccion_Edit"] = null;
                collection["valor_Edit"] = "";
                collection["ddlMesInicio_Edit"] = "";
                collection["ddlMesFin_Edit"] = "";
            }

            string seleccion = (collection["seleccion_Edit"] != null ? collection["seleccion_Edit"] : collection["seleccion_Edit"] = "0");
            string FechaInicio = (collection["FechaInicio_Edit"] != "" ? collection["FechaInicio_Edit"] : collection["FechaInicio_Edit"] = "1900-01-01 00:00:00.000");
            string Valor = (collection["valor_Edit"] != "" ? collection["valor_Edit"] : collection["valor_Edit"] = "0");
            string mesinicio = collection["ddlMesInicio_Edit"];
            string mesfin = collection["ddlMesFin_Edit"];

            if (concursovalue == 0 || reglavalue == 0 || subreglavalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    Condicion condicion = new Condicion()
                    {
                        subregla_id = subreglavalue,
                        variable_id = int.Parse(idVariable),
                        operador_id = int.Parse(collection["operador_id_Edit"]),
                        valor = Valor,
                        tabla_id = int.Parse(idtabla),
                        seleccion = seleccion,
                        textoSeleccion = collection["textoSeleccion_Edit"].Trim(),
                        fecha = DateTime.Parse(FechaInicio),
                        mesinicio = int.Parse(mesinicio),
                        mesfin = int.Parse(mesfin)
                    };
                    web.AdministracionClient.ActualizarCondicion(id, condicion, userName);
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo editar la condición con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuesr = subreglavalue, valuer = reglavalue, value = concursovalue });
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
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            int subreglavalue = Convert.ToInt16(TempData["valuesr"]);
            string userName = HttpContext.Session["userName"].ToString();
            if (concursovalue == 0 || reglavalue == 0 || subreglavalue == 0)
            {
                return RedirectToAction("Index", "Concursos");
            }

            else
            {
                try
                {
                    string mensaje = "";
                    mensaje = web.AdministracionClient.EliminarCondicion(id, null, userName);
                    if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                    else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla CONDICION.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
                }
                catch (Exception ex)
                {
                    throw new Exception("No se pudo eliminar la condición con id = " + id, ex);
                }
                return RedirectToAction("Index", new { valuesr = subreglavalue, valuer = reglavalue, value = concursovalue });
            }
        }

        public ActionResult ListarTablas(int idtabla)
        {
            return Json(web.AdministracionClient.ListarTablas(idtabla), 0);
        }

        public ActionResult ListarTipoDato(int idtabla)
        {
            return Json(web.AdministracionClient.ListarVariablesPorId(idtabla).First().tipoDato.ToString(), 0);
        }
    }
}


