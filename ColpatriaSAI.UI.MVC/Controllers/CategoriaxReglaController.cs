using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using System.Diagnostics;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class CategoriaxReglaController : ControladorBase
    {
        WebPage web = new WebPage();

        public ActionResult Index()
        {
            if (Request.QueryString["valuer"] != string.Empty)
                ViewData["regla_id"] = Request.QueryString["valuer"];
            if (Request.QueryString["value"] != string.Empty)
                ViewData["concurso_id"] = Request.QueryString["value"];

            List<Categoria> categorias = web.AdministracionClient.ListarCategorias();
            List<CategoriaxRegla> categoriaRegla = web.AdministracionClient.ListarCategoriasxRegla(Convert.ToInt32(ViewData["regla_id"]));

            var lstLeftJoin =
              (from c in categorias
               join ca in categoriaRegla on c.id equals ca.categoria_id into CatReg
               from cr in CatReg.DefaultIfEmpty()
               select new CategoriaReglaModel()
               {
                   categoria_id = c.id,
                   categoria_nombre = c.nombre,
                   categoriaxRegla_id = (cr == null) ? 0 : cr.id,
                   esColquin = (cr == null) ? false : cr.esColquin,
                   esRecaudo = (cr == null) ? false : cr.esRecaudo
               }
              ).ToList();

            return View(lstLeftJoin);
        }

        [HttpPost]
        public ActionResult Editar(string id, FormCollection collection)
        {
            try
            {
                int regla_id = Convert.ToInt32(collection["regla_id"]);
                int concurso_id = Convert.ToInt32(collection["concurso_id"]);
                string userName = HttpContext.Session["userName"].ToString();
                CategoriaxRegla cr;
                List<CategoriaxRegla> categoriasxRegla = new List<CategoriaxRegla>();
                
                for (int i = 0; i < collection.Count; i++)
                {
                    if (collection.Keys[i].Contains("cat_"))
                    {
                        cr = new CategoriaxRegla()
                        {
                            id = Convert.ToInt32(collection.Keys[i].Split('_')[1]),
                            regla_id = regla_id,
                            categoria_id = Convert.ToInt32(collection.Keys[i].Split('_')[2]),
                            esRecaudo = false,
                            esColquin = false
                        };
                        if (collection[i].Equals("recaudo"))
                        {
                            cr.esRecaudo = true;
                            cr.esColquin = false;
                        }
                        else if (collection[i].Equals("colquin"))
                        {
                            cr.esRecaudo = false;
                            cr.esColquin = true;
                        }
                        else if (collection[i].Equals("ninguno"))
                        {
                            cr.esRecaudo = false;
                            cr.esColquin = false;
                        }
                        if (cr.id != 0 || cr.esRecaudo == true || cr.esColquin == true)
                        {
                            categoriasxRegla.Add(cr);
                        }
                    }
                }

                web.AdministracionClient.ActualizarCategoriaxRegla(categoriasxRegla, userName);
                return RedirectToAction("Index", new { valuer = regla_id, value = concurso_id });
            }
            catch
            {
                return View();
            }
        }
    }
}