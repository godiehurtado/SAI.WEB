<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Combo>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Combos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });

        });

	    function eliminarCombo(idCombo) {

	        if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
	            var stUrl = '/Combo/DeleteCombo';
	            mostrarCargando("Eliminando Combo. Espere Por Favor...");
	            $.ajax({
	                type: 'POST',
	                url: stUrl,
	                data: {
	                    idCombo: idCombo
	                },
	                success: function (response) {
	                    if (response.Success) {
	                        closeNotify('jNotify');

	                        if (response.Result == 1) {
	                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
	                            window.location.href = window.location.href;
	                        }
	                        else if (response.Result == 0) {
                                mostrarError("La Meta no se puede eliminar por que hay registros relacionados.")
	                        }

	                    }
	                }
	            });
	        }
	    }

	</script>

    <h2>Combos</h2>
    <p>
        <a href="/Administracion">Regresar</a> | <%: Html.ActionLink("Crear nuevo combo", "Create") %>
    </p>

    <table id="tablaLista">
        <thead>
        <tr>
            <th>Código</th>
            <th>Combo</th>
            <th>Descripcion</th>
            <th>Validado?</th>
            <th align="center">Opciones</th>
        </tr>
        </thead>
        <% foreach (var item in Model) { %>
        <tr>
            <td align="center"><%: item.id %></td>
            <td><%: item.nombre %></td>
            <td><%: item.descripcion %></td>
            <td align="center"><%: (item.validado == 1) ? "Si" : "No" %></td>
            <td nowrap = "nowrap" align="center">
                <a href="/Combo/Create/?comboId=<%: item.id %>" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                
                <a href="javascript:eliminarCombo(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
            </td>
        </tr>
        <% } %>
    </table>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
