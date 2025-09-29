<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.ParticipacionDirector>>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Participaciones de directores - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarEditar(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 220, width: 380, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarEliminar(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        
        function mostrarDialogDirectores(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 630, width: 650, modal: true,
                buttons: {
                    Cerrar: function () { $(this).dialog("close"); }
                },
                title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });

            var dates = $("#fechaIni, #fechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "yy-mm-dd",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });

            $("#formParticipacion").validate({
                rules: {
                    fechaIni: "required",
                    fechaFin: "required",
                    compania_id: "required",
                    participante_id: "required",
                    porcentaje: "required"
                }
            });
            $('#buscarFecha1').keyup(function () { oTable.fnDraw(); });
            $('#buscarFecha2').keyup(function () { oTable.fnDraw(); });
            $('#buscarCompañia').keyup(function () { oTable.fnDraw(); });
            $('#buscarCanal').keyup(function () { oTable.fnDraw(); });
            $('#buscarPpante').keyup(function () { oTable.fnDraw(); });
            $('#buscarPtje').keyup(function () { oTable.fnDraw(); });
        });
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $('#buscarFecha1').attr("value", "");
            $('#buscarFecha2').attr("value", "");
            $('#buscarCompañia').attr("value", "");
            $('#buscarCanal').attr("value", "");
            $('#buscarPpante').attr("value", "");
            $('#buscarPtje').attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bFecha1 = document.getElementById('buscarFecha1').value;
	            var bFecha2 = document.getElementById('buscarFecha2').value;
	            var bCompania = document.getElementById('buscarCompañia').value;
	            var bCanal = document.getElementById('buscarCanal').value;
	            var bPpante = document.getElementById('buscarPpante').value;
	            var bPtje = document.getElementById('buscarPtje').value;

	            var Fecha1 = aData[0];
	            var Fecha2 = aData[1];
	            var Compania = aData[2];
	            var Canal = aData[3];
	            var Ppante = aData[4];
	            var Ptje = aData[5];

	            var comparaFecha1 = Fecha1.toUpperCase().indexOf(bFecha1.toUpperCase());
	            var comparaFecha2 = Fecha2.toUpperCase().indexOf(bFecha2.toUpperCase());
	            var comparaCompania = Compania.toUpperCase().indexOf(bCompania.toUpperCase());
	            var comparaCanal = Canal.toUpperCase().indexOf(bCanal.toUpperCase());
	            var comparaPpante = Ppante.toUpperCase().indexOf(bPpante.toUpperCase());
	            var comparaPtje = Ptje.toUpperCase().indexOf(bPtje.toUpperCase());

	            if ((comparaFecha1 >= 0) && (comparaFecha2 >= 0) && (comparaCompania >= 0) && (comparaCanal >= 0) && (comparaPpante >= 0) && (comparaPtje >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );

    </script>

    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    <% string ruta = Request.Url.ToString(); if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; }
       Random random = new Random(); int num = random.Next(1, 10000);  %>

    <h2>Participación por director</h2>
    <h4><%=Html.ActionLink("Regresar","Index","Contratacion/Parametrizacion") %></h4>

    <table>
        <tr>

            <td valign="top">
            <% using (Html.BeginForm("Crear", "ParticipacionDirector", FormMethod.Post, new { id = "formParticipacion" })) { %>
                <%: Html.ValidationSummary(true) %>
                <table>
                    <tr>
                        <td>Fecha inicial:<br />
                            <%: Html.TextBox("fechaIni", null, new { @readonly = "true", @class = "required" })%><br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td>Fecha final:<br />
                            <%: Html.TextBox("fechaFin", null, new { @readonly = "true", @class = "required" })%><br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td>Compañia:<br />
                            <%: Html.DropDownList("compania_id", (SelectList)ViewBag.compania_id, "Seleccione...", new { @class = "required" })%><br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td>Canal:<br />
                            <%: Html.DropDownList("canal_id", (SelectList)ViewBag.canal_id)%><br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td>Director:<br />
                            <%--<%: Html.DropDownList("participante_id", (SelectList)ViewBag.participante_id, "Seleccione...", new { @class = "required" })%>--%>
                            <%: Html.TextBox("participante", null, new { @readonly = "true" }) %><%--, @class = "required", style = "width:280px;"--%>
                            <%: Html.Hidden("jerarquiaDetalle_id", new { id = "jerarquiaDetalle_id" })%>
                            <a href="javascript:mostrarDialogDirectores('/ParticipacionDirector/Directores?r=<%: num %>', 'Lista de Directores', 'dialogPart');" style='float:right;' title='Buscar Participantes'><span class='ui-icon ui-icon-search'/></a>
                            <br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td>Porcentaje:<br />
                            <%: Html.TextBox("porcentaje", null, new { @class = "required" })%><br /><br />
                        </td>
                    </tr>
                    <tr>
                        <td valign="bottom"><input type="submit" value="Crear participacion" id="btnCrear" /></td>
                    </tr>
                </table>
            <% } %>
            </td>

            <td>
                <fieldset><legend><b>Lista de participaciones configuradas</b></legend>
                    <div style="text-align:right"><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada&nbsp;&nbsp;</label></div>
                    <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		                <tr>
			                <td><label for="buscarFecha1">Fecha inicial:</label></td>
			                <td><input type="text" id="buscarFecha1" name="buscarFecha1" size="10" /></td>
			                <td><label for="buscarFecha2">Fecha final:</label></td>
			                <td><input type="text" id="buscarFecha2" name="buscarFecha2" size="8" /></td>
			                <td><label for="buscarCompañia">Compañia:</label></td>
			                <td><input type="text" id="buscarCompañia" name="buscarCompañia" size="10" /></td>
		                </tr>
                        <tr>
                            <td><label for="buscarCanal">Canal:</label></td>
			                <td><input type="text" id="buscarCanal" name="buscarCanal" size="10" /></td>
			                <td><label for="buscarPpante">Director:</label></td>
			                <td><input type="text" id="buscarPpante" name="buscarPpante" size="8" /></td>
			                <td><label for="buscarPtje">Porcentaje:</label></td>
			                <td><input type="text" id="buscarPtje" name="buscarPtje" size="8" /></td>
                        </tr>
	                </table>

                    <table id="tablaLista">
                        <thead>
                        <tr> <th>Fecha inicial</th><th>Fecha final</th><th>Compañia</th><th>Canal</th><th>Director</th><th>Porcentaje</th><th>Opciones</th>
                        </tr>
                        </thead>
                        <tbody>
                    <% foreach (var item in Model) { %>
                        <tr>
                            <td><%: String.Format("{0:d}", item.fechaIni) %></td>
                            <td><%: String.Format("{0:d}", item.fechaFin) %></td>
                            <td><%: Html.DisplayFor(modelItem => item.Compania.nombre) %></td><% var canal = item.canal_id == 0 ? "Todos" : item.Canal.nombre; %>
                            <td><%: Html.DisplayFor(modelItem => canal) %></td>
                            <td><%: Html.DisplayFor(modelItem => item.JerarquiaDetalle.nombre)%></td>
                            <td><%: Html.DisplayFor(modelItem => item.porcentaje) %></td>
                            <td>
                                <a href="javascript:mostrarEditar('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar participacion', 'dialogo');" title='Editar participación' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-pencil'/></a>
                                <a href="javascript:mostrarEliminar('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar participacion', 'dialogo');" title='Eliminar participación' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>
                            </td>
                        </tr>
                    <% } %>
                        </tbody>
                    </table>
                </fieldset>
            </td>

        </tr>
    </table>

    <div id='dialogPart' style="display:none;"></div>
    <div id='dialogo' style="display:none;"></div>
</asp:Content>
