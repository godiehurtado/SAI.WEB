<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Meta>>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Metas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarMeta').keyup(function () { oTable.fnDraw(); });
            $('#buscarVariable').keyup(function () { oTable.fnDraw(); });
            $('#buscarTipo').keyup(function () { oTable.fnDraw(); });
            $('#buscarAuto').keyup(function () { oTable.fnDraw(); });
        });

        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarMeta").attr("value", "");
            $("#buscarVariable").attr("value", "");
            $("#buscarTipo").attr("value", "");
            $("#buscarAuto").attr("value", "");
            oTable.fnDraw();
        }

        /* Filtro para buscar en la 3ra columna exclusivamente*/
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bMeta = document.getElementById('buscarMeta').value;
	            var bVariable = document.getElementById('buscarVariable').value;
	            var bTipo = document.getElementById('buscarTipo').value;
	            var bAuto = document.getElementById('buscarAuto').value;
	            var Meta = aData[0];
	            var Variable = aData[1];
	            var Tipo = aData[2];
	            var Auto = aData[3];
	            var comparaMeta = Meta.toUpperCase().indexOf(bMeta.toUpperCase());
	            var comparaVariable = Variable.toUpperCase().indexOf(bVariable.toUpperCase());
	            var comparaTipo = Tipo.toUpperCase().indexOf(bTipo.toUpperCase());
	            var comparaAuto = Auto.toUpperCase().indexOf(bAuto.toUpperCase());
	            if ((comparaMeta >= 0) && (comparaVariable >= 0) && (comparaTipo >= 0) && (comparaAuto >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );

	    function eliminarMeta(idMeta) {

	        if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
	            var stUrl = '/Meta/DeleteMeta';
	            mostrarCargando("Eliminando Meta. Espere Por Favor...");
	            $.ajax({
	                type: 'POST',
	                url: stUrl,
	                data: {
	                    idMeta: idMeta
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

	    function formAnadirMetaValidacion(idMeta, nombreMeta) {

	        $("#contentMetaValidacionList").text("Cargando...");
            $("#contentMetaValidacionList").hide();
            $("#contentMetaValidacionEdit").show();
            selectAll(false);       
	        $("#origen").text("");
	        $("#guardarMetaValidacion").attr('disabled', false);

	        $("#origen").text(nombreMeta);

	        $("#metaValidacion").dialog({
                modal:true,
	            width: 600,
	            minHeight: 350,
	            title: 'Asociar Metas para Reponderar',
	            position: 'center',
	            close: function (ev, ui) {

	            }
	        });

	        $("#metaValidacionId").val(idMeta);
	    }

	    function metaValidacionSave() {

	        var metaValidacion = $("#origen").text();

	        if (metaValidacion != "") {
	            var stUrl = '/Meta/guardarMetaCumplimiento';
	            mostrarCargando("Enviando información. Espere Por Favor...");
	            $("#guardarMetaValidacion").attr('disabled', true);
	            $.ajax({
	                type: 'POST',
	                url: stUrl,
	                data: $("#metaValidacionForm").serialize(),
	                success: function (response) {
	                    if (response.Success) {
	                        closeNotify('jNotify');
	                        mostrarExito("El proceso se realizó con éxito.");
	                        $("#guardarMetaValidacion").attr('disabled', false);
	                        mostrarMetaValidacionList();
	                    }
	                }
	            });
	        }
	        else {
	            mostrarError("Debe seleccionar por lo menos una meta para el recalcular.");
	        }
	    }

	    function mostrarMetaValidacionEdit() {
	        $("#contentMetaValidacionList").hide();
	        $("#contentMetaValidacionEdit").show();
	    }

	    function mostrarMetaValidacionList() {

	        var stUrl = '/Meta/listadoMetaValidacion';
	        $.ajax({
	            type: 'POST',
	            url: stUrl,
	            data:
                    {
                        idMeta: $("#metaValidacionId").val()
                    },
	            success: function (response) {
	                $("#contentMetaValidacionList").html(response);
	            }
	        });

	        $("#contentMetaValidacionList").show();
	        $("#contentMetaValidacionEdit").hide();

	    }

	    function deleteMetaValidacion(idMetaValidacion) {

	        var stUrl = '/Meta/eliminarMetaValidacion';
	        mostrarCargando("Enviando información. Espere Por Favor...");
	        $.ajax({
	            type: 'POST',
	            url: stUrl,
	            data:
                    {
                        idMeta: idMetaValidacion
                    },
	            success: function (response) {
	                closeNotify('jNotify');
	                mostrarExito("El proceso se realizó con éxito.");
	                mostrarMetaValidacionList();
	            }
	        });

	    }

	    function eliminarTodasMetasValidacion() {

	        if (confirm(" Esta seguro de borrar todas las metas asociadas?  \n El proceso no se podra deshacer. ")) {

	            var stUrl = '/Meta/eliminarMetaValidacionAll';
	            mostrarCargando("Borrando información. Espere Por Favor...");
	            var idMeta = $("#metaValidacionId").val();
	            $.ajax({
	                type: 'POST',
	                url: stUrl,
	                data:
                    {
                        idMeta: idMeta
                    },
	                success: function (response) {
	                    closeNotify('jNotify');
	                    mostrarExito("El proceso se realizó con éxito.");
	                    mostrarMetaValidacionList();
	                }
	            });
	        }
	    }

	    function metaValidacionCancelar() {
	        $("#origen").text("");
	        $("#metaValidacionId").val(0);
	        $("#metaValidacion").dialog('close');
	    }

	</script>

    <h2>Metas</h2>
    <p>
        <a href="/Contratacion/Parametrizacion">Regresar</a> | <%: Html.ActionLink("Crear nueva meta", "Create") %>
    </p>

    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
    <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
	    <tr>
		    <td><label for="buscarMeta">Meta:</label></td>
		    <td><input type="text" id="buscarMeta" name="buscarMeta" /></td>
		    <td><label for="buscarVariable">Variable:</label></td>
		    <td><input type="text" id="buscarVariable" name="buscarVariable" /></td>
		    <td><label for="buscarTipo">Tipo:</label></td>
		    <td><input type="text" id="buscarTipo" name="buscarTipo" style="width:90px" /></td>
        </tr>
        <tr>
		    <td><label for="buscarAuto">Automático:</label></td>
		    <td><input type="text" id="buscarAuto" name="buscarAuto" style="width:40px" /></td>
	    </tr>
    </table>

    <table id="tablaLista">
        <thead>
        <tr>
            <th>Código</th>
            <th>Nombre de la meta</th>
            <th>Tipo Medida</th>
            <th>Tipo</th>
            <th>¿Automatica?</th>
            <th>¿Acumulada?</th>
            <th align="center">Opciones</th>
        </tr>
        </thead>
        <% foreach (var item in Model) { %>
        <tr>
            <td align="center"><%: item.id %></td>
            <td><%: item.nombre %></td>
            <td><%: item.TipoMedida.nombre %></td>
            <td><%: item.TipoMeta.nombre %></td>
            <td align="center"><%: (item.automatica == true) ? "Si" : "No" %></td>
            <td align="center"><%: (item.meta_id.HasValue ? "Si" : "No") %></td>
            <td nowrap = "nowrap" align="center">
                <a href="/Meta/Create/?metaId=<%: item.id %>" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                
                <a href="javascript:eliminarMeta(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                <!--a href="javascript:formAnadirMetaValidacion(<%: item.id %>,'<%: item.nombre %>');" title='Adicionar Metas para Validacion' style="float:left;"><span class='ui-icon ui-icon-copy'/></a-->
            </td>
        </tr>
        <% } %>
    </table>
    <div id='dialogEliminar' style="display:none;"></div>

<div id="metaValidacion" style="display:none;">
    <a href="javascript:mostrarMetaValidacionEdit();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Adicionar Meta</span></a>
    <a href="javascript:mostrarMetaValidacionList();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Ver Metas Asociadas</span></a>
    <a href="javascript:eliminarTodasMetasValidacion();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Eliminar todas las Metas Asociadas</span></a>
    <hr/>
    <div id="contentMetaValidacionEdit" style="display:block;">
        <form id="metaValidacionForm" name="metaValidacionForm" action="">
        Meta a validar:<br/>
        <div id="origen"></div>
        <input type="hidden" id="metaValidacionId" name="metaValidacionId" value="0" />
        <hr/>
        <table border="0">
        <tr>
            <td valign="top">Metas a recalcular:</td>
            <td>       
                <div style="overflow:auto;height:400px;">  
                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <%
                    int cols = 1;
                    List<Meta> metasList = (List<Meta>)ViewData["MetaCumplimientoList"];                      
                    foreach (Meta meta in metasList)
                    {
                        if (cols==1){
                            %>
                                <tr>  
                            <%        
                        }
                            
                        %>
                            <td>
                            <input type="checkbox" name="metas[]" value="<%=meta.id%>" /><%=meta.nombre%>
                            </td>
                        <%
                        if (cols==3){
                            %>
                                </tr>  
                            <%     
                            cols = 0;       
                        }                           
                                    
                        cols++;    
                    }
                %>
                </table>
                </div>
            </td>
        </tr>
        </table>
        <br/>
            
        <center>
        <input type="button" onclick="metaValidacionSave()" id="guardarMetaValidacion" value="Guardar"/>
        <input type="button" onclick="metaValidacionCancelar()" id="cancelarMetaValidacion" value="Cancelar"/>
        </center>
        </form>
    </div>
    <div id="contentMetaValidacionList" style="display:none;">
    </div>
</div>

</asp:Content>
