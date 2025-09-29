//using System;
//using System.Collections.Generic;
using System.Linq;
//using System.Web;
using System.Web.Mvc;
//using System.Web.Mvc.Ajax;
using System.Web.Routing;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ProductoController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewBag.Productos = web.AdministracionClient.ListarProductoes();
            ViewBag.Ramos = new SelectList(web.AdministracionClient.ListarRamos().ToList(), "id", "nombre");
            ViewBag.Amparos = new SelectList(web.AdministracionClient.ListarAmparoes().ToList(), "id", "nombre");
            ViewBag.Coberturas = new SelectList(web.AdministracionClient.ListarCoberturas().ToList(), "id", "nombre");
            ViewBag.Plazos = new SelectList(web.AdministracionClient.ListarPlazoes().ToList(), "id", "nombre");
            return View();
        }

        [HttpPost]
        public ActionResult Crear(FormCollection collect)
        {
            Producto producto = new Producto();
            try {
                UpdateModel<Producto>(producto, collect);
                string userName = HttpContext.Session["userName"].ToString();
                if (producto.plazo_id == null)
                {
                    producto.plazo_id = 0;
                }
                producto.id = web.AdministracionClient.InsertarProducto(producto, userName);
                if (producto.id != 0) {
                    Logging.Auditoria("Creación/Actualización del registro " + producto.id + " en la tabla PRODUCTO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    return RedirectToAction("Detalle", "Producto", new { id = producto.id });
                } else {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                }
            }
            catch { }
            return RedirectToAction("Index", "Producto");
        }

        [HttpPost]
        public ActionResult Eliminar(int id)
        {
            string mensaje = "";
            string userName = HttpContext.Session["userName"].ToString();
            mensaje = web.AdministracionClient.EliminarProducto(id,userName);
            if (mensaje == "") {
                Logging.Auditoria("Eliminación del registro " + id + " en la tabla PRODUCTO.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                TempData["Mensaje"] = "exito|" + Mensajes.Exito_Delete;
                return Json("");
            } else {
                TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]);
                return Json(mensaje);
            }
        }

        public ActionResult Detalle(int id)
        {
            ViewBag.ProductosDetalle = web.AdministracionClient.ListarProductoDetalles(id).ToList();
            ViewBag.producto_id = id;
            if (id != 0) ViewBag.ProductoAgrupado = web.AdministracionClient.ListarProductoesPorId(id).First().nombre;
            return View();
        }

        [HttpPost]
        public ActionResult Agrupar(int producto_id, string productosTrue, string productosFalse)
        {
            int resultado = web.AdministracionClient.AgruparProductoDetalle(producto_id, productosTrue, productosFalse);
            return RedirectToAction("Index");
        }
    }
}
