<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ExcepcionJerarquiaDetalleModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Excepciones Jerarquia - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Listado de Excepciones</h2>
			<p>
				<%: Html.ActionLink("Regresar", "Index","Franquicias") %>
				<%: Html.ActionLink("Nueva Excepción", "Create/" + RouteData.Values["id"])%>
			</p>
		</div>

		<div id="progresoSeccion">
	</div>
</asp:Content>
		<div style="clear:both;"><hr /></div>
	</div>
	<table id="tablaLista">
	<thead>
		<tr>
			<th align = "center">Editar</th>
			<th align = "center">Eliminar</th>
			<th align = "center">Fecha inicial (dd/mm/yyyy)</th>
			<th align = "center">Fecha final (dd/mm/yyyy)</th>
			<th align = "center">Estado</th>
			<th align = "center">Porcentaje</th>
		</tr>
	</thead>
	<tbody>
	<% foreach (var item in Model) { %>
	
		<tr>
			<td align="center"><a href='<%: Url.Action("Edit", "Excepciones", new { id = item.id }) %>' title='Editar' ><span class='ui-icon ui-icon-pencil'></span></a></td>
			<td align="center"><a href='<%: Url.Action("Delete", "Excepciones",new { id = item.id, idLocalidad = RouteData.Values["id"] }) %>' title='Eliminar' ><span class='ui-icon ui-icon-trash'></span></a></td>
			<td align = "center">
                <%
                    if (item.fecha_ini.Value == DateTime.Parse("01/01/1900"))
                    {    
                        %>
                            Siempre Vigente
                        <%
                    }
                    else
                    {
                %>
                    <%: String.Format("{0:d}", item.fecha_ini)%>
                <%
                    } 
                %>
            </td>
			<td align = "center">
                <%
                    if (item.fecha_fin.Value.ToShortDateString() == DateTime.MaxValue.ToShortDateString())
                    {    
                        %>
                            Siempre Vigente
                        <%
                    }
                    else
                    {
                %>
                    <%: String.Format("{0:d}", item.fecha_fin)%>
                <%
                    } 
                %>
            </td>
			<td align = "center"><%: (item.Estado) ? "Activa" : "Inactiva" %></td>
			<td align = "center"><%: item.Porcentaje %>%</td>
		</tr>
	
	<% } %>
	</tbody>
	</table>

	<script type="text/javascript">
	    $(document).ready(function () {
	        $('#tablaLista').dataTable({ "bJQueryUI": true,
	            "sPaginationType": "full_numbers","bStateSave": true
	        })
	        var oTable = $('.tbl').dataTable();
	    })
   </script>

	
