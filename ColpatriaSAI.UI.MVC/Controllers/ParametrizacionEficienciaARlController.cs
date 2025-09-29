using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.Negocio.Componentes.Utilidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Globalization;
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ParametrizacionEficienciaARLController : ControladorBase
    {
        WebPage web = new WebPage();

        //
        // GET: /ParametrizacionEficienciaARL/
        //public ActionResult Index()
        //{
        //    ViewData["ParametrizacionEficienciaARL"] = web.AdministracionClient.ListarParametrizacionEficienciaARL();
        //    ViewData["ParametrosApp"] = web.AdministracionClient.ListarParametrosAppPorId(34);
        //    return View(ViewData["ParametrizacionEficienciaARL"]);
        //}

        ///// <summary>
        ///// Funcion que se encarga de guardar los datos
        ///// </summary>
        ///// <param name="collection">Coleccion de Datos</param>
        ///// <returns></returns>
        //[HttpPost]
        //public ActionResult Crear(FormCollection collection)
        //{
        //    ParametrosEficienciaARL parametros = new ParametrosEficienciaARL()
        //    {
        //        nombreEtapa = collection["NombreEtapa"],
        //        mesInicial = Convert.ToInt16(collection["FechaInicio"]),
        //        mesFinal = Convert.ToInt16(collection["FechaFin"]),
        //        año = Convert.ToInt16(collection["Anio"])
        //    };

        //    Result.result result = new Result.result();
        //    result = web.AdministracionClient.InsertParametrizacionEficienciaARL(parametros, (string)Session["username"]);
        //    if (result.resultado == Result.tipoResultado.resultOK)
        //        return Json(new { Success = true, string.Empty });
        //    else
        //        return Json(new { Success = true, result.message });
        //}

        ///// <summary>
        ///// Funcion que se encarga de editar los registros
        ///// </summary>
        ///// <param name="id">Identificador de dato a editar</param>
        ///// <param name="collection">Coleccion de datos</param>
        ///// <returns></returns>
        //[HttpPost]
        //public ActionResult Editar(int id, FormCollection collection)
        //{
        //    Result.result result = new Result.result();
        //    ParametrosEficienciaARL parametros = new ParametrosEficienciaARL()
        //    {
        //        nombreEtapa = collection["NombreEtapa"],
        //        mesInicial = Convert.ToInt16(collection["FechaInicio"]),
        //        mesFinal = Convert.ToInt16(collection["FechaFin"]),
        //        año = Convert.ToInt16(collection["Anio"])
        //    };

        //    result = web.AdministracionClient.UpdateParametrizacionEficienciaARL(id, parametros);
        //    //if (result.resultado == Result.tipoResultado.resultOK)
        //    //    return RedirectToAction("Index");
        //    //else
        //    return RedirectToAction("Index");
        //}

        ///// <summary>
        ///// Funcion que se encarga de abrir el popup para la edicion
        ///// </summary>
        ///// <param name="id">Id del registro a editar</param>
        ///// <returns></returns>
        //public ActionResult Editar(int id)
        //{
        //    ParametrosEficienciaARL parametrizacion = new ParametrosEficienciaARL();
        //    parametrizacion = web.AdministracionClient.ListarParametrizacionEficienciaARLByID(id);
        //    var viewModel = new ParametrizacionEficienciaARLViewModel()
        //    {
        //        ParametrizacionEficienciaARLView = parametrizacion
        //    };

        //    ViewData["ParametrizacionEficienciaARLViewModel"] = viewModel;
        //    return View(viewModel);
        //}

        ///// <summary>
        ///// Funcion que se encarga de eliminar el registro seleccionado
        ///// </summary>
        ///// <param name="id">Identificador del id a borrar</param>
        ///// <param name="collection">Coleccion de datos a  borrar</param>
        ///// <returns></returns>
        //[HttpPost]
        //public ActionResult Eliminar(int id, FormCollection collection)
        //{
        //    Result.result result = new Result.result();
        //    result = web.AdministracionClient.DeleteParametrizacionEficienciaARL(id, null);
        //    //if (result.resultado == Result.tipoResultado.resultOK)
        //    //    return Json(new { Success = true, string.Empty });
        //    //else
        //    //    return Json(new { Success = true, result.message });
        //    return RedirectToAction("Index");
        //}

        //public ActionResult Eliminar(int id)
        //{
        //    ViewData["id"] = id;
        //    return View(id);
        //}

        ///// <summary>
        ///// Funcion q se encarga de actualizar la parametrizacion para del porcentaje 
        ///// </summary>
        ///// <param name="collection">Collecion de datos</param>
        ///// <returns></returns>
        //[HttpPost]
        //public ActionResult Update(FormCollection collection)
        //{
        //    string message = "No se pudo editar la informacion de parametrosapp";
        //    List<ParametrosApp> parametro = new List<ParametrosApp>();
        //    string valorPorcentaje = collection["porcentaje"].Replace(',', '.').ToString();

        //    ParametrosApp porcentaje = new ParametrosApp()
        //    {
        //        id = 34,
        //        valor = valorPorcentaje,
        //    };
        //    parametro.Add(porcentaje);

        //    int result = web.AdministracionClient.ActualizarParametrosApp(parametro);
        //    if (result > 0)
        //        return Json(new { Success = true, string.Empty });
        //    else
        //        return Json(new { Success = true, message });
        //}
    }
}
