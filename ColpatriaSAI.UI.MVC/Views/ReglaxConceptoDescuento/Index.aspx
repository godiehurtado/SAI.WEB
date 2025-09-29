<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Descuentos de Colquines por Regla
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
        });
    </script>
    <script type="text/javascript"> 
    $().ready(function () {
        $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
    });
    </script>

    <h2>Descuentos de Colquines por Regla</h2>
    <div><%: ViewData["Concursos"] + " > " + "" + ViewData["Reglas"]%></div>

    <div style="clear:both;"><hr /></div>

    <table align="center">
		<tr>
			<td><a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" id="bAnterior">Anterior</a></td>			
		</tr>
	</table>
        <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Descuento</th>
                    </tr>
                </thead>
                <tbody>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<ReglaxConceptoDescuento>)ViewData["ReglaxConceptoDescuento"]))
                   { %>
                    <tr>
                        <td align = "center"><%: item.ConceptoDescuento.nombre %></td>
                    </tr>
                <% } %>
                </tbody>
        </table>

</asp:Content>
