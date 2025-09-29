<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Etapas - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2> Etapas </h2>
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
					height: 150, width: 250, modal: true, title: titulo,
					open: function (event, ui) { $(this).load(pagina); },
					close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
				});
			}

			function cerrarDialog(dialog) {
				$("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
			}
			$(document).ready(function () {
				oTable = $('#tablaLista').dataTable({
					"bJQueryUI": true,
					"sPaginationType": "full_numbers","bStateSave": true
				});
				$("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
				$("#bInicio").button({ icons: { primary: "ui-icon-home"} });
				$("#bSiguiente").button({ icons: { secondary: "ui-icon-circle-arrow-e"} });

			});
			$(function () {
				$("#progressbar").progressbar({
					value: 50
				});
			});

	</script>

	<%--VALIDATOR--%>
			<script type="text/javascript">
				$.validator.setDefaults({
					
				});

				$().ready(function () {
					  $("#EtapaProducto").validate();                   
					$("#EtapaProducto").validate({
						rules: {
							nombre: "required"
						},                       
					}); });
			</script>
			
    <script type="text/javascript">
            javascript: window.history.forward(1);
    </script>

	<table id="tablaAdmin">
		<tr valign="top">
			<td>
				 <% Html.EnableClientValidation(); %>
				<% using (Html.BeginForm("Crear", "EtapaProducto", FormMethod.Post, new { id = "EtapaProducto" }))
				   {
					Html.ValidationSummary(true); %>
					<% ColpatriaSAI.UI.MVC.Models.EtapaProductoViewModel etapaproducto = (ColpatriaSAI.UI.MVC.Models.EtapaProductoViewModel)ViewData["EtapaProductoViewModel"]; %>
					
					<table align="center">
					<tr >						
						<td><a href="../Concursos" id="bInicio">Inicio</a></td>						
					</tr>
				</table>				

				<% } %>

			</td>          
		</tr>
	</table>
	
	<% if (TempData["Mensaje"] != null)
	   { %>
		<div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
	<% } %>

	<table id="tablaLista">
				<thead>
					<tr>
						<th>Opciones</th>
						<th>Etapa</th>
						<th>Detalle</th>   
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
				<% foreach (var item in ((IEnumerable<EtapaProducto>)ViewData["EtapaConcursos"]))
				   { %>
			
					<tr>
					   <td align="center">
							<a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Etapa'><span class='ui-icon ui-icon-pencil'/></a>							
						</td>
						<td><%: item.nombre %></td>
						<td align= "center">
							<%=Html.ActionLink("Etapas por Compañía", "Index", "CompaniaxEtapa", new { valuet = item.id, value = Request.QueryString["value"] }, new { })%> 
						</td>
					</tr>
				<% } %>
				</tbody>
				</table>

	<div id='dialogEditar' style="display:none;"></div>
	<div id='dialogEliminar' style="display:none;"></div>

</asp:Content>