<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4>¿Esta seguro de eliminar este Registro?</h4>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">           
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>