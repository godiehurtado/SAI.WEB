<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Amparo>>" %>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Amparos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 <h2>Amparos</h2>
      <p> 
        <a href="/Administracion">Regresar</a> | <%: Html.ActionLink("Crear nuevo Amparo", "Create") %>
    </p>
      
 <script type="text/javascript">
     $(document).ready(function () {
         oTable = $('#tablaLista').dataTable({
             "bJQueryUI": true,
             "sPaginationType": "full_numbers",
             "bStateSave": true
         });
     });

     function eliminarAmparo(idAmparo) {

         if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
             var stUrl = '/Amparo/DeleteAmparo';
             mostrarCargando("Eliminando Amparo. Espere Por Favor...");
             $.ajax({
                 type: 'POST',
                 url: stUrl,
                 data: {
                     idAmparo: idAmparo
                 },
                 success: function (response) {
                     if (response.Success) {
                         closeNotify('jNotify');

                         if (response.Result == 1) {
                             mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                             window.location.href = window.location.href;
                         }
                         else if (response.Result == 0) {
                             mostrarError("El Amparo no se puede eliminar por que hay registros relacionados.")
                         }

                     }
                 }
             });
         }
     }

	</script>
    
   <table  id="tablaLista">
    <thead> 
        <tr>
            <th>Código</th>
            <th>Nombre</th>
            <th>Opciones</th>
         
        </tr>
     </thead>
     <tbody>
    <% foreach (var item in Model) { %>
        <tr>
            <td align=center><%: item.id %></td>         
            <td><%: item.nombre %></td>
            <td nowrap = "nowrap" align="center">
                            <a href="/Amparo/Editar/?AmparoId=<%: item.id %>" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                
                            <a href="/Amparo/Detalle/?idAmparo=<%: item.id %>" title='Agrupar Amparos' style="float:left;"><span class='ui-icon ui-icon-newwin'/></a>                
                            <a href="javascript:eliminarAmparo(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                        </td>
           
        </tr>
    <% } %>
     </tbody>
    </table>



   
     

</asp:Content>