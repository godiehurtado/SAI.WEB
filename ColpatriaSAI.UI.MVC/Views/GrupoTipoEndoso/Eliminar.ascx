<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4 align = "center">¿Esta seguro de eliminar este registro?</h4>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>