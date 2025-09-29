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
    public class ComboController : ControladorBase
    {
        WebPage web = new WebPage();

        public ViewResult Index()
        {
            var combos = web.AdministracionClient.ListarCombos();
            return View(combos.ToList());
        }

        public ActionResult Create()
        {
            Combo combo = new Combo();
            List<ProductoCombo> productoCombo = new List<ProductoCombo>();

            var idCombo = Request["comboId"];

            if (!string.IsNullOrEmpty(idCombo))
            {
                combo = web.AdministracionClient.ListarCombosPorId(Convert.ToInt32(idCombo)).FirstOrDefault();
                productoCombo = web.AdministracionClient.ListarProductosComboPorId(Convert.ToInt32(idCombo)).ToList();
            }


            var comboModel = new ComboModel()
            {
                Combo = combo,
                ProductoComboList = productoCombo
            };

            return View(comboModel);
        }

        [HttpPost]
        public ActionResult SaveCombo()
        {
            int resultado = 0;

            Combo combo = new Combo()
            {
                id = Convert.ToInt32(Request["comboId"]),
                nombre = Request["nombre"],
                descripcion = Request["descripcion"],
                validado = 0
            };

            if (combo.id == 0)
                resultado = web.AdministracionClient.InsertarCombo(combo, HttpContext.Session["userName"].ToString());
            else
                resultado = web.AdministracionClient.ActualizarCombo(combo.id, combo, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true, IdCombo = resultado });
        }

        public ActionResult DeleteCombo(int idCombo)
        {
            int result = web.AdministracionClient.EliminarCombo(idCombo, HttpContext.Session["userName"].ToString());

            return Json(new { Success = true, Result = result });
        }

        public ActionResult ProductoCombo()
        {
            ProductoCombo productoCombo = new ProductoCombo();
            var idProductoCombo = Request["idProductoCombo"];
            int idCombo = Convert.ToInt32(Request["idCombo"]);
            int companiaIdProductoCombo = -1;
            int ramoIdProductoCombo = -1;
            if (!string.IsNullOrEmpty(idProductoCombo) && idProductoCombo != "0")
            {
                productoCombo = web.AdministracionClient.ListarProductosComboPorId(Convert.ToInt32(idCombo)).ToList().Where(x => x.id == Convert.ToInt32(idProductoCombo)).FirstOrDefault();
                companiaIdProductoCombo = Convert.ToInt32(productoCombo.compania_id);
                ramoIdProductoCombo = Convert.ToInt32(productoCombo.ramo_id);
            }

            var comboModel = new ComboModel()
            {
                ProductoCombo = productoCombo,
                Combo = web.AdministracionClient.ListarCombosPorId(Convert.ToInt32(idCombo)).FirstOrDefault(),
                CompaniaList = new SelectList(web.AdministracionClient.ListarCompanias().ToList(), "id", "nombre", productoCombo.compania_id),
                RamoList = new SelectList(web.AdministracionClient.ListarRamosPorCompania(companiaIdProductoCombo), "id", "nombre", productoCombo.ramo_id),
                ProductoList = new SelectList(web.AdministracionClient.ListarProductosporRamo(ramoIdProductoCombo), "id", "nombre", productoCombo.producto_id)
            };

            return View("ProductoCombo", comboModel);
        }

        public ActionResult SaveProductoCombo()
        {
            int resultado = 0;

            var productoCombo = new ProductoCombo()
            {
                id = Convert.ToInt32(Request["productoComboId"]),
                combo_id = Convert.ToInt32(Request["comboId"]),
                compania_id = Convert.ToInt32(Request["compania_id"]),
                ramo_id = (Request["ramo_id"] != "") ? Convert.ToInt32(Request["ramo_id"]) : 0,
                producto_id = (Request["producto_id"] != "") ? Convert.ToInt32(Request["producto_id"]) : 0,
                es_principal = (!string.IsNullOrEmpty(Request["es_principal"])) ? 1 : 0
            };
            string userName = HttpContext.Session["userName"].ToString();

            if (productoCombo.id == 0)
                resultado = web.AdministracionClient.InsertarProductoCombo(productoCombo, userName);
            else
                resultado = web.AdministracionClient.ActualizarProductoCombo(productoCombo.id, productoCombo, userName);

            web.AdministracionClient.ActualizarComboValidado(Convert.ToInt32(productoCombo.combo_id), 0, userName);

            return Json(new { Success = true });
        }

        public ActionResult DeleteProductoCombo(int idProductoCombo)
        {
            string userName = HttpContext.Session["userName"].ToString();
            int result = web.AdministracionClient.EliminarProductoCombo(idProductoCombo, userName);

            return Json(new { Success = true, Result = result });
        }

        public ActionResult ValidarCombo(int idCombo)
        {
            int result = 1;

            //OBTENEMOS LOS PRODUCTOS DEL COMBO A VALIDAR
            List<ProductoCombo> productoComboList = web.AdministracionClient.ListarProductosComboPorId(idCombo).ToList();

            //OBTENEMOS TODOS LOS COMBOS
            List<Combo> comboslist = web.AdministracionClient.ListarCombos().Where(c => c.id != idCombo).ToList();

            List<ProductoCombo> productoComboAValidarList = new List<ProductoCombo>();

            List<Boolean> existeProductoList = new List<Boolean>();

            Boolean comboRepetido = false;
            String message = "";
            Boolean success = true;

            //DETERMINAMOS SI EL COMBO TIENE PRODUCTOS
            if (productoComboList.Count() > 0)
            {
                //RECORREMOS LOS COMBOS Y SUS PRODUCTOS
                foreach (Combo combo in comboslist)
                {
                    //OBTENEMOS LOS PRODUCTOS DEL COMBO A VALIDAR
                    productoComboAValidarList = web.AdministracionClient.ListarProductosComboPorId(combo.id).ToList();

                    existeProductoList = new List<Boolean>();

                    foreach (ProductoCombo productoComboAValidar in productoComboAValidarList)
                    {
                        //VALIDAMOS SI EL PRODUCTO YA EXISTE
                        existeProductoList.Add(ValidarProducto(productoComboAValidar, productoComboList));
                    }

                    //DETERMINAMOS SI EN LA LISTA HAY ALGUN VALOR DE FALSE. ESTO INDICA QUE EL PRODUCTO NO ESTA REPETIDO EN EL COMBO
                    if (existeProductoList.Count() == productoComboList.Count())
                    {
                        var totalProd = existeProductoList.Where(x => x == false).Count();

                        if (totalProd == 0)
                            comboRepetido = true;
                    }
                }

                //DETERMINAMOS SI EL COMBO ESTA REPETIDO. OSEA SI LOS PRODUCTOS YA ESTAN EN OTRO COMBO TAL CUAL COMO EL QUE SE ESTA VALIANDO
                if (comboRepetido)
                {
                    message = "El combo esta repetido.";
                    success = false;
                }
                else
                {
                    //DETERMINAMOS SI EL COMBO TIENE UN PRODUCTO QUE SEA PRINCIPAL
                    if (productoComboList.Where(p => p.es_principal == 1).Count() <= 0)
                    {
                        message = "El combo no tiene un producto que sea principal.";
                        success = false;
                    }

                    //DETERMINAMOS SI EL COMBO TIENE UN PRODUCTO QUE SEA PRINCIPAL
                    if (productoComboList.Where(p => p.es_principal == 1).Count() > 1)
                    {
                        message = "El combo no tiene mas de un producto principal.";
                        success = false;
                    }
                }
            }
            else
            {
                message = "El combo no tiene productos asociados.";
                success = false;
            }

            if (success)
            {
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarComboValidado(idCombo, 1, userName);
            }


            return Json(new { Success = success, Message = message });
        }

        public Boolean ValidarProducto(ProductoCombo productoAValidar, List<ProductoCombo> productoComboList)
        {

            Boolean existe = false;

            foreach (ProductoCombo productoCombo in productoComboList)
            {
                //VALIDAMOS SI EL PRODUCTO YA EXISTE
                if (productoCombo.compania_id == productoAValidar.compania_id && productoCombo.ramo_id == productoAValidar.ramo_id && productoCombo.producto_id == productoAValidar.producto_id)
                    existe = true;
            }

            return existe;
        }
    }
}