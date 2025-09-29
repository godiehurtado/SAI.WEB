using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.Datos;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{


    public class DetallePartFranquiciaController : ControladorBase
    {
        WebPage web = new WebPage();

        //
        // GET: /DetallePartFranquicia/Edit/5
        [HttpPost]
        public ActionResult Edit()
        {
            int id = Convert.ToInt32(Request["idDetPartFranq"]);
            DetallePartFranquicia detallepartfranquicia = web.AdministracionClient.ListDetalleFranquiciaPorId(id).ToList()[0];// db.DetallePartFranquicias.Single(d => d.id == id);
            string porcentaje = Request["Porcentaje"].Replace(".", ","); // Convertir el punto en coma para guardar en BD - GLOBALIZATION ES

            detallepartfranquicia.compania_id = Convert.ToInt32(Request["compania_id"]);
            detallepartfranquicia.ramo_id = Convert.ToInt32(Request["ramo_id"]);

            if (Request["producto_id"] != null && Request["producto_id"] != "")
                detallepartfranquicia.producto_id = Convert.ToInt32(Request["producto_id"]);
            else
                detallepartfranquicia.producto_id = 0;

            if (Request["planes_id"] != null && Request["planes_id"] != "")
                detallepartfranquicia.plan_id = Convert.ToInt32(Request["planes_id"]);

            if (Request["lineaNegocio_id"] != null && Request["lineaNegocio_id"] != "")
                detallepartfranquicia.lineaNegocio_id = Convert.ToInt32(Request["lineaNegocio_id"]);
            else
                detallepartfranquicia.lineaNegocio_id = 0;

            if (Request["TipoVehiculo"] != null && Request["TipoVehiculo"] != "")
                detallepartfranquicia.tipoVehiculo_id = Convert.ToInt32(Request["TipoVehiculo"]);
            else
                detallepartfranquicia.tipoVehiculo_id = 0;

            if (Request["Amparo_id"] != null && Request["Amparo_id"] != "")
                detallepartfranquicia.amparo_id = Convert.ToInt32(Request["Amparo_id"]);
            else
                detallepartfranquicia.amparo_id = 0;

            if (Request["Porcentaje"] != null && Request["Porcentaje"] != "")
                detallepartfranquicia.porcentaje = Convert.ToDouble(porcentaje);

            if (Request["Rangoinferior"] != null && Request["Rangoinferior"] != "")
                detallepartfranquicia.rangoinferior = Convert.ToDouble(Request["Rangoinferior"]);
            else
                detallepartfranquicia.rangoinferior = null;

            if (Request["Rangosuperior"] != null && Request["Rangosuperior"] != "")
                detallepartfranquicia.rangosuperior = Convert.ToDouble(Request["Rangosuperior"]);
            else
                detallepartfranquicia.rangosuperior = null;

            var actualizacionRegistro = 0;
            actualizacionRegistro = web.AdministracionClient.ActualizarDetallePartFranquicia(detallepartfranquicia, HttpContext.Session["userName"].ToString());

            return Json(new { Success = (actualizacionRegistro == 1) ? true : false });
        }

        //
        // GET: /DetallePartFranquicia/Delete/5

        public ActionResult Delete(int id)
        {
            DetallePartFranquicia detallepartfranquicia = web.AdministracionClient.DetalleFranquiciaporId(id);//db.DetallePartFranquicias.Single(d => d.id == id);)
            ViewData["part_franquicia_id"] = detallepartfranquicia.part_franquicia_id.ToString();
            return Json(new { Success = true });
        }

        //
        // POST: /DetallePartFranquicia/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {

            try
            {
                web.AdministracionClient.EliminarDetallePartFranquiciaPorId(id, HttpContext.Session["userName"].ToString());
                return Json(new { Success = true });
            }
            catch
            {
                return Json(new { Success = false });
            }
        }

    }
}