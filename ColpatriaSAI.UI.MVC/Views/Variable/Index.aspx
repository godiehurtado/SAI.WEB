<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Variable
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <h2>Variable</h2>

    <script type="text/javascript">
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarLinea").attr("value", "");
            $("#buscarDescrip").attr("value", "");
            $("#buscarTipo").attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bLinea = document.getElementById('buscarLinea').value;
	            var bDescrip = document.getElementById('buscarDescrip').value;
	            var bTipo = document.getElementById('buscarTipo').value;

	            var Linea = aData[1];
	            var Descrip = aData[2];
	            var Tipo = aData[2];

	            var comparaLinea = Linea.toUpperCase().indexOf(bLinea.toUpperCase());
	            var comparaDescrip = Descrip.toUpperCase().indexOf(bDescrip.toUpperCase());
	            var comparaTipo = Tipo.toUpperCase().indexOf(bTipo.toUpperCase());

	            if ((comparaLinea >= 0) && (comparaDescrip >= 0) && (comparaTipo >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarLinea').keyup(function () { oTable.fnDraw(); });
            $('#buscarDescrip').keyup(function () { oTable.fnDraw(); });
            $('#buscarTipo').keyup(function () { oTable.fnDraw(); });
        });
	</script> 
  

    <%  string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>

    
    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
    <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		<tr>
			<td><label for="buscarLinea">Nombre:</label></td>
			<td><input type="text" id="buscarLinea" name="buscarLinea" /></td>
			<td><label for="buscarDescrip">Descripcion:</label></td>
			<td><input type="text" id="buscarDescrip" name="buscarDescrip" /></td>
			<td><label for="buscarTipo">Tipo Variable:</label></td>
			<td><input type="text" id="buscarTipo" name="buscarTipo" /></td>
		</tr>
	</table>

   <table  id="tablaLista">
    <thead>
        <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Descripcion</th>
            <th>Tipo Variable</th>
         </tr>
         </thead>
        <tbody>
     <% foreach (var item in ((IEnumerable<Variable>)ViewData["Variables"]))
       { %>
        <tr>
            <td align="center"><%: item.id %></td>
            
            <td><%: item.nombre %></td>
            <td><%: item.descripcion %></td>
            <td><%: item.TipoVariable.tipovariable1 %></td>

        </tr>
    <% } %>
   </tbody>
    </table>
    
</asp:Content>