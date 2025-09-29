<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Productos Core - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var ramoDetalles = new Array();

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true/*, "aoColumnDefs": [{ "bVisible": false, "aTargets": [0]}]*/ });

            /*if (capturarQueryString() == null) {
                $('#tituloRamo').css('display', 'none');
                $('#btnAgrupar').css('display', 'none');
            }*/
        });

        function obtenerValor(id) {
            var encontro = false;
            var productosTrue = $('#productosTrue').val().split(',');
            var productosFalse = $('#productosFalse').val().split(',');

            if ($('#productosTrue').val()) {
                for (i = 0; i < productosTrue.length; i++) {
                    if (productosTrue[i] == id) {
                        if ($('#productoDetalle' + id).attr('checked') == false) productosFalse.push(id);
                        productosTrue.splice(i, 1);
                        encontro = false;
                        break;
                    } else encontro = true;
                }
                if (encontro) productosTrue.push(id);

                if (productosTrue.length != 0) {
                    $('#productosTrue').val("");
                    for (i = 0; i < productosTrue.length; i++) {
                        if (productosTrue[i]) $('#productosTrue').val($('#productosTrue').val() + productosTrue[i] + ",");
                    }
                    $('#productosTrue').val($('#productosTrue').val().slice(0, -1));
                }
                if (productosFalse.length != 0) {
                    $('#productosFalse').val("");
                    for (i = 0; i < productosFalse.length; i++) {
                        if (productosFalse[i]) $('#productosFalse').val($('#productosFalse').val() + productosFalse[i] + ",");
                    }
                    $('#productosFalse').val($('#productosFalse').val().slice(0, -1));
                }
            } else {
                $('#productosTrue').val(id);
            }
        }
    </script>
    
    <h2><% if (ViewBag.ProductoAgrupado != null){ %> Producto Agrupado:  <%: ViewBag.ProductoAgrupado%> <% }else { %> Productos CORE <%} %></h2> 

    <div style="float:left;"><%: Html.ActionLink("Regresar", "Index", "Producto") %></div>

    <% if (ViewBag.ProductoAgrupado != null) { %>
    <div id="tituloRamo" style="float:left; padding-left:30px;">
        Seleccione los productos que desea agregar a esta agrupación. <br />
    </div>
    <% } %>
    <br /><br />

    <table  id="tablaLista">
    <thead>
        <tr>
            <% if (ViewBag.ProductoAgrupado != null){ %>
            <th align="center">Selección</th>
            <% } %> 
            <th align="center">Compañía Core</th>
            <th align="center">Ramo agrupado</th>
            <th align="center">Ramo Core</th>
            <th align="center">Producto agrupado</th>
            <th align="center">Producto Core</th>
            <th align="center">Código Core</th>
        </tr>
    </thead>
    <tbody>
    <% Random random = new Random(); int num = random.Next(1, 10000); string productosId = ""; %>
    <% foreach (var item in (IEnumerable<ProductoDetalle>)ViewBag.ProductosDetalle) { %>
        <% if (item.producto_id == (int)ViewBag.producto_id) productosId = productosId + item.id + ","; %>
        <tr>
            <% if (ViewBag.ProductoAgrupado != null) { %>
            <td align="center">
                <%: Html.CheckBox("productoDetalle" + item.id, (item.producto_id == (int)ViewBag.producto_id), new { value = item.id, onclick = "obtenerValor(value)" })%>
            </td>
            <% } %>
            <td align="center"><%: item.RamoDetalle.Compania.nombre %></td> <!-- Compañía CORE -->
            <td align="center"><%: item.Producto.Ramo.nombre %></td> <!-- Ramo Agrupado -->
            <td align="center"><%: item.RamoDetalle.nombre %></td> <!-- Ramo Core  -->
            <td align="center"><%: item.Producto.nombre %></td> <!-- Producto agrupado -->
            <td align="center"><%: item.nombre %></td>
            <td align="center"><%: item.codigoCore %></td>
        </tr>
    <% } %>
    </tbody>
    </table>
    <% if (ViewBag.ProductoAgrupado != null) { %>
        <% using (Html.BeginForm("Agrupar", "Producto", FormMethod.Post, new { id = "formProductoEditar" })) { %>
            <%: Html.Hidden("producto_id", (Int64)ViewBag.producto_id)%>
            <%: Html.Hidden("productosTrue", productosId.Length > 0 ? productosId.Substring(0, productosId.Length - 1) : "")%>
            <%: Html.Hidden("productosFalse")%>
            <p align = "center"><input type="submit" value="Agrupar" id="btnAgrupar" /></p>
        <% } %>
    <% } %>
</asp:Content>