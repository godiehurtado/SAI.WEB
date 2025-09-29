<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#CategoriaEditar").validate();
    });
</script>

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Categoria", FormMethod.Post, new { id = "CategoriaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CategoriaViewModel categoria = (ColpatriaSAI.UI.MVC.Models.CategoriaViewModel)ViewData["CategoriaViewModel"]; %>
        <fieldset style="border:1px solid gray">

        <table width="100%" cellpadding="2">
        <tr>
            <td align = "center"><%: Html.Label("Nombre")%></td>
            <td align = "center"><%: Html.TextBoxFor(Model => categoria.CategoriaView.nombre, new { @class = "required" })%>
            <%: Html.ValidationMessageFor(Model => categoria.CategoriaView.nombre)%></td>
        </tr>
<%--        <p>
            <%: Html.Label("Nivel")%>
            <%: Html.DropDownList("nivel_id", (SelectList)categoria.NivelList, "Seleccionar...", new { @class = "required" })%>
        </p>
      <p>
            <%: Html.Label("Principal")%>
            <%
                List<SelectListItem> esPrincipal = new List<SelectListItem>();
                
                esPrincipal.Add(new SelectListItem{ Text = "Principal" , Value = "1", Selected = (categoria.CategoriaView.principal == 1)});
                esPrincipal.Add(new SelectListItem { Text = "Secundaria", Value = "2", Selected = (categoria.CategoriaView.principal == 2) });
            %>
            <%: Html.DropDownList("principal", esPrincipal, "Seleccione un Valor", new { @class = "required" })%>

            <%: Html.ValidationMessageFor(Model => categoria.CategoriaView.principal)%>
        </p>--%>
        </table>
        </fieldset>
        <p align = "center"><input type="submit" value="Actualizar" /></p>
    <% } %>