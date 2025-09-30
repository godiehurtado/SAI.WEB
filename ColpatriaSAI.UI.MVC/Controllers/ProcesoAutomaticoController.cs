using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ColpatriaSAI.UI.MVC.Views.Shared;
using ColpatriaSAI.UI.MVC.Models;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    public class ProcesoAutomaticoController : ControladorBase
    {
        //
        // GET: /ProcesoAutomatico/
        WebPage web = new WebPage();

        static Dictionary<int, AUT_Proceso_Dependencia> dependenciasDic = new Dictionary<int, AUT_Proceso_Dependencia>();


        public ActionResult Index()
        {
            List<Ejecuciones> ejecucion = web.AdministracionClient.TraerUltimaEjecucion();
            List<AUT_Programacion_Proceso> programas = web.AdministracionClient.TraerUltimasFechasProgramacion();
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            return View(new EjecucionesViewModel
                {
                    idEjecucion = ejecucion.First().id_ejecucion.ToString(),
                    fechaInicio = ejecucion.First().fechaIncioEjecucion.ToString(),
                    fechaFin = ejecucion.First().fechaFinEjecucion.ToString(),
                    estado = ejecucion.First().estadoEjecucion,
                    ultimaFecha = programas[0].fecha_hora_inicio_ejecucion.ToString(),
                    penultimaFecha = programas[1].fecha_hora_inicio_ejecucion.ToString(),
                    procesos = procesos
                });
        }

        public JsonResult Consultar()
        {
            string fechainicio = Request["fechaEj"];
            List<Ejecuciones> ejecucion = new List<Ejecuciones>();
            if (String.IsNullOrWhiteSpace(fechainicio))
            {
                ejecucion = web.AdministracionClient.TraerUltimaEjecucion();
            }
            else
            {
                DateTime fechaini = DateTime.Parse(fechainicio);
                ejecucion = web.AdministracionClient.TraerEjecucion(fechaini);
            }

            string idEjecucion = String.Empty;
            string fechaInicio = String.Empty;
            string fechaFin = String.Empty;
            string estado = String.Empty;
            string htmlresultados = string.Empty;

            if (ejecucion.Count > 0)
            {
                idEjecucion = ejecucion.First().id_ejecucion.ToString();
                fechaInicio = ejecucion.First().fechaIncioEjecucion.ToString();
                fechaFin = ejecucion.First().fechaFinEjecucion.ToString();
                estado = ejecucion.First().estadoEjecucion;

                int consecutivo = 1;
                foreach (Ejecuciones ejecuciones in ejecucion)
                {
                    htmlresultados += "<tr><td>" +
                        (ejecuciones.estadoProceso == "TERMINADO" ?
                        "<i class=\"glyphicon glyphicon-thumbs-up\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color:Green;\"></i>" :
                        (ejecuciones.estadoProceso == "CON ERRORES" ?
                        "<i class=\"glyphicon glyphicon-thumbs-down\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color:Red;\"></i>" :
                        (ejecuciones.estadoProceso == "EN PROCESO" ?
                        "<i class=\"glyphicon glyphicon-refresh\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color:Blue;\"></i>" :
                        (ejecuciones.estadoProceso == "PENDIENTE GENERACION ARCHIVO" ?
                        "<i class=\"glyphicon glyphicon-time\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color:Violet;\"></i>" :
                        "<i class=\"glyphicon glyphicon-ban-circle\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color:Black;\"></i>"))))
                        +
                            "</td><td><a style=\"cursor:pointer;\" onclick=\"javascript:cargarDetalle('" + ejecuciones.nombreProceso.TrimStart() + consecutivo.ToString() + "')\" data-toggle=\"modal\" data-target=\"#myModal\">" + ejecuciones.nombreProceso +
                            "</a></td><td>" + ejecuciones.fechaInicioProceso.ToString() +
                            "</td><td>" + ejecuciones.fechaFinProceso.ToString() +
                            "</td><td>" + ejecuciones.estadoProceso +
                            "</td><td class=\"hidden-xs hidden-sm hidden-md hidden-lg\" style=\"width: 200px;float: left;white-space: pre;white-space: pre-wrap;white-space: pre-line;white-space: -pre-wrap;white-space: -o-pre-wrap;white-space: -moz-pre-wrap;white-space: -hp-pre-wrap;word-wrap: break-word;\"><p id=\"" + ejecuciones.nombreProceso + consecutivo.ToString() + "\">" + (ejecuciones.detalleProceso == null ? "</p></td></tr>" : ejecuciones.detalleProceso.Replace("<", "").Replace(">", "") + "</p></td></tr>");
                    consecutivo++;
                }
            }
            else
            {
                htmlresultados += "<tr><td>" + "No hay ejecuciones para este día" + "</td></tr>";
                fechaInicio = "";
                fechaFin = "";
                estado = "NO EJECUTADO";
            }
            
            return Json(new { Success = true, htmlresult = htmlresultados, idEjecucion = idEjecucion, fechaInicio = fechaInicio, fechaFin = fechaFin, estado = estado});
        }

        public JsonResult ConsultarProceso()
        {
            string idProceso = Request["idProceso"];
            List<AUT_Proceso_Dependencia> dependencias = web.AdministracionClient.TraerDependenciaPorProceso(int.Parse(idProceso));
            List<AUT_Tipo_Accion_En_Error> acciones = web.AdministracionClient.TraerAccionesEnError();
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            AUT_Proceso proceso = procesos.Where(x => x.id == int.Parse(idProceso)).FirstOrDefault();
            string nombreProceso = proceso.nombre_proceso;
            string maxReintentos = proceso.max_reintentos.ToString();
            string emailInicio = proceso.notificar_inicio;
            string emailFin = proceso.notificar_fin;
            string emailError = proceso.notificar_error;
            string htmlresultados = string.Empty;
            int contador = 1;
            if (dependencias.Count > 0)
            {
                foreach (AUT_Proceso_Dependencia dependencia in dependencias)
                {
                    dependenciasDic.Add(contador, dependencia);
                    htmlresultados += "<tr><td><label id=\"txtprocesodep" + contador.ToString() + "\">" + procesos.Where(x => x.id == dependencia.id_proceso_requerido).FirstOrDefault().nombre_proceso + "</label>"
                        + "<div id=\"divprocesodep" + contador.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnprocesodep" + contador.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\"" 
                        + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                        + procesos.Where(x => x.id == dependencia.id_proceso_requerido).FirstOrDefault().nombre_proceso + "<span class=\"caret\"></span></button>"
                        + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                    foreach(AUT_Proceso pro in procesos)
                    {
                        htmlresultados += "<li><a href=\"javascript:cambiarDependencia(" + pro.id.ToString() + ",'" + pro.nombre_proceso + "'," + contador.ToString() + ")\">" + pro.nombre_proceso + "</a></li>";
                    }

                    htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + contador.ToString() + "\">"
                        + acciones.Where(x => x.id_accion == dependencia.en_error_proceso_requerido).FirstOrDefault().nombre_accion + "</label>"
                        + "<div id=\"divacciondep" + contador.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnacciondep" + contador.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\"" 
                        + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                        + acciones.Where(x => x.id_accion == dependencia.en_error_proceso_requerido).FirstOrDefault().nombre_accion + "<span class=\"caret\"></span></button>"
                        + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                    foreach(AUT_Tipo_Accion_En_Error acc in acciones)
                    {
                        htmlresultados += "<li><a href=\"javascript:cambiarAccion(" + acc.id_accion.ToString() + ",'" + acc.nombre_accion + "'," + contador.ToString() + ")\">" + acc.nombre_accion + "</a></li>";
                    }

                    htmlresultados += "</ul></div></td><td>"
                        + "<a id=\"editardep" + contador.ToString() + "\" href=\"javascript:editarDependencia(" + contador.ToString() + ")\">"
                        + "<i class=\"glyphicon glyphicon-pencil\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                        + "<a id=\"guardardep" + contador.ToString() + "\" href=\"javascript:guardarDependencia(" + contador.ToString() + ")\" style=\"display: none;\">"
                        + "<i class=\"glyphicon glyphicon-floppy-disk\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                        + "<a href=\"javascript:eliminarDependencia(" + contador.ToString() + ")\">"
                        + "<i class=\"glyphicon glyphicon-trash\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Eliminar\"></i></a>" + "</td></tr>";
                    contador++;
                }
            }
            else
            {
                htmlresultados += "<tr><td>NO HAY DEPENDENCIAS</td></tr>";
            }
            
            return Json(new { Success = true, htmlresult = htmlresultados, nombreProceso = nombreProceso, maxReintentos = maxReintentos, emailInicio = emailInicio, emailFin = emailFin, emailError = emailError});
        }

        public JsonResult EncenderProceso()
        {
            DateTime fecha = DateTime.Parse(DateTime.Now.ToShortDateString()).AddHours(18);
            AUT_Programacion_Proceso programacion = new AUT_Programacion_Proceso();

            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            bool procesohabilidato = false;
            foreach (AUT_Proceso pro in procesos)
            {
                if (pro.habilitado == 1)
                {
                    procesohabilidato = true;
                }
            }

            if (procesohabilidato)
            {
                programacion.fecha_hora_inicio_ejecucion = fecha;
                web.AdministracionClient.InsertarProgramacion(programacion);
            }

            List<AUT_Programacion_Proceso> programas = web.AdministracionClient.TraerFechasProgramacion();
            string estadoProcesoAutomatico = String.Empty;
            string ultimaFechaEjecucion = String.Empty;
            string proximafechaejecucion = String.Empty;
            if (programas[0].fecha_hora_inicio_ejecucion > DateTime.Now)
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Green\">(Se encuentra encendido)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Red\">Apagar</h5>"
                            + "<a href=\"javascript:apagarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Red;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas.Where(x => x.fecha_hora_inicio_ejecucion < DateTime.Now).FirstOrDefault().fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + programas[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
            }
            else
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Red\">(Se encuentra apagado)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Green\">Encender</h5>"
                            + "<a href=\"javascript:encenderProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + "NO APLICA" + "</h4>";
            }
            if (procesohabilidato)
            {
                return Json(new { Success = true, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });
            }
            else
            {
                return Json(new { Success = false, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });
            }
        }

        public JsonResult ActivarProceso()
        {
            List<AUT_Programacion_Proceso> programas = web.AdministracionClient.TraerUltimasFechasProgramacion();
            bool resultado = true;
            if (programas[0].fecha_hora_inicio_ejecucion > DateTime.Now)
            {
                resultado = web.AdministracionClient.EliminarProgramacion(programas[0]);
            }
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            bool procesohabilidato = false;
            foreach (AUT_Proceso pro in procesos)
            {
                if (pro.habilitado == 1)
                {
                    procesohabilidato = true;
                }
            }

            if (procesohabilidato)
            {
                DateTime fecha = DateTime.Now.AddMinutes(2);
                AUT_Programacion_Proceso programacion = new AUT_Programacion_Proceso();
                programacion.fecha_hora_inicio_ejecucion = fecha;
                web.AdministracionClient.InsertarProgramacion(programacion);
            }

            programas = web.AdministracionClient.TraerFechasProgramacion();
            string estadoProcesoAutomatico = String.Empty;
            string ultimaFechaEjecucion = String.Empty;
            string proximafechaejecucion = String.Empty;
            if (programas[0].fecha_hora_inicio_ejecucion > DateTime.Now)
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Green\">(Se encuentra encendido)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Red\">Apagar</h5>"
                            + "<a href=\"javascript:apagarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Red;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas.Where(x => x.fecha_hora_inicio_ejecucion < DateTime.Now).FirstOrDefault().fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + programas[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
            }
            else
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Red\">(Se encuentra apagado)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Green\">Encender</h5>"
                            + "<a href=\"javascript:encenderProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + "NO APLICA" + "</h4>";
            }
            if (procesohabilidato)
            {
                return Json(new { Success = true, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });
            }
            else
            {
                return Json(new { Success = false, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });
            }
        }

        public JsonResult ApagarProceso()
        {
            List<AUT_Programacion_Proceso> programas = web.AdministracionClient.TraerUltimasFechasProgramacion();
            bool resultado = true;
            resultado = web.AdministracionClient.EliminarProgramacion(programas[0]);
            List<AUT_Programacion_Proceso> programas2 = web.AdministracionClient.TraerUltimasFechasProgramacion();
            string estadoProcesoAutomatico = String.Empty;
            string ultimaFechaEjecucion = String.Empty;
            string proximafechaejecucion = String.Empty;
            if (programas2[0].fecha_hora_inicio_ejecucion > DateTime.Now)
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Green\">(Se encuentra encendido)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Red\">Apagar</h5>"
                            + "<a href=\"javascript:apagarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Red;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas.Where(x => x.fecha_hora_inicio_ejecucion < DateTime.Now).FirstOrDefault().fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + programas2[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
            }
            else
            {
                estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Red\">(Se encuentra apagado)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Green\">Encender</h5>"
                            + "<a href=\"javascript:encenderProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                ultimaFechaEjecucion = "<h4>" + programas2[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                proximafechaejecucion = "<h4>" + "NO APLICA" + "</h4>";
            }
            return Json(new { Success = resultado, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });            
        }

        public JsonResult HabilitarProceso()
        {
            string idProceso = Request["idProceso"];
            AUT_Proceso proceso = web.AdministracionClient.TraerProcesos().Where(x => x.id == int.Parse(idProceso)).FirstOrDefault();
            proceso.habilitado = 1;
            proceso = web.AdministracionClient.ActualizarProceso(proceso);
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            string htmlresult = string.Empty;
            foreach (AUT_Proceso pro in procesos)
            {
                htmlresult += "<tr><td class=\"col-lg-6\">"
                + "<a style=\"cursor:pointer;\" onclick=\"javascript:cargarDetalleProceso(<%=Html.Encode(proceso.id)%>)\" data-toggle=\"modal\" data-target=\"#modalDetProceso\">"
                + pro.nombre_proceso + "</a></td>";
                if (pro.habilitado == 1)
                {
                    htmlresult += "<td class=\"col-lg-3\" style=\"color: Green;\">Habilitado</td>";
                }
                else
                {
                    htmlresult += "<td class=\"col-lg-3\" style=\"color: Red;\">Deshabilitado</td>";
                }
                htmlresult += "<td class=\"col-lg-3\" style=\"text-align:center\">";
                if (pro.habilitado == 1)
                {
                    htmlresult += "<h6 style=\"color: Red\">Deshabilitar</h6>"
                        + "<a href=\"javascript:deshabilitarProceso(" + pro.id + ")\">"
                        + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Red;font-size: xx-large\"></i></a>";
                }
                else
                {
                    htmlresult += "<h6 style=\"color: Green\">Habilitar</h6>"
                        + "<a href=\"javascript:habilitarProceso(" + pro.id + ")\">"
                        + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a>";
                }
                htmlresult += "</td></tr>";
            }
            return Json(new { Success = true, htmlresult = htmlresult });
        }

        public JsonResult DeshabilitarProceso()
        {
            string idProceso = Request["idProceso"];
            AUT_Proceso proceso = web.AdministracionClient.TraerProcesos().Where(x => x.id == int.Parse(idProceso)).FirstOrDefault();
            proceso.habilitado = 0;
            proceso = web.AdministracionClient.ActualizarProceso(proceso);
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            string htmlresult = string.Empty;
            bool procesohabilidato = false;
            string estadoProcesoAutomatico = String.Empty;
            string ultimaFechaEjecucion = String.Empty;
            string proximafechaejecucion = String.Empty;
            foreach (AUT_Proceso pro in procesos)
            {
                htmlresult += "<tr><td class=\"col-lg-6\">"
                + "<a style=\"cursor:pointer;\" onclick=\"javascript:cargarDetalleProceso(<%=Html.Encode(proceso.id)%>)\" data-toggle=\"modal\" data-target=\"#modalDetProceso\">"
                + pro.nombre_proceso + "</a></td>";
                if (pro.habilitado == 1)
                {
                    htmlresult += "<td class=\"col-lg-3\" style=\"color: Green;\">Habilitado</td>";
                }
                else
                {
                    htmlresult += "<td class=\"col-lg-3\" style=\"color: Red;\">Deshabilitado</td>";
                }
                htmlresult += "<td class=\"col-lg-3\" style=\"text-align:center\">";
                if (pro.habilitado == 1)
                {
                    procesohabilidato = true;
                    htmlresult += "<h6 style=\"color: Red\">Deshabilitar</h6>"
                        + "<a href=\"javascript:deshabilitarProceso(" + pro.id + ")\">"
                        + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Red;font-size: xx-large\"></i></a>";
                }
                else
                {
                    htmlresult += "<h6 style=\"color: Green\">Habilitar</h6>"
                        + "<a href=\"javascript:habilitarProceso(" + pro.id + ")\">"
                        + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a>";
                }
                htmlresult += "</td></tr>";
            }
            if (!procesohabilidato)
            {
                List<AUT_Programacion_Proceso> programas = web.AdministracionClient.TraerUltimasFechasProgramacion();
                bool resultado = true;
                if (programas[0].fecha_hora_inicio_ejecucion > DateTime.Now)
                {
                    resultado = web.AdministracionClient.EliminarProgramacion(programas[0]);
                    estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Red\">(Se encuentra apagado)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Green\">Encender</h5>"
                            + "<a href=\"javascript:encenderProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                    ultimaFechaEjecucion = "<h4>" + programas[1].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                    proximafechaejecucion = "<h4>" + "NO APLICA" + "</h4>";
                }
                else
                {
                    estadoProcesoAutomatico = "<div class=\"col-lg-6\" style=\"text-align: center\">"
                            + "<h1 class=\" uppercase title\">PROCESO AUTOMÁTICO</h1>"
                            + "<h5 style=\"color: Red\">(Se encuentra apagado)</h5></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\">"
                            + "<h5 style=\"color: Green\">Encender</h5>"
                            + "<a href=\"javascript:encenderProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Green;font-size: xx-large\"></i></a></div>"
                            + "<div class=\"col-lg-3\" style=\"text-align: center\"><h5 style=\"color: Blue\">Activar</h5><a href=\"javascript:activarProceso()\">"
                            + "<i class=\"glyphicon glyphicon-off\" data-toggle=\"tooltip\" data-placement=\"right\" style=\"color: Blue;font-size: xx-large\"></i></a></div>";
                    ultimaFechaEjecucion = "<h4>" + programas[0].fecha_hora_inicio_ejecucion.ToString() + "</h4>";
                    proximafechaejecucion = "<h4>" + "NO APLICA" + "</h4>";
                }
            }
            return Json(new { Success = true, htmlresult = htmlresult, estadoProcesoAutomatico = estadoProcesoAutomatico, ultimaFechaEjecucion = ultimaFechaEjecucion, proximafechaejecucion = proximafechaejecucion });
        }

        public JsonResult ActualizarDependencias()
        {
            string idProceso = Request["idProceso"];
            string contador = Request["contador"];
            string procesodep = Request["procesodep"];
            string tipoaccion = Request["tipoaccion"];
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            List<AUT_Tipo_Accion_En_Error> acciones = web.AdministracionClient.TraerAccionesEnError();
            AUT_Proceso_Dependencia nuevadependencia = new AUT_Proceso_Dependencia();
            nuevadependencia.id = int.Parse(idProceso);
            nuevadependencia.id_proceso_requerido = procesos.Where(x => x.nombre_proceso == procesodep).FirstOrDefault().id;
            nuevadependencia.en_error_proceso_requerido = acciones.Where(x => x.nombre_accion == tipoaccion).FirstOrDefault().id_accion;
            dependenciasDic[int.Parse(contador)] = nuevadependencia;
            return Json(new { Success = true});
        }

        public JsonResult AgregarDependencias()
        {
            string htmlresultados = string.Empty;
            List<AUT_Tipo_Accion_En_Error> acciones = web.AdministracionClient.TraerAccionesEnError();
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            int diccionario_count = dependenciasDic.Keys.Count();
            for (int i = 1; i <= diccionario_count; i++)
            {
                htmlresultados += "<tr><td><label id=\"txtprocesodep" + i.ToString() + "\">" + procesos.Where(x => x.id == dependenciasDic[i].id_proceso_requerido).FirstOrDefault().nombre_proceso + "</label>"
                + "<div id=\"divprocesodep" + i.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnprocesodep" + i.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
                + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                + procesos.Where(x => x.id == dependenciasDic[i].id_proceso_requerido).FirstOrDefault().nombre_proceso + "<span class=\"caret\"></span></button>"
                + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                foreach (AUT_Proceso pro in procesos)
                {
                    htmlresultados += "<li><a href=\"javascript:cambiarDependencia(" + pro.id.ToString() + ",'" + pro.nombre_proceso + "'," + i.ToString() + ")\">" + pro.nombre_proceso + "</a></li>";
                }

                htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + i.ToString() + "\">"
                        + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "</label>"
                        + "<div id=\"divacciondep" + i.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnacciondep" + i.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
                        + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                        + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "<span class=\"caret\"></span></button>"
                        + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                foreach (AUT_Tipo_Accion_En_Error acc in acciones)
                {
                    htmlresultados += "<li><a href=\"javascript:cambiarAccion(" + acc.id_accion.ToString() + ",'" + acc.nombre_accion + "'," + i.ToString() + ")\">" + acc.nombre_accion + "</a></li>";
                }

                htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + i.ToString() + "\">"
                    + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "</label></td><td>"
                    + "<a id=\"editardep" + i.ToString() + "\" href=\"javascript:editarDependencia(" + i.ToString() + ")\">"
                    + "<i class=\"glyphicon glyphicon-pencil\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                    + "<a id=\"guardardep" + i.ToString() + "\" href=\"javascript:guardarDependencia(" + i.ToString() + ")\" style=\"display: none;\">"
                    + "<i class=\"glyphicon glyphicon-floppy-disk\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                    + "<a href=\"javascript:eliminarDependencia(" + i.ToString() + ")\">"
                    + "<i class=\"glyphicon glyphicon-trash\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Eliminar\"></i></a>" + "</td></tr>";
            }

            htmlresultados += "<tr><td><label id=\"txtprocesodep" + (diccionario_count + 1).ToString() + "\" style=\"display: none;\">" + "</label>"
               + "<div id=\"divprocesodep" + (diccionario_count + 1).ToString() + "\" class=\"dropdown\"><button id=\"btnprocesodep" + (diccionario_count + 1).ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
               + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
               + "SELECCIONE UN PROCESO" + "<span class=\"caret\"></span></button>"
               + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
            foreach (AUT_Proceso pro in procesos)
            {
                htmlresultados += "<li><a href=\"javascript:cambiarDependencia(" + pro.id.ToString() + ",'" + pro.nombre_proceso + "'," + (diccionario_count + 1).ToString() + ")\">" + pro.nombre_proceso + "</a></li>";
            }

            htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + (diccionario_count + 1).ToString() + "\" style=\"display: none;\">" + "</label>"
                        + "<div id=\"divacciondep" + (diccionario_count + 1).ToString() + "\" class=\"dropdown\"><button id=\"btnacciondep" + (diccionario_count + 1).ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
                        + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                        + "SELECCIONE UNA ACCION" + "<span class=\"caret\"></span></button>"
                        + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
            foreach (AUT_Tipo_Accion_En_Error acc in acciones)
            {
                htmlresultados += "<li><a href=\"javascript:cambiarAccion(" + acc.id_accion.ToString() + ",'" + acc.nombre_accion + "'," + (diccionario_count + 1).ToString() + ")\">" + acc.nombre_accion + "</a></li>";
            }

            htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + (diccionario_count + 1).ToString() + "\">"
                + "</label></td><td>"
                + "<a id=\"editardep" + (diccionario_count + 1).ToString() + "\" href=\"javascript:editarDependencia(" + (diccionario_count + 1).ToString() + ")\" style=\"display: none;\">"
                + "<i class=\"glyphicon glyphicon-pencil\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                + "<a id=\"guardardep" + (diccionario_count + 1).ToString() + "\" href=\"javascript:guardarDependencia(" + (diccionario_count + 1).ToString() + ")\">"
                + "<i class=\"glyphicon glyphicon-floppy-disk\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                + "<a href=\"javascript:eliminarDependencia(" + (diccionario_count + 1).ToString() + ")\">"
                + "<i class=\"glyphicon glyphicon-trash\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Eliminar\"></i></a>" + "</td></tr>";

            dependenciasDic.Add((diccionario_count + 1), new AUT_Proceso_Dependencia());
            
            return Json(new { Success = true, htmlresult = htmlresultados });
        }

        public JsonResult EliminarDependencias()
        {
            string htmlresultados = string.Empty;
            string idProceso = Request["idProceso"];
            string contador = Request["contador"];
            List<AUT_Tipo_Accion_En_Error> acciones = web.AdministracionClient.TraerAccionesEnError();
            List<AUT_Proceso> procesos = web.AdministracionClient.TraerProcesos();
            dependenciasDic.Remove(int.Parse(contador));
            int diccionario_count = dependenciasDic.Keys.Count();
            for (int i = 1; i <= diccionario_count; i++)
            {
                htmlresultados += "<tr><td><label id=\"txtprocesodep" + i.ToString() + "\">" + procesos.Where(x => x.id == dependenciasDic[i].id_proceso_requerido).FirstOrDefault().nombre_proceso + "</label>"
                + "<div id=\"divprocesodep" + i.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnprocesodep" + i.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
                + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                + procesos.Where(x => x.id == dependenciasDic[i].id_proceso_requerido).FirstOrDefault().nombre_proceso + "<span class=\"caret\"></span></button>"
                + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                foreach (AUT_Proceso pro in procesos)
                {
                    htmlresultados += "<li><a href=\"javascript:cambiarDependencia(" + pro.id.ToString() + ",'" + pro.nombre_proceso + "'," + i.ToString() + ")\">" + pro.nombre_proceso + "</a></li>";
                }

                htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + i.ToString() + "\">"
                        + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "</label>"
                        + "<div id=\"divacciondep" + i.ToString() + "\" class=\"dropdown\" style=\"display: none;\"><button id=\"btnacciondep" + i.ToString() + "\" class=\"btn btn-cancel dropdown-toggle\""
                        + "type=\"button\" data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"true\" style=\"width: 100% ;\">"
                        + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "<span class=\"caret\"></span></button>"
                        + "<ul class=\"dropdown-menu\" aria-labelledby=\"txtrol\">";
                foreach (AUT_Tipo_Accion_En_Error acc in acciones)
                {
                    htmlresultados += "<li><a href=\"javascript:cambiarAccion(" + acc.id_accion.ToString() + ",'" + acc.nombre_accion + "'," + i.ToString() + ")\">" + acc.nombre_accion + "</a></li>";
                }

                htmlresultados += "</ul></div></td><td><label id=\"txtacciondep" + i.ToString() + "\">"
                    + acciones.Where(x => x.id_accion == dependenciasDic[i].en_error_proceso_requerido).FirstOrDefault().nombre_accion + "</label></td><td>"
                    + "<a id=\"editardep" + i.ToString() + "\" href=\"javascript:editarDependencia(" + i.ToString() + ")\">"
                    + "<i class=\"glyphicon glyphicon-pencil\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                    + "<a id=\"guardardep" + i.ToString() + "\" href=\"javascript:guardarDependencia(" + i.ToString() + ")\" style=\"display: none;\">"
                    + "<i class=\"glyphicon glyphicon-floppy-disk\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Editar\"></i></a>"
                    + "<a href=\"javascript:eliminarDependencia(" + i.ToString() + ")\">"
                    + "<i class=\"glyphicon glyphicon-trash\" data-toggle=\"tooltip\" data-placement=\"right\" title=\"Eliminar\"></i></a>" + "</td></tr>";
            }

            return Json(new { Success = true, htmlresult = htmlresultados });
        }

        public JsonResult GuardarProceso()
        {
            string idProceso = Request["idProceso"];
            string maxReintentos = Request["maxReintentos"];
            string emailInicio = Request["emailInicio"];
            string emailFin = Request["emailFin"];
            string emailError = Request["emailError"];

            AUT_Proceso proceso = web.AdministracionClient.TraerProcesos().Where(x => x.id == int.Parse(idProceso)).FirstOrDefault();
            proceso.max_reintentos = int.Parse(maxReintentos);
            proceso.notificar_inicio = emailInicio;
            proceso.notificar_fin = emailFin;
            proceso.notificar_error = emailError;

            proceso = web.AdministracionClient.ActualizarProceso(proceso);

            List<AUT_Proceso_Dependencia> dependenciasold = web.AdministracionClient.TraerDependenciaPorProceso(int.Parse(idProceso));
            foreach (AUT_Proceso_Dependencia dependencia in dependenciasold)
            {
                web.AdministracionClient.EliminarProcesoDependencia(dependencia);
            }
            
            int contador = dependenciasDic.Count();
            for (int i = 1; i < contador; i++)
            {
                web.AdministracionClient.InsertarProcesoDependencia(dependenciasDic[i]);
            }

            dependenciasDic = new Dictionary<int, AUT_Proceso_Dependencia>();
            return Json(new { Success = true });
        }

        public JsonResult LimpiarDiccionario()
        {
            dependenciasDic = new Dictionary<int, AUT_Proceso_Dependencia>();
            return Json(new { Success = true});
        }
    }
}
