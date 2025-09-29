<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Participantes
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 385, width: 850, modal: true, closeOnEscape: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); $(ui).find('#FechaInicio').datepicker().click(function () { $(this).datepicker('show') }); $(ui).find('#FechaFin').datepicker().click(function () { $(this).datepicker('show') }); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); $(ui).find('#FechaInicio').datepicker('destroy'); $(ui).find('#FechaFin').datepicker('destroy'); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, width: 350, modal: true, closeOnEscape: true,
                title: titulo,
                open: function (event, ui) { $(this).load(pagina); $(ui).find('#FechaInicio').datepicker().click(function () { $(this).datepicker('show') }); $(ui).find('#FechaFin').datepicker().click(function () { $(this).datepicker('show') }); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); $(ui).find('#FechaInicio').datepicker('destroy'); $(ui).find('#FechaFin').datepicker('destroy'); }
            });
        }
        
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarDocumento").attr("value", "");
            $("#buscarNombre").attr("value", "");
            $("#buscarApellido").attr("value", "");
            $("#buscarNivel").attr("value", "");
            $("#buscarSegmento").attr("value", "");
            $("#buscarDocumento").focus();
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bDocumento = document.getElementById('buscarDocumento').value;
	            var bNombre = document.getElementById('buscarNombre').value;
	            var bApellido = document.getElementById('buscarApellido').value;
	            var bNivel = document.getElementById('buscarNivel').value;
	            var bSegmento = document.getElementById('buscarSegmento').value;

	            var qs = window.location.href.split("/");
	            var indice = qs[qs.length - 1] != "2" ? 3 : 3

	            var Documento = aData[indice];
	            var Nombre = aData[indice + 1];
	            var Apellido = aData[indice + 2];
	            var Nivel = aData[indice + 3];
	            var Segmento = aData[indice + 4];

	            var comparaDocumento = Documento.toUpperCase().indexOf(bDocumento.toUpperCase());
	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
	            var comparaApellido = Apellido.toUpperCase().indexOf(bApellido.toUpperCase());
	            var comparaNivel = Nivel.toUpperCase().indexOf(bNivel.toUpperCase());
	            var comparaSegmento = Segmento.toUpperCase().indexOf(bSegmento.toUpperCase());

	            if ((comparaDocumento >= 0) && (comparaNombre >= 0) && (comparaApellido >= 0) && (comparaNivel >= 0) && (comparaSegmento >= 0))
	                return true;
	            return false;
	        }
        );
	    var nivel = null;
	    $(document).ready(function () {
	        var qs = window.location.href.split("/");
	        if (qs[qs.length - 1] == "2") {
	            $("#asesores").text("Listar ejecutivos");
	            nivel = 2;
	        } else {
	            $("#asesores").text("Listar asesores");
	            nivel = null;
	        }
	        cargarTabla();
	        /* Event Listener del campo de búsqueda avanzada */
	        $('#buscarDocumento').keyup(function () { oTable.fnDraw(); });
	        $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
	        $('#buscarApellido').keyup(function () { oTable.fnDraw(); });
	        $('#buscarNivel').keyup(function () { oTable.fnDraw(); });
	        $('#buscarSegmento').keyup(function () { oTable.fnDraw(); });

	        $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
	        $("#bNuevo").button({ icons: { primary: "ui-icon-circle-plus"} });
	        $("#asesores").button({ icons: { primary: "ui-icon-person"} });

	    });

	    function cargarTabla() {
	        $("#tablaLista tbody").click(function (event) {
	            if (nivel != null) {
	                $(oTable.fnSettings().aoData).each(function () {
	                    $(this.nTr).removeClass('row_selected');
	                });
	                var fila = $(event.target.parentNode);
	                fila.addClass('row_selected');
	                mostrarInfoPpante(fila.get(0).cells[1].innerHTML);
	            }
	        });
	        oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "bProcessing": true, "sPaginationType": "full_numbers","bStateSave": true });
	        if (nivel != null) {
	            $('#tablaLista').dataTable({
	                "bJQueryUI": true, "bProcessing": true, "sPaginationType": "full_numbers","bStateSave": true, "bDestroy": true,
                    "aoColumnDefs": [{ "bVisible": false, "aTargets": [0,1] }],
	                "sAjaxSource": "/Participante/Listar/?nivelGP=" + nivel,
	                "fnServerData": fnServerObjectToArray(['id1', 'id', 'tipoDocumento', 'documento', 'nombre', 'apellidos', 'nivel', 'segmento'])
	            });
	        }
	    }
	    fnServerObjectToArray = function (elementos) {
	        return function (sSource, aoData, fnCallback) {
	            $.ajax({
	                "dataType": 'json', "type": "POST", "url": sSource, "data": aoData,
	                "success": function (json) {
	                    var a = [];
	                    for (var i = 0, iLen = json.length; i < iLen; i++) {
	                        var inner = [];
	                        for (var j = 0, jLen = elementos.length; j < jLen; j++)
	                            inner.push(json[i][elementos[j]]);
	                        a.push(inner);
	                    }
	                    json.aaData = a;
	                    fnCallback(json);
	                }
	            });
	        }
	    }

	    function mostrarInfoPpante(cedula) {
	        var ppante;
	        $.ajax({ url: '/Participante/getInfoParticipante/', data: { cedula: cedula }, async: false,
	            success: function (r) { if (r[0].nombrePpante) ppante = r[0]; }
	        });
	        if (ppante != null) {
	            $('#dialog').dialog({
	                height: 450, width: 370, modal: true, title: ppante.nombrePpante,
	                open: function (event, ui) {
	                    $('#tipoDocPpante').text(ppante.tipoDocPpante);
	                    $('#docPpante').text(ppante.docPpante);
	                    $('#estadoPpante').text(ppante.estadoPpante);
	                    $('#fecIngresoPpante').text(ppante.fecIngresoPpante != '01/01/1900' ? ppante.fecIngresoPpante : "");
	                    $('#fecRetiroPpante').text(ppante.fecRetiroPpante != '01/01/1900' ? ppante.fecRetiroPpante : "");
	                    $('#fecNacPpante').text(ppante.fecNacPpante != '01/01/1900' ? ppante.fecNacPpante : "");
	                    $('#companiaPpante').text(ppante.companiaPpante);
	                    $('#nivelPpante').text(ppante.nivelPpante);
	                    $('#zonaPpante').text(ppante.zonaPpante);
	                    $('#localidadPpante').text(ppante.localidadPpante);
	                    $('#tipoPpante').text(ppante.tipoPpante);
	                    $('#categoriaPpante').text(ppante.categoriaPpante);
	                    $('#segmentoPpante').text(ppante.segmentoPpante);
	                    $('#canalPpante').text(ppante.canalPpante);
	                    $('#clavePpante').text(ppante.clavePpante);
	                    $('#codPpante').text(ppante.codPpante);
	                    $('#emailPpante').text(ppante.emailPpante);
	                    $('#salarioPpante').text(ppante.salarioPpante);
	                    $('#telefonoPpante').text(ppante.telefonoPpante);
	                    $('#direccionPpante').text(ppante.direccionPpante);
	                },
	                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
	            });
	        }
        }

        function listarAsesores() {
            if ($("#asesores span:last").text() != "Listar asesores") {
                window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' +
                    document.location.port : '') + '/Participante';
            } else {
                window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' +
                    document.location.port : '') + '/Participante/Index/2'; // + id;
            }
        }
    </script>
        
    <div id="encabezadoParticipante">
        <div>
        <div id="infoPasoActual" style="text-align:left; float:left; width:750px">
            <h2>Participantes</h2>
            <p>
                En esta página puede ver los participantes existentes en el Sistema de Administración de Incentivos. Así mismo puede editar o eliminar los participantes existentes o crear uno nuevo.
            </p>
            <h4><%=Html.ActionLink("Regresar","Index","JerarquiaComercial")%></h4>
        </div>
        
		<!--<div id="progresoSeccion" style="text-align:right; float:right">
            <a href="/JerarquiaComercial" id="bAnterior" title='Regresar a la Lista'>Regresar</a>
		</div>-->
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <p>
        <%: Html.ActionLink("Nuevo Participante", "Crear", null, new { id = "bNuevo" })%>
        <%--<a href="javascript:listarAsesores();" id="asesores" title='Mostrar lista de asesores'>Listar asesores</a>--%>
    </p>

    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    
    <div id="participante">
        <table id="tablaAdmin">
            <tr valign="top">
                <td>
                    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                    <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		                <tr>
			                <td><label for="buscarDocumento">N°. Documento:</label></td>
			                <td><input type="text" id="buscarDocumento" name="buscarDocumento" size="8" /></td>
			                <td><label for="buscarNombre">Nombre:</label></td>
			                <td><input type="text" id="buscarNombre" name="buscarNombre" size="10" /></td>
			                <td><label for="buscarApellido">Apellidos:</label></td>
			                <td><input type="text" id="buscarApellido" name="buscarApellido" size="10" /></td>
                            <td><label for="buscarNivel">Nivel:</label></td>
			                <td><input type="text" id="buscarNivel" name="buscarNivel" size="8" /></td>
			                <td><label for="buscarSegmento">Segmento:</label></td>
			                <td><input type="text" id="buscarSegmento" name="buscarSegmento" size="8" /></td>
                        </tr>
	                </table>

                    <table id="tablaLista">
                    <thead>
                        <tr>
                            <th align="center">Editar</th>
                            <th align="center">Eliminar</th>
                            <th align="center">Tipo de Documento</th>
                            <th align="center">Documento</th>
                            <th align="center">Nombre</th>
                            <th align="center">Apellidos</th>
                            <th align="center">Nivel</th>
                            <th align="center">Segmento</th>
                        </tr>
                    </thead>
                    <tbody>
                      <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
                    <% Random random = new Random(); int num = random.Next(1, 10000);  %>
                    <% if (ViewData["Participantes"] != null) { %>
                        <% foreach (var item in ((IEnumerable<Participante>)ViewData["Participantes"])) { %>
                        <tr>
                            <td align="center"><a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar Participante', 'dialogEditar');" title='Editar Participante'><span class='ui-icon ui-icon-pencil'></span></a></td >
                            <td align="center"><a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Participante', 'dialogEliminar');" title='Eliminar Participante'><span class='ui-icon ui-icon-trash'></span></a></td>
                            <td align="center"><%: item.TipoDocumento.nombre %></td>
                            <td align="center"><%: item.documento %></td>
                            <td align="center"><%: item.nombre %></td>
                            <td align="center"><%: item.apellidos %></td>
                            <td align="center"><%: item.Nivel.nombre %></td>
                            <td align="center"><%: item.Segmento.nombre %></td>
                        </tr>
                        <% } %>
                    <% } %>
                    </tbody>
                    </table>
                </td>
            </tr>
         </table>
    </div>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

    <div id='dialog' style="display:none;" class="info">
        <table width="100%">
            <tr><td><b>Tipo de Documento:</b></td>     <td id="tipoDocPpante"></td></tr>
            <tr><td><b>Documento:</b></td>             <td id="docPpante"></td></tr>
            <tr><td><b>Estado:</b></td>                <td id="estadoPpante"></td></tr>
            <tr><td><b>Fecha Ingreso:</b></td>         <td id="fecIngresoPpante"></td></tr>
            <tr><td><b>Fecha Retiro:</b></td>          <td id="fecRetiroPpante"></td></tr>
            <tr><td><b>Fecha Nacimiento:</b></td>      <td id="fecNacPpante"></td></tr>
            <tr><td><b>Compañía de nómina:</b></td>    <td id="companiaPpante"></td></tr>
            <tr><td><b>Nivel principal:</b></td>       <td id="nivelPpante"></td></tr>
            <tr><td><b>Zona:</b></td>                  <td id="zonaPpante"></td></tr>
            <tr><td><b>Localidad:</b></td>             <td id="localidadPpante"></td></tr>
            <tr><td><b>Tipo Participante:</b></td>     <td id="tipoPpante"></td></tr>
            <tr><td><b>Categoria:</b></td>             <td id="categoriaPpante"></td></tr>
            <tr><td><b>Segmento.</b></td>              <td id="segmentoPpante"></td></tr>
            <tr><td><b>Canal:</b></td>                 <td id="canalPpante"></td></tr>
            <tr><td><b>Clave:</b></td>                 <td id="clavePpante"></td></tr>
            <tr><td><b>Código Productor:</b></td>      <td id="codPpante"></td></tr>
            <tr><td><b>Email:</b></td>                 <td id="emailPpante"></td></tr>
            <tr><td><b>Salario:</b></td>               <td id="salarioPpante"></td></tr>
            <tr><td><b>Teléfono:</b></td>              <td id="telefonoPpante"></td></tr>
            <tr><td><b>Dirección:</b></td>             <td id="direccionPpante"></td></tr>
        </table>
    </div>
</asp:Content>
            <%--window.location.href = document.location.protocol + '' + document.location.hostname + (document.location.port != '' ? ':' +
                document.location.port : '') + '/Participante/Index/' + id;
	        oTable = $('#tablaLista').dataTable();
	        if (mostrar)
            {
                $.ajax({ url: "/Participante/Listar", data: { nivelGP: 2 }, // type: "POST",
	                success: function (result) {
                        oTable.fnClearTable();
	                    $(result).each(function () {
	                        var fila =
                            "<tr>" +
                                "<td align='center'><a href='javascript:alert(\"Ver\")' title='Editar Participante'><span class='ui-icon ui-icon-pencil'/></a></td >" +
                                "<td align='center'><a href='javascript:alert(\"\")' title='Eliminar Participante'><span class='ui-icon ui-icon-trash'/></a></td>" +
                                "<td align='center'>" + this.tipoDocumento + "</td>" +
                                "<td align='center'>" + this.documento + "</td>" +
                                "<td align='center'>" + this.nombre + "</td>" +
                                "<td align='center'>" + this.apellidos + "</td>" +
                                "<td align='center'>" + this.nivel + "</td>" +
                                "<td align='center'>" + this.segmento + "</td>" +
                            "</tr>";
	                        oTable.fnAddTr($(fila)[0]);
	                    });
	                    $("#asesores").text("Listar ejecutivos");
	                }
	            });
	        } else {
	            oTable = $('#tablaLista').dataTable({
	                "bJQueryUI": true, "bProcessing": true, "sPaginationType": "full_numbers","bStateSave": true, "bServerSide": true,
	                "sAjaxSource": "/Participante/Index"
	            });
	        }--%>