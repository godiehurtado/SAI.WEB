using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.Negocio.Componentes;
using ColpatriaSAI.Negocio.Entidades;
using ColpatriaSAI.UI.MVC.Views.Shared;
using System.Web.Mvc.Ajax;
using ColpatriaSAI.UI.MVC.Models;
using PagedList;
using System.Threading;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography;
using System.Text;
using System.Net;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class PruebaController : Controller
    {
        WebPage web = new WebPage();
        Thread ejecucion = new Thread(() =>
        {
            Procesar();
        });

        public ActionResult Index()
        {
            //ejecucion.Name = "Pruebas";
            //ViewBag.estado_ini = ejecucion.IsAlive.ToString();
            ////ejecucion.Start();
            //ViewBag.estado_fin = ejecucion.IsAlive.ToString();
            
            //CreateMachineKey();

            var request = (FtpWebRequest)WebRequest.Create("ftp://10.132.82.232/NOM231O");
            request.Credentials = new NetworkCredential("usrftpsai", "ftpsai");
            request.Method = WebRequestMethods.Ftp.GetFileSize;

            try
            {
                FtpWebResponse response = (FtpWebResponse)request.GetResponse();
            }
            catch (WebException ex)
            {
                FtpWebResponse response = (FtpWebResponse)ex.Response;
                if (response.StatusCode ==
                    FtpStatusCode.ActionNotTakenFileUnavailable)
                {
                    //Does not exist
                }
            }


            return View(ViewBag);
        }

        public static void Procesar()
        {
            List<ParticipanteConcurso> part = new List<ParticipanteConcurso>();

            for (var i = 0; i < 100; i++)
            {
                //part.AddRange(web.AdministracionClient.ListarParticipanteConcursoes());
                Thread.Sleep(800);

            }
            
            
        }


        public ActionResult Resultado()
        {
            if (ejecucion.IsAlive)
                ViewBag.Alive = "SI";
            else
                ViewBag.Alive = "NO";
            //ViewBag.nombre = ejecucion.Name.ToString();
            return View(ViewBag);
        }



        public static void CreateMachineKey()
        {
            string[] commandLineArgs = null;
            commandLineArgs = System.Environment.GetCommandLineArgs();

            string decryptionKey = null;
            decryptionKey = CreateKey(24);
            string validationKey = null;
            validationKey = CreateKey(64);

            Console.WriteLine("<machineKey validationKey='"+ validationKey +"' decryptionKey='" +decryptionKey +"' validation='SHA1' />");
        }

        public static string CreateKey(int numBytes)
        {
            RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
            byte[] buff = new byte[numBytes];

            rng.GetBytes(buff);

            return BytesToHexString(buff);
        }

        public static string BytesToHexString(byte[] bytes)
        {
            StringBuilder hexString = new StringBuilder(64);
            int counter = 0;

            for (counter = 0; counter <= bytes.Length - 1; counter++)
            {
                hexString.Append(string.Format("{0:X2}", bytes[counter]));
            }

            return hexString.ToString();
        }


    }
}
