<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Excepcion>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Eliminar
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Eliminar</h2>
    
    <h3>Esta seguro de borrar este registro?</h3>
    <%: Html.ActionLink("Regresar", "Index/" + Request["idLocalidad"])%> 
    <div style="clear:both;"><hr /></div>
    <fieldset>
        <legend>Datos del registro</legend>        
     
        <table cellspacing="1" cellpadding="1" width="100%" border="0">
            <tr class="trColor1">
                <td>Compañía:</td>
                <td width="300px">
                 <% if (Model.Compania != null)
                    { %>
                  <%:Model.Compania.nombre%>
                  <% } %>
                </td>
                <td>Línea de Negocio:</td>
                <td>
                 <% if (Model.LineaNegocio != null)
                    { %>
                    <%:Model.LineaNegocio.nombre%>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>Ramo:</td>
                <td>
                <% if (Model.Ramo != null)
                    { %>
                    <%: Model.Ramo.nombre   %>
                        <% } %>
                </td>
                <td>Negocio:</td>
                <td>
                    <%: Model.negocio_id   %>
                </td>
            </tr>
            <tr class="trColor1">
                <td>Producto:</td>
                <td colspan="3">
                <% if (Model.Producto != null)
                   { %>
                    <%:Model.Producto.nombre%>
                    <% } %>
                   
                </td>
            </tr>
            <tr>
                <td>Participante:</td>
                <td colspan="3">
                    <% if (Model.Participante != null)
                   { %>
                     <%: Model.Participante.nombre   %>
                         <% } %>
                </td>
            </tr>
            <tr class="trColor1">
                <td>Porcentaje:</td>
                <td>
                    <%: Model.Porcentaje    %>%
                </td>
                   <td>Código Agrupador:</td>
                <td> <%: Model.codigoAgrupador    %></td>
            </tr>
            <tr>
                <td>Estado:</td>
                <td> 
                <%if (Model.Estado == true)
                  { %>
                  Activo
                    <% }
                  else
                  { %>
                  Inactivo
                  <% } %>
                </td>
                   <td>Localidad:</td>
                <td> <%: Model.Localidad.nombre    %></td>

            </tr>
           
        </table>
         <% using (Html.BeginForm()) { %>
        <p>	
            <input type="hidden" id="excepcionRecaudo" name="excepcionRecaudo" value="<%=Model.excepcion_recaudo %>">	   
            <input type="hidden" id="idLocalidad" name="idLocalidad" value="<%=Request["idLocalidad"] %>">
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>
    </fieldset>
   

</asp:Content>

