using System;
using System.Collections.Generic;

using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;

namespace ColpatriaSAI.UI.MVC.Controllers
{

    public class AnticiposFranquiciasController : ControladorBase
    {
        //
        // GET: /AnticiposFranquicias/
        WebPage web = new WebPage();
        public ActionResult Index()
        {
            List<Negocio.Entidades.AnticipoFranquicia> anticipoFranquicias = web.AdministracionClient.ListarAnticipoFranquicias();
            return View(anticipoFranquicias);
        }

        //
        // GET: /AnticiposFranquicias/Details/5

        public ActionResult Details(int id)
        {
            return View();
        }

        //
        // GET: /AnticiposFranquicias/Create

        public ActionResult Create()
        {

            Negocio.Entidades.AnticipoFranquicia anticipoFranquicia = new AnticipoFranquicia();
            anticipoFranquicia = CargarListas(null);

            return View(anticipoFranquicia);
        }

        //
        // POST: /AnticiposFranquicias/Create

        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            AnticipoFranquicia anticipoFranquicia = new AnticipoFranquicia();
            try
            {
                // TODO: Add insert logic here
                ViewData["Mensaje"] = "";
                foreach (string VARIABLE in collection)
                {
                    ViewData[VARIABLE] = collection[VARIABLE];
                }
                anticipoFranquicia.localidad_id = int.Parse(ViewData["Localidades"].ToString());
                anticipoFranquicia.fecha_anticipo = DateTime.Now;
                anticipoFranquicia.descripcion = ViewData["descripcion"].ToString();
                anticipoFranquicia.usuarioEjecutoAnti = ViewData["usuarioEjecutoAnti"].ToString();
                anticipoFranquicia.valorAnti = double.Parse(ViewData["valorAnti"].ToString());
                anticipoFranquicia.estado = "1";
                anticipoFranquicia.compania_id = int.Parse(ViewData["Companias"].ToString());
                web.AdministracionClient.InsertarAnticipoFranquicias(anticipoFranquicia, HttpContext.Session["userName"].ToString());
                ViewData["Mensaje"] = "El registro se inserto correctamente";
                return RedirectToAction("Index");
            }
            catch
            {
                ViewData["Mensaje"] = "Error en la insercion del registro";
                return View(CargarListas(null));
            }
        }

        //
        // GET: /AnticiposFranquicias/Edit/5

        public ActionResult Edit(int id)
        {
            string compa = "";
            string localidad = "";
            string estado = "";
            string valorItemSel = "";
            var antfr = web.AdministracionClient.AnticipoFranquiciaPorId((int)id);
            if (Request.QueryString.HasKeys())
            {
                AnticipoFranquicia anticipoFranquicia = new AnticipoFranquicia();
                compa = Request.QueryString["comp"];
                localidad = Request.QueryString["localidad"];
                estado = Request.QueryString["estado"];
                anticipoFranquicia.fecha_anticipo = DateTime.Parse(Request.QueryString["fechaanticipo"].ToString());
                anticipoFranquicia.descripcion = Request.QueryString["descripcion"].ToString();
                anticipoFranquicia.usuarioEjecutoAnti = Request.QueryString["usejeant"].ToString();
                antfr = anticipoFranquicia;
            }
            else
            {
                compa = antfr.compania_id.ToString();
                localidad = antfr.localidad_id.ToString();
                estado = antfr.estado;

            }

            var comp = new SelectList(TraerCompanias(0), "id", "nombre");
            ViewData["Companias"] = Helper.TraerSelectListItemSeleccionado(comp, compa, ref valorItemSel);

            var local = new SelectList(TraerLocalidades(0), "id", "nombre");
            ViewData["Localidades"] = Helper.TraerSelectListItemSeleccionado(local, localidad, ref valorItemSel);

            List<SelectListItem> itemsEstado = new List<SelectListItem>();
            itemsEstado.Add(new SelectListItem
            {
                Text = "Creado",
                Value = "1"
            });
            itemsEstado.Add(new SelectListItem
            {
                Text = "Pagado",
                Value = "2",
                Selected = true
            });
            itemsEstado.Add(new SelectListItem
            {
                Text = "Anulado",
                Value = "3"
            });
            itemsEstado.Add(new SelectListItem
            {
                Text = "Descontado",
                Value = "4"
            });

            var esta = new SelectList(itemsEstado, "Value", "Text", estado);
            ViewData["Estados"] = esta;

            return View(antfr);
        }

        //
        // POST: /AnticiposFranquicias/Edit/5

        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            AnticipoFranquicia anticipoFranquicia = new AnticipoFranquicia();
            try
            {
                anticipoFranquicia.localidad_id = int.Parse(collection["Localidades"].ToString());
                anticipoFranquicia.fecha_anticipo = DateTime.Now;
                anticipoFranquicia.descripcion = collection["descripcion"].ToString();
                anticipoFranquicia.usuarioEjecutoAnti = collection["usuarioEjecutoAnti"].ToString();
                anticipoFranquicia.valorAnti = double.Parse(collection["valorAnti"].ToString());
                anticipoFranquicia.estado = collection["Estado"].ToString();
                anticipoFranquicia.compania_id = int.Parse(collection["Companias"].ToString());
                string userName = HttpContext.Session["userName"].ToString();
                web.AdministracionClient.ActualizarAnticipoFranquicia(Convert.ToInt32(collection["Id"]), anticipoFranquicia, userName);
                return RedirectToAction("Index");
            }
            catch
            {
                ViewData["Mensaje"] = "Error en la actualización del registro";
                return View("Edit");

            }
        }

        //
        // GET: /AnticiposFranquicias/Delete/5

        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /AnticiposFranquicias/Delete/5

        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        [HttpPost]
        public JsonResult Anular(int id)
        {
            web.AdministracionClient.AnularAnticipo(id);
            return Json(new { Success = 1, excepcion = id, ex = "", Modo = "Anular" });
        }


        [HttpPost]
        public JsonResult Pagar(int id)
        {
            string valselitem = "";
            ColpatriaSAI.Negocio.Entidades.AnticipoFranquicia anticipoFranquicia =
                web.AdministracionClient.ListarAnticipoFranquicias().FirstOrDefault(e => e.Id == id);

            if (anticipoFranquicia != null)
            {
                anticipoFranquicia.estado = "2";

                try
                {
                    if (HttpContext.Session["NombreUser"] != null)
                    {
                        web.AdministracionClient.ActualizarAnticipoFranquicias(id, anticipoFranquicia,
                                                                               HttpContext.Session["NombreUser"].
                                                                                   ToString());
                    }
                    else
                    {
                        web.AdministracionClient.ActualizarAnticipoFranquicias(id, anticipoFranquicia,
                                                                               "Usario no antenticado");
                    }
                    // return Json(web.AdministracionClient.ListarLocalidadesPorZona(zona_id).Select(p => new { p.nombre, p.id }), JsonRequestBehavior.AllowGet);
                    return Json(new { Success = 1, excepcion = anticipoFranquicia.Id, ex = "", Modo = "Pagar" });
                }
                catch (Exception er)
                {

                    return
                        Json(
                            new
                                {
                                    Success = 0,
                                    excepcion = anticipoFranquicia.Id,
                                    ex = er.Message.ToString(),
                                    Modo = "Pagar"
                                });
                }
            }
            return
                       Json(
                           new
                           {
                               Success = 0,
                               excepcion = "",
                               ex = "No se logro obtener la entidad anticipo franquicia",
                               Modo = "Pagar"
                           });
        }



        public AnticipoFranquicia CargarListas(int? id)
        {
            string compa = "";
            string localidad = "";
            string estado = "";
            string usuarioEjecutoAnti = "";
            string descripcion = "";
            string fechaanticipo = "";
            string valorItemSel = "";
            Negocio.Entidades.AnticipoFranquicia anticipoFranquicia = null;

            if (Request.QueryString.HasKeys())
            {
                anticipoFranquicia = new AnticipoFranquicia();
                compa = Request.QueryString["comp"];
                localidad = Request.QueryString["localidad"];
                estado = Request.QueryString["estado"];
                anticipoFranquicia.fecha_anticipo = DateTime.Parse(Request.QueryString["fechaanticipo"].ToString());
                anticipoFranquicia.descripcion = Request.QueryString["descripcion"].ToString();
                anticipoFranquicia.usuarioEjecutoAnti = Request.QueryString["usejeant"].ToString();
            }
            else
            {
                if (id != null)
                {

                    var antfr = web.AdministracionClient.AnticipoFranquiciaPorId((int)id);
                    compa = antfr.compania_id.ToString();
                    localidad = antfr.localidad_id.ToString();
                    estado = antfr.estado;





                    var comp = new SelectList(TraerCompanias(0), "id", "nombre");
                    ViewData["Companias"] = Helper.TraerSelectListItemSeleccionado(comp, compa, ref valorItemSel);

                    var local = new SelectList(TraerLocalidades(0), "id", "nombre");
                    ViewData["Localidades"] = Helper.TraerSelectListItemSeleccionado(local, localidad, ref valorItemSel);

                    List<SelectListItem> itemsEstado = new List<SelectListItem>();
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Creado",
                        Value = "1"
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Pagado",
                        Value = "2",
                        Selected = true
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Anulado",
                        Value = "3"
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Descontado",
                        Value = "4"
                    });

                    var esta = new SelectList(itemsEstado, "Value", "Text", estado);
                    ViewData["Estados"] = esta;

                    return antfr;
                }
                else
                {
                    var comp = new SelectList(TraerCompanias(0), "id", "nombre");
                    ViewData["Companias"] = Helper.TraerSelectListItemSeleccionado(comp, compa, ref valorItemSel);

                    var local = new SelectList(TraerLocalidades(0), "id", "nombre");
                    ViewData["Localidades"] = Helper.TraerSelectListItemSeleccionado(local, localidad, ref valorItemSel);

                    List<SelectListItem> itemsEstado = new List<SelectListItem>();
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Creado",
                        Value = "1"
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Pagado",
                        Value = "2",
                        Selected = true
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Anulado",
                        Value = "3"
                    });
                    itemsEstado.Add(new SelectListItem
                    {
                        Text = "Descontado",
                        Value = "4"
                    });

                    var esta = new SelectList(itemsEstado, "Value", "Text", estado);
                    ViewData["Estados"] = esta;
                    return new AnticipoFranquicia();

                }

            }


            return new AnticipoFranquicia();






        }

        private List<ColpatriaSAI.Negocio.Entidades.Localidad> TraerLocalidades(int id)
        {
            List<ColpatriaSAI.Negocio.Entidades.Localidad> localidads = new List<Localidad>();

            if (id == 0)
            {
                localidads = web.AdministracionClient.ListarFranquicias();
            }
            else
            {
                localidads = web.AdministracionClient.ListarFranquiciaPorId(id);
            }


            return localidads.OrderBy(e => e.nombre).ToList();

        }

        public List<Compania> TraerCompanias(int id)
        {


            List<ColpatriaSAI.Negocio.Entidades.Compania> companias = new List<Compania>();


            if (id == 0)
            {
                companias = web.AdministracionClient.ListarCompanias();
            }
            else
            {
                companias = web.AdministracionClient.ListarCompaniasPorId(id);
            }


            return companias.OrderBy(e => e.nombre).ToList();



            //return companias;

        }
    }
}
