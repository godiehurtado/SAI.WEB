<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Localidad>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Listado de Franquicias - - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <script type="text/javascript">
       $(document).ready(function () {
                $('#tablaLista').dataTable({ "bJQueryUI": true,
                    "sPaginationType": "full_numbers","bStateSave": true
                
                })
            
        var oTable = $('.tbl').dataTable();

     })
</script>

    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Listado de Franquicias</h2>
            <p>
                En esta página puede visualizar el listado de franquicias registradas en el sistema así como definir los porcentajes 
                de participación , cambio de porcentajes y las excepciones a tener en cuenta en el proceso de liquidación y pagos.<br />                
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
            Haga clic en Excepciones para visualizar y definir las excepciones de la misma. De igual
                manera puede hacer clic en el link de Porcentajes de Participación para visualizarlos o haga clic en el link de Cambio masivo de porcentajes para cambiar los mismos.

        </div>
        <div style="clear:both;"><hr /></div>   
    </div>
    <div id="Div1">
            <p>
             <%: Html.ActionLink("Regresar", "Index", "LiquidacionFranqui")%>
             <%: Html.ActionLink("Cambio masivo de porcentajes", "ActualizacionMasivaPartFranquicias", "ParticipacionFranquicias")%>
             <%: Html.ActionLink("Excepciones Especiales", "ExcepcionesEspeciales", "Excepciones")%>
             <%: Html.ActionLink("Cargue Masivo Excepciones", "CargueMasivoExcepciones", "Excepciones")%>
            </p>
        </div>
	<table  class="tbl" id="tablaLista">
	 <thead>
		<tr>
			<th>Excepciones</th>
			<th>Porcentajes de participación</th>
			<th>Franquicia</th>
		</tr>
		</thead> 
	<% foreach (var item in Model) 
	   
	   
	   { %>
	
		<tr id='<%= item.id.ToString()%>'>
		    <td>				
				 <%: Html.ActionLink("Excepciones", "Index", "Excepciones", new { id = item.id }, null)%>
                 (<%=item.Excepcions.Count()%>)
			</td>
			<td>				
				 <%: Html.ActionLink("Porcentajes de Participación", "Index", "ParticipacionFranquicias", new { id = item.id },null)%>
                 (<%=item.ParticipacionFranquicias.Count()%>)
			</td>		 
			<td>
			<% if
				   (item.id != 0)
				  
			  {%>
				<%:item.nombre%>
				<%}%>
			  <%else{%>

				 <%:Html.Label("Condiciones Generales")%>
				 
			<%}%>
			</td>
		</tr>
	
	<% } %>

	</table>

</asp:Content>

