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
using ColpatriaSAI.UI.MVC.Models;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class MetaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ViewResult Index()
        {
            var metas = web.AdministracionClient.ListarMetas();
            ViewData["MetaCumplimientoList"] = web.AdministracionClient.ListarMetas().ToList();
            return View(metas.ToList());
        }

        public ActionResult Create()
        {
            List<Meta> metaList = new List<Meta>();
            Meta meta = new Meta();
            List<ProductosMeta> productosMeta = new List<ProductosMeta>();
            List<MetaCompuesta> metasCompuestas = new List<MetaCompuesta>();
            var idMeta = Request["metaId"];

            if (!string.IsNullOrEmpty(idMeta))
            {
                meta = web.AdministracionClient.ListarMetasPorId(Convert.ToInt32(idMeta)).FirstOrDefault();
                productosMeta = web.AdministracionClient.ListarProductosMetaPorId(Convert.ToInt32(idMeta)).ToList();
                metasCompuestas = web.AdministracionClient.ListarMetaCompuestaPorId(Convert.ToInt32(idMeta)).ToList();

                //TRAEMOS TODAS LAS METAS DE TIPO CALCULO SIMPLE (Id = 1) y LA MISMA VARIABLE QUE LA META EN EDICION
                metaList = web.AdministracionClient.ListarMetas().Where(x => x.tipoMetaCalculo_id == 1 && x.tipoMedida_id == meta.tipoMedida_id).ToList();

                var metaLisTemp = from ml in metaList
                                  where !(from mc in metasCompuestas
                                          where mc.metaOrigen_id == Convert.ToInt32(idMeta)
                                          select mc.metaDestino_id)
                                          .Contains(ml.id)
                                  select ml;

                metaList = (from ml in metaLisTemp.AsEnumerable()
                            select new Meta
                            {
                                id = ml.id,
                                TipoMedida = ml.TipoMedida,
                                tipoMedida_id = ml.tipoMedida_id,
                                tipoMetaCalculo_id = ml.tipoMetaCalculo_id,
                                TipoMeta = ml.TipoMeta,
                                tipoMeta_id = ml.tipoMeta_id,
                                automatica = ml.automatica,
                                nombre = ml.nombre
                            }).ToList();
            }

            var metaModel = new MetaModel()
            {
                Meta = meta,
                MetaList = metaList,
                ProductosMetaList = productosMeta,
                MetaCompuestaList = metasCompuestas,
                TipoMetaList = new SelectList(web.AdministracionClient.ListarTipometas(), "id", "nombre", meta.tipoMeta_id),
                VariableList = new SelectList(web.AdministracionClient.ListarTipoMedidas().Where(x => x.esMeta == true).ToList(), "id", "nombre", meta.tipoMedida_id),
                Acumulada = meta.meta_id.HasValue ? true : false,
                MetaMensualList = new SelectList(web.AdministracionClient.ListarMetasMensuales(meta.id), "id", "nombre", meta.meta_id)
            };

            return View(metaModel);
        }

        [HttpPost]
        public ActionResult SaveMeta()
        {
            Meta meta;
            int resultado = 0;
            int metaAcumulada_id = 0;
            Boolean acumulada = int.TryParse(Request["meta_id"], out metaAcumulada_id);

            if (acumulada)
            {
                Meta metaMensual = web.AdministracionClient.ListarMetasPorId(metaAcumulada_id).FirstOrDefault();

                meta = new Meta()
                {
                    id = Convert.ToInt32(Request["metaId"]),
                    nombre = Request["nombre"],
                    tipoMedida_id = metaMensual.tipoMedida_id,
                    tipoMeta_id = metaMensual.tipoMeta_id,
                    automatica = metaMensual.automatica,
                    tipoMetaCalculo_id = metaMensual.tipoMetaCalculo_id,
                    meta_id = metaAcumulada_id
                };
            }
            else
            {
                meta = new Meta()
                {
                    id = Convert.ToInt32(Request["metaId"]),
                    nombre = Request["nombre"],
                    tipoMedida_id = Convert.ToInt32(Request["tipoMedida_id"]),
                    tipoMeta_id = Convert.ToInt32(Request["tipoMeta_id"]),
                    automatica = (Request["automatica"] == "0" ? false : true),
                    tipoMetaCalculo_id = Convert.ToInt32(Request["tipoMetaCalculo"])
                };

                web.AdministracionClient.ActualizarMetaAcumulada(meta.id, meta, HttpContext.Session["userName"].ToString());
            }

            if (meta.id == 0)
                resultado = web.AdministracionClient.InsertarMeta(meta, HttpContext.Session["userName"].ToString());
            else
                resultado = web.AdministracionClient.ActualizarMeta(meta.id, meta, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true, IdMeta = resultado });
        }

        public ActionResult DeleteMeta(int idMeta)
        {
            int result = web.AdministracionClient.EliminarMeta(idMeta, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true, Result = result });
        }

        public ActionResult ProductoMeta()
        {
            ProductosMeta productoMeta = new ProductosMeta();
            var idProductoMeta = Request["idProductoMeta"];
            int idMeta = Convert.ToInt32(Request["idMeta"]);
            int companiaIdProductoMeta = -1;
            int ramoIdProductoMeta = -1;
            if (!string.IsNullOrEmpty(idProductoMeta) && idProductoMeta != "0")
            {
                productoMeta = web.AdministracionClient.ListarProductosMetaPorId(Convert.ToInt32(idMeta)).ToList().Where(x => x.id == Convert.ToInt32(idProductoMeta)).FirstOrDefault();
                if (productoMeta.compania_id != 0)
                    companiaIdProductoMeta = Convert.ToInt32(productoMeta.compania_id);

                if (productoMeta.ramo_id != 0)
                    ramoIdProductoMeta = Convert.ToInt32(productoMeta.ramo_id);
            }

            var metaModel = new MetaModel()
            {
                ProductosMeta = productoMeta,
                Meta = web.AdministracionClient.ListarMetasPorId(Convert.ToInt32(idMeta)).FirstOrDefault(),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", productoMeta.compania_id),
                RamoList = new SelectList(web.AdministracionClient.ListarRamosPorCompania(companiaIdProductoMeta), "id", "nombre", productoMeta.ramo_id),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductosporRamo(ramoIdProductoMeta), "id", "nombre", productoMeta.producto_id),
                LineaNegocioList = new SelectList(web.AdministracionClient.ListarLineaNegocios(), "id", "nombre", productoMeta.lineaNegocio_id),
                ModalidadPagoList = new SelectList(web.AdministracionClient.ListarModalidadPagoes(), "id", "nombre", productoMeta.modalidadPago_id),
                AmparoList = new SelectList(web.AdministracionClient.ListarAmparoes(), "id", "nombre", productoMeta.amparo_id)
            };

            return View("ProductoMeta", metaModel);
        }

        public ActionResult SaveProductoMeta()
        {
            int resultado = 0;
            string userName = HttpContext.Session["userName"].ToString();
            var productoMeta = new ProductosMeta()
            {
                id = Convert.ToInt32(Request["productoMetaId"]),
                meta_id = Convert.ToInt32(Request["metaId"]),
                compania_id = Convert.ToInt32(Request["compania_id"]),
                ramo_id = (Request["ramo_id"] != "") ? Convert.ToInt32(Request["ramo_id"]) : 0,
                producto_id = (Request["producto_id"] != "") ? Convert.ToInt32(Request["producto_id"]) : 0,
                lineaNegocio_id = (Request["lineaNegocio_id"] != "") ? Convert.ToInt32(Request["lineaNegocio_id"]) : 0,
                modalidadPago_id = (Request["modalidadPago_id"] != "") ? Convert.ToInt32(Request["modalidadPago_id"]) : 0,
                amparo_id = (Request["amparo_id"] != "") ? Convert.ToInt32(Request["amparo_id"]) : 0
            };

            if (productoMeta.id == 0)
                resultado = web.AdministracionClient.InsertarProductoMeta(productoMeta, userName);
            else
                resultado = web.AdministracionClient.ActualizarProductoMeta(productoMeta.id, productoMeta, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true });
        }

        public ActionResult DeleteProductoMeta(int idProductoMeta)
        {
            string userName = HttpContext.Session["userName"].ToString();
            int result = web.AdministracionClient.EliminarProductoMeta(idProductoMeta, userName);

            return Json(new { Success = true, Result = result });
        }

        public ActionResult SaveMetaCompuesta()
        {
            char[] delimiterChars = { ',' };
            string userName = HttpContext.Session["userName"].ToString();
            List<string> metasDestinoList = Request["metasDestino[]"].Split(delimiterChars).ToList();
            int idMetaOrigen = Convert.ToInt32(Request["idMeta"]);
            foreach (string idMetaDestino in metasDestinoList)
            {
                int resultado = web.AdministracionClient.InsertarMetaCompuesta(Convert.ToInt32(idMetaDestino), idMetaOrigen, userName);
            }

            return Json(new { Success = true });
        }

        public ActionResult DeleteMetaCompuesta(int idMetaCompuesta)
        {
            string userName = HttpContext.Session["userName"].ToString();
            int result = web.AdministracionClient.EliminarMetaCompuesta(idMetaCompuesta, userName);

            return Json(new { Success = true, Result = result });
        }

        //EL REQUERIMIENTO SE DIJO QUE NO SE IBA HACER. 
        //SE DEJA COMENTADO POR SI HAY LA POSIBILIDAD QUE EL NEGOCIO LO APRUEBE NUEVAMENTE
        /*
        public ActionResult guardarMetaCumplimiento()
        {
            String messagge = string.Empty;
            Boolean success = false;
            int metaValidacionId = int.Parse(Request["metaValidacionId"]);
            string metas = Request["metas[]"];

            char[] delimiterChars = { ',' };

            //VALIDAMOS QUE HAYA METAS
            if (!string.IsNullOrEmpty(metas))
            {
                string[] arrMetas = metas.Split(delimiterChars);

                //OBTENEMOS EL LISTADO DE LAS METAS QUE SE ENCUENTRA ASOCIADAS
                List<MetaValidacionCumplimiento> metasValidacionCumplimientoList = new List<MetaValidacionCumplimiento>();

                metasValidacionCumplimientoList = web.AdministracionClient.ListarMetaValidacionCumplimientoPorId(metaValidacionId).ToList();

                //RECORREMOS LAS METAS SELECCIONADAS Y LAS INSERTAMOS
                foreach (string idMeta in arrMetas)
                {
                    if (!string.IsNullOrEmpty(idMeta) && idMeta != "0" && Convert.ToInt32(idMeta) != metaValidacionId)
                    {
                        //VALIDAMOS SI LA ASOCIACION YA EXISTE
                        var totalMeta = metasValidacionCumplimientoList.Where(x => x.metaValidacion_id == metaValidacionId && x.metaReponderacion_id == Convert.ToInt32(idMeta)).Count();

                        if (totalMeta == 0)
                        {
                            int registro = web.AdministracionClient.InsertarMetaValidacionCumplimiento(metaValidacionId, Convert.ToInt32(idMeta));
                        }
                    }
                }
            }

            return Json(new { Success = true });
        }

        [HttpPost]
        public ActionResult listadoMetaValidacion()
        {
            int idMeta = Convert.ToInt32(Request["idMeta"]);

            //OBTENEMOS EL LISTADO DE METAS A VALIDAR
            List<MetaValidacionCumplimiento> metaValidacionList = web.AdministracionClient.ListarMetaValidacionCumplimientoPorId(idMeta);

            var model = new MetaValidacionCumplimientoModel()
            {
                MetaValidacionCumplimientoList = metaValidacionList
            };

            return View("MetasValidacionList", model);
        }

        [HttpPost]
        public ActionResult eliminarMetaValidacion()
        {
            int idMeta = Convert.ToInt32(Request["idMeta"]);

            web.AdministracionClient.EliminarMetaValidacionCumplimiento(idMeta);

            return Json(new { Success = true });
        }

        [HttpPost]
        public ActionResult eliminarMetaValidacionAll()
        {
            int idMeta = Convert.ToInt32(Request["idMeta"]);

            List<MetaValidacionCumplimiento> metaValidacionCumplimientoList = web.AdministracionClient.ListarMetaValidacionCumplimientoPorId(idMeta);

            foreach (MetaValidacionCumplimiento metaValidacionCumplimiento in metaValidacionCumplimientoList)
            {
                web.AdministracionClient.EliminarMetaValidacionCumplimiento(metaValidacionCumplimiento.id);
            }

            return Json(new { Success = true });
        }
        */
    }
}