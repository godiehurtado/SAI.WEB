using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class CategoriaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Categorias"] = web.AdministracionClient.ListarCategorias();
            Crear();
            return View(ViewData["Categorias"]);
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new CategoriaViewModel()
            {
                CategoriaView = new Categoria(),
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().ToList(), "id", "nombre")
            };
            ViewData["CategoriaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collection)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    Categoria categoria = new Categoria()
                    {
                        nombre = collection[0],
                        nivel_id = Convert.ToInt16(collection[1]),
                        principal = Convert.ToInt16(collection[2])
                    };
                    string userName = HttpContext.Session["userName"].ToString();
                    if (web.AdministracionClient.InsertarCategoria(categoria, userName) != 0)
                    {
                        Logging.Auditoria("Creación del registro " + categoria.nombre + " en la tabla CATEGORIA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    }
                    else
                    {
                        TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo crear la categoria", ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Editar(int id)
        {
            Categoria categoria = web.AdministracionClient.ListarCategoriasPorId(id).ToList()[0];
            var viewModel = new CategoriaViewModel()
            {
                CategoriaView = categoria,
                NivelList = new SelectList(web.AdministracionClient.ListarNivels().ToList(), "id", "nombre", categoria.nivel_id),
            };
            ViewData["CategoriaViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Editar(int id, FormCollection collection)
        {
            int mensaje = 0;
            try
            {
                Categoria categoria = new Categoria()
                {
                    nombre = collection[0].Trim()/*,
                    nivel_id = Convert.ToInt16(collection[1]),
                    principal = Convert.ToInt16(collection[2])*/
                }; string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.ActualizarCategoria(id, categoria, userName);

                if (mensaje == 0)
                {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Update_Duplicado; View(TempData["Mensaje"]);
                }
                else
                {
                    Logging.Auditoria("Actualización del registro " + id + " en la tabla CATEGORIA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo editar la categoria con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }

        public ActionResult Eliminar(int id)
        {
            return View(id);
        }

        [HttpPost]
        public ActionResult Eliminar(int id, FormCollection collection)
        {
            string mensaje = "";
            try
            {
                string userName = HttpContext.Session["userName"].ToString();
                mensaje = web.AdministracionClient.EliminarCategoria(id, null, userName);
                if (mensaje != "") { TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]); }
                else { Logging.Auditoria("Eliminación del registro " + id + " en la tabla CATEGORIA.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion()); }
            }
            catch (Exception ex)
            {
                throw new Exception("No se pudo eliminar la categoria con id = " + id, ex);
            }
            return RedirectToAction("Index");
        }
    }
}


