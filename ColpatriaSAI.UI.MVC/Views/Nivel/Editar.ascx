<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %><%--ColpatriaSAI.Negocio.Entidades.Nivel--%>

<script type="text/javascript">
    $().ready(function () {
        $("#NivelEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "Nivel", FormMethod.Post, new { id = "NivelEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.NivelViewModel nivel = (ColpatriaSAI.UI.MVC.Models.NivelViewModel)ViewData["CrearNivel"]; %>
        <table>
            <tr>
                <td><%: Html.Label("Nombre") %></td>
                <td>
                    <%: Html.TextBoxFor(Model => nivel.NivelView.nombre, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(Model => nivel.NivelView.nombre)%>
                </td>
            </tr>
        </table>
        <p><input type="submit" value="Crear" /></p>
    <% } %>
