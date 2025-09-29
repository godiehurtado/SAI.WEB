<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Participacione>>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Participaciones por producto - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarEditar(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 300, width: 450, modal: true, title: titulo,
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

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers","bStateSave": true });

            var dates = $("#fechaIni, #fechaFin").datepicker({
                defaultDate: "+1w", numberOfMonths: 3, dateFormat: "yy-mm-dd",
                showButtonPanel: true, changeMonth: true, changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);                    dates.not(this).datepicker("option", option, date);
                }
            });

            $("#formParticipacion").validate(/*{
                rules: {
                    fechaIni: "required",
                    fechaFin: "required",
                    compania_id: "required",
                    lineaNegocio_id: "required",
                    ramo_id: "required",
                    mesesAntiguedad: "required",
                    porcentaje: "required"
                }
            }*/);
            $('#buscarFecha1').keyup(function () { oTable.fnDraw(); });
            $('#buscarFecha2').keyup(function () { oTable.fnDraw(); });
            $('#buscarCompañia').keyup(function () { oTable.fnDraw(); });
            $('#buscarLinea').keyup(function () { oTable.fnDraw(); });
            $('#buscarRamo').keyup(function () { oTable.fnDraw(); });
            $('#buscarMeses').keyup(function () { oTable.fnDraw(); });
            $('#buscarPtje').keyup(function () { oTable.fnDraw(); });

            var compania = $('#compania_id');
            compania.change(function () {
                $('#ramo_id').find('option').remove();
                $.ajax({
                    url: '/Participacion/getRamos', data: { idCompa: compania.val() },
                    success: function (data) {
                        $("<option value='0' selected>Seleccione..</option>").appendTo($('#ramo_id'));
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#ramo_id'));
                        });
                    }
                });
            });
        });
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $('#buscarFecha1').attr("value", "");
            $('#buscarFecha2').attr("value", "");
            $('#buscarCompañia').attr("value", "");
            $('#buscarLinea').attr("value", "");
            $('#buscarRamo').attr("value", "");
            $('#buscarMeses').attr("value", "");
            $('#buscarPtje').attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bFecha1 = document.getElementById('buscarFecha1').value;
	            var bFecha2 = document.getElementById('buscarFecha2').value;
	            var bCompania = document.getElementById('buscarCompañia').value;
	            var bLinea = document.getElementById('buscarLinea').value;
	            var bRamo = document.getElementById('buscarRamo').value;
	            var bMeses = document.getElementById('buscarMeses').value;
	            var bPtje = document.getElementById('buscarPtje').value;

	            var Fecha1 = aData[0];
	            var Fecha2 = aData[1];
	            var Compania = aData[2];
	            var Linea = aData[3];
	            var Ramo = aData[4];
	            var Meses = aData[5];
	            var Ptje = aData[6];

	            var comparaFecha1 = Fecha1.toUpperCase().indexOf(bFecha1.toUpperCase());
	            var comparaFecha2 = Fecha2.toUpperCase().indexOf(bFecha2.toUpperCase());
	            var comparaCompania = Compania.toUpperCase().indexOf(bCompania.toUpperCase());
	            var comparaLinea = Linea.toUpperCase().indexOf(bLinea.toUpperCase());
	            var comparaRamo = Ramo.toUpperCase().indexOf(bRamo.toUpperCase());
	            var comparaMeses = Meses.toUpperCase().indexOf(bMeses.toUpperCase());
	            var comparaPtje = Ptje.toUpperCase().indexOf(bPtje.toUpperCase());

	            if ((comparaFecha1 >= 0) && (comparaFecha2 >= 0) && (comparaCompania >= 0) && (comparaLinea >= 0) &&
                        (comparaRamo >= 0) && (comparaMeses >= 0) && (comparaPtje >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
    </script>

    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    <% Participacione part = (Participacione)ViewData["Participacion"];
       string ruta = Request.Url.ToString(); if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; }
       Random random = new Random(); int num = random.Next(1, 10000);  %>

    <h2>Participación por producto</h2>
    <!--<div style="position:absolute; top: 135px; left: 700px; right: 499px;"><a href="/Contratacion/Parametrizacion">Regresar</a></div>-->
    <%=Html.ActionLink("Regresar","Index","Contratacion/Parametrizacion") %>
    
    <fieldset>
        <table width="100%">
        
        <% using (Html.BeginForm("Crear", "Participacion", FormMethod.Post, new { id = "formParticipacion" })) { %>
            <%: Html.ValidationSummary(true) %>
            <tr>
                <td>Fecha inicial:<br />
                    <%: Html.TextBox("fechaIni", null, new { @readonly = "true", @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().fechaIni)%>
                </td>
                <td>Fecha final:<br />
                    <%: Html.TextBox("fechaFin", null, new { @readonly = "true", @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().fechaFin)%>
                </td>
                <td>Compañía:<br />
                    <%: Html.DropDownList("compania_id", (SelectList)ViewBag.compania_id, "Seleccione...", new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().compania_id)%>
                </td>
                <td>Linea de negocio:<br />
                    <%: Html.DropDownList("lineaNegocio_id", (SelectList)ViewBag.lineaNegocio_id)%>
                    <%: Html.ValidationMessageFor(model => Model.First().lineaNegocio_id)%>
                </td>
            </tr>
            <tr>
                <td>Ramo:<br />
                    <%: Html.DropDownList("ramo_id", new List<SelectListItem>(), new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().ramo_id)%>
                </td>
                <td>Meses de antiguedad:<br />
                    <%: Html.TextBox("mesesAntiguedad", null, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().mesesAntiguedad)%>
                </td>
                <td>Porcentaje:<br />
                    <%: Html.TextBox("porcentaje", null, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(model => Model.First().porcentaje)%>
                </td>
                <td valign="bottom"><input type="submit" value="Crear participacion" id="btnCrear" /></td>
            </tr>
        <% } %>
            <tr>
                <td colspan="4">
                    <br />
                    <fieldset><legend><b>Lista de participaciones</b></legend>
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
			                    <td><label for="buscarLinea">Linea de negocio:</label></td>
			                    <td><input type="text" id="buscarLinea" name="buscarLinea" size="8" /></td>
			                    <td><label for="buscarRamo">Ramo:</label></td>
			                    <td><input type="text" id="buscarRamo" name="buscarRamo" size="8" /></td>
			                    <td><label for="buscarMeses">Meses antig:</label></td>
			                    <td><input type="text" id="buscarMeses" name="buscarMeses" size="8" /></td>
			                    <td><label for="buscarPtje">Porcentaje:</label></td>
			                    <td><input type="text" id="buscarPtje" name="buscarPtje" size="8" /></td>
                            </tr>
	                    </table>

                        <table id="tablaLista">
                            <thead>
                            <tr> <th>Fecha inicial</th><th>Fecha final</th><th>Compañia</th><th>Linea de negocio</th>
                                 <th>Ramo</th><th>Meses Antig</th><th>Porcentaje</th><th>Opciones</th>
                            </tr>
                            </thead>
                            <tbody>
                        <% foreach (var item in Model) { %>
                            <tr>
                                <td><%: String.Format("{0:d}", item.fechaIni) %></td>
                                <td><%: String.Format("{0:d}", item.fechaFin) %></td>
                                <td><%: Html.DisplayFor(modelItem => item.Compania.nombre) %></td>
                                <% var linea = item.LineaNegocio.id == 0 ? "Todos" : item.LineaNegocio.nombre; %>
                                <td><%: Html.DisplayFor(modelItem => linea)%></td>
                                <td><%: Html.DisplayFor(modelItem => item.Ramo.nombre) %></td>
                                <td><%: Html.DisplayFor(modelItem => item.mesesAntiguedad) %></td>
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
        </fieldset>
    <div id='dialogo' style="display:none;"></div>

</asp:Content>
