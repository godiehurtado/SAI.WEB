<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Cobertura>>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Coberturas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <h2>Coberturas</h2>

  <script type="text/javascript">
      function mostrarBusqueda() {
          $("#busquedaAvanzada").toggle('slow');
          $("#buscarNombre").attr("value", "");
          $("#buscarCore").attr("value", "");
          oTable.fnDraw();
      }
      $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNombre = document.getElementById('buscarNombre').value;
	            var bCore = document.getElementById('buscarCore').value;
	            var Nombre = aData[1];
	            var Core = aData[2];
	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
	            var comparaCore = Core.toUpperCase().indexOf(bCore.toUpperCase());

	            if ((comparaNombre >= 0) && (comparaCore >= 0)) {
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
          $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
          $('#buscarCore').keyup(function () { oTable.fnDraw(); });
      });
	</script>

    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
    <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		<tr>
			<td><label for="buscarNombre">Nombre:</label></td>
			<td><input type="text" id="buscarNombre" name="buscarNombre" /></td>
			<td><label for="buscarCore">Código Core:</label></td>
			<td><input type="text" id="buscarCore" name="buscarCore" /></td>
		</tr>
	</table>

   <table  id="tablaLista">
    <thead> 
        <tr>
            <th>Código</th>           
            <th>Nombre</th>
            <th>Código Core</th>
        </tr>
     </thead>
     <tbody>
    <% foreach (var item in Model) { %>
        <tr>
            <td align="center"><%: item.id %></td>         
            <td><%: item.nombre %></td>
            <td><%: item.codigoCore %></td>
           
        </tr>
    <% } %>
     </tbody>
    </table>     

</asp:Content>