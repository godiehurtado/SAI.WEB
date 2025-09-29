<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.IngresoLocalidad>" %>

    <h4>¿Esta seguro de querer eliminar el ingreso para el grupo <%: this.Model.grupo %> del año <%: this.Model.año %>, localidad <%: this.Model.Localidad.nombre %>?</h4>
    <% using (Html.BeginForm("Eliminar", "IngresoLocalidad", FormMethod.Post, new { id = "IngresoLocalidadEliminar" }))
        { %>
        <p>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>