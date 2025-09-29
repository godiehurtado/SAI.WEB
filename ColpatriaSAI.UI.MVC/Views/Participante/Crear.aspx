<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ParticipanteViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Crear Participante
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, width: 300, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 300, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialogParticipantes(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 620, width: 550, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close");
                    }
                },
                title: titulo,

                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function cerrarDialog(dialog) {
            $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
        }
    </script>
    <script type="text/javascript">
        $().ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });

            $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            $("#formParticipante").validate({
                rules: {
                    nombre: "required"
                }
            });
            $('#fechaIngreso').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });
            $('#fechaRetiro').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });
            $('#fechaNacimiento').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });

            var zonas = $("#zona_id");
            var localidades = $("#localidad_id");
            zonas.change(function () {
                localidades.find('option').remove();
                $.getJSON('/Participante/getLocalidades', { zona_id: zonas.val() }, function (data) {
                    $("<option value='0' selected>Todos</option>").appendTo(localidades);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
                    });
                });
            });
//            var segmentos = $("#segmento_id");
//            var canales = $("#canal_id");
//            segmentos.change(function () {
//                canales.find('option').remove();
//                $.getJSON('/Participante/getCanales', { segmento_id: segmentos.val() }, function (data) {
//                    $("<option value='0' selected>Seleccione un Valor</option>").appendTo(canales);
//                    $(data).each(function () {
//                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(canales);
//                    });
//                });
//            });
        });

        function saveParticipante() {

            if ($("#formParticipante").valid()) {


                var validado = true;
                var porcentajeSalario = $("#porcentaje_salario").val();
                var porcentajeParticipacion = $("#porcentaje_participacion").val();

                //DETERMINAMOS QUE LOS PORCENTAJES SUMEN 100 SI SON DIFERENTES DE 0
                if (porcentajeSalario != "" || porcentajeParticipacion != "") {

                    if (porcentajeSalario == "")
                        porcentajeSalario = 0;

                    if (porcentajeParticipacion == "")
                        porcentajeParticipacion = 0;

                    var totalPorcentaje = parseInt(porcentajeParticipacion) + parseInt(porcentajeSalario);

                    if (totalPorcentaje != 100 && totalPorcentaje != 0) {
                        alert("Los porcentajes de salario y participacion deben sumar el 100%. Verifique.");
                        validado = false;
                    }
                }

                if (validado)
                    $("#formParticipante").submit();

            }

        }

    </script>

    <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
    <% Random random = new Random(); int num = random.Next(1, 10000);  %>

    <div id="encabezadoSeccion">
		<div id="infoSeccion" style="text-align:left">
			<h2>Crear Participante</h2>
		</div>
		<div id="progresoSeccion" style="text-align:right;">
            <a href="../Participante" id="bAnterior" title='Regresar a la Lista'>Regresar</a>
		</div>
		<div style="clear:both;"></div>
	</div>

    <% if (TempData["Mensaje"] != null) { %>
    <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
   
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
            <% Html.EnableClientValidation(); %>        
            <% using (Html.BeginForm("Crear", "Participante", FormMethod.Post, new { id = "formParticipante" })) { %>
            <%: Html.ValidationSummary(true) %>
                <fieldset>

                    <table width="100%" cellpadding="2">
                        <tr>
                            <td><u><%: Html.Label("Nombre")%></u></td>
                            <td><%: Html.TextBox("nombre", null, new { @class = "required" })%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.nombre)%></td>

                            <td><u><%: Html.Label("Apellidos")%></u></td>
                            <td><%: Html.TextBox("apellidos", null, new { @class = "required" })%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.apellidos)%></td>
                        </tr>
                        <tr>
                            <td><u><%: Html.Label("Tipo de Documento")%></u></td>
                            <td><%: Html.DropDownList("tipoDocumento_id", (SelectList)Model.TipoDocumentoList, "Seleccione un Valor", new { @class = "required", style = "width:280px;" })%></td> 

                            <td><u><%: Html.Label("Documento")%></u></td>
                            <td><%: Html.TextBox("documento", null, new { @class = "required" })%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.documento)%></td>
                        </tr>
                        <tr>
                            <td><u><%: Html.Label("Estado")%></u></td>
                            <td><%: Html.DropDownList("estadoParticipante_id", (SelectList)Model.EstadoParticipanteList, "Seleccione un Valor", new { @class = "required", style = "width:280px;" })%></td> 

                            <td><label for="FechaIngreso">Fecha Ingreso:</label></td>
                            <td><%= Html.TextBox("fechaIngreso", null, new { @readonly = "true" })%></td>
                        </tr>
                        <tr>                
                            <td><label for="FechaRetiro">Fecha Retiro:</label></td>
                            <td><%= Html.TextBox("fechaRetiro", null, new { @readonly = "true" })%></td>

                            <td><label for="FechaNacimiento">Fecha Nacimiento:</label></td>
                            <td><%= Html.TextBox("fechaNacimiento", null, new { @readonly = "true" })%></td>
                        </tr>
                        <tr>                          
                            <td><u><%: Html.Label("Compañía de nómina")%></u></td>
                            <td><%: Html.DropDownList("compania_id", (SelectList)Model.CompaniaList, "Seleccione un Valor", new { style = "width:280px;", @class = "required" })%></td>

                            <td><%: Html.Label("Nivel principal")%></td>
                            <td><%: Html.DropDownList("nivel_id", (SelectList)Model.NivelList, "Todas", new { style = "width:280px;" })%></td>                       
                        </tr>
                        <tr>
                            <td><%: Html.Label("Zona")%></td>
                            <td><%: Html.DropDownList("zona_id", (SelectList)Model.ZonaList, "Todas", new { style = "width:280px;" })%></td>     

                            <td><%: Html.Label("Localidad")%></td>
                            <td><%: Html.DropDownList("localidad_id", new List<SelectListItem>(), "Todas", new { style = "width:280px;" })%></td>
                        </tr>
                        <tr>
                            <td><%: Html.Label("Categoría")%></td>
                            <td><%: Html.DropDownList("categoria_id", (SelectList)Model.CategoriaList, "Ninguna", new { style = "width:280px;" })%></td>

                            <td><u><%: Html.Label("Segmento")%></u></td>
                            <td><%: Html.DropDownList("segmento_id", (SelectList)Model.SegmentoList, "Seleccione un Valor", new { style = "width:280px;", @class = "required" })%></td>
                        </tr>                   
                        <tr>
                            <td><u><%: Html.Label("Canal")%></u></td>
                            <td><%: Html.DropDownList("canal_id", (SelectList)Model.CanalList, "Seleccione un Valor", new { style = "width:280px;", @class = "required" })%></td>

                            <td><%: Html.Label("Email")%></td>
                            <td><%: Html.TextBox("email", null)%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.email)%></td>
                        </tr>
                        <tr>
                            <td><%: Html.Label("Salario")%></td>
                            <td>$<%: Html.TextBox("salario", null)%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.salario)%></td>

                            <td><%: Html.Label("Telefono")%></td>
                            <td><%: Html.TextBox("telefono", null)%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.telefono)%></td>
                        </tr>
                        <tr>
                            <td><%: Html.Label("Dirección")%></td>
                            <td><%: Html.TextBox("direccion", null)%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.direccion)%></td>
                            <td><%: Html.Label("Porcentaje Participación")%></td>
                            <td><%: Html.TextBox("porcentaje_participacion", null, new { @class = "number" })%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.porcentajeParticipacion)%>
                            </td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                            <td><%: Html.Label("Porcentaje Salario")%></td>
                            <td><%: Html.TextBox("porcentaje_salario", null, new { @class = "number" })%>
                                <%: Html.ValidationMessageFor(model => model.ParticipanteView.porcentajeSalario)%>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" align="center">
                                <input type="button" value="Guardar" id = "crear" onclick="saveParticipante();"/>
                            </td>
                        </tr>
                    </table>

                </fieldset>
                <% } %>
            </td>
        </tr>
    </table>

</asp:Content>
