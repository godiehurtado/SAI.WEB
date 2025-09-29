<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.SalarioMinimo>" %>

    <h4>¿Esta seguro de querer eliminar el salario mínimo para el año <strong><%: Model.anio %></strong>?</h4>
    <% using (Html.BeginForm())
        { %>
        <p>
		    <input type="submit" value="Eliminar" />
        </p>
    <% } %>