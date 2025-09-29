<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.ParticipacionFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Eliminar
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

  <%--  <h2>Eliminar PARTICIPACI</h2>--%>

    <h3>Esta seguro de borrar este registro?</h3>
    

    <fieldset>
        <legend>Eliminar Participación Franquicia</legend>
        <input type="hidden" id="ParticipacionFranquiciaId" name="ParticipacionFranquiciaId" value='<%= ViewData["IdLastFranquicia"] %>' />
        <table cellspacing="2" width="100%">
            <tr>
                <td><label for="FechaInicio">Fecha Inicio:</label></td>
                <td><%: String.Format("{0:g}", Model.fecha_ini) %></td>
                <td><label for="FechaFin">Fecha Final:</label></td>
                <td><%: String.Format("{0:g}", Model.fecha_fin) %></td>
            </tr>
            <tr>
                <td><label for="Localidad">Localidad:</label></td>
                <td><%: String.Format("{0:g}", Model.Localidad.nombre) %></td>
                <td><label for="FechaAct">Fecha Actualización:</label></td>
                <td><%: String.Format("{0:g}", Model.fecha_actualizacion) %></td>
            </tr>
        </table>

    </fieldset>


    <% using (Html.BeginForm()) { %>
        <p>
		    <input type="submit" value="Eliminar" /> |
		    <%: Html.ActionLink("Regresar", "Index", new { id = int.Parse(Session["idfranquicia"].ToString()) })%>
        </p>
    <% } %>

</asp:Content>

