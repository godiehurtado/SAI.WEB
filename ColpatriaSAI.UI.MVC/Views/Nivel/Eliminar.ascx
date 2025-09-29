<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.Nivel>" %>
    <h4 align = "center">¿Esta seguro de querer eliminar el registro <strong><%: Model.nombre %></strong>?</h4>
    <% using (Html.BeginForm())
        { %>
        <p>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>