<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Presupuesto>>" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Presupuestos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script  type="text/javascript">       
        $(document).ready(function () {

            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true, "aaSorting": [[2, "desc"]]
            });

            $("#bCargue").button({ icons: { primary: "ui-icon-document"} });

        });
	</script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Presupuestos Cargados</h2>
			<p>
				<%: Html.ActionLink("Regresar","Index","Presupuesto") %>
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

    <fieldset id="fieldLista"><legend><h3>Listado de Presupuestos</h3></legend>
        <a href="/Presupuesto/Carge/" id="bCargue" title='Cargar Presupuesto'>Cargar Presupuesto</a><br/><br/>
        <table id="tablaLista">
            <thead>
            <tr>
                <th>Fecha inicial</th><th>Fecha final</th><th>Último carge</th><th>Opciones</th>
            </tr>
            </thead>
            <tbody>
            <% if (Model != null)
               { %>
                <% 
                    foreach (var item in Model) {

                        var anio = item.fechaInicio.Value.Year;    
                %>
                <tr id="fila<%: item.id %>">
                    <%--<td style="width:60px"><%: item.id %> </td>--%>
                    <td><%: String.Format("{0:d}", item.fechaInicio)%> </td>
                    <td><%: String.Format("{0:d}", item.fechaFin)%> </td>
                    <td><%: item.fechaModificacion%> </td>
                    <td >
                        <a href="/Presupuesto/Detalle/<%: item.id %>" title='Detalle Presupuesto' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-newwin'/></a>
                    </td>
                </tr>
                <% } %>
            <% } %>
            </tbody>
        </table>
    </fieldset>    
</asp:Content>
