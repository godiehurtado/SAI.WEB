<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<script type="text/javascript">
    $().ready(function () {
        $("#LocalidadEditar").validate({
            rules: { nombre: "required", zona_id: "required" }
        });
    });
</script>
<% using (Html.BeginForm("Editar", "Localidad", FormMethod.Post, new { id = "LocalidadEditar" }))
   { %>
<%: Html.ValidationSummary(true) %>
<% ColpatriaSAI.UI.MVC.Models.LocalidadViewModel localidad = (ColpatriaSAI.UI.MVC.Models.LocalidadViewModel)ViewData["LocalidadViewModel"];  %>
<table>
    <tr>
        <td>
            <%: Html.Label("Nombre") %>
        </td>
        <td>
            <%: Html.TextBoxFor(model => localidad.LocalidadView.nombre)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.nombre)%>
        </td>
        <td>
            <%: Html.Label("Zona") %>
        </td>
        <td>
            <%: Html.DropDownList("zona_id", (SelectList)localidad.ZonaList)%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Tipo de Localidad") %>
        </td>
        <td>
            <%: Html.DropDownList("tipolocalidad_id", (SelectList)localidad.TipoLocalidad)%>
        </td>
        <td>
            <%: Html.Label("Código SISE") %>
        </td>
        <% string cSise = localidad.LocalidadView.codigo_SISE != null ? localidad.LocalidadView.codigo_SISE.Trim() : ""; %>
        <td>
            <%: Html.TextBox("codigo_SISE", cSise)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_SISE)%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Código CAPI") %>
        </td>
        <% string cCapi = localidad.LocalidadView.codigo_CAPI != null ? Convert.ToString(localidad.LocalidadView.codigo_CAPI) : ""; %>
        <td>
            <%: Html.TextBox("codigo_CAPI", cCapi)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_CAPI)%>
        </td>
        <td>
            <%: Html.Label("Código BH") %>
        </td>
        <% string cBH = localidad.LocalidadView.codigo_BH != null ? localidad.LocalidadView.codigo_BH.Trim() : ""; %>
        <td>
            <%: Html.TextBox("codigo_BH", cBH)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_BH)%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Código EMERMEDICA") %>
        </td>
        <% string cEmerm = localidad.LocalidadView.codigo_EMERMEDICA != null ? localidad.LocalidadView.codigo_EMERMEDICA.Trim() : ""; %>
        <td>
            <%: Html.TextBox("codigo_EMERMEDICA", cEmerm)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_EMERMEDICA)%>
        </td>
        <td>
            <%: Html.Label("Código ARP") %>
        </td>
        <% string cARP = localidad.LocalidadView.codigo_ARP != null ? localidad.LocalidadView.codigo_ARP.Trim() : ""; %>
        <td>
            <%: Html.TextBox("codigo_ARP", cARP)%>
            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_ARP)%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Clave Pago") %>
        </td>
        <% string cPago = localidad.LocalidadView.clavePago != null ? localidad.LocalidadView.clavePago.Trim() : ""; %>
        <td>
            <%: Html.TextBox("clave_pago", cPago)%>
        </td>
        <td></td>
        <td></td>
    </tr>
</table>
<p align="center">
    <input type="submit" value="Actualizar" /></p>
<% } %>
