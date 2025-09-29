<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Ramos Core - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    function mostrarDialog(pagina, titulo, dialog) {
        $("#" + dialog).dialog({
            height: 190, width: 350, modal: true, title: titulo,
            open: function (event, ui) { $(this).load(pagina); },
            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
        });
    }

    function mostrarDialog1(pagina, titulo, dialog) {
        $("#" + dialog).dialog({
            height: 190, width: 350, modal: true, title: titulo,
            open: function (event, ui) { $(this).load(pagina); },
            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
        });
    }

    function cerrarDialog(dialog) {
        $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
    }

    $(document).ready(function () {
        oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true/*, "aoColumnDefs": [{ "bVisible": false, "aTargets": [0]}]*/ });
        $.validator.setDefaults({});
        $("#formRamoDetalle").validate();
        $("#formRamoDetalle").validate({
            rules: { nombre: "required" }
        });

        if (capturarQueryString() == null) {
            $('#tituloRamo').css('display', 'none');
            $('#btnAgrupar').css('display', 'none');

        }
    });

    function obtenerValor(id) {
        var encontro = false;
        var ramosTrue = $('#ramosTrue').val().split(',');
        var ramosFalse = $('#ramosFalse').val().split(',');

        if ($('#ramosTrue').val()) {
            for (i = 0; i < ramosTrue.length; i++) {
                if (ramosTrue[i] == id) {
                    if ($('#ramoDetalle' + id).attr('checked') == false) ramosFalse.push(id);
                    ramosTrue.splice(i, 1);
                    encontro = false;
                    break;
                } else encontro = true;
            }
            if (encontro) ramosTrue.push(id);

            if (ramosTrue.length != 0) {
                $('#ramosTrue').val("");
                for (i = 0; i < ramosTrue.length; i++) {
                    if (ramosTrue[i]) $('#ramosTrue').val($('#ramosTrue').val() + ramosTrue[i] + ",");
                }
                $('#ramosTrue').val($('#ramosTrue').val().slice(0, -1));
            }
            if (ramosFalse.length != 0) {
                $('#ramosFalse').val("");
                for (i = 0; i < ramosFalse.length; i++) {
                    if (ramosFalse[i]) $('#ramosFalse').val($('#ramosFalse').val() + ramosFalse[i] + ",");
                }
                $('#ramosFalse').val($('#ramosFalse').val().slice(0, -1));
            }
        } else {
            $('#ramosTrue').val(id);
        }
    }
</script>

    <%  string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>
    
    <h2>Ramos Core</h2>

    <div style="float:left;">
        <%: Html.ActionLink("Regresar", "Index", "Ramo") %>
    </div>
    <div id="tituloRamo" style="float:left; padding-left:30px">
        Ramo Agrupado: <%: ViewData["RamoAgrupado"] %> - Compañía de pago: <%:ViewData["CompaniaAgrupada"] %>
    </div>
    <br /><br />

        <% ColpatriaSAI.UI.MVC.Models.RamoViewModel ramo = (ColpatriaSAI.UI.MVC.Models.RamoViewModel)ViewData["RamoViewModel"]; %>
        <table  id="tablaLista">
        <thead>
            <tr>
                <% if (ViewData["CompaniaAgrupada"]!= null ) {%><th align="center">Selección</th><% } %>
                <th align="center">Compañía CORE</th>
                <th align="center">Ramo Agrupado</th>
                <th align="center">Ramo CORE</th>
            </tr>
        </thead>
        <tbody>
        <% Random random = new Random(); int num = random.Next(1, 10000); string ramosId = ""; %>
        <% foreach (var item in (List<RamoDetalle>)ViewData["RamosDetalle"]) { %>
            <% if (item.ramo_id == Convert.ToInt32(ViewData["r"])) ramosId = ramosId + item.id + ","; %>
            <tr>
                <% if (ViewData["CompaniaAgrupada"]!= null ) {%>
                <td align="center">
                <% if (ViewData["RamoAgrupado"] != null) { %>
                    <%: Html.CheckBox("ramoDetalle" + item.id, (item.ramo_id == Convert.ToInt32(ViewData["r"])), new { value = item.id, onclick = "obtenerValor(value)" })%>
                <% } %>
                </td><% } %>
                <td align="center"><%: item.Compania.nombre %></td>
                <td align="center"><%: item.Ramo.nombre %></td>
                <td align="center"><%: item.nombre %></td>
            </tr>
        <% } %>
        </tbody>
        </table>
    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Index", "RamoDetalle", FormMethod.Post, new { id = "formRamoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <%: Html.Hidden("ramo_id", ViewData["r"]) %>
        <%: Html.Hidden("ramosTrue", ramosId.Length > 0 ? ramosId.Substring(0, ramosId.Length - 1) : "")%>
        <%: Html.Hidden("ramosFalse") %>
        <p align = "center"><input type="submit" value="Agrupar" id="btnAgrupar" /></p>
    <% } %>
</asp:Content>