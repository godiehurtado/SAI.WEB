using System;
using System.Web.Mvc;
using System.Data;
using System.Text;
using System.Data.Linq;
using System.Collections;
using System.Web.UI.WebControls;
using System.Linq;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Drawing;
using System.Data.Objects;
using OfficeOpenXml;
using OfficeOpenXml.Style;

namespace ColpatriaSAI.UI.MVC.Views.Shared
{
    public static class Exportar
    {
        public static ActionResult Excel(DataSet Ds, string nombreArchivo, HttpRequestBase request, HttpResponseBase respuesta)
        {
            return new ExcelResult(Ds, nombreArchivo, request, respuesta);
        }
    }

    public class ExcelResult : ActionResult
    {
        //Row limits older excel verion per sheet, the row limit for excel 2003 is 65536
        const int limiteFila = 65000;
        private DataSet _Ds;
        private string _nombreArchivo;
        private HttpRequestBase _request;
        private HttpResponseBase _respuesta;

        public ExcelResult(DataTable Dt, string nombreArchivo, HttpRequestBase request, HttpResponseBase respuesta)
        {
            var ds = new DataSet();
            ds.Tables.Add(Dt.Copy());
            _Ds = ds;
            _nombreArchivo = nombreArchivo;
            _request = request;
            _respuesta = respuesta;
        }

        public ExcelResult(DataSet Ds, string nombreArchivo, HttpRequestBase request, HttpResponseBase respuesta)
        {
            _Ds = Ds;
            _nombreArchivo = nombreArchivo;
            _request = request;
            _respuesta = respuesta;
        }

        public override void ExecuteResult(ControllerContext context)
        {
            //var excelXml = obtenerXMLExcel(_Ds, _nombreArchivo);
            //_respuesta.WriteFile(Path.GetTempPath() + Path.GetTempFileName().Replace(".tmp",".xlsx"));
            context.HttpContext.Response.Buffer = true;
            context.HttpContext.Response.Clear();
            context.HttpContext.Response.AddHeader("content-disposition", "attachment; filename=" + _nombreArchivo);
            context.HttpContext.Response.ContentType = "application/vnd.openxmlformats-officedocument.SpreadsheetML.Sheet";
            context.HttpContext.Response.WriteFile(construirArchivo());//context.HttpContext.Server.MapPath("/CargueSAI/Presupuesto/" + _nombreArchivo)
            //archivo.SaveAs(_respuesta.OutputStream);
            //_respuesta.Clear();
            //_respuesta.AppendHeader("Content-disposition", "attachment; filename=" + _nombreArchivo);
            //_respuesta.ContentType = "application/vnd.openxmlformats-officedocument.SpreadsheetML.Sheet";//vnd.ms-excel
            //_respuesta.Write(excelXml);
            //_respuesta.Flush();
            //_respuesta.End();
        }

        private string construirArchivo()
        {
            FileInfo archivo = new FileInfo(System.Configuration.ConfigurationManager.AppSettings["RutaArchivos"] + "Presupuesto\\" + _nombreArchivo);
            if (File.Exists(archivo.FullName)) archivo.Delete();

            using (ExcelPackage excel = new ExcelPackage(archivo)) {
                foreach (DataTable Dt in _Ds.Tables) {
                    ExcelWorksheet ws = excel.Workbook.Worksheets.Add(Dt.TableName);
                    ws.Cells["A1"].LoadFromDataTable(Dt, true);

                    using (ExcelRange header = ws.Cells[1, 1, 1, Dt.Columns.Count]) {
                        header.Style.Font.Bold = true; // header.Style.Fill.PatternType = ExcelFillStyle.Solid;                      //Set Pattern for the background to Solid                    header.Style.Fill.BackgroundColor.SetColor(Color.FromArgb(79, 129, 189));  //Set color to dark blue                    header.Style.Font.Color.SetColor(Color.White);
                        header.AutoFitColumns(0);
                    }
                    //if (!Dt.TableName.StartsWith("1")) ws.Cells[1, 1, Dt.Rows.Count, Dt.Columns.Count].AutoFitColumns(0);
                }
                excel.Workbook.Properties.Title = _nombreArchivo;
                excel.Workbook.Properties.Author = "SAI";
                excel.Workbook.Properties.Comments = "Formato necesario para ejecutar el cargue de presupuesto indicando las comvenciones de metas y códigos de nivel";
                excel.Workbook.Properties.Company = "Colpatria - Unidad de Inversión";
                excel.Save();
            }
            return archivo.FullName;// "http:////" + _request.ServerVariables["LOCAL_ADDR"] + (_request.Url.Host != null ? (":" + Convert.ToString(_request.Url.Port)) : "") + "//CargueSAI//Presupuesto//Formato%20cargue%20de%20Presupuestos.xlsx";
        }

        //public static string obtenerXMLExcel(DataSet Ds, string filename)
        //{
        //    var excelTemplate = obtenerPlantillaLibro();
        //    var worksheets = obtenerHojasLibro(Ds);
        //    var excelXml = string.Format(excelTemplate, worksheets);
        //    return excelXml;
        //}

        ////public static string obtenerXMLExcel(DataTable Dt, string nombreArchivo)
        ////{
        ////    var plantillaExcel = obtenerPlantillaLibro();
        ////    var ds = new DataSet();
        ////    ds.Tables.Add(Dt.Copy());
        ////    var hojas = obtenerHojasLibro(ds);
        ////    var excelXml = string.Format(plantillaExcel, hojas);
        ////    return excelXml;
        ////}

        //private static string obtenerHojasLibro(DataSet Ds)
        //{
        //    var sw = new StringWriter();
        //    if (Ds == null || Ds.Tables.Count == 0) {
        //        sw.Write("<Worksheet ss:Name=\"Sheet1\">\r\n<Table>\r\n<Row><Cell><Data ss:Type=\"String\"></Data></Cell></Row>\r\n</Table>\r\n</Worksheet>");
        //        return sw.ToString();
        //    }
        //    foreach (DataTable dt in Ds.Tables) {
        //        if (dt.Rows.Count == 0)
        //            sw.Write("<Worksheet ss:Name=\"" + reemplazarXmlCar(dt.TableName) + "\">\r\n<Table>\r\n<Row><Cell  ss:StyleID=\"s62\"><Data ss:Type=\"String\"></Data></Cell></Row>\r\n</Table>\r\n</Worksheet>");

        //        else {
        //            // Escribir cada data row
        //            var sheetCount = 0;
        //            for (int i = 0; i < dt.Rows.Count; i++) {
        //                if ((i % limiteFila) == 0) {
        //                    // Agregar etiquetas de cierre hojas previas del mismo data table
        //                    if ((i / limiteFila) > sheetCount) {
        //                        sw.Write("\r\n</Table>\r\n</Worksheet>");
        //                        sheetCount = (i / limiteFila);
        //                    }
        //                    // Escribir el nombre de la columna de la fila
        //                    sw.Write("\r\n<Worksheet ss:Name=\"" + reemplazarXmlCar(dt.TableName) + 
        //                        (((i / limiteFila) == 0) ? "" : Convert.ToString(i / limiteFila)) + "\">\r\n<Table>");
        //                    sw.Write("\r\n<Row>");

        //                    foreach (DataColumn dc in dt.Columns)
        //                        sw.Write(string.Format("<Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">{0}</Data></Cell>", reemplazarXmlCar(dc.ColumnName)));
        //                    sw.Write("</Row>");
        //                }
        //                sw.Write("\r\n<Row>");

        //                foreach (DataColumn dc in dt.Columns) sw.Write(obtenerCelda(dc.DataType, dt.Rows[i][dc.ColumnName]));
        //                sw.Write("</Row>");
        //            }
        //            sw.Write("\r\n</Table>\r\n</Worksheet>");
        //        }
        //    }

        //    return sw.ToString();
        //}

        //private static string obtenerCelda(Type tipo, object datoCelda)
        //{
        //    var data = (datoCelda is DBNull) ? "" : datoCelda;
        //    if (tipo.Name.Contains("Int") || tipo.Name.Contains("Double") || tipo.Name.Contains("Decimal"))
        //        return string.Format("<Cell><Data ss:Type=\"Number\">{0}</Data></Cell>", data);

        //    if (tipo.Name.Contains("Date") && data.ToString() != string.Empty)
        //        return string.Format("<Cell ss:StyleID=\"s63\"><Data ss:Type=\"DateTime\">{0}</Data></Cell>", Convert.ToDateTime(data).ToString("yyyy-MM-dd"));

        //    return string.Format("<Cell><Data ss:Type=\"String\">{0}</Data></Cell>", reemplazarXmlCar(data.ToString()));
        //}

        //private static string obtenerPlantillaLibro()
        //{
        //    var sb = new StringBuilder(818);
        //    sb.AppendFormat(@"<?xml version=""1.0""?>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"<?mso-application progid=""Excel.Sheet""?>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"<Workbook xmlns=""urn:schemas-microsoft-com:office:spreadsheet""{0}", Environment.NewLine);
        //    sb.AppendFormat(@" xmlns:o=""urn:schemas-microsoft-com:office:office""{0}", Environment.NewLine);
        //    sb.AppendFormat(@" xmlns:x=""urn:schemas-microsoft-com:office:excel""{0}", Environment.NewLine);
        //    sb.AppendFormat(@" xmlns:ss=""urn:schemas-microsoft-com:office:spreadsheet""{0}", Environment.NewLine);
        //    sb.AppendFormat(@" xmlns:html=""http://www.w3.org/TR/REC-html40"">{0}", Environment.NewLine);
        //    sb.AppendFormat(@" <Styles>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  <Style ss:ID=""Default"" ss:Name=""Normal"">{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Alignment ss:Vertical=""Bottom""/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Borders/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Font ss:FontName=""Calibri"" x:Family=""Swiss"" ss:Size=""11"" ss:Color=""#000000""/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Interior/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <NumberFormat/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Protection/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  </Style>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  <Style ss:ID=""s62"">{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <Font ss:FontName=""Calibri"" x:Family=""Swiss"" ss:Size=""11"" ss:Color=""#000000""{0}", Environment.NewLine);
        //    sb.AppendFormat(@"    ss:Bold=""1""/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  </Style>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  <Style ss:ID=""s63"">{0}", Environment.NewLine);
        //    sb.AppendFormat(@"   <NumberFormat ss:Format=""Short Date""/>{0}", Environment.NewLine);
        //    sb.AppendFormat(@"  </Style>{0}", Environment.NewLine);
        //    sb.AppendFormat(@" </Styles>{0}", Environment.NewLine);
        //    sb.Append(@"{0}\r\n</Workbook>");
        //    return sb.ToString();
        //}

        //private static string reemplazarXmlCar(string input)
        //{
        //    input = input.Replace("&", "&amp");
        //    input = input.Replace("<", "&lt;");
        //    input = input.Replace(">", "&gt;");
        //    input = input.Replace("\"", "&quot;");
        //    input = input.Replace("'", "&apos;");
        //    return input;
        //}
    }
}