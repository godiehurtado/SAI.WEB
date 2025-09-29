<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Detalle
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>DetalleDetalle Participación Franquicia</h2>

<p>
  <%: Html.ActionLink("Regresar", "Index" + "/" + Session["idfranquicia"])%>
   <%-- <%: Html.ActionLink("Editar", "Edit", new { id=Model.id }) %> |--%>
  
</p>
<fieldset>
    <legend>Detalle Participación Franquicia</legend>

   

     <table cellspacing="1" cellpadding="1" width="100%" border="0">
            <tr class="trColor1">
                <td><%: Html.Label("Compañía")%></td>
                <td>  <%: Html.DisplayFor(model => model.Compania.nombre) %></td>
                <td></td>
                <td></td>
            </tr>
            <tr >
                <td><%: Html.Label("Ramo")%></td>
                <td>
                     <%: Html.DisplayFor(model => model.Ramo.nombre) %>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr class="trColor1">
                <td>
                    <%: Html.Label("Producto")%>
                </td>
                <td>
                    <%: Html.DisplayFor(model => model.Producto.nombre) %>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    <%: Html.Label("Planes")%>
                </td>
             
                <td>
                    <%: Html.DisplayFor(model => model.Plan.nombre) %>
                </td>
                <td>
                    <%: Html.Label("Porcentaje")%>
                </td>
                <td>
                      <%: Html.DisplayFor(model => model.porcentaje) %>%
                </td>
            </tr>
            <tr class="trColor1">
                <td>
                    <%: Html.Label("Línea de Negocio")%>
                </td>
                <td>
                 <% if (Model.lineaNegocio_id != null && Model.lineaNegocio_id != 0)
                    { %>
                   <%= Html.DisplayFor(model => model.lineaNegocio_id) %>
                    <% } %>
                </td>
                <td>Rango Inferior</td>
                <td><%: Html.DisplayFor(model => model.rangoinferior) %></td>
            </tr>
            <tr>
                <td>
                    <%: Html.Label("Tipo de Vehículo")%>
                </td>
                <td>
                 <% if (Model.tipoVehiculo_id != null && Model.tipoVehiculo_id != 0)
                    { %>
                   <%: Html.DisplayFor(model => model.TipoVehiculo.Nombre) %>
                    <% } %>                    
                </td>
                <td>Rango Superior</td>
                <td>  <%: Html.DisplayFor(model => model.rangosuperior) %></td>
            </tr>
            
        </table>



</fieldset>


</asp:Content>
