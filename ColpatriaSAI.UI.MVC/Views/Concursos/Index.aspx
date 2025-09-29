<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Concursos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 480, width: 450, modal: true, closeOnEscape: true,                
                title: titulo,
                open: function (event, ui) { $(this).load(pagina); $(ui).find('#FechaInicio').datepicker().click(function () { $(this).datepicker('show') }); $(ui).find('#FechaFin').datepicker().click(function () { $(this).datepicker('show') }); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); $(ui).find('#FechaInicio').datepicker('destroy'); $(ui).find('#FechaFin').datepicker('destroy'); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 210, width: 350, modal: true, closeOnEscape: true,                
                title: titulo,
                open: function (event, ui) { $(this).load(pagina); $(ui).find('#FechaInicio').datepicker().click(function () { $(this).datepicker('show') }); $(ui).find('#FechaFin').datepicker().click(function () { $(this).datepicker('show') }); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); $(ui).find('#FechaInicio').datepicker('destroy'); $(ui).find('#FechaFin').datepicker('destroy'); }
            });
        }

        $(function () {
            var dates = $("#FechaInicio, #FechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "FechaInicio" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
            $('#buscarFechaInicio').keyup(function () { oTable.fnDraw(); });
            $('#buscarFechaFin').keyup(function () { oTable.fnDraw(); });
            $('#buscarTipoConcurso').keyup(function () { oTable.fnDraw(); });
            
        });
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarNombre").attr("value", "");
            $("#buscarFechaInicio").attr("value", "");
            $("#buscarFechaFin").attr("value", "");
            $("#buscarTipoConcurso").attr("value", "");            

            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNombre = document.getElementById('buscarNombre').value;
	            var bFechaInicio = document.getElementById('buscarFechaInicio').value;
	            var bFechaFin = document.getElementById('buscarFechaFin').value;
	            var bTipoConcurso = document.getElementById('buscarTipoConcurso').value;
                
                var Nombre = aData[1];
	            var FechaInicio = aData[2];
	            var FechaFin = aData[3];
	            var TipoConcurso = aData[4];

	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
	            var comparaFechaInicio = FechaInicio.toUpperCase().indexOf(bFechaInicio.toUpperCase());
	            var comparaFechaFin = FechaFin.toUpperCase().indexOf(bFechaFin.toUpperCase());
	            var comparaTipoConcurso = TipoConcurso.toUpperCase().indexOf(bTipoConcurso.toUpperCase());

	            if ((comparaNombre >= 0) && (comparaFechaInicio >= 0) && (comparaFechaFin >= 0) && (comparaTipoConcurso >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
	        $(function () {
	            $("#progressbar").progressbar({
	                value: 0
	            });
	            $("#bCrear").button({ icons: { primary: "ui-icon-circle-plus"} });
	            $("#bCrearLiquidacion").button({ icons: { primary: "ui-icon-circle-plus"} });
	            $("#bMonedas").button({ icons: { primary: "ui-icon-wrench"} });
	            $("#bPCapi").button({ icons: { primary: ".ui-icon-circle-triangle-e"} });
	            $("#bExcepciones").button({ icons: { primary: ".ui-icon-circle-triangle-e"} });
	            $("#liquidacionAsesor").button({ icons: { primary: ".ui-icon-circle-triangle-e"} });
	        });
    </script>
    <script  type="text/javascript">javascript: window.history.forward(1);</script>
    
    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>Concursos: <%: ViewBag.segmentoUsuario %></h2>
                <p>
                    <%: Html.ActionLink("Nuevo Concurso", "Crear", "Concursos", new { id="bCrear"})%>
                    <a href="/MaestroMonedaxnegocio" id="bMonedas" title='Tabla de Monedas'>Tabla de Monedas</a>
                    <%: Html.ActionLink("Colquines Manuales", "Index", "LiquidacionMoneda", new{}, new { id = "bCrearLiquidacion" })%>
                    <%--<a href="/EtapaProducto" id="bPCapi" title='Etapas'>Etapas</a>--%>
                    <a href="/Concursos/Excepciones" id="bExcepciones" >Excepciones</a> 
                    <a href="/Concursos/LiquidacionAsesor" id="liquidacionAsesor" >Liquidación Asesor</a> 
                </p>
        </div>
        <div id="progreso">
        </div>
        <div style="clear:both;"><hr /></div>
    </div>
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    
    <div id="concurso">
        <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Listar", "Concursos", FormMethod.Post, new { id = "formConcurso" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.ConcursoViewModel concurso =
                           (ColpatriaSAI.UI.MVC.Models.ConcursoViewModel)ViewData["ConcursoViewModel"]; %>                  
                <% } %>

            </td>

            <td>            
            <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		            <tr>                        
			            <td><label for="buscarNombre">Concurso:</label></td>
			            <td><input type="text" id="buscarNombre" name="buscarNombre" size="10" /></td>
			            <td><label for="buscarFechaInicio">Fecha Inicial:</label></td>
			            <td><input type="text" id="buscarFechaInicio" name="buscarFechaInicio" size="8" /></td>
			            <td><label for="buscarFechaFin">Fecha Final:</label></td>
			            <td><input type="text" id="buscarFechaFin" name="buscarFechaFin" size="8" /></td>
                        <td><label for="buscarTipoConcurso">Tipo de Concurso:</label></td>
			            <td><input type="text" id="buscarTipoConcurso" name="buscarTipoConcurso" size="8" /></td>
                        <td><label for="buscarSegmento">Segmento:</label></td>
			            <td><input type="text" id="Text1" name="buscarSegmento" size="8" /></td>
		            </tr>                    
	            </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Editar</th>
                        <th align = "center">Eliminar</th>
                        <th align = "center">Duplicar</th>
                        <th align = "center">Detalle</th>
                        <th align = "center">Liquidar</th>
                        <th align = "center">Nombre</th>
                        <th align = "center">Inicio</th>
                        <th align = "center">Fin</th>
                        <th align = "center">Tipo de Concurso</th>                        
                        <th align = "center">Principal</th>
                        <th align = "center">Pers./Sinies.</th>
                    </tr>
                </thead>
                <tbody>
                <%  string ruta = Request.Url.ToString().Split('?')[0].ToString();
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                     // Se deben eliminar la palabra Index, causa raiz del error. 
					 // Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					 // de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					 if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<Concurso>)ViewData["Concursos"])) { %>
                   <tr>
                        <td align="center"><a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar Concurso', 'dialogEditar');" title='Editar Concurso'><span class='ui-icon ui-icon-pencil'></span></a></td >
                        <td align="center"><a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Concurso', 'dialogEliminar');" title='Eliminar Concurso'><span class='ui-icon ui-icon-trash'></span></a></td>
                        <!--<td align="center"><a href="<%= Url.Action("Eliminar", "Concursos", new { value = item.id }) %>" title='Liquidar concurso'><span class='ui-icon ui-icon-calculator'></span></a></td>-->
                        <td align="center"><a href="javascript:mostrarDialog('<%: ruta %>Duplicar/<%: item.id %>', 'Duplicar Concurso', 'dialogEditar');" title='Duplicar Concurso'><span class='ui-icon ui-icon-copy'></span></a></td>
                        <!--<td align="center"><a href="javascript:mostrarDialog(<%= Url.Action("Duplicar", "Concursos", new { id = item.id }) %>', 'Duplicar Concurso', 'dialogEditar');" title='Duplicar Concurso'><span class='ui-icon ui-icon-copy'></span></a></td>-->
                        <td align="center"><a href="<%= Url.Action("Index", "Regla", new { value = item.id }) %>" title='Ver Detalle del Concurso'><span class='ui-icon ui-icon-newwin'></span></a></td>
                        <td align="center"><a href="<%= Url.Action("Index", "LiquidacionConcurso", new { value = item.id }) %>" title='Liquidar concurso'><span class='ui-icon ui-icon-calculator'></span></a></td>
                        <td><%: item.nombre %></td>
                        <td align="center"><%: String.Format("{0:d}",item.fecha_inicio) %></td>
                        <td align="center"><%: String.Format("{0:d}",item.fecha_fin) %></td>
                        <td align="center"><%: item.TipoConcurso.nombre %></td>                        
                        <td align="center"><%: ((item.principal == true) ? "Si" : "No") %></td>
                        <td align="center">
                        <% if (item.principal == true)
                           { %>
                        <a href="<%= Url.Action("Index", "PersistenciaEsperada", new { value = item.id }) %>" title='Persistencia/Siniestralidad'><span class='ui-icon ui-icon-document'></span></a>
                        <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
                </table>
            </td>
        </tr>
         </table>
    </div>

    
    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>