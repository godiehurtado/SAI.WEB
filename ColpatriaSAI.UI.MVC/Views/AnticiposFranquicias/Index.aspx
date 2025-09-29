<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.AnticipoFranquicia>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Anticipos Franquicias - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <script type="text/javascript">

	  function mostrarBusqueda() {
		  $("#busquedaAvanzada").toggle('slow');
		  $("#buscarLocalidad").attr("value", "");
		  $("#buscarFecha").attr("value", "");
		  $("#buscarEstado").attr("value", "");
		  $("#buscarCompania").attr("value", "");
		  oTable.fnDraw();
	  }

	  $.fn.dataTableExt.afnFiltering.push(
			function (oSettings, aData, iDataIndex) {
				var bLocalidad = document.getElementById('buscarLocalidad').value;
				var bFecha = document.getElementById('buscarFecha').value;
				var bEstado = document.getElementById('buscarEstado').value;
				var bCompania = document.getElementById('buscarCompania').value;


				var Localidad = aData[1];
				var Fecha = aData[2];
				var Estado = aData[4];
				var Compania = aData[5];

				var comparaLocalidad = Localidad.toUpperCase().indexOf(bLocalidad.toUpperCase());
				var comparaFecha = Fecha.toUpperCase().indexOf(bFecha.toUpperCase());
				var comparaEstado = Estado.toUpperCase().indexOf(bEstado.toUpperCase());
				var comparaCompania = Compania.toUpperCase().indexOf(bCompania.toUpperCase());

				if ((comparaLocalidad >= 0) && (comparaFecha >= 0) && (comparaEstado >= 0) && (comparaCompania >= 0)) {
					return true;
				}
				return false;
			}
		);


        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                "bStateSave": true
            });

	        $("#bCrear").button({ icons: { primary: "ui-icon-circle-plus"} });
	        $("#bReporte").button({ icons: { primary: "ui-icon-script"} });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarLocalidad').keyup(function () { oTable.fnDraw(); });
            $('#buscarFecha').keyup(function () { oTable.fnDraw(); });
            $('#buscarEstado').keyup(function () { oTable.fnDraw(); });
            $('#buscarCompania').keyup(function () { oTable.fnDraw(); });
        });
</script>

<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Listado de anticipos</h2>
             <%: Html.ActionLink("Regresar", "Index", "LiquidacionFranqui")%>
		</div>
		<div id="progresoSeccion">
				En esta página puede visualizar los anticipos realizados a cada una de las franquicias.
				Así mismo puede realizar un nuevo anticipo o pagar/cancelar los anticipos realizados.<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

<p>
<%
    %>
	<%: Html.ActionLink("Nuevo Anticipo", "Create", null, new { id="bCrear"})%>
    <a href='#'  onclick="popupReport('ReportAnticipoFranquicia','');" title='Reporte Anticipos' id="bReporte" >Ver Reporte Anticipos</a>
</p>

<div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
<table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
	<tr>
		<td><label for="buscarLocalidad">Localidad:</label></td>
		<td><input type="text" id="buscarLocalidad" name="buscarLocalidad" /></td>
		<td><label for="buscarFecha">Fecha:</label></td>
		<td><input type="text" id="buscarFecha" name="buscarFecha" /></td>
		<td><label for="buscarEstado">Estado:</label></td>
		<td><input type="text" id="buscarEstado" name="buscarEstado" /></td>
		<td><label for="buscarCompania">Compañía:</label></td>
		<td><input type="text" id="buscarCompania" name="buscarCompania" /></td>
	</tr>
</table>

<table id="tablaLista">
<thead>
	<tr>
		<th>Editar</th>
		<th>Localidad</th>
		<th>Fecha contablización (dd/mm/yyyy)</th>
		<th>Valor Anticipo</th>
		<th>Estado</th>
		<th>Compañía</th>
	</tr>
	</thead>
	<tbody>
<% foreach (var item in Model) { %>
	<tr>
		
			<td  style="vertical-align: middle" align="center">
			  <a href='<%: Url.Action("Edit", "AnticiposFranquicias", new { id = item.Id }) %>'
	title='Editar' class='ui-state-default ui-corner-all' style="display: table-cell;"><span class='ui-icon ui-icon-pencil'/></a>
	</td> 	   
		<td>
			<%: item.Localidad.nombre %>
		</td>
		<td>
			<%: String.Format("{0:d}", item.fecha_anticipo) %>
		</td>
		<td>
			<%: String.Format("{0:C}", item.valorAnti) %>
		</td>
		<td>
		<% if (Convert.ToInt32(item.estado) == 1)
{ %>
				  <b>Creado</b>
				   <% } if (Convert.ToInt32(item.estado) == 2)
{ %>
				  Pagado
				  <% } if (Convert.ToInt32(item.estado) == 3){ %>
				  Anulado
				   <% } if (Convert.ToInt32(item.estado) == 5)
{ %>
Descontado
<% } %>

		</td>
		<td>
			<%: item.Compania.nombre %>
		</td>
	</tr>  
<% } %>
</tbody>
</table>

</asp:Content>

