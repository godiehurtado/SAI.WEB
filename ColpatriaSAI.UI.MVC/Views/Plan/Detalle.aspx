<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Planes Core - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
        oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true/*, "aoColumnDefs": [{ "bVisible": false, "aTargets": [0]}]*/ });
    });

    function obtenerValor(id) {
        var encontro = false;
        var planesTrue = $('#planesTrue').val().split(',');
        var planesFalse = $('#planesFalse').val().split(',');

        if ($('#planesTrue').val()) {
            for (i = 0; i < planesTrue.length; i++) {
                if (planesTrue[i] == id) {
                    if ($('#planDetalle' + id).attr('checked') == false) planesFalse.push(id);
                    planesTrue.splice(i, 1);
                    encontro = false;
                    break;
                } else encontro = true;
            }
            if (encontro) planesTrue.push(id);

            if (planesTrue.length != 0) {
                $('#planesTrue').val("");
                for (i = 0; i < planesTrue.length; i++) {
                    if (planesTrue[i]) $('#planesTrue').val($('#planesTrue').val() + planesTrue[i] + ",");
                }
                $('#planesTrue').val($('#planesTrue').val().slice(0, -1));
            }
            if (planesFalse.length != 0) {
                $('#planesFalse').val("");
                for (i = 0; i < planesFalse.length; i++) {
                    if (planesFalse[i]) $('#planesFalse').val($('#planesFalse').val() + planesFalse[i] + ",");
                }
                $('#planesFalse').val($('#planesFalse').val().slice(0, -1));
            }
        } else {
            $('#planesTrue').val(id);
        }
    }
</script>

    <h2>Planes Core</h2>

    <div style="float:left;">
        <%: Html.ActionLink("Regresar", "Index")%>
    </div>
    <% if (ViewBag.PlanAgrupado != null) { %>
    <div id="tituloRamo" style="float:left; padding-left:30px; font-weight:bold;">
        Ramo Agrupado: <%: ViewBag.PlanAgrupado %>
    </div>
    <% } %>
        <br /><br />

    <table  id="tablaLista">
    <thead>
        <tr>
            <% if (ViewBag.PlanAgrupado != null) { %><th align="center">Selección</th> <% } %>
            <th align="center">Compañía de pago</th> 
            <th align="center">Ramo Core</th> 
            <th align="center">Producto Core</th> 
            <th align="center">Plan Core</th> 
            <th align="center">Código Core</th>
        </tr>
    </thead>
    <tbody>
    <% Random random = new Random(); int num = random.Next(1, 10000); string planesId = ""; %>
    <% foreach (var item in (IEnumerable<PlanDetalle>)ViewBag.PlanDetalle) { %>
        <% if (item.plan_id == (int)ViewBag.plan_id) planesId = planesId + item.id + ","; %>
        <tr>
            <% if (ViewBag.PlanAgrupado != null) { %>
            <td align="center">
                <%: Html.CheckBox("planDetalle"+ item.id, (item.plan_id == (int)ViewBag.plan_id), new { value = item.id, onclick = "obtenerValor(value)" })%>
            </td>
            <% } %>
            <td align="center"><%: item.ProductoDetalle.RamoDetalle.Compania.nombre %></td>
            <td align="center"><%: item.ProductoDetalle.RamoDetalle.nombre %></td>
            <td align="center"><%: item.ProductoDetalle.nombre %></td>
            <td align="center"><%: item.nombre %></td>
            <td align="center"><%: item.codigoCore %></td>
        </tr>
    <% } %>
    </tbody>
    </table>
    <% if (ViewBag.PlanAgrupado != null) { %>
        <% using (Html.BeginForm("Agrupar", "Plan", FormMethod.Post, new { id = "formPlanEditar" })) { %>
            <%: Html.Hidden("plan_id", (Int64)ViewBag.plan_id)%>
            <%: Html.Hidden("planesTrue", planesId.Length > 0 ? planesId.Substring(0, planesId.Length - 1) : "")%>
            <%: Html.Hidden("planesFalse")%>
            <p align = "center"><input type="submit" value="Agrupar" id="btnAgrupar" /></p>
        <% } %>
    <% } %>
</asp:Content>