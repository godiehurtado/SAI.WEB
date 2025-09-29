<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4 align = "center">¿Esta seguro de eliminar este Registro?</h4>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
            <%: Html.Hidden("id", ViewData["id"]) %>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>