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
    public class CondicionAgrupadaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["valuer"] != string.Empty)
            {
                ViewData["valuer"] = Request.QueryString["valuer"];
                TempData["valuerEdit"] = Request.QueryString["valuer"];
                TempData["valuerEdit1"] = Request.QueryString["valuer"];
                TempData["valuer2"] = Request.QueryString["valuer"];

                ViewData["value"] = Request.QueryString["value"];
                TempData["value"] = Request.QueryString["value"];
            }

            try
            {
                ViewData["Reglas"] = web.AdministracionClient.ListarRegla().Where(e => e.id == int.Parse(ViewData["valuer"].ToString())).ToList()[0].nombre;
                ViewData["CondicionesAgrupadas"] = web.AdministracionClient.ListarCondicionAgrupada().Where(C => C.regla_id == int.Parse(ViewData["valuer"].ToString()));
                Crear();
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo cargar la pagina de condicion agrupada", ex);
            }
            return View();
        }

        public ActionResult SubRegla()
        {
            if (Request["regla_id"] != string.Empty && Request["regla_id"] != null)
                ViewData["regla_id"] = Request["regla_id"];
            else
                ViewData["regla_id"] = 0;

            ViewData["SubReglas"] = web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == Convert.ToInt16(ViewData["regla_id"]) && sr.tipoSubregla != 3);
            return View(ViewData["SubReglas"]);
        }

        public ActionResult SubRegla1()
        {
            if (Request["regla_id"] != string.Empty && Request["regla_id"] != null)
                ViewData["regla_id"] = Request["regla_id"];
            else
                ViewData["regla_id"] = 0;

            ViewData["SubReglas"] = web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == Convert.ToInt16(ViewData["regla_id"]) && sr.tipoSubregla != 3);
            return View(ViewData["SubReglas"]);
        }

        public ActionResult SubReglaEdit()
        {
            if (Request["regla_id_Edit"] != string.Empty && Request["regla_id_Edit"] != null)
                ViewData["regla_id_Edit"] = Request["regla_id_Edit"];
            else
                ViewData["regla_id_Edit"] = 0;

            ViewData["SubReglas"] = web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == Convert.ToInt16(ViewData["regla_id_Edit"]) && sr.tipoSubregla != 3);
            return View(ViewData["SubReglas"]);
        }

        public ActionResult SubReglaEdit1()
        {
            if (Request["regla_id_Edit"] != string.Empty && Request["regla_id_Edit"] != null)
                ViewData["regla_id_Edit"] = Request["regla_id_Edit"];
            else
                ViewData["regla_id_Edit"] = 0;

            ViewData["SubReglas"] = web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == Convert.ToInt16(ViewData["regla_id_Edit"]) && sr.tipoSubregla != 3);
            return View(ViewData["SubReglas"]);
        }

        public ActionResult Crear()
        {
            var viewModel = new CondicionAgrupadaViewModel()
            {
                CondicionAgrupadaView = new CondicionAgrupada(),
                OperadorList = new SelectList(web.AdministracionClient.ListarOperadorAgrupado().ToList(), "id", "nombre"),
                SubRegla1List = new SelectList(web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == int.Parse(ViewData["valuer"].ToString())), "id", "descripcion"),
                SubRegla2List = new SelectList(web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == int.Parse(ViewData["valuer"].ToString())), "id", "descripcion")
            };

            ViewData["CondicionAgrupadaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            int idRegla = 0;
            string nombreAgrupacion = "";
            bool principalsubRegla = false;
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int idCondicionAgrupada = 0;
            string userName = HttpContext.Session["userName"].ToString();

            try
            {
                if (ModelState.IsValid && Request.QueryString["id"] != string.Empty)
                {
                    CondicionAgrupada condicionagrupada = new CondicionAgrupada()
                    {
                        subregla_id1 = int.Parse(collection["subregla_id1"]),
                        subregla_id2 = int.Parse(collection["subregla_id2"]),
                        operador_id = int.Parse(collection["operador_id"]),
                        regla_id = int.Parse(collection["regla_id"]),
                        nombre = collection["nombre"]
                    };
                    idCondicionAgrupada = web.AdministracionClient.InsertarCondicionAgrupada(condicionagrupada, userName);
                    idRegla = int.Parse(collection["regla_id"]);
                    nombreAgrupacion = collection["nombre"];

                    if (idCondicionAgrupada != 0)
                    {
                        Logging.Auditoria("Creación del registro " + condicionagrupada.id + " en la tabla CONDICIONAGRUPADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.SubReglaAgrupada; View(TempData["Mensaje"]);
                    }
                }

                if (idCondicionAgrupada != 0)
                {
                    SubRegla subregla = new SubRegla()
                       {
                           regla_id = idRegla,
                           descripcion = nombreAgrupacion,
                           principal = principalsubRegla,
                           tipoSubregla = 2,
                           condicionAgrupada_id = idCondicionAgrupada
                       };
                    web.AdministracionClient.InsertarSubRegla(subregla, userName);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear la condicion agrupada", ex);
            }
            return RedirectToAction("Index", new { valuer = idRegla, value = concursovalue });
        }

        public ActionResult Editar(int id, int idr)
        {
            CondicionAgrupada condicionagrupada = web.AdministracionClient.ListarCondicionAgrupadaPorId(id).ToList()[0];
            TempData["SubReglaNombre"] = condicionagrupada.SubRegla.descripcion;
            TempData["SubRegla1Nombre"] = condicionagrupada.SubRegla1.descripcion;
            ViewData["valuer"] = condicionagrupada.regla_id;
            var viewModel = new CondicionAgrupadaViewModel()
            {
                CondicionAgrupadaView = condicionagrupada,
                OperadorList = new SelectList(web.AdministracionClient.ListarOperadorAgrupado().ToList(), "id", "nombre", condicionagrupada.operador_id),
                SubRegla1List = new SelectList(web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == idr), "id", "descripcion", condicionagrupada.subregla_id1),
                SubRegla2List = new SelectList(web.AdministracionClient.ListarSubRegla().Where(sr => sr.regla_id == idr), "id", "descripcion", condicionagrupada.subregla_id2)
            };
            ViewData["CondicionAgrupadaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int reglavalue = Convert.ToInt16(TempData["valuer2"]);
            string userName = HttpContext.Session["userName"].ToString();
            CondicionAgrupada condicionagrupada1 = web.AdministracionClient.ListarCondicionAgrupadaPorId(id).ToList()[0];
            int idsubregla_id_Edit = (int)condicionagrupada1.subregla_id1;
            int idsubregla_id_Edit1 = (int)condicionagrupada1.subregla_id2;

            string idSubReglaEdit1 = (collection["subregla_id_Edit"] != "0" ? collection["subregla_id_Edit"] : collection["subregla_id_Edit"] = idsubregla_id_Edit.ToString());
            string idSubReglaEdit2 = (collection["subregla_id_Edit1"] != "0" ? collection["subregla_id_Edit1"] : collection["subregla_id_Edit1"] = idsubregla_id_Edit1.ToString());

            try
            {
                CondicionAgrupada condicionagrupada = new CondicionAgrupada()
                {
                    nombre = collection[3],
                    subregla_id1 = int.Parse(collection["subregla_id_Edit"]),
                    subregla_id2 = int.Parse(collection["subregla_id_Edit1"]),
                    operador_id = int.Parse(collection["operador_id"]),
                    regla_id = reglavalue
                };
                int idCondicionAgrupada = web.AdministracionClient.ActualizarCondicionAgrupada(id, condicionagrupada, userName);

                if (idCondicionAgrupada != 0)
                {
                    Logging.Auditoria("Actualización del registro " + condicionagrupada.id + " en la tabla CONDICIONAGRUPADA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                }
                else
                {
                    TempData["Mensaje"] = "error|" + Mensajes.SubReglaAgrupada; View(TempData["Mensaje"]);
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar la condición agrupada con id = " + id, ex);
            }
            return RedirectToAction("Index", new { valuer = reglavalue, value = concursovalue });
        }

        public ActionResult Eliminar(int id)
        {
            return View();
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            int concursovalue = Convert.ToInt16(TempData["value"]);
            int reglavalue = Convert.ToInt16(TempData["valuer"]);
            string userName = HttpContext.Session["userName"].ToString();
            string mensaje = "";
            try
            {
                mensaje = web.AdministracionClient.EliminarCondicionAgrupada(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla CONDICIONAGRUPADA.", Logging.Prioridad.Baja, Modulo.Concursos, Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar la condición agrupada con id = " + id, ex);
            }
            return RedirectToAction("Index", new { valuer = reglavalue, value = concursovalue });
        }
    }
}
