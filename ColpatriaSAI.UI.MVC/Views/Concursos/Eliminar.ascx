<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <h4 align = "center">¿Esta seguro de eliminar este Registro?</h4>
    <h5 align = "center">Esto eliminará toda la información asociada al Concurso.</h5>
    <h5 align = "center">Si el Concurso tiene liquidaciones no se eliminará.</h5>
    <% using (Html.BeginForm())
        { %>
        <p align = "center">
            <%: Html.Hidden("id", ViewData["id"]) %>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>