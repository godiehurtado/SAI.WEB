<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.UI.MVC.Models.ExcepcionJerarquiaDetalleModel>" %>

<table id="tableExcepcion" width="100%">
	<thead>
		<tr>
			<%--<th align = "center">Editar</th>--%>			
            <th align = "center">Eliminar</th>			
            <th align = "center">Destino</th>
			<th align = "center">Meta</th>
		</tr>
	</thead>
    <tbody>
<%
    foreach(ColpatriaSAI.Negocio.Entidades.ExcepcionJerarquiaDetalle excepcionJerarquia in this.Model.ExcepcionJerarquiaDetalleList ){        
        %>
            <tr>
			<%--<td align="center"><a href='javascript:editExcepcionJerarquia(<%=excepcionJerarquia.id%>);' title='Editar' ><span class='ui-icon ui-icon-pencil'></span></a></td>--%>
			<td align="center"><a href='javascript:deleteExcepcionJerarquia(<%=excepcionJerarquia.id%>);' title='Eliminar' ><span class='ui-icon ui-icon-trash'></span></a></td>
            <td>            
                <%=excepcionJerarquia.JerarquiaDetalle.nombre %>                
            </td>		         
			<td>
                <%
                    var textMeta = "Todos";
                    if (excepcionJerarquia.Meta != null && !string.IsNullOrEmpty(excepcionJerarquia.Meta.nombre.Trim()))
                        textMeta = excepcionJerarquia.Meta.nombre;
                %>
                <%=textMeta%> 
            </td>
            </tr>
        <%       
    }      
      
%>
    </tbody>
</table>
<script type="text/javascript">
	$(document).ready(function () {
	    $('#tableExcepcion').dataTable({ "bJQueryUI": true,
	        "sPaginationType": "full_numbers","bStateSave": true
	    })
	    var oTable = $('.tbl').dataTable();
	})
</script>