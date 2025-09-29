<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Productos del concurso - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
		<script type="text/javascript">
			function mostrarDialog(pagina, titulo, dialog) {
				$("#" + dialog).dialog({
					height: 250, width: 300, modal: true, title: titulo,
					open: function (event, ui) { $(this).load(pagina); },
					close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
				});
			}

			function mostrarDialog1(pagina, titulo, dialog) {
				$("#" + dialog).dialog({
					height: 190, width: 300, modal: true, title: titulo,
					open: function (event, ui) { $(this).load(pagina); },
					close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
				});
			}

			function cerrarDialog(dialog) {
				$("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
			}
			$(document).ready(function () {
				oTable = $('#tablaLista').dataTable({"bJQueryUI": true,"sPaginationType": "full_numbers","bStateSave": true});
				$("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
				$("#bInicio").button({ icons: { primary: "ui-icon-home"} });
				$("#bSiguiente").button({ icons: { secondary: "ui-icon-circle-arrow-e"} });
				$("#compania_id option").each(function () {
				    $(this).attr({ 'title': $.trim($(this).html()) });
				});
				$("#lineaNegocio_id option").each(function () {
				    $(this).attr({ 'title': $.trim($(this).html()) });
				});
			});
	</script>

	<%--VALIDATOR--%>
			<script type="text/javascript">
				$().ready(function () {

					$(function () {
						$("#progressbar").progressbar({
							value: 39
						});
					});

					$("#ProductoConcurso").validate({
						rules: {
							nombre: "required"
						}
					}); 
				});
			</script>

			<%--DATEPICKER --%>
	<script type="text/javascript">
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
	  </script>

	  <script type="text/javascript">
		  $(function () {
			  var companias = $("#compania_id");
			  var ramos = $("#ramo_id");
			  var productos = $("#producto_id");
			  companias.change(function () {
				  ramos.find('option').remove();
				  $("#producto_id").attr("disabled", "disabled");
				  $("<option value='0' selected>Todas</option>").appendTo(productos);
				  $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
					  $("<option value='0' selected>Todas</option>").appendTo(ramos);
					  $(data).each(function () {
						  $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
					  });
				  });
			  });
			  ramos.change(function () {
				  productos.find('option').remove();
				  $("#producto_id").removeAttr("disabled");
				  $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
					  $("<option value='0' selected>Todas</option>").appendTo(productos);
					  $(data).each(function () {
						  $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
					  });
				  });
			  });
		  });
	   </script>

        <script type="text/javascript">
           function productoConcursoSave() {
               if ($("#ProductoConcurso").valid()) {
                   $("#crear").attr('disabled', true);
                   $("#ProductoConcurso").submit();
                   mostrarCargando("Enviando informacion. Espere Por Favor...");
               }
           }
        </script>
	   
	   <script  type="text/javascript">javascript: window.history.forward(1);</script>

		<div id="encabezadoConcurso" align = "center">
		<div id="infoPasoActual" align = "center">
			<h2>Paso 2: Definir Productos</h2>
			<div><%: ViewData["Concursos"] %> </div>
		</div>
		<div id="progreso" align = "center">
			<%--<div id="progressbar"></div>--%>
			<ul id="pasos">					
					<li>1. <a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>" id="A1">Participantes</a></li>
					<li><b>2.Productos</b></li>					
					<li>3. <a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" id="A5">Reglas y Premios</a></li>
			</ul>
		</div>
	   <div style="clear:both;"><hr /></div>
	</div>  

	  <% if (TempData["Mensaje"] != null)
	   { %>
		<div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
	   
	  <% } %>


	<table id="tablaAdmin" >
		<tr valign="top">
			<td>
				 <% Html.EnableClientValidation(); %>
				<% using (Html.BeginForm("Crear", "ProductoConcurso", FormMethod.Post, new { id = "ProductoConcurso"}))
				   {
					Html.ValidationSummary(true); %>
					<% ColpatriaSAI.UI.MVC.Models.ProductoConcursoViewModel productoconcurso = (ColpatriaSAI.UI.MVC.Models.ProductoConcursoViewModel)ViewData["ProductoConcursoViewModel"]; %>
					
					<fieldset style="border:1px solid gray">
					<table width="100%" cellpadding="2">
				   
					<tr>
						<td><u><%: Html.Label("Compañia")%></u></td>
						<td><%: Html.DropDownList("compania_id", (SelectList)productoconcurso.CompaniaList, "Seleccione un Valor", new { style = "width:300px;", id = "compania_id", @class = "required" })%></td>
					
						<td><u><label for="FechaInicio">Fecha Inicio</label></u></td>
						<td><%= Html.TextBox("FechaInicio", null, new { @readonly = "true", @class = "required" })%></td>              
					</tr>
					<tr>
						<td><%: Html.Label("Ramo")%></td>
						<td><%: Html.DropDownList("ramo_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;", id = "ramo_id" })%></td>
					
						<td><u><label for="FechaFin">Fecha Fin</label></u></td>
						<td><%= Html.TextBox("FechaFin", null, new { @readonly = "true",@class = "required"  })%></td>
					</tr>
					<tr>
						<td><%: Html.Label("Producto")%></td>
						<td><%: Html.DropDownList("producto_id", new List<SelectListItem>(),"Todas", new { style = "width:300px;", id = "producto_id" })%></td>						
					</tr>
					<tr>
						<td><%: Html.Label("Linea de Negocio")%></td>
						<td><%: Html.DropDownList("lineaNegocio_id", (SelectList)productoconcurso.LineaNegocioList, "Todas", new { style = "width:300px;", id = "lineaNegocio_id" })%></td>						
					</tr>
					<tr>
						<td><input type="button" value="Guardar" id = "crear" onclick="productoConcursoSave()" /></td>
						<td><input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" /></td>
					</tr>
					</table>
					</fieldset>
				<% } %>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr >
			<td><a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>" id="bAnterior">Anterior</a></td>
			<td><a href="../Concursos" id="bInicio">Inicio</a></td>
			<td><a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" id="bSiguiente">Siguiente </a></td>
		</tr>
	</table>
	<table id="tablaLista">
				<thead>
					<tr>
						<th>Opciones</th>                   
						<th>Compañia</th>
						<th>Ramo</th>
						<th>Producto</th>                        
						<th>Linea Negocio</th>
						<th>Fecha Inicial</th>
						<th>Fecha Final</th>
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
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
				<% Random random = new Random();
				   int num = random.Next(1, 10000);  %>
				<% foreach (var item in ((IEnumerable<ProductoConcurso>)ViewData["ProductoConcursos"])) { %>
				   
					<tr>
					   <td align=center>
							<a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Productos'><span class='ui-icon ui-icon-pencil'/></a> 
							<a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Productos'><span class='ui-icon ui-icon-trash'/></a>
						</td>
				  
						
						
						<td align = "center"><%: item.Compania.nombre %></td>
						<td align = "center"><%: item.Ramo.nombre %></td>
						<td align = "center"><%: item.Producto.nombre %></td>                                                
						<td align = "center"><%: item.LineaNegocio.nombre %></td>  
						<td align = "center"><%: String.Format("{0:d}", item.fecha_inicio)%></td>
						<td align = "center"><%: String.Format("{0:d}", item.fecha_fin) %></td>
					  
					   
					 
					</tr>
				<% } %>
				</tbody>
				</table>   



	<div id='dialogEditar' style="display:none;"></div>
	<div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
