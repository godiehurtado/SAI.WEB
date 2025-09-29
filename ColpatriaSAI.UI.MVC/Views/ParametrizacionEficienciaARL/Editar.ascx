<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<script type="text/javascript">
    $().ready(function () {
        $("#formParametrizacionEficienciaARLEditar").validate({

        });

    });
</script>
<script type="text/javascript">
    function parametrizacionSave() {
        if ($("#formParametrizacionEficienciaARLEditar").valid()) {
            $("#editar").attr('disabled', true);
            $("#formParametrizacionEficienciaARLEditar").submit();
            mostrarCargando("Enviando informacion. Espere Por Favor...");
        }
    }
        </script>
<% Html.EnableClientValidation(); %>
<% using (Html.BeginForm("Editar", "ParametrizacionEficienciaARL", FormMethod.Post, new { id = "formParametrizacionEficienciaARLEditar" }))
           {
               Html.ValidationSummary(true); %>
<% ColpatriaSAI.UI.MVC.Models.ParametrizacionEficienciaARLViewModel eficiencia = (ColpatriaSAI.UI.MVC.Models.ParametrizacionEficienciaARLViewModel)ViewData["ParametrizacionEficienciaARLViewModel"]; %>
<table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0"
    cellpadding="0" style="padding-left: 50px">
    <tr>
        <td>
            <u>
                <%: Html.Label("Nombre Etapa") %></u>
        </td>
        <td>
            <%: Html.TextBox("NombreEtapa", eficiencia.ParametrizacionEficienciaARLView.nombreEtapa, new {@class = "required"}) %>
        </td>
    </tr>
    <tr>
        <td>
            <u>
                <%: Html.Label("Mes Inicio")%></u>
        </td>
        <td>
            <%: Html.ComboMeses("FechaInicio") %>
            <%: Html.ValidationMessageFor(Model => eficiencia.ParametrizacionEficienciaARLView.mesInicial)%>
        </td>
    </tr>
    <tr>
        <td>
            <u>
                <%: Html.Label("Mes Final")%></u>
        </td>
        <td>
            <%: Html.ComboMeses("FechaFin")%>
            <%: Html.ValidationMessageFor(Model => eficiencia.ParametrizacionEficienciaARLView.mesFinal)%>
        </td>
    </tr>
    <tr>
        <td>
            <u>
                <%: Html.Label("Mes Final")%></u>
        </td>
        <td>
            <%: Html.ComboAnios("Anio")%>            
        </td>
    </tr>
</table>
<p align="center">
    <input type="button" value="Actualizar" id="editar" onclick="parametrizacionSave()" /></p>
<% } %>