using System.Linq;
using System.Web.Mvc;
using System.Web.Routing;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class PlanController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            ViewData["Planes"] = web.AdministracionClient.ListarPlans();
            Crear();
            return View(new Plan());
        }

        public ActionResult Details(int id)
        {
            return View();
        }

        public ActionResult Crear()
        {
            var viewModel = new PlanViewModel() {
                PlanView = new Plan(),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductoes(), "id", "nombre"),
                AmparoList = new SelectList(web.AdministracionClient.ListarAmparoes(), "id", "nombre"),
                CoberturaList = new SelectList(web.AdministracionClient.ListarCoberturas(), "id", "nombre"),
                PlazoList = new SelectList(web.AdministracionClient.ListarPlazoes(), "id", "nombre"),
                ModalidadPagoList = new SelectList(web.AdministracionClient.ListarModalidadPagoes(), "id", "nombre"),
            };
            ViewData["PlanViewModel"] = viewModel;
            return View(viewModel);
        }

        [HttpPost]
        public ActionResult Crear(Plan plan)
        {
            //Plan plan = new Plan();
            try {
                string userName = HttpContext.Session["userName"].ToString();
                //UpdateModel<Producto>(producto, collect);
                plan.id = web.AdministracionClient.InsertarPlan(plan, userName);
                if (plan.id != 0){
                    Logging.Auditoria("Creación/Actualización del registro " + plan.id + " en la tabla PLAN.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                    return RedirectToAction("Detalle", "Plan", new { id = plan.id });
                } else {
                    TempData["Mensaje"] = "error|" + Mensajes.Error_Insert_Duplicado; View(TempData["Mensaje"]);
                }
            }
            catch { }
            return RedirectToAction("Index", "Plan");
        }

        [HttpPost]
        public ActionResult Eliminar(int id)
        {
            string mensaje = "";
            string userName = HttpContext.Session["userName"].ToString();
            mensaje = web.AdministracionClient.EliminarPlan(id, userName);
            if (mensaje == "") {
                Logging.Auditoria("Eliminación del registro " + id + " en la tabla PLAN.", Logging.Prioridad.Baja, Modulo.General, Sesion.VariablesSesion());
                TempData["Mensaje"] = "exito|" + Mensajes.Exito_Delete;
                return Json("");
            } else {
                TempData["Mensaje"] = "error|" + Mensajes.Error_Delete_Asociado; View(TempData["Mensaje"]);
                return Json(mensaje);
            }
        }

        public ActionResult Detalle(int id)
        {
            ViewBag.PlanDetalle = web.AdministracionClient.ListarPlanDetalles(id).ToList();
            ViewBag.plan_id = id;
            if (id != 0) ViewBag.PlanAgrupado = web.AdministracionClient.ListarPlansPorId(id).First().nombre;
            return View();
        }

        [HttpPost]
        public ActionResult Agrupar(int plan_id, string planesTrue, string planesFalse)
        {
            int resultado = web.AdministracionClient.AgruparPlanDetalle(plan_id, planesTrue, planesFalse);
            return RedirectToAction("Index");
        }
    }
}
