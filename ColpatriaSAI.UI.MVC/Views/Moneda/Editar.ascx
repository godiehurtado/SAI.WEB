<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %><%--ColpatriaSAI.Negocio.Entidades.Moneda--%>

<script type="text/javascript">
    $().ready(function () {
        $("#MonedaEditar").validate();
    });
</script>

    <% using (Html.BeginForm("Editar", "Moneda", FormMethod.Post, new { id = "MonedaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.MonedaViewModel moneda = (ColpatriaSAI.UI.MVC.Models.MonedaViewModel)ViewData["CrearMoneda"]; %>
        <table width="100%" cellpadding="2">
        <tr> 
        <td>
            <%: Html.Label("Nombre") %>
            <%: Html.TextBoxFor(Model => moneda.MonedaView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => moneda.MonedaView.nombre)%></td>

            <td><%: Html.Label("Unidad de medida") %>
            <%: Html.DropDownList("unidadmedida_id", (SelectList)moneda.UnidadMedidaList, "Seleccionar...", new { @class = "required" })%></td>
        </tr>
        <tr>
            <td><%: Html.Label("Segmento") %>
            <%: Html.DropDownList("segmento_id", (SelectList)moneda.SegmentoList, "Seleccionar...", new { @class = "required" })%></td>
            
        </tr>
        </table>
        <p align = "center"><input type="submit" value="Editar" /></p>
    <% } %>