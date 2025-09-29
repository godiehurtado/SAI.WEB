<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.AnticipoFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Nuevo Anticipo - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script src="<%: Url.Content("~/Scripts/jquery.validate.js") %>" type="text/javascript"></script>
<script src="<%: Url.Content("~/Scripts/jquery.validate.unobtrusive.js") %>" type="text/javascript"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $('#fecha_anticipo').datepicker({ dateFormat: 'yy-mm-dd' });
    });
</script>

<div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Nuevo Anticipo</h2>
                <%: Html.ActionLink("Regresar", "Index") %>
        </div>
        <div id="progresoSeccion">
            <p>
                Seleccione la franquicia y complete el formulario para realizar un anticipo a una franquicia.
                Debe definir una compañía por la cuál será realizado el pago.
                Recuerde que el sistema registra el usuario que realizó el anticipo.
            </p>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>
<% using (Html.BeginForm("Create", "AnticiposFranquicias", FormMethod.Post, new { id = "FormAnticiposFranquicias" }))
   { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend>Datos del anticipo</legend>
        <table cellspacing="2" width="100%">
            <tr>
                <td>Franquicia</td>
                <td>
                    <%: Html.DropDownList("Localidades", ViewData["Localidades"] as MultiSelectList)%>
                    <%: Html.ValidationMessageFor(model => model.localidad_id) %>                
                </td>
            </tr>
            <%--<tr>
                <td>Fecha Anticipo</td>
                <td>
                    <%: Html.EditorFor(model => model.fecha_anticipo, new { @class = "required", value = System.DateTime.Now })%>
                    <%: Html.ValidationMessageFor(model => model.fecha_anticipo) %>
                </td>
            </tr>--%>
            <tr>
                <td>Compañía</td>
                <td>
                    <%: Html.DropDownList("Companias", ViewData["Companias"] as MultiSelectList)%>
                    <%: Html.ValidationMessageFor(model => model.compania_id) %>                
                </td>
            </tr>
            <tr>
                <td>Descripción</td>
                <td>
                     <%: Html.TextAreaFor(model => model.descripcion,5,70,null) %>
                     <%: Html.ValidationMessageFor(model => model.descripcion) %>
                </td>
            </tr>
            <tr>
                <td>Valor</td>
                <td>
                    $<%: Html.EditorFor(model => model.valorAnti, null, new { id="valorAnti" })%>
                    <%: Html.ValidationMessageFor(model => model.valorAnti) %>              
                </td>
            </tr>
            
            <tr>
                <td><%: Html.HiddenFor(model => model.usuarioEjecutoAnti, new { value = HttpContext.Current.Session["NombreUser"] })%></td>
                <td><input type="submit" value="Crear" /></td>
            </tr>
        </table>
    </fieldset>
<% } %>
    <div class="editor-label">
    <% if (ViewData["Mensaje"] != null) { %>
        <%:ViewData["Mensaje"].ToString()%>
    <% } %>
    </div>
</asp:Content>
