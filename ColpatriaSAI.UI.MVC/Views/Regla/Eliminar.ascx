<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4 align = "center">¿Esta realmente seguro de eliminar este Registro?</h4>
    <h5 align = "center">Esto eliminará toda la información asociada a la regla.</h5>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
            <%: Html.Hidden("id", ViewData["id"]) %>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>