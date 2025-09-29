<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4>¿Esta seguro de eliminar esta base de moneda</strong>?</h4>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>