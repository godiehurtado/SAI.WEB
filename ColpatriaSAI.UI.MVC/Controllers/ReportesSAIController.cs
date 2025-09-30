using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using ColpatriaSAI.UI.MVC.Comun;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Net;
using System.IO;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ReportesSAIController : ControladorBase
    {
        WebPage web = new WebPage();        

        public ActionResult Index()
        {
            ViewBag.FTPReportes = new AppSettingsReader().GetValue("FTPReportes", String.Empty.GetType()).ToString();
            return View();
        }

        public ActionResult Etl()
        {
            List<ETLRemota> etlRemotas = ETL.ListarETLsRemotasporTipo(2);
            ViewBag.ETLs = new SelectList(etlRemotas, "id", "nombre");
            List<Compania> companias = web.AdministracionClient.ListarCompanias();
            companias.Insert(0, new Compania() { id = 0, nombre = "Todas" });
            ViewBag.Companias = new SelectList(companias, "id", "nombre");

            List<Localidad> localidades = web.AdministracionClient.ListarLocalidades().Where(x => x.zona_id == 9).OrderByDescending(x => x.nombre).ToList();
            localidades.Insert(0, new Localidad() { id = 0, nombre = "Todas" });
            ViewBag.Localidad = new SelectList(localidades, "id", "nombre");

            return View();
        }

        public ActionResult Reportesftp(string path = "")
        {
            try
            {
                //string ftpServer = "ftp://ftppru.axacolpatria.co:21/SalidaSAI/Reportes/";
                //string fullPath = ftpServer + path;
                //string userName = "usrftpsai";
                //string password = @"ToE\PP7N*PztpL/*\_*";

                string ftpServer = new AppSettingsReader().GetValue("FTPReportes", String.Empty.GetType()).ToString();
                string fullPath = ftpServer + path;
                string userName = new AppSettingsReader().GetValue("FTPusername", String.Empty.GetType()).ToString();
                string password = new AppSettingsReader().GetValue("FTPpass", String.Empty.GetType()).ToString();

                FtpWebRequest request = (FtpWebRequest)WebRequest.Create(fullPath);
                request.Method = WebRequestMethods.Ftp.ListDirectoryDetails;
                request.Credentials = new NetworkCredential(userName, password);
                request.UsePassive = true;
                request.UseBinary = true;
                request.EnableSsl = false;

                string[] principalFolder = path.Split(new[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
                string principalName = "";
                if (principalFolder.Count() > 0)
                {
                    principalName = principalFolder[0].Replace("/", "");
                }

                List<FtpItem> items = new List<FtpItem>();

                using (FtpWebResponse response = (FtpWebResponse)request.GetResponse())
                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    while (!reader.EndOfStream)
                    {
                        string line = reader.ReadLine();
                        bool isDirectory = line.StartsWith("d");
                        string[] details = line.Split(new[] { "          " }, StringSplitOptions.RemoveEmptyEntries);
                        string[] splitname = details[details.Length - 1].Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                        int index = Array.FindIndex(splitname, s => s.Contains(principalName));
                        string name = "";
                        if(principalName != "" && index != -1)
                        {
                            for (int i = index; i < splitname.Length; i++)
                            {
                                name = name + splitname[i] + " ";
                            }
                        }
                        else
                        {
                            name = splitname[splitname.Length - 2] + " " + splitname[splitname.Length - 1];
                        }

                        name = name.TrimEnd();
                        
                        string[] splitdate = name.Split(new[] { '_' }, StringSplitOptions.RemoveEmptyEntries);
                        string dateString = splitdate[splitdate.Length - 1].Replace(".csv", "").Replace('.',':');
                        DateTime lastModified = new DateTime();
                        bool isDate = DateTime.TryParse(dateString, out lastModified);

                        if (isDate)
                        {
                            items.Add(new FtpItem
                            {
                                Name = name,
                                LastModified = lastModified,
                                IsDirectory = isDirectory
                            });
                        }
                    }
                }

                items = items.OrderByDescending(i => i.LastModified).ToList();

                ViewBag.CurrentPath = path;
                return View(items);
            }
            catch (Exception ex)
            {
                return new HttpStatusCodeResult((int)HttpStatusCode.InternalServerError, ex.Message);
            }
        }

        /// <summary>
        /// Esta acción permite redireccionar a la página de visualización de reportes, enviando el reporte correspondiente como parametro
        /// </summary>
        /// <param name="id">Nombre del reporte a visualizar</param>
        /// <returns>Redirecciona a la página de visualización y descarga de reportes, con el reporte correspondiente</returns>
        public ActionResult VerReporte(String id)
        {
            String url = "~/Reportes/verReporte.aspx?Reporte={0}&Formato=CSV";

            switch (id)
            {
                case "ReportEjecutivo":
                    url += "&GP=false";
                    break;
                case "ReportAsesor":
                    id = "ReportEjecutivo";
                    url += "&GP=true";
                    break;
                case "ReporteConsolidadoRecaudos":
                    id = "ReporteConsolidadoporTipoMedida";
                    url += "&tipoMedida_id=1";
                    break;
                case "ReporteConsolidadoPrimas":
                    id = "ReporteConsolidadoporTipoMedida";
                    url += "&tipoMedida_id=3";
                    break;
            }

            return Redirect(String.Format(url, id));
        }

        [HttpPost]
        public ActionResult GenerarReporte(FormCollection collection)
        {
            try
            {
                List<ETLRemota> etlRemotas = ETL.ListarETLsRemotasporTipo(2);
                int etl_id = int.Parse(collection["etl_id"]);
                ETLRemota etl = etlRemotas.Where(e => e.id == etl_id).First();

                Dictionary<string, object> parametros = new Dictionary<string, object>();
                switch (etl_id)
                {
                    case 2:
                    case 5:
                    case 7:
                        parametros.Add("Compania_id", int.Parse(collection["compania_id"]));
                        parametros.Add("FechaInicio", DateTime.Parse(collection["fecha_ini"]));
                        parametros.Add("FechaFin", DateTime.Parse(collection["fecha_fin"]));
                        break;
                    case 3:
                    case 4:
                    case 6:
                    case 14:
                    case 15:
                        parametros.Add("Compania_id", int.Parse(collection["compania_id"]));
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        parametros.Add("MesInicio", int.Parse(collection["mes_ini"]));
                        parametros.Add("MesFin", int.Parse(collection["mes_fin"]));
                        break;
                    case 8:
                    case 16:
                    case 17:
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        if (etl_id == 16) { parametros.Add("TipoMedida_id", 1); }
                        if (etl_id == 17) { parametros.Add("TipoMedida_id", 3); }
                        break;
                    case 9:
                        parametros.Add("Compania_id", int.Parse(collection["compania_id"]));
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        break;
                    case 10:
                    case 11:
                        parametros.Add("FechaInicio", DateTime.Parse(collection["fecha_ini"]));
                        break;
                    case 13:
                        break;
                    case 28:
                        parametros.Add("IDlocalidad", Convert.ToInt16(collection["localidad_id"]));
                        parametros.Add("IDfranquicia", Convert.ToInt16(collection["Parametros_id"]));
                        break;
                    case 33:
                        parametros.Add("Compania_id", 1);
                        parametros.Add("Ramo_id", 9);
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        parametros.Add("MesInicio", int.Parse(collection["mes_ini"]));
                        parametros.Add("MesFin", int.Parse(collection["mes_fin"]));
                        break;
                    case 34:
                        parametros.Add("Compania_id", 4);
                        parametros.Add("Ramo_id", 41);
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        parametros.Add("MesInicio", int.Parse(collection["mes_ini"]));
                        parametros.Add("MesFin", int.Parse(collection["mes_fin"]));
                        break;
                    case 36:
                        parametros.Add("Compania_id", 3);
                        parametros.Add("Ramo_id", 17);
                        parametros.Add("Anio", int.Parse(collection["anio"]));
                        parametros.Add("MesInicio", int.Parse(collection["mes_ini"]));
                        parametros.Add("MesFin", int.Parse(collection["mes_fin"]));
                        break;
                    case 31:
                        parametros.Add("idLocalidad", Convert.ToInt16(collection["localidad_id"]));
                        break;
                    case 35:
                        parametros.Add("FechaInicio", DateTime.Parse(collection["fecha_ini"]));
                        break;
                }

                ETL.EjecutarETL(etl, parametros, Sesion.VariablesSesion());
            }
            catch
            {
                return RedirectToAction("Index");
            }

            return RedirectToAction("Index");
        }

        /// <summary>
        /// Funcion que se encarga de traer las localidades por franquicias
        /// </summary>
        /// <param name="localidadID">Identificador de la localidad</param>
        /// <returns>Rango de fechas parametrizadas</returns>
        [AcceptVerbs(HttpVerbs.Get)]
        public ActionResult getParamParticipacionFranquiciaByLocalidad(int localidadID)
        {
            return Json(web.AdministracionClient.ListarPartFranquiciasPorlocalidad(localidadID).Select(r => new { r.rangoParametros, r.id }), JsonRequestBehavior.AllowGet);
        }

        public ActionResult DescargarReporte(string fileName)
        {
            try
            {
                // Configuración del FTP
                //string ftpServer = "ftp://ftppru.axacolpatria.co:21/SalidaSAI/Reportes/";
                //string ftpPath = ftpServer + fileName;
                //string userName = "usrftpsai";
                //string password = @"ToE\PP7N*PztpL/*\_*";

                string ftpServer = new AppSettingsReader().GetValue("FTPReportes", String.Empty.GetType()).ToString();
                string ftpPath = ftpServer + fileName;
                string userName = new AppSettingsReader().GetValue("FTPusername", String.Empty.GetType()).ToString();
                string password = new AppSettingsReader().GetValue("FTPpass", String.Empty.GetType()).ToString();

                // Configurar la solicitud FTP
                FtpWebRequest request = (FtpWebRequest)WebRequest.Create(ftpPath);
                request.Method = WebRequestMethods.Ftp.DownloadFile;
                request.Credentials = new NetworkCredential(userName, password);
                request.UsePassive = true;
                request.UseBinary = true;
                request.EnableSsl = false;

                // Obtener la respuesta del servidor FTP
                using (FtpWebResponse response = (FtpWebResponse)request.GetResponse())
                using (Stream responseStream = response.GetResponseStream())
                {
                    if (responseStream != null)
                    {
                        byte[] buffer = new byte[2048];
                        using (MemoryStream memoryStream = new MemoryStream())
                        {
                            int bytesRead;
                            while ((bytesRead = responseStream.Read(buffer, 0, buffer.Length)) > 0)
                            {
                                memoryStream.Write(buffer, 0, bytesRead);
                            }

                            string[] splitname = fileName.Split(new[] { "/" }, StringSplitOptions.RemoveEmptyEntries);
                            string name = splitname[splitname.Length - 1];
                            // Retornar el archivo descargado al cliente
                            return File(memoryStream.ToArray(), "application/octet-stream", name);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Manejo de errores
                return new HttpStatusCodeResult((int)HttpStatusCode.InternalServerError, ex.Message);
            }

            return new HttpStatusCodeResult((int)HttpStatusCode.NotFound);
        }
    }

    public class FtpItem
    {
        public string Name { get; set; }
        public DateTime LastModified { get; set; }
        public bool IsDirectory { get; set; }
    }
}
