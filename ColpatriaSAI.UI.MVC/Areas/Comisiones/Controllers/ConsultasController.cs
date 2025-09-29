using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels;
using System.Data;
using ColpatriaSAI.Negocio.Componentes.Comision.Consultas;
using ColpatriaSAI.Datos;
using System.Web.Script.Serialization;
using System.IO;
using ColpatriaSAI.UI.MVC.Controllers;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Controllers
{
    public class ConsultasController : ControladorBase
    {
        private ConsultasComisionesSVC.BitacoraCalculoClient _svcTableroClient;

        public ActionResult bitacoraPorCalculo()
        {

            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();

            //Se listan los usuarios
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.ListadoUsuarios> UsuariosFiltrados = _svcTableroClient.ListadoUsuariosCalculoComison().ToList();
            DataTable dtUsuarios = new DataTable();
            dtUsuarios.Columns.Add("codigoextraccion");
            dtUsuarios.Columns.Add("usersEntrantes");
            dtUsuarios.Columns.Add("UsuariosSalientes");

            foreach (var item in UsuariosFiltrados)
            {
                dtUsuarios.Rows.Add(item.numExtraccion, item.usuariosEntrantes, item.UsuariosSalientes);
            }
            TempData["LogUsuarios"] = dtUsuarios;

            //Se listas las facturas
            UsuariosFiltrados = _svcTableroClient.ListadoFacturasCalculoComison().ToList();
            dtUsuarios = new DataTable();
            dtUsuarios.Columns.Add("codigoextraccion");
            dtUsuarios.Columns.Add("usersEntrantes");
            dtUsuarios.Columns.Add("UsuariosSalientes");
            foreach (var item in UsuariosFiltrados)
            {
                dtUsuarios.Rows.Add(item.numExtraccion, item.usuariosEntrantes, item.UsuariosSalientes);
            }
            TempData["LogFacturas"] = dtUsuarios;

            //Se listan los recaudos
            UsuariosFiltrados = _svcTableroClient.ListadoRecaudosCalculoComison().ToList();
            dtUsuarios = new DataTable();
            dtUsuarios.Columns.Add("codigoextraccion");
            dtUsuarios.Columns.Add("usersEntrantes");
            dtUsuarios.Columns.Add("UsuariosSalientes");

            foreach (var item in UsuariosFiltrados)
            {
                dtUsuarios.Rows.Add(item.numExtraccion, item.usuariosEntrantes, item.UsuariosSalientes);
            }
            TempData["LogRecaudos"] = dtUsuarios;

            return View();
        }

        public ActionResult DetalleUsuarios(string codExtraccion)
        {
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.DetalleUsuarios> UsuariosFiltrados = _svcTableroClient.DetalleUsuariosCalculoComison(codExtraccion).ToList();

            return Json(UsuariosFiltrados, JsonRequestBehavior.AllowGet);
        }

        public ActionResult DetalleFacturacion(string codExtraccion)
        {
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.DetalleFacturas> DetalleFacturas = _svcTableroClient.DetalleFactura(codExtraccion).ToList();

            return Json(DetalleFacturas, JsonRequestBehavior.AllowGet);
        }


        public ActionResult DetalleRecaudo(string codExtraccion)
        {
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.DetalleFacturas> DetalleRecaudo = _svcTableroClient.DetalleRecaudo(codExtraccion).ToList();

            return Json(DetalleRecaudo, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ExcelDetalleUsuarios(string codExtraccion, string tipoLog, string idUsuario, int exportar)
        {
            TempData["CodExtraccion"] = codExtraccion;
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            string tipoDecodificiado = "";
            switch (tipoLog)
            {
                case "Usuario sin Ramo":
                    tipoDecodificiado = "SIN RAMO";
                    break;
                case "Usuario sin Producto":
                    tipoDecodificiado = "SIN PRODUCTO";
                    break;
                case "Usuario sin Plan":
                    tipoDecodificiado = "SIN PLAN";
                    break;
                case "Usuario sin Tipo Contrato":
                    tipoDecodificiado = "SIN TIPO CONTRATO";
                    break;
                case "Usuario sin Tipo Documento":
                    tipoDecodificiado = "SIN TIPO DOCUMENTO";
                    break;
                case "Usuario sin Modalidad Pago":
                    tipoDecodificiado = "SIN MODALIDAD PAGO";
                    break;
                case "Usuario sin Modalidad Financiacion":
                    tipoDecodificiado = "SIN MODALIDAD FINANCIACION";
                    break;
                case "Usuario sin Tipo Beneficiario":
                    tipoDecodificiado = "SIN TIPO BENEFICIARIO";
                    break;
                case "Usuario sin Estado Beneficiario":
                    tipoDecodificiado = "SIN ESTADO BENEFICIARIO";
                    break;
                case "Usuarios sin asesor":
                    tipoDecodificiado = "SIN ASESOR";
                    break;

            }

            //Si se realzia un filtrado por usuarios consutruyo el parametro para la sentencia in en el where
            if (!string.IsNullOrEmpty(idUsuario))
            {
                string[] vIdUsuario = idUsuario.Split(',');
                idUsuario = "";
                foreach (var item in vIdUsuario)
                    idUsuario += "'" + item.Trim() + "',";

                idUsuario = idUsuario.Substring(0, idUsuario.Length - 1);//se quita la coma (,) al final
            }

            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtraccionBH>
                UsuariosFiltrados = _svcTableroClient.ExcelDetalleUsuario(codExtraccion, tipoDecodificiado, idUsuario).ToList();

            if (exportar == 1)
                ExportToExcel(UsuariosFiltrados);

            return Json(UsuariosFiltrados, JsonRequestBehavior.AllowGet);
        }


        public ActionResult ExcelDetalleFactura(string codExtraccion, string tipoLog, int exportar)
        {
            TempData["CodExtraccion"] = codExtraccion;
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            string tipoDecodificiado = "";
            switch (tipoLog)
            {
                case "Usuario sin Ramo":
                    tipoDecodificiado = "SIN RAMO";
                    break;
                case "Usuario sin Producto":
                    tipoDecodificiado = "SIN PRODUCTO";
                    break;
                case "Usuario sin Plan":
                    tipoDecodificiado = "SIN PLAN";
                    break;
                case "Usuario sin Tipo Contrato":
                    tipoDecodificiado = "SIN TIPO CONTRATO";
                    break;
                case "Usuario sin Tipo Documento":
                    tipoDecodificiado = "SIN TIPO DOCUMENTO";
                    break;
                case "Usuario sin Modalidad Pago":
                    tipoDecodificiado = "SIN MODALIDAD PAGO";
                    break;
                case "Usuario sin Modalidad Financiacion":
                    tipoDecodificiado = "SIN MODALIDAD FINANCIACION";
                    break;
                case "Usuario sin Tipo Beneficiario":
                    tipoDecodificiado = "SIN TIPO BENEFICIARIO";
                    break;
                case "Usuario sin Estado Beneficiario":
                    tipoDecodificiado = "SIN ESTADO BENEFICIARIO";
                    break;
                case "Usuarios sin asesor":
                    tipoDecodificiado = "SIN ASESOR";
                    break;

            }

            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtFacturacion>
                UsuariosFiltrados = _svcTableroClient.ExcelDetalleFactura(codExtraccion, tipoDecodificiado).ToList();

            if (exportar == 1)
                ExportToExcelFac(UsuariosFiltrados);

            return Json(UsuariosFiltrados, JsonRequestBehavior.AllowGet);
        }

        public ActionResult ExcelDetalleRecaudo(string codExtraccion, string tipoLog, int exportar)
        {
            TempData["CodExtraccion"] = codExtraccion;
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
           
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtracionRecaudo>
                UsuariosFiltrados = _svcTableroClient.ExcelDetalleRecaudo(codExtraccion, tipoLog).ToList();

            if (exportar == 1)
                ExportToExcelRec(UsuariosFiltrados);

            return Json(UsuariosFiltrados, JsonRequestBehavior.AllowGet);
        }


        public void ExportToExcelFac(List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtFacturacion> myList)
        {
            string fileName = "DetalleFacturacion.xls";

            System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();
            dg.AllowPaging = false;
            dg.DataSource = myList;
            dg.DataBind();

            System.Web.HttpContext.Current.Response.Clear();
            System.Web.HttpContext.Current.Response.Buffer = true;
            //System.Web.HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            System.Web.HttpContext.Current.Response.Charset = "";
            System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition",
              "attachment; filename=" + fileName);

            System.Web.HttpContext.Current.Response.ContentType =
              "application/vnd.ms-excel";
            System.IO.StringWriter stringWriter = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlTextWriter =
              new System.Web.UI.HtmlTextWriter(stringWriter);
            dg.RenderControl(htmlTextWriter);
            System.Web.HttpContext.Current.Response.Write(stringWriter.ToString());
            System.Web.HttpContext.Current.Response.End();
        }

        public void ExportToExcel(List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtraccionBH> myList)
        {
            string fileName = "DetalleUsuarios.xls";

            System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();
            dg.AllowPaging = false;
            dg.DataSource = myList;
            dg.DataBind();

            System.Web.HttpContext.Current.Response.Clear();
            System.Web.HttpContext.Current.Response.Buffer = true;
            //System.Web.HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            System.Web.HttpContext.Current.Response.Charset = "";
            System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition",
              "attachment; filename=" + fileName);

            System.Web.HttpContext.Current.Response.ContentType =
              "application/vnd.ms-excel";
            System.IO.StringWriter stringWriter = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlTextWriter =
              new System.Web.UI.HtmlTextWriter(stringWriter);
            dg.RenderControl(htmlTextWriter);
            System.Web.HttpContext.Current.Response.Write(stringWriter.ToString());
            System.Web.HttpContext.Current.Response.End();
        }

        public void ExportToExcelRec(List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.LogExtracionRecaudo> myList)
        {
            string fileName = "DetalleRecaudo.xls";

            System.Web.UI.WebControls.DataGrid dg = new System.Web.UI.WebControls.DataGrid();
            dg.AllowPaging = false;
            dg.DataSource = myList;
            dg.DataBind();

            System.Web.HttpContext.Current.Response.Clear();
            System.Web.HttpContext.Current.Response.Buffer = true;
            //System.Web.HttpContext.Current.Response.ContentEncoding = Encoding.UTF8;
            System.Web.HttpContext.Current.Response.Charset = "";
            System.Web.HttpContext.Current.Response.AddHeader("Content-Disposition",
              "attachment; filename=" + fileName);

            System.Web.HttpContext.Current.Response.ContentType =
              "application/vnd.ms-excel";
            System.IO.StringWriter stringWriter = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlTextWriter =
              new System.Web.UI.HtmlTextWriter(stringWriter);
            dg.RenderControl(htmlTextWriter);
            System.Web.HttpContext.Current.Response.Write(stringWriter.ToString());
            System.Web.HttpContext.Current.Response.End();
        } 

        public ActionResult FiltroLosUsuariosxFechas(string fechIni, string fechFin)
        {
            _svcTableroClient = new ConsultasComisionesSVC.BitacoraCalculoClient();
            List<ColpatriaSAI.Negocio.Componentes.Comision.Consultas.ListadoUsuarios> UsuariosFiltrados = _svcTableroClient.ListadoUsuariosCalculoComisonPorFechas(fechIni, fechFin).ToList();

            return Json(UsuariosFiltrados, JsonRequestBehavior.AllowGet);
        }



    }
}