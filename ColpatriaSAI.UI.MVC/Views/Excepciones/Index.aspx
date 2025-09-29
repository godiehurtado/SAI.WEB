<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Excepcion>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Excepciones Franquicias - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('#tablaLista').dataTable({ "bJQueryUI": true,
	            "sPaginationType": "full_numbers","bStateSave": true
	        })
	        var oTable = $('.tbl').dataTable();
	    })
   </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Listado de Excepciones</h2>
			<h4><%:ViewBag.nombreFranquicia%></h4>
			<p>
				<%: Html.ActionLink("Regresar", "Index","Franquicias") %>
                
                <%
                    if (ViewBag.excepcionEspecial == true)
                        Response.Write(Html.ActionLink("Nueva Excepción Especial", "CreateEspeciales/"));
                    else
                        Response.Write(Html.ActionLink("Nueva Excepción", "Create/" + RouteData.Values["id"]));
                %>
				
			</p>
		</div>

		<div id="progresoSeccion">
	</div>

		<div style="clear:both;"><hr /></div>
	</div>
	<table id="tablaLista">
	<thead>
		<tr>
			<th align = "center">Editar</th>
			<th align = "center">Eliminar</th>
			<th align = "center">Fecha inicial (dd/mm/yyyy)</th>
			<th align = "center">Fecha final (dd/mm/yyyy)</th>
            <%
                if (ViewBag.excepcionEspecial == true)
                {
            %>
                    <th align = "center">Localidad Para</th>
                    <th align = "center">Localidad De</th>
            <%
                }
                else
                {
            %>
                    <th align = "center">Compañía</th>
                    <th align = "center">Ramo</th>
                    <th align = "center">Producto</th>
            <% 
                }
            %>
            
            <th align = "center">Número Negocio</th>
            <th align = "center">Clave</th>
			<th align = "center">Estado</th>
			<th align = "center">Porcentaje</th>
		</tr>
	</thead>
	<tbody>
	<% foreach (var item in Model)
    { %>
	
		<tr>
			<td align="center"><a href='<%: Url.Action("Edit", "Excepciones", new { id = item.id, excepcionEspecial = ViewBag.excepcionEspecial }) %>' title='Editar' ><span class='ui-icon ui-icon-pencil'></span></a></td>
			<td align="center"><a href='<%: Url.Action("Delete", "Excepciones",new { id = item.id, idLocalidad = RouteData.Values["id"], excepcionEspecial = ViewBag.excepcionEspecial }) %>' title='Eliminar' ><span class='ui-icon ui-icon-trash'></span></a></td>
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

            <%
                if (ViewBag.excepcionEspecial == true)
                {
            %>
                     <td align = "center"><%: item.Localidad.nombre%></td>
                     <td align = "center"><%: item.Localidad1.nombre%></td>
            <%
                }
                else
                {
            %>
                    <td align = "center"><%: item.Compania.nombre%></td>
                    <td align = "center"><%: item.Ramo.nombre%></td>
                    <td align = "center"><%: item.Producto.nombre%></td>
            <% 
                }
            %>

            <td align = "center"><%: item.negocio_id%></td>
            <td align = "center"><%: item.clave%></td>
			<td align = "center"><%: (item.Estado) ? "Activa" : "Inactiva"%></td>
			<td align = "center"><%: item.Porcentaje%>%</td>
		</tr>
	
	<% } %>
	</tbody>
	</table>
</asp:Content>

