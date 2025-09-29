<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Escalas de Notas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Escalas de Notas</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarNota').keyup(function () { oTable.fnDraw(); });
            $('#buscarPorcentaje').keyup(function () { oTable.fnDraw(); });
            $('#buscarTipo').keyup(function () { oTable.fnDraw(); });
            $('#buscarInferior').keyup(function () { oTable.fnDraw(); });
            $('#buscarSuperior').keyup(function () { oTable.fnDraw(); });
            $('#buscarFecha1').keyup(function () { oTable.fnDraw(); });
            $('#buscarFecha2').keyup(function () { oTable.fnDraw(); });
        });
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarNota").attr("value", "");
            $("#buscarPorcentaje").attr("value", "");
            $("#buscarTipo").attr("value", "");
            $("#buscarInferior").attr("value", "");
            $("#buscarSuperior").attr("value", "");
            $("#buscarFecha1").attr("value", "");
            $("#buscarFecha2").attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNota = document.getElementById('buscarNota').value;
	            var bPorcentaje = document.getElementById('buscarPorcentaje').value;
	            var bTipo = document.getElementById('buscarTipo').value;
	            var bInferior = document.getElementById('buscarInferior').value;;
	            var bSuperior = document.getElementById('buscarSuperior').value;
	            var bFecha1 = document.getElementById('buscarFecha1').value;
	            var bFecha2 = document.getElementById('buscarFecha2').value;

	            var Nota = aData[2];
	            var Porcentaje = aData[3];
	            var Tipo = aData[4];
	            var Inferior = aData[5];
	            var Superior = aData[6];
	            var Fecha1 = aData[7];
	            var Fecha2 = aData[8];

	            var comparaNota = Nota.toUpperCase().indexOf(bNota.toUpperCase());
	            var comparaPorcentaje = Porcentaje.toUpperCase().indexOf(bPorcentaje.toUpperCase());
	            var comparaTipo = Tipo.toUpperCase().indexOf(bTipo.toUpperCase());
	            var comparaInferior = Inferior.toUpperCase().indexOf(bInferior.toUpperCase());
	            var comparaSuperior = Superior.toUpperCase().indexOf(bSuperior.toUpperCase());
	            var comparaFecha1 = Fecha1.toUpperCase().indexOf(bFecha1.toUpperCase());
	            var comparaFecha2 = Fecha2.toUpperCase().indexOf(bFecha2.toUpperCase());

	            if ((comparaNota >= 0) && (comparaPorcentaje >= 0) && (comparaTipo >= 0) && (comparaInferior >= 0) && 
                        (comparaSuperior >= 0) && (comparaFecha1 >= 0) && (comparaFecha2 >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
    </script>

     <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formEscalaNota").validate({
                        rules: {
                            salario: "required"
                        },
                        submitHandler: function (form) {
                            $("#crear").attr('disabled', true);
                            form.submit();
                        }
                    });               

                });
            </script>

  
    <script  type="text/javascript">
        $(function () {
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
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });

       
	</script>
    
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Definir una escala</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "EscalaNota", FormMethod.Post, new { id = "formEscalaNota" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.EscalaNotaViewModel escalaNota =
                           (ColpatriaSAI.UI.MVC.Models.EscalaNotaViewModel)ViewData["EscalaNotaViewModel"]; %>
                    <p>
                        <%: Html.Label("Nota")%>
                        <%: Html.TextBox("nota", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.nota)%>
                    </p>
                    <p>
                        <%: Html.Label("Porcentaje")%>
                        <%: Html.TextBox("porcentaje", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.porcentaje)%>
                    </p>
                    <p>
                        <%: Html.Label("Tipo de escala")%>
                        <%: Html.DropDownList("tipoEscala_id", (SelectList)escalaNota.TipoEscalaList, "Seleccione un Valor", new { @class = "required" })%>
                    </p>
                    <p>
                        <%: Html.Label("Limite inferior")%>
                        <%: Html.TextBox("limiteInferior", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.limiteInferior)%>
                    </p>
                    <p>
                        <%: Html.Label("Limite superior")%>
                        <%: Html.TextBox("limiteSuperior", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.limiteSuperior)%>
                    </p>
                    <p>
                        <%: Html.Label("Fecha inicial")%>
                        <%: Html.TextBox("fechaIni", null, new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.fechaIni)%>
                    </p>
                    <p>
                        <%: Html.Label("Fecha final")%>
                        <%: Html.TextBox("fechaFin", null, new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => escalaNota.EscalaNotaView.fechaFin)%>
                    </p>
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>
            
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		            <tr>
			            <td><label for="buscarNota">Nota:</label></td>
			            <td><input type="text" id="buscarNota" name="buscarNota" size="10" /></td>
			            <td><label for="buscarPorcentaje">Porcentaje:</label></td>
			            <td><input type="text" id="buscarPorcentaje" name="buscarPorcentaje" size="8" /></td>
			            <td><label for="buscarTipo">Tipo de escala:</label></td>
			            <td><input type="text" id="buscarTipo" name="buscarTipo" size="10" /></td>
		            </tr>
                    <tr>
			            <td><label for="buscarInferior">Límite inferior:</label></td>
			            <td><input type="text" id="buscarInferior" name="buscarInferior" size="8" /></td>
			            <td><label for="buscarSuperior">Límite superior:</label></td>
			            <td><input type="text" id="buscarSuperior" name="buscarSuperior" size="8" /></td>
			            <td><label for="buscarFecha1">Fecha inicial:</label></td>
			            <td><input type="text" id="buscarFecha1" name="buscarFecha1" size="8" /></td>
			            <td><label for="buscarFecha2">Fecha final:</label></td>
			            <td><input type="text" id="buscarFecha2" name="buscarFecha2" size="8" /></td>
                    </tr>
	            </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Nota</th>
                        <th>Porcentaje</th>
                        <th>Tipo de escala</th>
                        <th>Límite inferior</th>
                        <th>Límite superior</th>
                        <th>Fecha inicial</th>
                        <th>Fecha final</th>
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
                 <% Random random = new Random();
                    int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<EscalaNota>)ViewData["Escalas"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar escala de nota', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar escala de nota', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td align="center"><%: item.nota %></td>
                        <td align="center"><%: item.porcentaje %></td>
                        <td><%: item.TipoEscala.nombre %></td>
                        <td align="center"><%: item.limiteInferior %></td>
                        <td align="center"><%: item.limiteSuperior %></td>
                        <td><%: item.fechaIni %></td>
                        <td><%: item.fechaFin %></td>
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>