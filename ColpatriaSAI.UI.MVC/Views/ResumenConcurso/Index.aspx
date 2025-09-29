<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Resumen del Concurso - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

        <style>
        #contenido table {
	        color: #7F7F7F;
	        border-collapse: collapse;
	        width:100%;
        }

        #contenido table,#contenido caption {
	        margin: 0 auto;
	        border-right: 1px solid #CCC;
	        border-left: 1px solid #CCC;
	        border-bottom: 1px solid #CCC;
        }

        #contenido caption,#contenido th,#contenido td {
	        border-left: 0;
	        padding: 10px
        }

        #contenido caption,#contenido thead th,#contenido tfoot th,#contenido tfoot td {
	        background-color: #CE1B11;
	        color: #FFF;
	        font-weight: bold;
	        text-transform: uppercase
        }

        #contenido thead th {
	        background-color: #CE1B11;
	        color: #FFF;
	        text-align: center
        }

        #contenido tbody th {
	        padding: 20px 10px
        }

        #contenido tbody tr.odd {
	        background-color: #F7F7F7;
	        color: #666
        }

        #contenido tbody a {
	        padding: 1px 2px;
	        color: #333;
	        text-decoration: none;
	        border-bottom: 1px dotted #E63C1E
        }

        #contenido tbody a:active,#contenido tbody a:hover,#contenido tbody a:focus,#contenido tbody a:visited {
	        color: #666
        }

        #contenido tbody tr:hover {
	        background-color: #EEE;
	        color: #333
        }

        #contenido tbody tr:hover a {
	        background-color: #FFF
        }

        #contenido tbody td+td+td+td a {
	        color: #C30;
	        font-weight: bold;
	        border-bottom: 0
        }

        #contenido tbody td+td+td+td a:active,#contenido tbody td+td+td+td a:hover,#contenido tbody td+td+td+td a:focus,#contenido tbody td+td+td+td a:visited {
	        color: #E63C1E
        }
        </style>

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
			height: 250, width: 300, modal: true, title: titulo,
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
	});
  
	</script>

<% ColpatriaSAI.Negocio.Entidades.Concurso concurso = (ColpatriaSAI.Negocio.Entidades.Concurso)ViewData["Concursos"]; %>
<div id="infoConcurso">
	<div id="encabezado">
		<h2><%: concurso.nombre %></h2>
		
		<p><%: concurso.descripcion %></p>
	</div>
	<div id="detalles">
		    <h3>Participantes por Concurso </h3>
		    <table align = "center" id="tablaLista">
				<thead>
					<tr>
						<th align = "left">Compañia</th>
						<th align = "left">Segmento</th>
						<th align = "left">Canal</th>
						<th align = "left">Nivel</th>
						<th align = "left">Zona</th>
						<th align = "left">Localidad</th>
						<th align = "left">Participante</th>
						<th align = "left">Categoria</th>
					</tr>
				</thead>
				<tbody>
				<%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
				
				<% foreach (var item in ((IEnumerable<ColpatriaSAI.Negocio.Entidades.ParticipanteConcurso>)ViewData["ParticipanteConcursos"])) { %>
					
					<tr>		
						<td align = "left"><%: item.Compania.nombre %></td>                        
						<td align = "left"><%: item.Segmento.nombre %></td>
						<td align = "left"><%: item.Canal.nombre %></td>
						<td align = "left"><%: item.Nivel.nombre %></td>                        
						<td align = "left"><%: item.Zona.nombre %></td>    
						<td align = "left"><%: item.Localidad.nombre %></td>                                            
						<td align = "left"><%: item.Participante.nombre %></td>                        
						<td align = "left"><%: item.Categoria.nombre %></td> 
					</tr>
				<% } %>
				</tbody>
			</table>
	    </div>
    </div>

		<h3>Productos por Concurso</h3>

	        <table align = "center">
				<thead>
					<tr>										 
						<th align = "left">Compañia</th>
						<th align = "left">Ramo</th>
						<th align = "left">Producto</th>                        
						<th align = "left">Linea Negocio</th>
						<th align = "left">Fecha Inicial</th>
						<th align = "left">Fecha Final</th>						
			
					</tr>
				</thead>
				<tbody>
				  
			  
				<% foreach (var item in ((IEnumerable<ColpatriaSAI.Negocio.Entidades.ProductoConcurso>)ViewData["ProductoConcursos"])) { %>
				   
					<tr>	
						<td align = "left"><%: item.Compania.nombre %></td>
						<td align = "left"><%: item.Ramo.nombre %></td>
						<td align = "left"><%: item.Producto.nombre %></td>                                                
						<td align = "left"><%: item.LineaNegocio.nombre %></td>  
						<td align = "left"><%: String.Format("{0:d}", item.fecha_inicio)%></td>
						<td align = "left"><%: String.Format("{0:d}", item.fecha_fin) %></td>
					</tr>
				<% } %>
				</tbody>
			</table>
				
			<h3>Reglas del Concurso</h3>   

			<table align = "center">
				<thead>
					<tr>
						<th align = "left">Nombre</th>
						<th align = "left">Fecha Inicio</th>
						<th align = "left">Fecha Fin</th>
						<th align = "left">Tipo Regla</th>
						<th align = "left">Periodo Regla</th>
					</tr>
				</thead>
				<tbody>
			   
				<% foreach (var item in ((IEnumerable<ColpatriaSAI.Negocio.Entidades.Regla>)ViewData["Reglas"])) { %>
					
					<tr>
						<td align = "left"><%: item.nombre %></td>
						<td align = "left"><%: String.Format("{0:d}",item.fecha_inicio) %></td>
						<td align = "left"><%: String.Format("{0:d}",item.fecha_fin) %></td>
						<td align = "left"><%: item.TipoRegla.nombre %></td>
						<td align = "left"><%: item.PeriodoRegla.periodo %></td>
				    </tr>
				<% } %>
				</tbody>
			</table>   

			<a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" style='float:center;' title='Regresar al Listado de Reglas'><span class='ui-icon ui-icon-arrowreturnthick-1-w'/></a>
</asp:Content>
