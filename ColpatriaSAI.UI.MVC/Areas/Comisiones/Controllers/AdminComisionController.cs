using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes.Comision.Administracion;
using System.Web.Script.Serialization;
using ColpatriaSAI.Negocio.Componentes.Comision;
using System.Data;
using ColpatriaSAI.UI.MVC.Controllers;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class AdminComisionController : ControladorBase
    {
        private ComisionesSVC.ComisionesClient _svcComisiones;
        

        public ActionResult Parametros()
        {

            _svcComisiones = new ComisionesSVC.ComisionesClient();

            string[] parametrosCOns1 = new string[3] { "1", "15", "16" };//Años borrado historial, factor edad máxima, meses envio de recaudos

            string[] ParametersInARow = new string[1000];  //

            for (int i =0; i < ParametersInARow.Length; i++) { ParametersInARow[i] = (i + 10000).ToString(); }
            string[] parametrosCOns = parametrosCOns1.Concat(ParametersInARow).ToArray();
            List<ConfigParametros> Parametros = _svcComisiones.ObtenerParametros(parametrosCOns).ToList();
            

            List<SelectListItem> dd = new List<SelectListItem>();
            //Se agrega un parametro inicial

            SelectListItem itemAIni = new SelectListItem();
            itemAIni.Text = "Seleccione un Párametro";
            itemAIni.Value = "-1";

            dd.Add(itemAIni);


            //Se agregan los parametros traidos de BD
            foreach (var item in Parametros)
            {
                SelectListItem itemAdd = new SelectListItem();
                itemAdd.Text = item.parametro;
                itemAdd.Value = item.id.ToString();

                dd.Add(itemAdd);
            }

            TempData["ddParametros"] = dd;//Se guarda el dropdownlist

            //Se guarda el json que contiene la lista obtenida (Son pocos parametros)
            var jsonSerializer = new JavaScriptSerializer();
            var JsonResult = jsonSerializer.Serialize(Parametros);
            TempData["JsonParametros"] = JsonResult;

            
            return View();
        }

        public JsonResult ModificarParametro(int id, string valor)
        {
            _svcComisiones = new ComisionesSVC.ComisionesClient();
            var jsonSerializer = new JavaScriptSerializer();
           string username = HttpContext.Session["userName"].ToString();
            ResultadoOperacionBD rtaOperacion= _svcComisiones.EditarParametro(id, valor, username);

            if (rtaOperacion.RegistrosAfectados > 0)
            {
                TempData["MesajeOp"] = "Edición realizada correctamente";
                rtaOperacion.MensajeError = "OK";
                //Se serialzia los resutlados actualizados
                string[] parametrosCOns1 = new string[3] { "1", "15", "16" };//Años borrado historial, factor edad máxima, meses envio de recaudos
                string[] ParametersInARow = new string[1000];  //

                for (int i = 0; i < ParametersInARow.Length; i++) { ParametersInARow[i] = (i + 10000).ToString(); }
                string[] parametrosCOns = parametrosCOns1.Concat(ParametersInARow).ToArray();
                List<ConfigParametros> Parametros = _svcComisiones.ObtenerParametros(parametrosCOns).ToList();
                //Se guarda el json que contiene la lista obtenida (Son pocos parametros)
                var JsonResult = jsonSerializer.Serialize(Parametros);
                TempData["JsonParametros"] = JsonResult;

            }
            else
            {
                TempData["MesajeOp"] = !String.IsNullOrEmpty(rtaOperacion.MensajeError) ? rtaOperacion.MensajeError : "Ocurrió un error intentelo nuevamente.";
            }

            return Json(rtaOperacion);// jsonSerializer.Serialize(rtaOperacion); ;
        }

        public ActionResult NovedadesUsuarios()
        {
            _svcComisiones = new ComisionesSVC.ComisionesClient();

            string[] parametrosCOns = new string[4] { "17", "18", "19","20" };//Novedades Usarios CF, CV, Usuarios Renovados, Beneficiarios Vigentes
            List<ConfigParametros> Parametros = _svcComisiones.ObtenerParametros(parametrosCOns).ToList();

            string InclusionBenefVigentes = Parametros.Where(x => x.id == 20).FirstOrDefault().valor;
            if (string.IsNullOrEmpty(InclusionBenefVigentes))
                InclusionBenefVigentes = "N";
            TempData["IncBenefVigentes"] = InclusionBenefVigentes;

            #region NovedadesCF
            String[] novedades = Parametros.Where(x => x.id == 17).FirstOrDefault().valor.Split(','); //Se carga el listado descriptivo de las novedades
            
            List<parmbhExtractNoveades> NovedadesRelacionadas;
            List<parmbhExtractNoveades> NovedadesAgrupadas = new List<parmbhExtractNoveades>();

            Session["NovedadesCF"] = novedades;

            if (novedades.Length == 1 && String.IsNullOrEmpty(novedades[0]))
            {
                NovedadesRelacionadas = new List<parmbhExtractNoveades>();
            }
            else
            {
                NovedadesRelacionadas = _svcComisiones.ObtenerListNovedades(novedades).ToList();
                //Se cargan las novedades agrupadas

                NovedadesAgrupadas = (from busq in NovedadesRelacionadas
                                      group busq by new { busq.NovNcode, busq.NovCDescription, busq.NovCtType } into grupoNovedad
                                      select new parmbhExtractNoveades()
                                      {
                                          NovNcode = grupoNovedad.Key.NovNcode,
                                          NovCDescription = grupoNovedad.Key.NovCDescription,
                                          NovCtType = grupoNovedad.Key.NovCtType
                                      }).ToList();

            }

            DataTable dtNovedadesCF = new DataTable();
            dtNovedadesCF.Columns.Add("NovNcode");
            dtNovedadesCF.Columns.Add("NovCDescription");
            dtNovedadesCF.Columns.Add("NovCtType");
            //dtNovedadesCF.Columns.Add("Nca_Cdescription");

            foreach (var item in NovedadesAgrupadas)
                dtNovedadesCF.Rows.Add(item.NovNcode, item.NovCDescription, item.NovCtType);//item.Nca_Cdescription


            TempData["DtUsuariosCF"] = dtNovedadesCF;
            #endregion


            #region NovedadesCV
            String[] novedadesCV = Parametros.Where(x => x.id == 18).FirstOrDefault().valor.Split(','); //Se carga el listado descriptivo de las novedades
            List<parmbhExtractNoveades> NovedadesAgrupadasCV = new List<parmbhExtractNoveades>();

            Session["NovedadesCV"] = novedadesCV;


            if (novedadesCV.Length == 1 && string.IsNullOrEmpty(novedadesCV[0]))
            {
                NovedadesRelacionadas = new List<parmbhExtractNoveades>();
            }
            else
            {
                NovedadesRelacionadas = _svcComisiones.ObtenerListNovedades(novedadesCV).ToList();

                //Se cargan las novedades agrupadas
                NovedadesAgrupadasCV = (from busq in NovedadesRelacionadas
                                        group busq by new { busq.NovNcode, busq.NovCDescription, busq.NovCtType } into grupoNovedad
                                        select new parmbhExtractNoveades()
                                        {
                                            NovNcode = grupoNovedad.Key.NovNcode,
                                            NovCDescription = grupoNovedad.Key.NovCDescription,
                                            NovCtType = grupoNovedad.Key.NovCtType
                                        }).ToList();
            }
            


            DataTable dtNovedadesCV = new DataTable();
            dtNovedadesCV.Columns.Add("NovNcode");
            dtNovedadesCV.Columns.Add("NovCDescription");
            dtNovedadesCV.Columns.Add("NovCtType");
            //dtNovedadesCF.Columns.Add("Nca_Cdescription");

            foreach (var item in NovedadesAgrupadasCV)
                dtNovedadesCV.Rows.Add(item.NovNcode, item.NovCDescription, item.NovCtType);


            TempData["DtUsuariosCV"] = dtNovedadesCV;
            #endregion


            #region  NovedadesREN
            String[] novedadesRen = Parametros.Where(x => x.id == 19).FirstOrDefault().valor.Split(','); //Se carga el listado descriptivo de las novedades
           
            Session["NovedadesRen"] = novedadesRen;
            
            List<parmbhExtractNoveades> NovedadesAgrupadasRen= new List<parmbhExtractNoveades>();

            if (novedadesRen.Length == 1 && string.IsNullOrEmpty(novedadesRen[0]))
                NovedadesAgrupadasRen = new List<parmbhExtractNoveades>();
            else
            {
                NovedadesRelacionadas = _svcComisiones.ObtenerListNovedades(novedadesRen).ToList();
                //Se cargan las novedades agrupadas
                NovedadesAgrupadasRen = (from busq in NovedadesRelacionadas
                                         group busq by new { busq.NovNcode, busq.NovCDescription, busq.NovCtType } into grupoNovedad
                                         select new parmbhExtractNoveades()
                                         {
                                             NovNcode = grupoNovedad.Key.NovNcode,
                                             NovCDescription = grupoNovedad.Key.NovCDescription,
                                             NovCtType = grupoNovedad.Key.NovCtType
                                         }).ToList();

            }

            

            DataTable dtNovedadesRen = new DataTable();
            dtNovedadesRen.Columns.Add("NovNcode");
            dtNovedadesRen.Columns.Add("NovCDescription");
            dtNovedadesRen.Columns.Add("NovCtType");

            foreach (var item in NovedadesAgrupadasRen)
                dtNovedadesRen.Rows.Add(item.NovNcode, item.NovCDescription, item.NovCtType);


            TempData["DtUsuariosREN"] = dtNovedadesRen;
            #endregion

            return View();
        }

        public ActionResult DetalleNovedades(string idNovedad)
        {
            _svcComisiones = new ComisionesSVC.ComisionesClient();

            List<parmbhExtractNoveades> NovedadesRelacionadas = _svcComisiones.ObtenerListNovedades(new string[]{idNovedad}).ToList();
            return Json(NovedadesRelacionadas, JsonRequestBehavior.AllowGet);
            
        }

        public ActionResult ListadoNovedadesAdd(string tipoNov)
        {

            _svcComisiones = new ComisionesSVC.ComisionesClient();

            string[] parametrosCOns = new string[1] { "17" };// = new string[4] { "17", "18", "19", "20" };//Novedades Usarios CF, CV, Usuarios Renovados, Beneficiarios Vigentes

            switch (tipoNov)
            {
                case "CF":
                    parametrosCOns = new string[1] { "17"};//Novedades Usarios CF
                    break;
                case "CV":
                    parametrosCOns = new string[1] { "18" };//Novedades Usarios CV
                    break;
                case "REN":
                    parametrosCOns = new string[1] { "19" };//Usuarios Renovados
                    break;
                case "VIG":
                    break;
                default:
                    break;
            }

            List<ConfigParametros> Parametros = _svcComisiones.ObtenerParametros(parametrosCOns).ToList();

            //Se obtienen las novedades actuales en pos de quitarlas del lsitado general
            String[] novedades = Parametros.FirstOrDefault().valor.Split(','); //Se carga el listado descriptivo de las novedades
            List<parmbhExtractNoveades> NovedadesRelacionadas;
            List<parmbhExtractNoveades> NovedadesAgrupadas = new List<parmbhExtractNoveades>();

            if (novedades.Length == 1 && string.IsNullOrEmpty(novedades[0]))
                NovedadesRelacionadas = _svcComisiones.ObtenerListNovedadesAdd(new string[]{"-99"}).ToList(); //Se realiza el not int con un codigo inexsitente
            else
                NovedadesRelacionadas = _svcComisiones.ObtenerListNovedadesAdd(novedades).ToList();

                
            

            //Se cargan las novedades agrupadas
            NovedadesAgrupadas = (from busq in NovedadesRelacionadas
                                  group busq by new { busq.NovNcode, busq.NovCDescription, busq.NovCtType } into grupoNovedad
                                  select new parmbhExtractNoveades()
                                  {
                                      NovNcode = grupoNovedad.Key.NovNcode,
                                      NovCDescription = grupoNovedad.Key.NovCDescription,
                                      NovCtType = grupoNovedad.Key.NovCtType
                                  }).ToList();

            return Json(NovedadesAgrupadas, JsonRequestBehavior.AllowGet);
            
        
        }


        public ActionResult AddNovedad(string idNovedad, string tipoNov)
        {

            String[] novedades;
            

            _svcComisiones = new ComisionesSVC.ComisionesClient();
            var jsonSerializer = new JavaScriptSerializer();
            ResultadoOperacionBD rtaOperacion= new ResultadoOperacionBD();

            List<string> listExclusionVacio = new List<string>();
            string username = HttpContext.Session["userName"].ToString();
            switch (tipoNov)
            {
                case "1":// "CF"
                    novedades = (string[])Session["NovedadesCF"];

                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    Array.Resize(ref novedades, novedades.Length + 1);
                    novedades[novedades.Length - 1] = idNovedad;
                  
                    rtaOperacion = _svcComisiones.EditarParametro(17, String.Join(",", novedades), username);
                    break;
                case "2"://"CV"
                    novedades = (string[])Session["NovedadesCV"];
                     
                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    Array.Resize(ref novedades, novedades.Length + 1);
                    novedades[novedades.Length - 1] = idNovedad;

                    rtaOperacion = _svcComisiones.EditarParametro(18, String.Join(",", novedades), username);
                    break;
                case "3"://"REN"
                    novedades = (string[])Session["NovedadesREN"];
                     
                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    Array.Resize(ref novedades, novedades.Length + 1);
                    novedades[novedades.Length - 1] = idNovedad;

                    rtaOperacion = _svcComisiones.EditarParametro(19, String.Join(",", novedades),username);
                    break;
                case "4"://"VIG"
                    break;
                default:
                    break;
            }
             NovedadesUsuarios();
             rtaOperacion.MensajeError = "OK";
             return Json(rtaOperacion, JsonRequestBehavior.AllowGet);
        }

        public ActionResult EliminarNovedad(string idNovedad, string tipoNov)
        {

            String[] novedades;


            _svcComisiones = new ComisionesSVC.ComisionesClient();
            var jsonSerializer = new JavaScriptSerializer();
            ResultadoOperacionBD rtaOperacion = new ResultadoOperacionBD();
            List<string> itemsLista= new List<string>();
            List<string> listExclusionVacio = new List<string>();
            string username = HttpContext.Session["userName"].ToString();
            switch (tipoNov)
            {
                case "1"://"CF"
                    novedades = (string[])Session["NovedadesCF"];

                    
                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    itemsLista = novedades.ToList();
                    itemsLista.Remove(idNovedad);
                    rtaOperacion = _svcComisiones.EditarParametro(17, String.Join(",", itemsLista.ToArray()),username);
                    break;
                case "2"://"CV"
                    novedades = (string[])Session["NovedadesCV"];

                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    itemsLista = novedades.ToList();
                    itemsLista.Remove(idNovedad);
                    rtaOperacion = _svcComisiones.EditarParametro(18, String.Join(",", itemsLista.ToArray()),username);
                    break;
                case "3"://"REN"
                    novedades = (string[])Session["NovedadesREN"];
                    
                    listExclusionVacio = novedades.ToList();
                    listExclusionVacio.Remove(string.Empty);
                    novedades = listExclusionVacio.ToArray();

                    itemsLista = novedades.ToList();
                    itemsLista.Remove(idNovedad);
                    rtaOperacion = _svcComisiones.EditarParametro(19, String.Join(",", itemsLista.ToArray()),username);
                    break;
                case "4"://"VIG"
                    break;
                default:
                    break;
            }
            NovedadesUsuarios();
            rtaOperacion.MensajeError = "OK";
            return Json(rtaOperacion, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ActualizarBeneficiariosComision(string config)
        {
            _svcComisiones = new ComisionesSVC.ComisionesClient();
            var jsonSerializer = new JavaScriptSerializer();
            ResultadoOperacionBD rtaOperacion = new ResultadoOperacionBD();
            string username = HttpContext.Session["userName"].ToString();
            rtaOperacion = _svcComisiones.EditarParametro(20, config,username);
            rtaOperacion.MensajeError = "OK";
            return Json(rtaOperacion, JsonRequestBehavior.AllowGet);
        }

        

    }
}
