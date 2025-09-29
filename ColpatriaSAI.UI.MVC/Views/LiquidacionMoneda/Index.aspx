<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.LiquidacionMonedaModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidacion Moneda 
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        //ALMACENAMOS EN OTRA LISTA LOS CARGUES AGRUPADOS
        var liquidacionMonedaTemp = this.Model.LiquidacionMonedaList.GroupBy(x => x.fechaCargue).ToList();
    %>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#tablaLista').dataTable({ "bJQueryUI": true,
                "sPaginationType": "full_numbers"
            })
            var oTable = $('.tbl').dataTable();
        })

        function eliminarCargue(fechaCargue) {

            if (confirm('Usted va a eliminar el cargue de la fecha ' + fechaCargue + '.\n\n Esta seguro?')) {
                var stUrl = '/LiquidacionMoneda/EliminarCargue';
                mostrarCargando("Eliminando Cargue. Espere Por Favor...");
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data:
                    {
                        fechaCargue: fechaCargue
                    },
                    success: function (response) {
                        closeNotify('jNotify');
                        if (response.Success) {
                            mostrarExito(response.Messagge);
                            window.location.href = window.location.pathname;
                        }
                        else {
                            mostrarError(response.Messagge);
                        }
                    }
                });               
            }
        }

    </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" style="width:450px;">
			<h2>Listado de Colquines Manuales</h2>
			<p>
				<%: Html.ActionLink("Regresar", "Index","Concursos") %>
				<%: Html.ActionLink("Cargue Masivo de Colquines", "ColquinesManuales")%>
                (Descargue el formato de carga <a href='<%=ViewData["partArchivoFormato"]%>'>aquí</a>)
			</p>
		</div>

		<div id="progresoSeccion">
	</div>

		<div style="clear:both;"><hr /></div>
	</div>
	<table id="tablaLista">
	<thead>
		<tr>
			<th align = "center">Fecha Liquidacion (dd/mm/yyyy)</th>
            <th align = "center">Compañia</th>
            <th align = "center">Participante</th>
			<th align = "center">Cantidad</th>
			<th align = "center">Fecha Cargue  (dd/mm/yyyy)</th>

		</tr>
	</thead>
	<tbody>
	<% foreach (ColpatriaSAI.Negocio.Entidades.LiquidacionMoneda liquidacionMoneda in this.Model.LiquidacionMonedaList)
    { %>
	
		<tr>
			<td align = "center"><%=liquidacionMoneda.fechaLiquidacion.Value.ToShortDateString() %></td>
            <td align = "center"><%=liquidacionMoneda.Compania.nombre %></td>
            <td align = "left"><%=liquidacionMoneda.Participante.nombre %> <%=liquidacionMoneda.Participante.apellidos %></td>
            <td align = "right"><%=liquidacionMoneda.cantidad %></td>
            <td align = "center"><%=liquidacionMoneda.fechaCargue %></td>			
		</tr>
	
	<% } %>
	</tbody>
	</table>
    <u>Seleccione por fecha el ultimo cargue para eliminarlo.</u>
    <div id="cargues">    
	<% 
        if (liquidacionMonedaTemp.Count() > 0)
        {
            foreach (var item in liquidacionMonedaTemp)
            { 
    %>
	            <input type="radio" name="fechaCargue" id="fechaCargue" value="<%=item.Key%>" onclick='eliminarCargue(this.value);'/><%=item.Key%><br/>	
	<%      }
        }
        else
        {
    %>	
        No hay cargues para eliminar.
    <%
        } 
    %>     
    </div>

</asp:Content>
