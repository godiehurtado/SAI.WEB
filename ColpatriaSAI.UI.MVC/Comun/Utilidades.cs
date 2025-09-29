using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Web.Mvc;
using System.IO;
using System.Net;

namespace ColpatriaSAI.UI.MVC.Comun
{
    public static class Utilidades
    {
        private static WebPage web = new WebPage();
        private static string valoresWebConfig = web.AdministracionClient.ValoresWebConfigServicio();
        private static string[] valores = valoresWebConfig.Split(',');
        private static string ipFtp = valores[1];
        private static string user = valores[2];
        private static string pass = valores[3];
        private static string rutaFTPCargue = valores[6];
        public const int BUFFER_SIZE = 100000;

        public static int TraerSegmentodelUsuario()
        {
            string nombreUsuario = (string)HttpContext.Current.Session["username"];
            List<UsuarioxSegmento> SegmentodelUsuario = new List<UsuarioxSegmento>();
            SegmentodelUsuario = new WebPage().AdministracionClient.ListarSegmentodelUsuario();
            return (int)SegmentodelUsuario.Single(sdu => sdu.userName == nombreUsuario).segmento_id;
        }

        /// <summary>Inicializa la carpeta de cargue de archivos</summary>
        /// <param name="patron">Patrón de busqueda de archivos</param>
        public static void setCarpetaCarge(string patron, string rutaArchivos)
        {
            string[] archivos = Directory.GetFiles(rutaArchivos, patron); foreach (string file in archivos) System.IO.File.Delete(file);
        }

        public static bool subirArchivoFtp(string rutaArchivos, string nombreArchivo, HttpPostedFileBase file)
        {
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create("ftp://" + ipFtp + rutaFTPCargue + nombreArchivo);
            request.Method = WebRequestMethods.Ftp.UploadFile;
            request.Credentials = new NetworkCredential(user, pass);

            try
            {
                using (Stream sourceStream = file.InputStream)
                using (Stream requestStream = request.GetRequestStream())
                {
                    request.ContentLength = sourceStream.Length;
                    byte[] buffer = new byte[BUFFER_SIZE];
                    int bytesRead = sourceStream.Read(buffer, 0, BUFFER_SIZE);
                    do
                    {
                        requestStream.Write(buffer, 0, bytesRead);
                        bytesRead = sourceStream.Read(buffer, 0, BUFFER_SIZE);
                    } while (bytesRead > 0);
                }
                FtpWebResponse response = (FtpWebResponse)request.GetResponse();

                if (response.StatusDescription.Contains("226")) return true;
            }
            catch { return false; }
            return false;
        }
    }
}