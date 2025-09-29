<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4>¿Esta seguro de eliminar este grupo?</h4>
    <% using (Html.BeginForm())
        { %>
        <p>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>