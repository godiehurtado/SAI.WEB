using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using Entidades = ColpatriaSAI.Negocio.Entidades;
using Componentes = ColpatriaSAI.Negocio.Componentes;
namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class CalculoUsuariosController : ColpatriaSAI.UI.MVC.Controllers.ControladorBase
    {
        private CalculosTalentosComision.CalculosClient _svcModelClient;
        private ModeloComisionSVC.ModeloComisionClient _svcModelos;

        #region Calculos Talentos
        [Authorize]
        public ActionResult CalculosTalentos()
        {
            _svcModelos = new ModeloComisionSVC.ModeloComisionClient();
            DetalleCalculosNetosViewModel vmmodel = new DetalleCalculosNetosViewModel();

            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "1", Text = "Enero" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "2", Text = "Febrero" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "3", Text = "Marzo" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "4", Text = "Abril" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "5", Text = "Mayo" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "6", Text = "Junio" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "7", Text = "Julio" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "8", Text = "Agosto" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "9", Text = "Septiembre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "10", Text = "Octubre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "11", Text = "Noviembre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "12", Text = "Diciembre" });
            vmmodel.MesesAnio.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            vmmodel.ModelosComision.AddRange(_svcModelos.ListarModeloComisionVigentes().Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.ModelosComision.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección", Selected = true });

            for (int i = 2012; i <= DateTime.Now.Year; i++)
            {
                vmmodel.Anios.Add(new SelectListItem() { Value = i.ToString(), Text = i.ToString() });
            }
            vmmodel.Anios.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            vmmodel.vmodelpartial = new List<ResultadosCalculosViewModel>();

            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult CalculosTalentos(DetalleCalculosNetosViewModel model)
        {


            _svcModelClient = new CalculosTalentosComision.CalculosClient();
            _svcModelos = new ModeloComisionSVC.ModeloComisionClient();

            model.MesesAnio.Add(new SelectListItem() { Value = "1", Text = "Enero" });
            model.MesesAnio.Add(new SelectListItem() { Value = "2", Text = "Febrero" });
            model.MesesAnio.Add(new SelectListItem() { Value = "3", Text = "Marzo" });
            model.MesesAnio.Add(new SelectListItem() { Value = "4", Text = "Abril" });
            model.MesesAnio.Add(new SelectListItem() { Value = "5", Text = "Mayo" });
            model.MesesAnio.Add(new SelectListItem() { Value = "6", Text = "Junio" });
            model.MesesAnio.Add(new SelectListItem() { Value = "7", Text = "Julio" });
            model.MesesAnio.Add(new SelectListItem() { Value = "8", Text = "Agosto" });
            model.MesesAnio.Add(new SelectListItem() { Value = "9", Text = "Septiembre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "10", Text = "Octubre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "11", Text = "Noviembre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "12", Text = "Diciembre" });
            model.MesesAnio.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            foreach (SelectListItem item in model.MesesAnio)
            {
                item.Selected = (item.Value.Equals(model.Mes.ToString()));
            }

            for (int i = 2012; i <= DateTime.Now.Year; i++)
            {
                model.Anios.Add(new SelectListItem() { Value = i.ToString(), Text = i.ToString(), Selected = (i == model.Anio) });
            }
            model.Anios.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            model.ModelosComision.AddRange(_svcModelos.ListarModeloComisionVigentes().Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == model.IdModelo) }));
            model.ModelosComision.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });


            model.vmodelpartial = new List<ResultadosCalculosViewModel>();
            if (ModelState.IsValid)
            {


                if (model.IdModelo >= 0 && model.Mes >= 0 && model.Anio >= 0 && model.Asesor.HasValue)
                {
                    string username = string.Empty;
                    if (HttpContext.Session["userName"] != null)
                        username = HttpContext.Session["userName"].ToString();

                    List<Componentes.Comision.Calculos.ResultadosCalculos> result = _svcModelClient.CalculoTalentos(model.Anio.Value, model.Mes.Value, model.IdModelo.Value, model.Asesor.Value, username).ToList();
                    model.vmodelpartial.AddRange(result.Select(x => new ResultadosCalculosViewModel() { CombinacionQuery = x.CombinacionQuery, resultados = x.resultados, Combinaciones = x.Combinaciones }));
                } 
            }
            return View(model);
        }

        #endregion

        #region Calculos Netos
        [Authorize]
        public ActionResult CalculosNetos()
        {
            _svcModelos = new ModeloComisionSVC.ModeloComisionClient();
            DetalleCalculosNetosViewModel vmmodel = new DetalleCalculosNetosViewModel();

            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "1", Text = "Enero" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "2", Text = "Febrero" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "3", Text = "Marzo" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "4", Text = "Abril" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "5", Text = "Mayo" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "6", Text = "Junio" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "7", Text = "Julio" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "8", Text = "Agosto" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "9", Text = "Septiembre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "10", Text = "Octubre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "11", Text = "Noviembre" });
            vmmodel.MesesAnio.Add(new SelectListItem() { Value = "12", Text = "Diciembre" });
            vmmodel.MesesAnio.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            vmmodel.ModelosComision.AddRange(_svcModelos.ListarModeloComisionVigentes().Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre }));
            vmmodel.ModelosComision.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección", Selected = true });

            for (int i = 2012; i <= DateTime.Now.Year; i++)
            {
                vmmodel.Anios.Add(new SelectListItem() { Value = i.ToString(), Text = i.ToString() });
            }
            vmmodel.Anios.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            vmmodel.vmodelpartial = new List<ResultadosCalculosViewModel>();

            return View(vmmodel);
        }

        [HttpPost, Authorize]
        public ActionResult CalculosNetos(DetalleCalculosNetosViewModel model)
        {
            _svcModelClient = new CalculosTalentosComision.CalculosClient();
            _svcModelos = new ModeloComisionSVC.ModeloComisionClient();

            model.MesesAnio.Add(new SelectListItem() { Value = "1", Text = "Enero" });
            model.MesesAnio.Add(new SelectListItem() { Value = "2", Text = "Febrero" });
            model.MesesAnio.Add(new SelectListItem() { Value = "3", Text = "Marzo" });
            model.MesesAnio.Add(new SelectListItem() { Value = "4", Text = "Abril" });
            model.MesesAnio.Add(new SelectListItem() { Value = "5", Text = "Mayo" });
            model.MesesAnio.Add(new SelectListItem() { Value = "6", Text = "Junio" });
            model.MesesAnio.Add(new SelectListItem() { Value = "7", Text = "Julio" });
            model.MesesAnio.Add(new SelectListItem() { Value = "8", Text = "Agosto" });
            model.MesesAnio.Add(new SelectListItem() { Value = "9", Text = "Septiembre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "10", Text = "Octubre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "11", Text = "Noviembre" });
            model.MesesAnio.Add(new SelectListItem() { Value = "12", Text = "Diciembre" });
            model.MesesAnio.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });


            foreach (SelectListItem item in model.MesesAnio)
            {
                item.Selected = (item.Value.Equals(model.Mes.ToString()));
            }

            for (int i = 2012; i <= DateTime.Now.Year; i++)
            {
                model.Anios.Add(new SelectListItem() { Value = i.ToString(), Text = i.ToString(), Selected = (i == model.Anio) });
            }
            model.Anios.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });

            model.ModelosComision.AddRange(_svcModelos.ListarModeloComisionVigentes().Select(x => new SelectListItem() { Value = x.id.ToString(), Text = x.nombre, Selected = (x.id == model.IdModelo) }));
            model.ModelosComision.Insert(0, new SelectListItem() { Value = "", Text = "Sin Selección" });


            model.vmodelpartial = new List<ResultadosCalculosViewModel>();

            if (ModelState.IsValid)
            {

                if (model.IdModelo.HasValue && model.Mes.HasValue && model.Anio.HasValue && model.Asesor.HasValue)
                {
                    string username = string.Empty;
                    if (HttpContext.Session["userName"] != null)
                        username = HttpContext.Session["userName"].ToString();
                    List<Componentes.Comision.Calculos.ResultadosCalculos> result = _svcModelClient.CalculosNetos(model.Anio.Value, model.Mes.Value, model.IdModelo.Value, model.Asesor.Value, username).ToList();
                    model.vmodelpartial.AddRange(result.Select(x => new ResultadosCalculosViewModel() { CombinacionQuery = x.CombinacionQuery, resultados = x.resultados, Combinaciones = x.Combinaciones }));
                }
            }

            return View(model);
        }

        #endregion
    }
}
