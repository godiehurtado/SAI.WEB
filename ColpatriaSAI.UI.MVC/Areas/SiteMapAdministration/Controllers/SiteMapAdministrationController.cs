using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Componentes.Admin;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.UI.MVC.Views.Shared;
using SiteMap = ColpatriaSAI.Negocio.Entidades.SiteMap;



namespace ColpatriaSAI.UI.MVC.Areas.SiteMapAdministration.Controllers
{
    //[Authorize(Roles = "Administrator")]
    public class SiteMapAdministrationController : Controller
    {
        //
        // GET: /SiteMapAdministration/SiteMapAdministration/
        WebPage web = new WebPage();
        public ActionResult Index()
        {

            List<ColpatriaSAI.Negocio.Entidades.SiteMap> siteMapes = web.AdministracionClient.ListarSiteMap().ToList();
            // Quitar el nodo raíz
            siteMapes.RemoveAt(0);
            // Quitar el nodo Inicio - A este tienen permiso todos los roles
            siteMapes.RemoveAt(0);
            return View(siteMapes);
        }

        ////
        //// GET: /SiteMapAdministration/SiteMapAdministration/Details/5

        //public ActionResult Details(int id)
        //{
        //    return View();
        //}

        //
        // GET: /SiteMapAdministration/SiteMapAdministration/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /SiteMapAdministration/SiteMapAdministration/Create

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                string userName = HttpContext.Session["userName"].ToString();



                foreach (var variable in collection.AllKeys)
                {
                    ColpatriaSAI.Negocio.Entidades.SiteMap sitemap = new ColpatriaSAI.Negocio.Entidades.SiteMap()
                                                                         {
                                                                             ID = collection["ID"].ToString(),
                                                                             TITLE = collection["TITLE"].ToString(),
                                                                             ACTION = collection["ACTION"],
                                                                             DESCRIPTION = collection["DESCRIPTION"],
                                                                             CONTROLLER = collection["CONTROLLER"],
                                                                             PARAMID = collection["PARAMID"],
                                                                             URL = collection["URL"],
                                                                             PARENT_ID = collection["PARENT_ID"],
                                                                             Roles = collection["Roles"]



                                                                         };

                    web.AdministracionClient.InsertarSiteMap(sitemap, userName);
                    Logging.Auditoria("Creación del registro: " + collection["ID"].ToString() + " en la tabla: " + "SiteMap", Logging.Prioridad.Baja,
                    Modulo.General, Sesion.VariablesSesion());



                }



                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /SiteMapAdministration/SiteMapAdministration/Edit/5

        public ActionResult Edit(string id)
        {

            List<aspnet_Roles> roles = web.AdministracionClient.ListarRoles();
            char[] separator = { ',' };

            string[] formroles = web.AdministracionClient.ListarSiteMapPorId(id).ToList()[0].Roles.ToString().Split(separator);

            List<SelectListItem> items = new List<SelectListItem>();


            items.Clear();
            foreach (var aspnetRolese in roles)
            {

                foreach (var formrole in formroles)
                {
                    if (formrole.ToString().ToUpper() == aspnetRolese.RoleName.ToString().ToUpper())
                    {

                        SelectListItem item = new SelectListItem
                                                  {
                                                      Text = aspnetRolese.RoleName,
                                                      Value = aspnetRolese.RoleId.ToString(),
                                                      Selected = true
                                                  };
                        if (!items.Exists(ag => ag.Text == item.Text))
                        {
                            items.Add(new SelectListItem
                            {
                                Text = aspnetRolese.RoleName,
                                Value = aspnetRolese.RoleId.ToString(),
                                Selected = true
                            });
                        }
                        else
                        {
                            items.RemoveAt(items.FindIndex(0, ag => ag.Text == item.Text));
                            items.Add(new SelectListItem
                            {
                                Text = aspnetRolese.RoleName,
                                Value = aspnetRolese.RoleId.ToString(),
                                Selected = true
                            });
                        }

                    }

                    else
                    {

                        SelectListItem item = new SelectListItem
                        {
                            Text = aspnetRolese.RoleName,
                            Value = aspnetRolese.RoleId.ToString(),
                            Selected = true
                        };
                        if (!items.Exists(ag => ag.Text == item.Text))
                        {
                            items.Add(new SelectListItem
                            {
                                Text = aspnetRolese.RoleName,
                                Value = aspnetRolese.RoleId.ToString(),
                                Selected = false
                            });
                        }

                    }

                }

            }




            ViewData["ListRoles"] = items; //new SelectList(items, "Value", "Text");




            ColpatriaSAI.Negocio.Entidades.SiteMap sitemap = web.AdministracionClient.ListarSiteMapPorId(id).ToList()[0];

            return View(sitemap);

            //var movie = context.Movies.Single(m => m.MovieId == id);
            //return View(movie); 
            return null;
        }



        //
        // POST: /SiteMapAdministration/SiteMapAdministration/Edit/5

        [HttpPost]
        public ActionResult Edit(string id, FormCollection collection)
        {
            // TODO: Add update logic here
            try
            {

                string userName = HttpContext.Session["userName"].ToString();
                char[] separator = { ',' };
                string rolessupdate = "";
                if (collection["ListRoles"] != null)
                {
                    string[] roles = collection["ListRoles"].Split(separator);
                    foreach (string roleid in roles)
                    {


                        aspnet_Roles role = web.AdministracionClient.GetRolById(new Guid(roleid));
                        if (rolessupdate == "")
                        {

                            rolessupdate = role.RoleName;
                        }
                        else
                        {
                            rolessupdate = rolessupdate + "," + role.RoleName;
                        }


                    }
                }
                else
                {
                    rolessupdate = "";
                }


                foreach (var variable in collection.AllKeys)
                {
                    ColpatriaSAI.Negocio.Entidades.SiteMap sitemap = new ColpatriaSAI.Negocio.Entidades.SiteMap()
                                                                         {
                                                                             ID = collection["ID"].ToString(),
                                                                             TITLE = collection["TITLE"].ToString(),
                                                                             ACTION = collection["ACTION"],
                                                                             DESCRIPTION = collection["DESCRIPTION"],
                                                                             CONTROLLER = collection["CONTROLLER"],
                                                                             PARAMID = collection["PARAMID"],
                                                                             URL = collection["URL"],
                                                                             PARENT_ID = collection["PARENT_ID"],
                                                                             Roles = rolessupdate//collection["Roles"]



                                                                         };

                    web.AdministracionClient.ActualizarsiteMap(id, sitemap, userName);
                    string registroanterior = "";
                    foreach (KeyValuePair<string, object> keyValuePair in ViewData)
                    {
                        registroanterior = keyValuePair.Key + "=" + keyValuePair.Value;
                    }

                    Logging.Auditoria("Actualización  del registro: " + collection["ID"].ToString() + " en la tabla: " + "SiteMap" + " registroanterior:" + registroanterior, Logging.Prioridad.Baja,
                Modulo.General, Sesion.VariablesSesion());


                    HttpContext.Cache.Remove("122EF2B1-F0A4-4507-B011-94669840F79C");

                }




                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /SiteMapAdministration/SiteMapAdministration/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /SiteMapAdministration/SiteMapAdministration/Delete/5

        [HttpPost]
        public ActionResult Delete(string id, FormCollection collection)
        {
            foreach (var variable in collection.AllKeys)
            {
                ColpatriaSAI.Negocio.Entidades.SiteMap sitemap = new ColpatriaSAI.Negocio.Entidades.SiteMap()
                {
                    ID = collection["ID"].ToString(),
                    TITLE = collection["TITLE"].ToString(),
                    ACTION = collection["ACTION"],
                    DESCRIPTION = collection["DESCRIPTION"],
                    CONTROLLER = collection["CONTROLLER"],
                    PARAMID = collection["PARAMID"],
                    URL = collection["URL"],
                    PARENT_ID = collection["PARENT_ID"],
                    Roles = collection["Roles"]



                };

                web.AdministracionClient.Eliminarsitemap(id, sitemap, HttpContext.Session["userName"].ToString());
                Logging.Auditoria("Eliminación del registro: " + collection["ID"].ToString() + " en la tabla: " + "SiteMap", Logging.Prioridad.Baja,
                Modulo.General, Sesion.VariablesSesion());


            }




            return RedirectToAction("Index");
        }
    }
}
