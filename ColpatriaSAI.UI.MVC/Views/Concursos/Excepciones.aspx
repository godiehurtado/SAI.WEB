<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.ExcepcionesGenerale>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Excepciones - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () { 
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
         
        });

        

	        function eliminarExcepcion(id) {

	            if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
	                var stUrl = '/concursos/EliminarExcepcion';
	                mostrarCargando("Eliminando Excepción. Espere Por Favor...");
	                $.ajax({
	                    type: 'POST',
	                    url: stUrl,
	                    data: {
	                        idexcepcion: id
	                    },
	                    success: function (response) {
	                        if (response.Success) {
	                            closeNotify('jNotify');

	                            if (response.Result == 1) {
	                                mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
	                                window.location.href = window.location.href;
	                            }
	                            else if (response.Result == 0) {
	                                mostrarError("La Excepción no se pudo  eliminar.")
	                            }

	                        }
	                    }
	                });
	            }
	        };

	              
           
    </script>
   
    <h2>
    Listado De  Excepciones</h2>
    <p>
        <a href="/concursos/Index">Regresar</a> | <%: Html.ActionLink("Crear nueva Excepcion", "CrearExcepcion") %>
    </p>
     <div id="progreso">
        </div>
    <table>
            <tr  valign="top">
                <td>
                 <% using (Html.BeginForm("saveExepcion", "ExcepcionConcurso", FormMethod.Post, new { id = "FrmExcepcion" })){
                        Html.ValidationSummary(true); %>
                    
                 
              </td>

                <td>
                
                   
                    <table border="0" cellspacing="5" cellpadding="5" id="tbFiltros" style="display:none">
		            <tr>  
                     <td><label for="ddlcompania">Compañia:</label></td>
			            <td><input type="text" id="ddlcompania" name="ddlcompania" /></td>                      
			            <td><label for="ddlRamoF">Ramo:</label></td>
			            <td> <input type="text" id="ddlramo" name="ddlramo" /></td>
			            <td><label for="bclave">Clave :</label></td>
			            <td><input type="text" id="bclave" name="bclave" /></td>
                        
		            </tr>                    
	            </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Compañia</th>
                        <th align = "center">Ramo</th>
                        <th align = "center">Clave</th>
                        <th align = "center">Negocio</th>
                        <th align = "center">Factor</th>
                         <th align = "center">Año</th>
                        <th align = "center">Tipo Medida</th>
                        <th align = "center">Fecha Inicio</th>
                        <th align = "center">Fecha Fin</th>
                        <th align="center"> Opciones</th>
                       
                    </tr>
                </thead>
                <tbody>
                   <% foreach (var item in ((List<ExcepcionesGenerale>)ViewData["LstExcepciones"])){%>
	                    <tr>
                            <td><%:item.Compania.nombre %></td>
                            <td><%: item.Ramo.nombre %></td>
                            <td><%: item.clave %></td>
                            <td><%: item.numeroNegocio %></td>
                            <td><%: item.factor %></td>
                            <td><%: item.ano %></td>
                            <td><%: item.TipoMedida.nombre %></td>
                            <td><%: String.Format("{0:d}", item.fechaInicio)%></td>
                            <td><%: String.Format("{0:d}",item.fechaFin) %></td>
                            
                            
                            <td nowrap = "nowrap" align="center">
                            <a href="/concursos/EditarExcepciones/?id=<%: item.id %>" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                
                            <a href="javascript:eliminarExcepcion(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                        </td>                                               
		                </tr>
	                   <% } %>
                       
                       </tbody>
                </table>
                </td>

               </tr>
        </table>
    <% } %>
   
        
        </a>
   
        
</asp:Content>
