<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.ParticipacionFranquicia>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Porcentajes de participación - Sistema de Administración de Incentivos 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            var oTable = $('.tbl').dataTable();
        })

        function eliminarPartFranquicia(id) {
            if (confirm('¿Esta seguro de eliminar esta participación?')) {
                mostrarCargando(Procesando);
                $.ajax({ url: '/ParticipacionFranquicias/Delete', data: { id: id }, type: "POST", async: false,
                    success: function (result) {
                        closeNotify('jNotify');
                        mostrarExito("Proceso Terminado. Espere por favor...");
                        window.location.href = document.location;
                    }
                });
            }
        }
   </script>

    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Porcentajes de participación</h2>
            <h4><%: TempData["nombreFranquicia"]%></h4>
            <p>
            <%: Html.ActionLink("Regresar", "Index","Franquicias") %> |
            <%: Html.ActionLink("Nueva", "Create", new { id=int.Parse(Session["idfranquicia"].ToString()) })%> | 
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
            Haga clic en Nueva para definir nuevos porcentajes de participación a <b><%: TempData["nombreFranquicia"]%></b>. 
            Haga clic en <b>Copiar porcentajes</b> si desea definir los porcentajes de esta franquicia a partir de otra existente. <br />
            Haga clic en el icono de descargar para poder visualizar la información completa o guardarla en formato <b>EXCEL</b>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <table class="tbl" id="tablaLista">
		<thead>
		<tr>
			<th align="center">Editar</th>
            <th align="center">Copiar % A</th>
			<th align="center">Descargar</th>
			<th align="center">Eliminar</th>
			<%--<th>id</th>--%>
			<th align="center">Fecha inicial (dd/mm/yyyy) </th>
			<th align="center">Fecha final (dd/mm/yyyy) </th>
			<%--<th>localidad_id</th>--%>
			<th>Localidad</th>
			<%--<th>fecha_actualizacion</th>--%>
		</tr>
		</thead>
        <tbody>
    <% 
        foreach (var item in Model) { 
            
       %>
        <tr>
            <td align="center">
                <a href='<%: Url.Action("Edit", "ParticipacionFranquicias", new { id = item.id }) %>' title='Editar'><span class='ui-icon ui-icon-pencil'></span></a>
            </td>

<%--        <td align="center">
                <a href='<%: Url.Action("Detalle", "ParticipacionFranquicias", new { id = item.id }) %>' title='Detalle' class='ui-state-default ui-corner-all'><span class='ui-icon ui-icon-search'></span></a>
            </td>
--%>        
            <td align="center">
                <a href='<%: Url.Action("CopiarParametrizacionFranquicia", "ParticipacionFranquicias", new { id = item.id }) %>' title='Copiar Porcentajes'><span class='ui-icon ui-icon-play'></span></a>
            </td>

			<td align="center">
                <a href='#'  onclick="popupReport('ReporteParamFranquicia','id_par_fran=<%=item.id %>');"  title='Descargar Parametrización' ><span class='ui-icon ui-icon-search'></span></a>
			</td>
    
            <td align="center">
                <a href="#" onclick='eliminarPartFranquicia(<%: item.id %>)' title='Eliminar' ><span class='ui-icon ui-icon-trash'></span></a>
            </td>
            <%--<td>
                <%: item.id %>
            </td>--%>
            <td align="center"><%: String.Format("{0:d}", item.fecha_ini) %></td>
            <td align="center"><%: String.Format("{0:d}", item.fecha_fin) %></td>
             <%-- <td ><%: String.Format("{0:g}", item.Localidad.id) %></td>--%>
            <td >
            <% if (int.Parse(Session["idfranquicia"].ToString()) != 0) { %>
                <%: String.Format("{0:g}", item.Localidad.nombre) %>
            <% } else {%>
                <%:String.Format("{0:g}", "Condiciones Generales")%>
            <% } %>
            </td>
            <%--<td><%: String.Format("{0:g}", item.fecha_actualizacion) %></td>--%>
        </tr>
    <% } %>
        </tbody>
    </table>
</asp:Content>