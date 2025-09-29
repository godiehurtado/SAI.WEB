<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidación Regla - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<style>
#subregla 
{
    width:80%;
    padding-bottom:10px;
}
#subregla h4
{
    background-color: #E4E4E4;
    border-bottom: 1px solid #DCDCDC;
    color: #333333;
    font-size: 12px;
    margin: 0 0 5px;
    padding: 6px 8px;
}
#condiciones table
{
    border-collapse:collapse;
    border-color:Gray;
}
#condiciones table td
{
    padding:4px;
}
</style>
<script type="text/javascript">
    $(function () {
        oTable = $('#tablaLista').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers"
        });

    });
	</script>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Detalle de liquidación <%: ViewBag.regla %></h2>
            <h3>Participante: <%: ViewBag.participante %></h3>
        </div>
        <div id="progresoSeccion">
            <br />
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <div id="InformacionLiquidacion">

    <% 
        int subReglaActual = 0;
        bool nueva = true;
        
        foreach (var item in ((IEnumerable<VistaDetalleLiquidacionReglaParticipante>)ViewBag.detalle)){
            if (subReglaActual != item.subregla_id)
            {
                subReglaActual = Convert.ToInt32(item.subregla_id);
                nueva = false;
            %>
                <div id="subregla"> <!-- Inicia subregla -->
                    <h4>SUBREGLA <%:  item.descripcion.ToUpper() %>: <% var resultado = (item.Gano == true) ? "Cumplió" : "No cumplió"; %><%: resultado%></h4>
                    <div id="condiciones"> <!-- Inician condiciones -->
                        <table width="100%" cellspacing="2" border="1">
                            <tr>
                                <th>Condición</th>
                                <th>Resultado</th>
                            </tr>
            <% }else { nueva = true; } %>
                            <tr>
                                <td>
                                    <%: item.Variable %>
                                    <%: item.expresion %>
                                    <%: item.valor %>
                                </td>
                                <td><%: item.resultado %></td>
                            </tr>
                <% if (nueva){ %>
                        </table> 
                    </div> <!-- Fin condiciones -->
                </div> <!-- Fin subregla -->
                <%  } %>
        <%  } %>
        <% if (!nueva) { // cerrar el HTML para la última subregla %>
                        </table> 
                    </div> <!-- Fin condiciones -->
                </div> <!-- Fin subregla -->
        <% } %>
    </div>
</asp:Content>
