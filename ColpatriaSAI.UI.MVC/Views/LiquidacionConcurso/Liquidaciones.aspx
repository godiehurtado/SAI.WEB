<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.LiquidacionRegla>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript">
	    function mostrarDialog1(pagina, titulo, dialog) {
	        $("#" + dialog).dialog({
	            height: 180, width: 350, modal: true, title: titulo,
	            open: function (event, ui) { $(this).load(pagina); },
	            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
	        });
	    }

	    function eliminarLiquidacionRegla(id) {
	        if (confirm('Está seguro que desea eliminar esta liquidación?')) {
	            $.ajax({ url: '/LiquidacionConcurso/Eliminar', data: { idLiquidacion: id }, type: 'POST',
	                success: function (result) {
	                    closeNotify('jNotify');
	                    if (result.Success) {
	                        mostrarExito(result.Messagge + ' Liquidación eliminada');
	                        setTimeout(function () {
	                            $("#liquidacionRedirect").submit();
	                        }, 1000);
	                    }
	                    else
	                        mostrarError(result.Messagge);
	                }
	            });
	        }
	    }

	    var pararVerificacion;
	    $(window).unload(function () { pararVerificacion = clearInterval(pararVerificacion); });

	    $(function () {
	        $("#progressbar").progressbar({ value: 35 });

	        oTable = $('#tablaLista').dataTable({
	            "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true
	        });

	        $.getJSON('/SessionLess/ValidarProcesos', {}, function (data) {
	            if (data[0] != null) {
	                $(data).each(function () {
	                    if (this.tipo == 1) {
	                        $("#nueva").hide();
	                        mostrar = true;
	                    }
	                });
	                if (mostrar) mostrarExito("Hay una liquidación en curso. Por favor, espere un momento!");
	            }
	        });
	        verificarLiquidacion();
	    });	    

	    function LiquidarPagos(idLiquidacion) {
	        $.ajax({ url: '/LiquidacionConcurso/GenerarPagos', data: { idLiquidacion: idLiquidacion }, type: 'POST',
	            success: function (result) {
	                closeNotify('jNotify');
	                if (result.Success) {
	                    mostrarExito(result.Messagge + ' Espere por favor...');
	                    setTimeout(function () {
	                        $("#liquidacionRedirect").submit();
	                    }, 1000);
	                }
	                else
	                    mostrarError(result.Messagge);
	            }
	        });
	    }

	    function DescargarReporte(idLiquidacion) {
	        mostrarCargando("En unos minutos el reporte solicitado estará disponible en el FTP. Consultelo en la opción 'Ver Reportes'");
	        $.ajax({ url: '/LiquidacionConcurso/ReporteLiquidacionRegla', data: { idLiquidacion: idLiquidacion }, type: 'POST',
	            success: function (result) {
	                closeNotify('jNotify');
	                if (result.Success) {
	                    mostrarExito(response.Messagge);
	                }
	                else {
	                    mostrarError(result.Messagge);
	                }
	                $("#liquidacionRedirect").submit();
	            }
	        });
	        window.setTimeout(function () {
	            $('#liquidacionRedirect').submit();
	        }, 5000);
	    }

	</script>

    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>LIQUIDACIÓN: <%: ViewBag.regla.nombre %></h2>
            <p>En esta página puede visualizar las liquidaciones realizadas previamente a la regla <b><%: ViewBag.regla.nombre %></b>. 
               Haga clic en el botón "Nueva Liquidación" para generar un nuevo proceso de liquidación</p>
            <p>
            <%: Html.ActionLink("Regresar", "Index", "LiquidacionConcurso", new { value = ViewBag.regla.concurso_id }, null)%>
            </p>
        </div>
        <div id="progreso">
           
        </div>
       <div style="clear:both;"><hr /></div>
    </div>

    <% string ruta = Request.Url.Host.ToString(); %>
    <% string ruta1 = Request.Url.Port.ToString(); %>
	<% Random random = new Random();
				   int num = random.Next(1, 10000);  %>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <p>
    <% if (Convert.ToInt16(TempData["resultadoLiq"]) != 0)
        { %>
    <% using (Html.BeginForm("LiquidarRegla", "LiquidacionConcurso", FormMethod.Post, new  { id="liquidacion" })) { %>
        <%: Html.Hidden("regla",(int)ViewBag.regla.id) %>
        <input id="nueva" type="submit" value="Nueva Liquidación" />
    <% } %>
    <% } %>
    <% using (Html.BeginForm("Liquidaciones", "LiquidacionConcurso", FormMethod.Post, new  { id="liquidacionRedirect" })) { %>
        <%: Html.Hidden("regla",(int)ViewBag.regla.id) %>
        <%: Html.Hidden("concurso_id",(int)Convert.ToInt32(ViewBag.concurso_id)) %>
    <% } %>
        
    </p>     
    <table id="tablaLista">
        <thead>
        <tr>            
            <th align="center">Fecha de liquidación</th>
            <th align="center">Periodo liquidado</th>
            <th align="center">Descargar resultados</th>
            <%--<% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1) { %><th align="center">Descargar resultados</th><% } %>  
            <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2) { %><th align="center">Descargar resultados</th><% } %>
            <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1) { %><th align="center">Consulta por clave</th><% } %>  
            <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2) { %><th align="center">Consulta por nivel</th><% } %> --%>
            <th align="center">Pagar</th>
            <th align="center">Estado</th>
            <th align="center">Eliminar</th>
            <th align="center">Ajustes</th>
        </tr>
        </thead>
        <tbody>
    <% foreach (var item in Model) { %>
        <tr>            
            <td align="center"><%: String.Format("{0:MM/dd/yyyy - HH:mm:ss}", item.fecha_liquidacion) %></td>
            <td align="center"><%: String.Format("{0:d}", item.fecha_inicial) %> - <%: String.Format("{0:d}", item.fecha_final) %> </td>
            <td align="center"><a href="javascript:DescargarReporte(<%=item.id%>);" title='Descargar Liquidación Regla'><span class='ui-icon ui-icon-note'></span></a></td>
            <%--<% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2) { %><td align="center"><a href='#' onclick="popupReport('ReporteLiquidacionReglaGeneralEjecutivo','idLiquidacion=<%: item.id %>');" title='Descargar Liquidación Regla General Ejecutivo'><span class='ui-icon ui-icon-note'></span></a> <a href='#' onclick="popupReport('ReporteLiquidacionReglaDetalladoEjecutivo','idLiquidacion=<%: item.id %>');" title='Descargar Liquidación Regla Detallado Ejecutivo'><span class='ui-icon ui-icon-note'></span></a></td><% } %>--%>
            <%--<% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1) { %><td align="center"><a href='#' onclick="popupReport('ReporteLiquidacionConcursoxAsesor','idLiquidacion=<%: item.id %>');" title='Descargar Detalle Liquidación'><span class='ui-icon ui-icon-document-b'></span></a></td><% } %>  
            <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2) { %><td align="center"><a href='#' onclick="popupReport('ReporteLiquidacionConcursoxNodo','idLiquidacion=<%: item.id %>');" title='Descargar Detalle Liquidación'><span class='ui-icon ui-icon-document-b'></span></a></td><% } %>  --%>
            <% if (item.EstadoLiquidacion.id == 1) { %><td align="center"><a href="javascript:LiquidarPagos(<%=item.id%>);">Pagar</a></td>
            <% }else if (item.EstadoLiquidacion.id == 2) { %><td align="center"><a href='#'  onclick="alert('Liquidación pagada.');" title='Liquidación Pagada'>Pagar</a></td><% } %>           
            <td align="center"><%=item.EstadoLiquidacion.nombre %></td>
            <td align="center"><% if (item.EstadoLiquidacion.id == 1) { %><a href="#" style='float: center;' title='Eliminar Liquidación' onclick="eliminarLiquidacionRegla(<%: item.id %>);"><span class='ui-icon ui-icon-trash' /></a><% } %></td>
            <% if (item.EstadoLiquidacion.id == 1) { %><td align="center"><a href='#'  onclick="alert('Liquidación aún si pagar.');" title='Ajustes' ><span class='ui-icon ui-icon-wrench'></span></a></td>
            <% }else if (item.EstadoLiquidacion.id == 2) { %><td align="center"><%: Html.ActionLink("Ajustes", "AjustesConcursos", "Ajustes", new { @id = item.id, @regla_id = ViewBag.regla.id }, new { @class = "ui-icon ui-icon-wrench" })%></td><% } %>
        </tr>
    <% } %>
        </tbody>
        <%: Html.Hidden("tipoConcurso", (int)TempData["tipoConcurso_id"])%>
    </table>
    <div id='dialogEliminar' style="display: none;"></div>

    <script type="text/javascript">
        function verificarLiquidacion() {
            $.ajax({ url: '/LiquidacionConcurso/getLiquidacionesRegla/' + $("#regla").val(),
                success: function (data) {
                    //if ($("#nroLiquidaciones").val() != 0) {
                        if (parseInt(data[0]) > $("#nroLiquidaciones").val()) {
                            $("#liquidacionRedirect").submit();
                        }
                    //}
                    //$("#nroLiquidaciones").val(data[0]);
                }
            });
            pararVerificacion = setTimeout(verificarLiquidacion, 3000);
        }
    </script>
    <%: Html.Hidden("nroLiquidaciones", (int)ViewBag.cantidadLiquidaciones) %>
</asp:Content>
