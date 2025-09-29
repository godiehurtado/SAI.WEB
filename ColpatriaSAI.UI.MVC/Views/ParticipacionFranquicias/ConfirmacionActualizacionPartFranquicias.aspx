<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ConfirmacionActualizacionPartFranquicias
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

 <script type="text/javascript">
     $(document).ready(function() {
         $('#tablaLista').dataTable({ "bJQueryUI": true,
                 "sPaginationType": "full_numbers","bStateSave": true

             });

         var oTable = $('.tbl').dataTable();

     });

     function Actualizar() {

         $.ajax({
             url: '/ParticipacionFranquicias/ActualizacionPartFranquiciasConfirmada',
             data: null,
             type: 'POST',
             contentType: 'application/json;',
             dataType: 'json',
             success: function (result) {

                 if (result.Success == 1) {
                     alert("Se ha actualizo la información con exito");
                     window.location.href = "/Franquicias/Index/";
                     


                 }
                 else {
                     alert(result.ex);
                 }
             }
         });
     }
     

   </script>
<h2>Actualizacion Franquicias</h2>
<h3>Esta seguro de cambiar estos registros?</h3>
<p>
    <%: Html.ActionLink("Regresar", "ActualizacionMasivaPartFranquicias") %>
</p>
<table class="tbl" id="tablaLista">
   <thead>
    <tr>
       
        <th>
          Compañia
        </th>
        <th>
            Ramo
        </th>
        <th>
            Producto
        </th>
        <th>
            porcentaje
        </th>
        <th>
            Rango Inferior
        </th>
        <th>
            Rango Superior
        </th>
        <th>
           Plan
        </th>
        <th>
            Linea Negocio
        </th>
        <th>
            Tipo Vehiculo
        </th>
      
    </tr>
     </thead>
<% foreach (var item in Model) { %>
    <tr>
       
        <td>
            <%: Html.DisplayFor(modelItem => item.Compania.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.Ramo.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.Producto.nombre) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.porcentaje) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.rangoinferior) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.rangosuperior) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.plan_id) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.lineaNegocio_id) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.tipoVehiculo_id) %>
        </td>
       
    </tr>
    
<% } %>

</table>


                <input type="button" value="Guardar" onclick="Actualizar()" />
                 
               
</asp:Content>
