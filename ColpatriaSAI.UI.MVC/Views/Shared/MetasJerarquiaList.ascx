<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.UI.MVC.Models.MetaJerarquiaModel>" %>

<table id="tableMeta" width="100%">
	<thead>
		<tr>	
            <th align = "center">Eliminar</th>			
            <th align = "center">Meta</th>
            <th align = "center">Año</th>
		</tr>
	</thead>
    <tbody>
<%
    foreach(ColpatriaSAI.Negocio.Entidades.MetaxNodo metaJerarquia in this.Model.MetaJerarquiaList ){        
        %>
            <tr>			
			<td align="center"><a href='javascript:deleteMetaJerarquia(<%=metaJerarquia.id%>);' title='Eliminar' ><span class='ui-icon ui-icon-trash'></span></a></td>
            <td>            
                <%=metaJerarquia.Meta.nombre%>                
            </td>		
            <td>            
                <%=metaJerarquia.anio%>                
            </td>
            </tr>
        <%       
    }      
      
%>
    </tbody>
</table>
<script type="text/javascript">
	$(document).ready(function () {
	    $('#tableMeta').dataTable({ "bJQueryUI": true,
	        "sPaginationType": "full_numbers","bStateSave": true
	    })
	    var oTable = $('.tbl').dataTable();
	})
</script>