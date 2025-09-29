<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.PeriodoCierreModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Periodos de Cierre - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('#tablaLista').dataTable({ "bJQueryUI": true,
	            "sPaginationType": "full_numbers", "bStateSave": true
	        })
	        var oTable = $('.tbl').dataTable();
	        $('#fechaCierre').datepicker({ dateFormat: 'yy-mm-dd' });

	        $("#FormPeriodos").validate({
	            errorClass: "invalid",
	            errorPlacement: function (error, element) {
	                return true;
	            }
	        });
	    })

	    function mostrarPeriodos() {
	        $("#divPeriodos").show("slow");
	    }

	    function mostrarPeriodos2() {
	        $("#divPeriodos2").show("slow");
	    }

        function reprocesarPeriodo() {
            var stUrl = '/PeriodoCierre/ReprocesaPeriodo';
            var continuar = confirm(
                "Desea Reprocesar el periodo " + document.getElementById("txtperiodo").value
            );
            if (continuar == true) {
                var ok = confirm(
                    "Esta operacion borrara todos los registros del periodo seleccionado para los c" +
                    "ore: SISE, BH y CAPI y no podran reversarse. Tener en cuenta activar los proce" +
                    "sos  correspondientes(Inician 6:00 p.m) "
                )
                if (ok == true) {
                    mostrarCargando("Ejecutando Operacion! Espere Por Favor...");
                    var prueba1 = $.ajax({
                        type: 'POST',
                        url: stUrl,
                        data: {
                            periodo: document.getElementById("txtperiodo").value
                        },
                        success: function (response) {
                            if (response.Success) {
                                $("#divPeriodos").hide("slow");
                                closeNotify('jNotify');
                                mostrarExito("El proceso se realizó con éxito.");
                                location.reload();
                            }
                        }
                    });
                    return true;
                } else {
                    mostrarError("Accion revertida por el usuario");
                    location.reload();
                    return false;
                }                
                return true;
            } else {
                mostrarError("Accion revertida por el usuario");
                location.reload();
                return false;
            }
        }

	    function cerrarPeriodo(anioCierre, mesCierre) {
	        var stUrl = '/PeriodoCierre/CerrarPeriodo';
	        mostrarCargando("Consultando. Espere Por Favor...");
	        var prueba1 = $.ajax({
	            type: 'POST',
	            url: stUrl,
	            data:
                {
                    periodo: document.getElementById("txtperiodo2").value
                },
	            success: function (response) {
	                if (response.Success) {
	                    $("#divPeriodos2").hide("slow");
	                    closeNotify('jNotify');
	                    mostrarExito("El proceso se realizó con éxito.");
	                    location.reload();
	                }
	            }
	        });
	    }

	    function reabrirPeriodo(idPeriodo, periodoText, compania, idPeriodoAbierto, fechaCierrePeriodoAbierto) {
	        $("#PeriodoIdCerrado").val(idPeriodo);
	        $("#PeriodoIdAbierto").val(idPeriodoAbierto);
	        $("#fechaCierrePeriodoAbierto").val(fechaCierrePeriodoAbierto);
	        $("#periodo").text(periodoText);
	        $("#compania").text(compania);
	        $("#guardar").focus();
	        $("#reabrirPeriodo").dialog({
	            width: 500,
	            minHeight: 200,
	            title: 'Reabrir periodo de cierre',
	            position: 'center',
	            close: function (ev, ui) {
	                cerrarReabrir();
	            },
	            modal: true
	        });
	    }

	    function reabrirPeriodoSave() {

	        var stUrl = '/PeriodoCierre/ReabrirPeriodo';

	        if ($("#FormPeriodos").valid()) {

	            var fechaCierre = $("#fechaCierre").val();
	            var fechaCierrePeriodoAbierto = $("#fechaCierrePeriodoAbierto").val();

	            if (fechaCierre >= fechaCierrePeriodoAbierto) {
	                mostrarError("La fecha de cierre del periodo a reabrir no puede ser mayor que la fecha del periodo actualmente abierto.(Fecha cierre actual:" + fechaCierrePeriodoAbierto + ")");
	            }
	            else {

	                if (confirm("Esta seguro de reabrir el periodo?.\n\nRecuerde que este proceso dejará en estado pendiente el periodo actual\ny no se podra deshacer el cambio.")) {

	                    $("#guardar").attr('disabled', true);
	                    mostrarCargando("Reabriendo periodo. Espere Por Favor...");
	                    $.ajax({
	                        type: 'POST',
	                        url: stUrl,
	                        data:
                        {
                            periodoIdCerrado: $('#PeriodoIdCerrado').val(),
                            periodoIdAbierto: $('#PeriodoIdAbierto').val(),
                            fechaCierre: $('#fechaCierre').val()
                        },
	                        success: function (response) {
	                            closeNotify('jNotify');
	                            if (response.Success) {
	                                mostrarExito(response.Messagge);
	                                window.location.href = window.location.pathname;
	                            }
	                            else {
	                                mostrarError(response.Messagge);
	                            }
	                        }
	                    });
	                }
	            }
	        }
	    }

	    function cerrarReabrir() {
	        $("#PeriodoIdCerrado").val("");
	        $("#PeriodoIdAbierto").val("");
	        $("#fechaCierre").val("");
	        $("#fechaCierrePeriodoAbierto").val("");
	        $("#periodo").text("");
	        $("#compania").text("");
	        $("#guardar").removeAttr('disabled');
	        $("#reabrirPeriodo").dialog("close");
	    }


   </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Información de cierres de periodo por compañía</h2>
			<h4></h4>
			<table>
            <tr>
                <td>
				    <%: Html.ActionLink("Nuevo Periodo", "Create")%>
                </td>
              <%--  <td>
                    <a href="<%= Url.Action("Index", "LogIntegracionBz") %>" >Fechas de GP</a>
                </td>--%>               
                <td>
                    Ver Reporte
                </td>
                <td align="center">
                    <a href='#' onclick="popupReport('ReporteLogIntegracion');" title='Ver Reporte de Integración General'><span class='ui-icon ui-icon-document-b'></span></a>
                </td>  
            </tr>
			</table>
		</div>

		<div id="progresoSeccion">
	</div>

		<div style="clear:both;"><hr /></div>
	</div>
	<table id="tablaLista">
	<thead>
		<tr>
            <th align = "center">Periodo</th>
            <th align = "center">Compañía</th>
			<th align = "center">Fecha inicial (dd/mm/yyyy)</th>
			<th align = "center">Fecha final (dd/mm/yyyy)</th>			
			<th align = "center">Fecha cierre (dd/mm/yyyy)</th>
            <th align = "center">Estado</th>
			<th align = "center">Opciones</th>
		</tr>
	</thead>
	<tbody>
	<% 
        var tempList = Model.PeriodoCierreList;
        foreach (var item in Model.PeriodoCierreList) {
            
            var periodo = item.mesCierre + "-" + item.anioCierre;
            var compania = item.Compania.nombre;  
                
        %>
	    
		<tr>			
			<td align = "center">
                <%=periodo%>
            </td>
			<td align = "center">
               <% 
                    if (item.compania_id == 0) 
                        Response.Write("Recaudos SISE (VIDA y GENERALES)");                    
                    else
                        Response.Write(compania);
                %>
            </td>
			<td align = "center">
                <%: String.Format("{0:d}", item.fechaInicio)%>            
            </td>
			<td align = "center">
                <%: String.Format("{0:d}", item.fechaFin)%>            
            </td>
			<td align = "center">
                <%: String.Format("{0:d}", item.fechaCierre)%>            
            </td>
			<td align = "center">
                <% 
                    if (item.estado == 0) 
                        Response.Write("Pendiente");
                    else if (item.estado == 1)
                        Response.Write("Abierto");
                    else
                        Response.Write("Cerrado");
                %>
            </td>
            <td align="center">                
                <%
                    //DETERMINAMOS SI EL ESTADO ES CERRADO PARA COMPARAR CON UN PERIODO ABIERTO Y SABES SI ES EL INMEDIATAMENTE ANTERIOR
                    var periodoAbierto  = 0;
                    var fechaCierrePeriodoAbierto = string.Empty;
                    if (item.estado == 2)
                    {
                        //OBTENEMOS EL PERIODO 
                        DateTime fechaPeriodo = Convert.ToDateTime(item.anioCierre + "-" + item.mesCierre + "-01");
                        DateTime fechaPeriodoSiguiente = fechaPeriodo.AddMonths(1);
                        var periodoAbiertoList = tempList.Where(x => x.compania_id == item.compania_id && x.estado == 1 && x.mesCierre == fechaPeriodoSiguiente.Month && x.anioCierre == fechaPeriodoSiguiente.Year).ToList();
                        if (periodoAbiertoList != null && periodoAbiertoList.Count() > 0){
                            periodoAbierto = periodoAbiertoList.First().id;
                            var fechaCierre = periodoAbiertoList.First().fechaCierre;
                            fechaCierrePeriodoAbierto = fechaCierre.Value.Year + "-" + ((fechaCierre.Value.Month.ToString().Length == 1) ? ("0" + fechaCierre.Value.Month.ToString()) : fechaCierre.Value.Month.ToString()) + "-" + ((fechaCierre.Value.Day.ToString().Length == 1) ? ("0" + fechaCierre.Value.Day.ToString()) : fechaCierre.Value.Day.ToString());
                        }
                            
                    }
                    
                    if (item.estado == 1 || item.estado == 0)
                    {
                        %>
                            <a href='<%: Url.Action("Edit", "PeriodoCierre", new { id = item.id }) %>' title='Editar' class='ui-icon ui-icon-pencil' style="float:left;"></a>
                            <%
                                if (item.estado == 0)
                                {
                            %>
                                <a href='<%: Url.Action("Delete", "PeriodoCierre",new { id = item.id }) %>' title='Eliminar' style="float:left;" class='ui-icon ui-icon-trash' ></a>
                            <%
                                }
                            %>
                        <%
                    }

                    if (periodoAbierto > 0)
                    {
                        %>
                            <a href="javascript:reabrirPeriodo(<%=item.id%>,'<%=periodo%>','<%=compania.Replace(",","")%>',<%=periodoAbierto%>,'<%=fechaCierrePeriodoAbierto%>');" title='Reabrir Periodo' style="float:left;" class='ui-icon ui-icon-newwin' ></a>
                        <%                        
                    }
                %>
            </td>
		</tr>
	
	<% } %>
	</tbody>
	</table>
    <table style="width:100%">
        <tr>
            <td>
                <input onclick="mostrarPeriodos()" type="button" name="Reprocesar Periodo" title="Reprocesar Periodo" value="Reprocesar Periodo" />
            </td>
            <td>
                <table id="divPeriodos" style="display:none">
                    <tr>
                        <td>
                            <label for="txtperiodo" class="col-sm-2 control-label">Periodo:</label>
                        </td>
                        <td>
                            <select style="width:100%; text-align:right" id="txtperiodo">
                                 <%  foreach (var periodo in Model.PeriodoCierreList.Where(x => x.estado == 2).GroupBy(key => new { key.anioCierre, key.mesCierre }).Select(s => new { anioCierre = s.Key.anioCierre, mesCierre = s.Key.mesCierre }))
                                         
                                     { %>
                                <option id="<%  =periodo.anioCierre.ToString() + "-" + periodo.mesCierre.ToString()%>"><%  =periodo.anioCierre.ToString() + "-" + periodo.mesCierre.ToString()%></option>
                            <%  } %>
                            </select>                            
                        </td>
                        <td>
                            <input onclick="reprocesarPeriodo()" type="button" name="Reprocesar" title="Reprocesar" value="Reprocesar"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>   
    
    <table style="width:100%">
        <tr>
            <td>
                <input onclick="mostrarPeriodos2()" type="button" name="Cerrar Periodo" title="Cerrar Periodo" value="Cerrar Periodo" />
            </td>
            <td>
                <table id="divPeriodos2" style="display:none">
                    <tr>
                        <td>
                            <label for="txtperiodo" class="col-sm-2 control-label">Periodo:</label>
                        </td>
                        <td>
                            <select style="width:100%; text-align:right" id="txtperiodo2">
                                 <%  foreach (var periodo in Model.PeriodoCierreList.Where(x => x.estado == 1).GroupBy(key => new {key.anioCierre, key.mesCierre}).Select(s => new {anioCierre = s.Key.anioCierre, mesCierre = s.Key.mesCierre}))
                                     { %>
                                <option id="Option1"><%  =periodo.anioCierre.ToString() + "-" + periodo.mesCierre.ToString()%></option>
                            <%  } %>
                            </select>                            
                        </td>
                        <td>
                            <input onclick="cerrarPeriodo()" type="button" name="Cerrar" title="Cerrar" value="Cerrar"/>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table> 

    <div id="reabrirPeriodo" style="display:none;">
<% 
     
        using (Html.BeginForm("SavePeriodo", "PeriodoCierre", FormMethod.Post, new { id = "FormPeriodos" }))
	   {%>

			<fieldset style="border:1px solid gray">
			
            <input type="hidden"  id="PeriodoIdCerrado" name="PeriodoIdCerrado" value='' />
            <input type="hidden"  id="PeriodoIdAbierto" name="PeriodoIdAbierto" value='' />
            <input type="hidden"  id="fechaCierrePeriodoAbierto" name="fechaCierrePeriodoAbierto" value='' />            

			<table cellspacing="2" width="100%">
                <tr>
                    <td>
                        Reabrir Periodo: 
                    </td>
                    <td>
                        <div id="periodo"></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        Compañia: 
                    </td>
                    <td>
                        <div id="compania"></div>
                    </td>
                </tr>                
				<tr>
                    <td>* Fecha Cierre:</td>
					<td>
						<%: Html.TextBox("fechaCierre", "", new { id = "fechaCierre", @class = "required" })%>
					</td>
				</tr>
			    <tr>
				    <td colspan="2" align="left">
                        <input type="button" onclick="reabrirPeriodoSave()" id="guardar" value="Reabrir"/>
                        <input type="button" onclick="cerrarReabrir()" id="cerrar" value="Cerrar"/>
                    </td>
			    </tr>
			</table>
			</fieldset>
			<br />
	<% } %>
    </div>
</asp:Content>

