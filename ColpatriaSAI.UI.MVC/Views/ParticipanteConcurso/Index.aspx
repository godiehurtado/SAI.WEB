<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Participantes del Concurso - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

	<script type="text/javascript">
		function mostrarDialog(pagina, titulo, dialog) {
			$("#" + dialog).dialog({
				height: 150, width: 300, modal: true, title: titulo,
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

		function mostrarDialogParticipantes(pagina, titulo, dialog) {
			$("#" + dialog).dialog({
				height: 620, width: 550, modal: true,
				buttons: {
					Cerrar: function () {
						$(this).dialog("close");
					}
				},
				 title: titulo,

				open: function (event, ui) { $(this).load(pagina); },
				close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
			});
		}

		function mostrarDialogJerarquia(pagina, titulo, dialog) {
		    $("#" + dialog).dialog({
		        height: 620, width: 550, modal: true,
		        buttons: {
		            Cerrar: function () {
		                $(this).dialog("close");
		            }
		        },
		        title: titulo,

		        open: function (event, ui) { $(this).load(pagina); },
		        close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
		    });
		}

		function cerrarDialog(dialog) {
			$("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
		}
		$(document).ready(function () {
			oTable = $('#tablaLista').dataTable({"bJQueryUI": true,"sPaginationType": "full_numbers","bStateSave": true});
			$("#bAnterior").button({icons: {primary: "ui-icon-circle-arrow-w"}});
			$("#bInicio").button({ icons: { primary: "ui-icon-home"}});
			$("#bSiguiente").button({ icons: { secondary: "ui-icon-circle-arrow-e"} });
			$("#compania_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
			$("#categoria_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
			$("#zona_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
			$("#canal_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
			$("#nivel_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
			$("#segmento_id option").each(function () {
			    $(this).attr({ 'title': $.trim($(this).html()) });
			});
        }); // close document.ready
	</script>

	<%--VALIDATOR--%>
	<script type="text/javascript">
		$().ready(function () {
			$(function () {
				$("#progressbar").progressbar({
					value: 26
				});
			});
				   
			$("#formParticipanteConcurso").validate({
				rules: {
					nombre: "required"
				}                        
			});               
		});
	</script>

	<script type="text/javascript">
		$(function () {
			var zonas = $("#zona_id");
			var localidades = $("#localidad_id");
			zonas.change(function () {
				localidades.find('option').remove();
				$.getJSON('/ParticipanteConcurso/getLocalidades', { zona_id: zonas.val() }, function (data) {
					$("<option value='0' selected>Todos</option>").appendTo(localidades);
					$(data).each(function () {
						$("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
					});
				});
			});
		});
	</script>

    <script type="text/javascript">
        function participanteConcursoSave() {
            if ($("#formParticipanteConcurso").valid()) {
                $("#crear").attr('disabled', true);
                $("#formParticipanteConcurso").submit();
                mostrarCargando("<strong>Enviando informacion. Espere Por Favor...</strong>");                
            }
        }
    </script>

	<script  type="text/javascript">javascript: window.history.forward(1);</script>

	<div id="encabezadoConcurso" align = "center">
		<div id="infoPasoActual" align = "center">
			<h2>Paso 1: Definir participantes</h2>
			<div><%: ViewData["Concursos"] %> </div>
		</div>
		<div id="progreso" align = "center">
			<%--<div id="progressbar" align = "center"></div>--%>
			<ul id="pasos">					
					<li><b>1.Participantes</b></li>
					<li>2. <a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="A1">Productos</a></li>										
					<li>3. <a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" id="A5">Reglas y Premios</a></li>
			</ul>
		</div>
	   <div style="clear:both;"><hr /></div>
	</div>
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

	 <% if (TempData["Mensaje"] != null)
	   { %>
		<div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
	<% } %>

   
	<table id="tablaAdmin">
		<tr valign="top">
			<td>
		  
				<% using (Html.BeginForm("Crear", "ParticipanteConcurso", FormMethod.Post, new { id = "formParticipanteConcurso" }))
				   {
					Html.ValidationSummary(true); %>
					<% ColpatriaSAI.UI.MVC.Models.ParticipanteConcursoViewModel participanteconcurso = (ColpatriaSAI.UI.MVC.Models.ParticipanteConcursoViewModel)ViewData["ParticipanteConcursoViewModel"]; %>
					<fieldset style="border:1px solid gray">
					<table width="100%" cellpadding="2">
					<tr>                          
						<td><u><%: Html.Label("Compañia")%></u></td>
						<td><%: Html.DropDownList("compania_id", (SelectList)participanteconcurso.CompaniaList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>

						<td><%: Html.Label("Zona")%></td>
						<td><%: Html.DropDownList("zona_id", (SelectList)participanteconcurso.ZonaList, "Todas", new { style = "width:300px;" })%></td>

					</tr>   
					<tr>                          
						<td><u><%: Html.Label("Segmento")%></u></td>
						<td><%: Html.DropDownList("segmento_id", (SelectList)participanteconcurso.SegmentoList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>

						<td><%: Html.Label("Localidad")%></td>
						<td><%: Html.DropDownList("localidad_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;" })%></td>

					</tr>
					 <tr>
						<td><%: Html.Label("Canal")%></td>
						<td><%: Html.DropDownList("canal_id", (SelectList)participanteconcurso.CanalList, "Todas", new { style = "width:300px;" })%></td>

						<% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1)
                        { %>
                        <td><%: Html.Label("Intermediario")%></td>
						<td><%: Html.TextBox("participante", null, new { @readonly = "true", style = "width:230px;" })%>
							<%: Html.Hidden("participante_id", 0, new { id = "participante_id" })%>
							<a href="javascript:mostrarDialogParticipantes('<%: ruta %>Participantes?r=<%: num %>&zona_id=0&concurso_id=<%: ViewData["value"] %>', 'Participantes', 'dialogEditar');" style='float:none;' title='Buscar Participantes'>Buscar</a>
						</td>
                        <% } %>

                        <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2)
                        { %>
                        <td><%: Html.Label("Jerarquía Comercial")%></td>
						<td><%: Html.TextBox("jerarquia", null, new { @readonly = "true", style = "width:230px;"  })%>
							<%: Html.Hidden("jerarquiaDetalle_id", 0, new { id = "jerarquiaDetalle_id" })%>
							<a href="javascript:mostrarDialogJerarquia('<%: ruta %>Jerarquia?r=<%: num %>&zona_id=0&concurso_id=<%: ViewData["value"] %>', 'Jerarquia', 'dialogEditar');" style='float:none;' title='Buscar Ejecutivo'>Buscar</a>
						</td>
                        <% } %>

					</tr>
					  <tr>
						<td><%: Html.Label("Nivel")%></td>
						<td><%: Html.DropDownList("nivel_id", (SelectList)participanteconcurso.NivelList, "Todas", new { style = "width:300px;" })%></td>

						<td><%: Html.Label("Categoria")%></td>
						<td><%: Html.DropDownList("categoria_id", (SelectList)participanteconcurso.CategoriaList, "Todas", new { style = "width:300px;" })%></td>

					</tr>
					<tr>
						<td><input type="button" value="Guardar" id = "crear" onclick="participanteConcursoSave()" /></td>
						<td><input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" /></td>
					</tr>
					</table>
					</fieldset>
					<table align="center">
						<tr >
							<td><a href="<%= Url.Action("Index", "Concursos") %>" id="bAnterior">Anterior</a></td>
							<td><a href="../Concursos" id="bInicio">Inicio</a></td>
							<td><a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="bSiguiente">Siguiente </a></td>
						</tr>
					</table>
				<% } %>

			</td>
		</tr>
	</table>    

	 <table id="tablaLista">
				<thead>
					<tr>
						<th align = "center">Opciones</th>
						<th align = "center">Compañia</th>
						<th align = "center">Segmento</th>
						<th align = "center">Canal</th>
						<th align = "center">Nivel</th>
						<th align = "center">Zona</th>
						<th align = "center">Localidad</th>
                        <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1)
                           { %> 
						<th align = "center">Intermediario</th>
                        <% } %>
                        <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2)
                           { %> 
                        <th align = "center">Ejecutivo</th>
                        <% } %>
						<th align = "center">Categoria</th>            
					</tr>
				</thead>
				<tbody>				 
			
				<% 
					foreach (var item in ((IEnumerable<ParticipanteConcurso>)ViewData["ParticipanteConcursos"])) { %>					
					<tr>
						<td align="center">
							<%--<a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Participantes'><span class='ui-icon ui-icon-pencil'/></a>--%>
							<a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:center;' title='Eliminar Participantes'><span class='ui-icon ui-icon-trash'/></a>
						</td>
						<td align = "center"><%: item.Compania.nombre %></td>                        
						<td align = "center"><%: item.Segmento.nombre %></td>
						<td><%: item.Canal.nombre %></td>
						<td align = "center"><%: item.Nivel.nombre %></td>                        
						<td align = "center"><%: item.Zona.nombre %></td>    
						<td align = "center"><%: item.Localidad.nombre %></td>
                        <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 1)
                           { %>                                          
						<td align = "center"><%: item.Participante.nombre + " " + item.Participante.apellidos%></td>                        
                        <% } %>
                        <% if (Convert.ToInt16(TempData["tipoConcurso_id"]) == 2)
                           { %>                                          
						<td align = "center"><%: item.JerarquiaDetalle.nombre %></td>                        
                        <% } %>
						<td><%: item.Categoria.nombre %></td> 
					</tr>
				<% } %>
				</tbody>
				</table>   

  
	<div id='dialogEditar' style="display:none;"></div>
	<div id='dialogEliminar' style="display:none;"></div>

</asp:Content>