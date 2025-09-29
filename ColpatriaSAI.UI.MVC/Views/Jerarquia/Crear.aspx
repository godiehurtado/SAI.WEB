<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Jerarquia>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Jerarquía Comercial - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Administración de la Jerarquía Comercial</h2>
<h4><%=Html.ActionLink("Regresar","Index","JerarquiaComercial") %></h4>

<script type="text/javascript">
    $(document).ready(function () {
        oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
        $("#crearJerarquia").validate();
    });

    function mostrarDialog(pagina, titulo, dialog) {
        $("#" + dialog).dialog({
            height: 150, modal: true, title: titulo,
            open: function (event, ui) { $(this).load(pagina); },
            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
        });
    }

    function editarJerarquia(id) {
        //$('#crearJerarquia').attr("action", "/Jerarquia/Editar/" + id);
        $('#btnCrear').attr("value", "Actualizar");
        $('#btnCancelarEdit').css("display", "block");
        $('#tablaLista').attr("disabled", "disabled");

        $('#jerarquia_id').val(id);
        $('#tipoJerarquia_id option').each(function () {
            if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#tipoJerarquia_id' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
        });
        $('#segmento_id option').each(function () {
            if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#segmento_id' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
        });
        $('#nombre').val(jQuery.trim($('#nombre' + id).text()))
        $('#ano').val(jQuery.trim($('#ano' + id).text()));

        $('#nombre').focus(); $('#nombre').select();
    }
    
    function cancelarEdicion() {
        inicializarControles();
        $('#btnCrear').attr("value", "Crear");
        $('#btnCancelarEdit').css("display", "none");
    }

    function inicializarControles() {
        //$('#crearJerarquia').attr("action", "/Jerarquia/Crear/0");
        $('#jerarquia_id').val(0);
        $("#tipoJerarquia_id option:first-child").attr("selected", "selected");
        $("#segmento_id option:first-child").attr("selected", "selected");
        $('#nombre').val('');
        $('#ano').val('');
        $('#tablaLista').removeAttr("disabled");
    }

    function guardarJerarquia() {
        var sUrl;
        if ($('#jerarquia_id').val() == 0) sUrl = "/Jerarquia/Crear"; else sUrl = '/Jerarquia/Editar';
        $('#crearJerarquia').attr("action", sUrl);
        $('#crearJerarquia').submit();
        /*$.ajax({ url: sUrl, data: { jerarquia: $("crearJerarquia").serialize() }, type: "POST",
            success: function (result) {
                window.location.href = document.location;
            }
        });
        $('#jerarquia_id').val(0);*/
    }
</script>
<% string ruta = Request.Url.ToString().Split('?')[0].ToString();  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }
    int num = new Random().Next(1, 10000);  %>
<% List<Jerarquia> jerarquias = ViewBag.Jerarquias; %>

<% using (Html.BeginForm("Crear", "Jerarquia", FormMethod.Post, new { id = "crearJerarquia" })) { %>
    <%: Html.ValidationSummary(true)%>

    <fieldset>
        <legend>Crear Jerarquia</legend>
        <table>
            <%:Html.Hidden("jerarquia_id")%>
            <tr>
                <td>Nombre:</td>
                <td><%: Html.TextBox("nombre", "", new { @class = "required" })%></td>
                <td><%: Html.ValidationMessageFor(model => Model.nombre)%></td>
            </tr>
            <tr>
                <td>Tipo de jerarquía:</td>
                <td><%: Html.DropDownList("tipoJerarquia_id", (SelectList)ViewBag.tipoJerarquia_id, "Seleccione...", new { @class = "required" })%></td>
                <td><%: Html.ValidationMessageFor(model => Model.tipoJerarquia_id)%></td>
            </tr>
            <tr>
                <td>Segmento:</td>
                <td><%: Html.DropDownList("segmento_id", (SelectList)ViewBag.segmento_id, "Seleccione...", new { @class = "required" })%></td>
                <td><%: Html.ValidationMessageFor(model => Model.segmento_id)%></td>
            </tr>
            <tr>
                <td>Año:</td>
                <td><%: Html.TextBox("ano", "", new { @class = "number" })%></td>
                <td><%: Html.ValidationMessageFor(model => Model.ano)%></td>
            </tr>
            <tr>
                <td colspan="3">
                    <input type="button" value="Crear" onclick="guardarJerarquia()" style="float:left" id="btnCrear" />
                    <input type="button" value="Cancelar edición" onclick="cancelarEdicion()" style="display:none; float:left" id="btnCancelarEdit" />
                </td>
            </tr>
        </table>
    </fieldset>
<% } %>
    <br />
    <fieldset>
        <legend>Listado de Jerarquias</legend>

        <table id="tablaLista">
            <thead> <tr> <th>Nombre</th><th>Tipo de jerarquia</th><th>Segmento</th><th>Año</th><th>Opciones</th> </tr> </thead>
            <tbody>
        <% foreach (var item in jerarquias) { %>
            <tr>
                <td id="nombre<%:item.id %>">           <%: Html.DisplayFor(modelItem => item.nombre)%></td>
                <td id="tipoJerarquia_id<%:item.id %>"> <%: Html.DisplayFor(modelItem => item.TipoJerarquia.nombre)%></td>
                <td id="segmento_id<%:item.id %>">      <%: Html.DisplayFor(modelItem => item.Segmento.nombre)%></td>
                <td id="ano<%:item.id %>">              <%: Html.DisplayFor(modelItem => item.ano)%></td>
                <td>
                    <a href="#" onclick="editarJerarquia(<%: item.id %>);" title='Editar esta jerarquia' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-pencil'></span></a>
                    <a href="/Jerarquia/Detalle/<%: item.id %>?id=<%: item.id %>" title='Administrar jerarquía' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-person'></span></a>
                    <a href="#" onclick="popupReport('ReporteJerarquiaDetalle','jerarquia_id=<%: item.id %>');" title='Descargar jerarquía' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-document'></span></a>
                    <a href="#" onclick="popupReport('ReporteExcepcionesJerarquia','jerarquia_id=<%: item.id %>');" title='Descargar excepciones' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-document-b'></span></a>
                    <%--<%: Html.ActionLink("Detalles", "Details", new { id = item.id })%>--%>
                    <%--<a href="javascript:mostrarDialog('<%: Url.Action("Eliminar", new { id = item.id }) %>', 'Eliminar jerarquía', 'dialog');" title='Eliminar esta jerarquia' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-trash'></span></a>--%>
                    <%--<%: Html.ActionLink("Eliminar", "Eliminar", new { id = item.id })%>  ?r=<%: num %> --%>
                </td>
            </tr>
        <% } %>
            </tbody>
        </table>

    </fieldset>
    <div id='dialog' style="display:none;"></div>

</asp:Content>
