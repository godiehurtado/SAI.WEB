<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.Moneda>" %>

    <h4 align = "center">¿Esta seguro de querer eliminar la moneda <strong><%: Model.nombre %></strong>?</h4>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>