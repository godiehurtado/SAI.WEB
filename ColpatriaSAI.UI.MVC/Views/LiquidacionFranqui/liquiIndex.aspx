<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.LiquidacionFranquicia>>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidación de Franquicias - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
    $(document).ready(function () {
        $('#tablaLista').dataTable({ "bJQueryUI": true,
            "sPaginationType": "full_numbers",
            "bStateSave": true,
            "aaSorting": [[0, "desc"]]

        })

        $("#msjReliquidacion").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            position: ['center', 'center'],
            minHeight: 150,
            width: 420,
            title: 'Re-Liquidación',
            close: function (event, ui) {
                window.location.href = './liquiindex';
            },
            buttons: [{
                text: "Cerrar",
                click: function () {
                    $(this).dialog("close");
                    window.location.href = './liquiindex';
                }
            }]
        });
    })

    var intervalProceso = null;
    var inicio = true;
    function reliquidarFranquicia(idLiquidacion) {

        if (confirm('Está seguro de reliquidar esta liquidación. El proceso no se podra detener')) {

            mostrarCargando("Re-Liquidando Franquicias. Espere Por Favor...");

            var stUrl = '/LiquidacionFranqui/ValidarLiquidaciones/' + idLiquidacion;
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: {},
                success: function (response) {
                    if (response.Success) {

                        intervalProceso = setInterval("validarProceso();", 6000);
                        var stUrl = '/LiquidacionFranqui/Reliquidar/' + idLiquidacion;
                        var prueba1 = $.ajax({
                            type: 'POST',
                            url: stUrl,
                            data: {},
                            success: function (response) {
                                if (response.Success) {
                                    /*closeNotify('jNotify');
                                    $("#msjReliquidacion").html("El proceso se realizó con éxito.<br/>" + response.mjsReliquidacion);
                                    $("#msjReliquidacion").dialog("open");*/
                                }
                            }
                        });
                    }
                    else {
                        closeNotify('jNotify');
                        $("#msjReliquidacion").html("Hay liquidaciones sin procesarse. Por favor cambie el estado a Anulado, Pagado o Reliquidado de estas.");
                        $("#msjReliquidacion").dialog("open");
                    }
                }
            });
        }
    }

    function validarProceso() {
        var idProcesoAnterior;
        var idProcesoActual = 0;
        var stUrl = '/SessionLess/ValidarProceso';
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: {},
            success: function (responseProceso) {
                if (responseProceso.Success) {
                    if (responseProceso.idProceso == 0 && !inicio) {
                        closeNotify('jNotify');
                        $("#msjReliquidacion").html("El proceso se realizó con éxito.<br/> Por favor liquide los meses posteriores si existen. <br/>Esto actualizará los acumulados mensuales.");
                        $("#msjReliquidacion").dialog("open");
                        clearInterval(intervalProceso);
                    }
                }
                inicio = false;
            }
        });
    }

</script>
<div id="msjReliquidacion"></div>
<div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Liquidación de Franquicias</h2>
            <p>
                <%: Html.ActionLink("Regresar", "Index", "LiquidacionFranqui")%>
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
        <th>Liquidación</th>
        <th>Fecha de liquidación (dd/mm/aaaa hh:mm:ss)</th>
        <th>Fecha inicio (mm/aaaa) </th>
        <th>Fecha fin (mm/aaaa)</th>
        <th>Detalle por franquicia</th>
        <th>Detalle general</th>
        <th>Estado</th>
        <th>Procesar</th>
        <th>Ver Pagos</th>
        <th>Ajustes</th>
        <th>Reliquidar</th>
    </tr>
    </thead> 
<% 
    foreach (var item in Model) {       
    %>
    <tr>
        <td>
            <%: Html.DisplayFor(modelItem => item.id) %>
        </td>
        <td>
            <%: Html.DisplayFor(modelItem => item.fechaLiquidacion) %>
        </td>
        <td>
            <%=item.periodoLiquidacionIni.Value.ToString("MMM/yyyy")%>
        </td>
        <td>
            <%=item.periodoLiquidacionFin.Value.ToString("MMM/yyyy")%>
        </td>
		<td align="center">
            <a href='#'  onclick="popupReport('ReportLiqFranquicias','ID=<%: item.id %>');" title='Descargar Detalle Liquidación por Franquicia'><span class='ui-icon ui-icon-search'></span></a>
		</td>
		<td align="center">
            <a href='#'  onclick="popupReport('ReporteLiquidacionFranquicias','ID=<%: item.id %>');" title='Descargar Detalle Liquidación'><span class='ui-icon ui-icon-search'></span></a>
		</td>
         <td align="center">
         <%  
            if (item.estado != null)
            {
                if (item.estado == 1)
                    Response.Write ("Creado");    
                else if (item.estado == 2)
                    Response.Write ("Pagado");    
                else if (item.estado == 3)
                    Response.Write ("Anulado");    
                else if (item.estado == 4)
                    Response.Write ("En curso");    
                else if (item.estado == 5)
                    Response.Write ("Re-Liquidado");                                    
            }
            else
            { 
                Response.Write ("Procesando...");
            }           
        %>
        </td>
        <td align="center">
            <%: Html.ActionLink("Procesar", "Pagos", new { id=item.id }) %>
        </td>
        <% 
            Boolean pagada = false;                        
            if (item.estado != null)
            {
                if (item.estado.Value == 2)
                {
                    pagada = true;                                
                %>
                    <td align="center">
                        <a href='#'  onclick="popupReport('ReporteDetallePagosFranquicia','id=<%: item.id %>');" title='Descargar Detalle Pagos' ><span class='ui-icon ui-icon-search'></span></a>
                    </td>
                    <td align="center">
                        <%: Html.ActionLink("Ajustes", "AjustesFranquicias", "Ajustes", new { @id = item.id }, new { @class = "ui-icon ui-icon-wrench"})%>
                    </td>
                    <td align="center">
                        <% 
                            if (item.permite_reliquidar == 1)
                            {
                        %>
                                <a href='#'  onclick="reliquidarFranquicia(<%: item.id %>);" title='Reliquidar' ><span class='ui-icon ui-icon-wrench'></span></a>
                        <%
                            }
                        %>
                    </td>
                <% 
                }                   
            }

            if (!pagada)
            {
                %>
                    <td align="center">
                        <a href='#'  onclick="alert('Liquidación aún si pagar.');" title='Descargar Detalle Pagos' ><span class='ui-icon ui-icon-search'></span></a>
                    </td>
                    <td align="center">
                        <a href='#'  onclick="alert('Liquidación aún si pagar.');" title='Ajustes' ><span class='ui-icon ui-icon-wrench'></span></a>
                    </td>
                    <td align="center">  
                        <% 
                            if (item.permite_reliquidar == 1 && item.estado.Value == 5)
                            {
                        %>
                                <a href='#'  onclick="reliquidarFranquicia(<%: item.id %>);" title='Reliquidar' ><span class='ui-icon ui-icon-wrench'></span></a>
                        <%
                            }
                        %>                                        
                    </td>
                <%
            }
                    
        %>
    </tr>
<% } %>

</table>

</asp:Content>
