<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.UI.MVC.Models.IngresoLocalidadModel>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<script type="text/javascript">
    $().ready(function () {
        $("#IngresoLocalidadEditar").validate({
            rules: { e_anio: { required: true }, e_ingreso: { required: true, number: true} }
        });
    });
</script>
<% using (Html.BeginForm("Editar", "IngresoLocalidad", FormMethod.Post, new { id = "IngresoLocalidadEditar" }))
   {
       Html.ValidationSummary(true); %>
<p>
    <%: Html.Label("Año") %>
    <%: Html.TextBox("e_anio", this.Model.IngresoLocalidad.año, new { @size = "4"} )%>
</p>
<p>
    <%: Html.Label("Localidad") %>
    <%: Html.DropDownList("e_localidad_id", this.Model.Localidad)%>
</p>
<p>
    <%: Html.Label("Grupo") %>
    <%: Html.DropDownList("e_grupo_id", this.Model.Grupo)%>
</p>
<p>
    <%: Html.Label("Ingreso") %>
    <%: Html.TextBox("e_ingreso", this.Model.IngresoLocalidad.valor)%>
</p>
<p>
    <input type="submit" value="Actualizar" />
</p>
<% } %>