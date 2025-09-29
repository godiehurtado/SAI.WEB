<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.FactorVariable>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#FactorEditar").validate({
           
            }
        });
    });
</script>

    <% using (Html.BeginForm("Editar", "FactorVariable", FormMethod.Post, new { id = "FactorEditar" }))
       {
        Html.ValidationSummary(true); %>
        <p>
            <%: Html.Label("Nombre")%>
            <%: Html.TextBoxFor(Model => Model.nombre, new { @class = "required number" })%>
            <%: Html.ValidationMessageFor(Model => Model.nombre)%>
        </p>
        <p>
            <%: Html.Label("Valor directo")%>
            <%: Html.TextBoxFor(Model => Model.valorDirecto, new { @class = "required number" })%>
            <%: Html.ValidationMessageFor(Model => Model.valorDirecto)%>
        </p>
        <p>
            <%: Html.Label("Valor contratación")%>
            <%: Html.TextBoxFor(Model => Model.valorContratacion, new { @class = "required number" })%>
            <%: Html.ValidationMessageFor(Model => Model.valorContratacion)%>
        </p>
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>