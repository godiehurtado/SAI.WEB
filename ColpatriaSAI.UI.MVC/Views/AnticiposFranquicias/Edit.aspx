<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.AnticipoFranquicia>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Editar Anticipo - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">


        function AnularAnticipo() {
            var id = $('#Id').val();
            if (confirm("Está seguro que desea anular este anticipo?")){
                $.ajax({
                    url: "/AnticiposFranquicias/Anular/" + id,
                    data: null,
                    type: 'POST',
                    contentType: 'application/json;',
                    dataType: 'json',
                    success: function (result) {
                        if (result.Success == 1) {
                            window.location.href = "/AnticiposFranquicias/index/";
                        }
                        else {
                            alert(result.ex);
                        }
                    }
                });
            }
        }

        function PagarAnticipo() {
            var id = $('#Id').val();
            if (confirm("Está seguro que desea pagar este anticipo?")) {
                $.ajax({
                    url: "/AnticiposFranquicias/Pagar/" + id,
                    data: null,
                    type: 'POST',
                    contentType: 'application/json;',
                    dataType: 'json',
                    success: function (result) {

                        if (result.Success == 1) {

                            window.location.href = "/AnticiposFranquicias/index/";



                        }
                        else {
                            alert(result.ex);
                        }
                    }
                });
            }
        }

        $(document).ready(function () {
            $('#fecha_anticipo').datepicker({ dateFormat: 'yy-mm-dd' });
        });
    </script>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Editar Anticipo</h2>
            <p>
                <%: Html.ActionLink("Regresar", "Index") %>
            </p>
        </div>
        <div id="progresoSeccion">
            Los anticipos que ya han sido pagados o anulados no pueden ser editados. Debe crear
            uno nuevo si desea continuar con el proceso.
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <% using (Html.BeginForm()) { %>
    <%: Html.ValidationSummary(true) %>
    <fieldset>
        <table cellspacing="2" width="100%">
            <tr>
                <td>
                    Franquicia:
                </td>
                <td>
                    <% if (Model.estado == "1") { %>
                        <%:Html.DropDownList("Localidades", ViewData["Localidades"] as MultiSelectList)%>
                        <%:Html.ValidationMessageFor(model => model.localidad_id)%>
                    <% } else { %>
                        <%: Model.Localidad.nombre %>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>
                    Estado:
                </td>
                <td>
                    <% if (Convert.ToInt32(Model.estado) == 1){ %>
                        <b>Creado</b>
                    <% } if (Convert.ToInt32(Model.estado) == 2){ %>
                        Pagado
                    <% } if (Convert.ToInt32(Model.estado) == 3){ %>
                        Anulado
                    <% } if (Convert.ToInt32(Model.estado) == 5){ %>
                        Descontado
                    <% } %>
                    <%: Html.HiddenFor(model => model.estado) %>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Contabilización:
                </td>
                <td>
                    <%: Model.fecha_anticipo.Value.ToLongDateString() %>
                    <%--<% if (Model.estado == "1") { %>
                        <%:Html.EditorFor(model => model.fecha_anticipo)%>
                        <%:Html.ValidationMessageFor(model => model.fecha_anticipo)%>
                    <% } else { %>
                        <%: Model.fecha_anticipo.ToString() %>
                    <% }%>--%>
                </td>
            </tr>
            <tr>
                <td>
                    Compañía:
                </td>
                <td>
                    <% if (Model.estado == "1") { %>
                        <%: Html.DropDownList("Companias", ViewData["Companias"] as MultiSelectList)%>
                        <%: Html.ValidationMessageFor(model => model.compania_id) %>
                    <% } else { %>
                        <%: Model.Compania.nombre %>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>
                    Descripción:
                </td>
                <td>
                    <% if (Model.estado == "1") { %>
                        <%: Html.TextAreaFor(model => model.descripcion, 5, 70, null)%>
                        <%: Html.ValidationMessageFor(model => model.descripcion) %>
                    <% } else { %>
                        <%: Model.descripcion.ToString() %>
                    <% }%>
                </td>
            </tr>
            <tr>
                <td>
                    Valor:
                </td>
                <td>
                    <% if (Model.estado == "1") { %>
                        $<%: Html.EditorFor(model => model.valorAnti) %>
                        <%: Html.ValidationMessageFor(model => model.valorAnti) %>
                    <% } else { %>
                        <%: String.Format("{0:C}", Model.valorAnti) %>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td>
                    <%: Html.HiddenFor(model => model.Id) %>
                </td>
                <td>
                    <% if (Model.estado == "1") { %>
                        <input type="submit" value="Guardar" />
                        <input type="button" value="Anular" onclick="AnularAnticipo()" />
                        <input type="button" value="Pagar" onclick="PagarAnticipo()" />
                    <% } %>
                    <%: Html.HiddenFor(model => model.usuarioEjecutoAnti, new { value = HttpContext.Current.Session["NombreUser"] })%>
                </td>
            </tr>
        </table>
    </fieldset>
    <% } %>
</asp:Content>
