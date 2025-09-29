<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.LiquidacionContratacion>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidación de la Contratación - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
    $(document).ready(function () {
        $('#tablaLista').dataTable({ "bJQueryUI": true,
            "sPaginationType": "full_numbers",
            "aaSorting": [[0, "desc"]],
            "bStateSave": true,
            "aoColumns": [
                    { "bSortable": true },
                    null,
                    { "bSortable": true },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false }
            ]
        })
        $(".btnPagar").button({ icons: { primary: "ui-icon-gear"} });
    })

    function PagarLiqContratacion(idLiquidacion) {
        var id = idLiquidacion;
        mostrarCargando("Pagando Liquidación. Espere Por Favor...");
        $("#btnPagar").attr('disabled', true);
        $.ajax({
            url: '/LiquidacionContrat/PagarLiqui',
            data: {
                idLiquidacion: id
            },
            type: 'POST',
            success: function (result) {
                closeNotify('jNotify');
                if (result.Success) {
                    $("#btnPagar").hide();
                    setTimeout(function () {
                        window.location.href = '/LiquidacionContrat';
                    },1000);
                }
                mostrarExito(result.Messagge);
            }
        });
    }

    function eliminarLiquidacion(id) {
        mostrarCargando("Eliminando Liquidación. Espere Por Favor...");
        $.ajax({
            url: '/LiquidacionContrat/EliminarLiquidacion',
            data: {
                idLiquidacion: id
            },
            type: 'POST',
            success: function (result) {
                closeNotify('jNotify');
                if (result.Success) {
                    setTimeout(function () {
                        window.location.href = '/LiquidacionContrat';
                    }, 1000);
                    mostrarExito("La Liquidacion se elimino con exito.");
                }                
            }
        });
    }

</script>

<div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Liquidación de la Contratación</h2>
            <p>
                <%: Html.ActionLink("Regresar", "Index", "Contratacion")%>
                <%: Html.ActionLink("Nueva Liquidación", "Create") %>
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
        </div>
        <div style="clear:both;"><hr /></div>
    </div>
<h2></h2>

<table id="tablaLista">
 <thead>
    <tr>
        <th>Id Liquidación</th>
        <th>Fecha de liquidación (dd/mm/aaaa hh:mm:ss)</th>
        <th>Periodo Liquidación</th>
        <th>Resumen</th>
        <th>Detalle</th>
        <th>Participaciones</th>
        <th>Pagos</th>
        <th>Estado</th>
        <th>Ajuste</th>
    </tr>
    </thead> 
<% 
    foreach (var item in Model) {       
    %>
    <tr>
        <td>
            <%= item.id%>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.fechaLiquidacion) %>
        </td>
        <td>
            <%=item.fechaIni.Value.Month%>-<%=item.fechaIni.Value.Year%>
        </td>
		<td align="center">
            <a href='#'  onclick="popupReport('ReporteContratacion','liquidacionContratacion_id=<%: item.id %>');" title='Descargar Resumen Liquidación'><span class='ui-icon ui-icon-search'></span></a>
		</td>
		<td align="center">
            <a href='#'  onclick="popupReport('ReporteDetalleContratacion','liquidacionContratacion_id=<%: item.id %>');" title='Descargar Detalle Liquidación'><span class='ui-icon ui-icon-search'></span></a>
		</td>
		<td align="center">
            <a href='#'  onclick="popupReport('ReporteLiquidacionParticipaciones','liquidacionContratacion_id=<%: item.id %>');" title='Descargar Liquidación Participaciones'><span class='ui-icon ui-icon-search'></span></a>
		</td>
		<td align="center">
            <%                      
                if (item.estado != null)
                {
                    if (item.estado.Value == 2)
                    {                              
                    %>
                        <a href='#'  onclick="popupReport('ReportePagosContratacion','liquidacionContratacion_id=<%: item.id %>');" title='Descargar Detalle Pagos' ><span class='ui-icon ui-icon-search'></span></a>
                    <% 
                    }     
                    
                    if (item.estado.Value == 1)
                    {                              
                    %>
                        <a href='#'  onclick="PagarLiqContratacion(<%: item.id %>);" title='Pagar Liquidación' class="btnPagar">Pagar</a>
                    <% 
                    }                                    
                }
                    
            %>

		</td>
        <td align="center">
            <%=item.EstadoLiquidacion.nombre%>
            <%                      
                if (item.estado != null)
                {
                    if (item.estado.Value == 1 || item.estado.Value == 4)
                    {
                        %>
                            <a href='#'  onclick="eliminarLiquidacion(<%: item.id %>);" title='Eliminar Liquidacion' ><span class='ui-icon ui-icon-trash'></span></a>
                        <%
                    }

                }
            %>
        </td>
        <td align="center">
            <%                      
                if (item.estado != null)
                {
                    if (item.estado.Value == 2)
                    {                              
                    %>
                        <%: Html.ActionLink("Ajustes", "AjustesContratos", "Ajustes", new { @id = item.id }, new { @class = "ui-icon ui-icon-wrench" })%>
                    <% 
                    }     
                    
                    if (item.estado.Value == 1)
                    {                              
                    %>
                        <a href='#'  onclick="alert('Liquidación aún si pagar.');" title='Ajustes' ><span class='ui-icon ui-icon-wrench'></span></a>
                    <% 
                    }                                    
                }
                    
            %>
        </td>
    </tr>
<% } %>

</table>

</asp:Content>
