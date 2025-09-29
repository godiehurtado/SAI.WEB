<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.ActividadEconomica>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Ocupaciones - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<h2>Ocupaciones</h2>
	<script type="text/javascript">
		$(document).ready(function () {
			oTable = $('#tablaLista').dataTable({
				"bJQueryUI": true,
				"sPaginationType": "full_numbers",
				"bStateSave": true
			});
		});
	</script>
	<% if (TempData["Mensaje"] != null)
	   { %>
		<div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
	<% } %>

   <table  id="tablaLista">
	<thead>    
		<tr>
			<th>Nombre</th>
		</tr>
	</thead>    
	<tbody>
	<% foreach (var item in Model) { %>
		<tr>
			<td><%: item.nombre %></td>
		</tr>
	<% } %>
	 </tbody>
	</table>
</asp:Content>
