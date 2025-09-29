<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $().ready(function () {
        $("#formParticipanteEditar").validate();
        $('#fechaIngresoEdit').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });
        $('#fechaRetiroEdit').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });
        $('#fechaNacimientoEdit').datepicker({ dateFormat: 'yy-mm-dd', changeMonth: true, changeYear: true });

        var zonas = $("#zona_id");
        var localidades = $("#localidad_id");

        var localidad = localidades.val();
        localidades.find('option').remove();
        $.getJSON('/Participante/getLocalidades', { zona_id: zonas.val() }, function (data) {
            $("<option value='0' selected>Todos</option>").appendTo(localidades);
            $(data).each(function () {
                $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
            });
            $('#localidad_id option').each(function () {
                if ($(this).val() == localidad) $(this).attr('selected', 'selected');
            });
        });

        zonas.change(function () {
            var localidad = $("#localidad_id").val();
            $("#localidad_id").find('option').remove();
            $.getJSON('/Participante/getLocalidades', { zona_id: zonas.val() }, function (data) {
                $("<option value='0' selected>Todos</option>").appendTo($("#localidad_id"));
                $(data).each(function () {
                    $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($("#localidad_id"));
                });
                $('#localidad_id option').each(function () {
                    if ($(this).val() == localidad) $(this).attr('selected', 'selected');
                });
            });
        });
    });

    function saveParticipante() {

        if ($("#formParticipanteEditar").valid()) {

            
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
                $("#formParticipanteEditar").submit(); 

        }
        
    }
</script>

<% if (TempData["Mensaje"] != null) { %>
    <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
<% } %>

<% Html.EnableClientValidation(); %>
<% using (Html.BeginForm("Editar", "Participante", FormMethod.Post, new { id = "formParticipanteEditar" })) {
    Html.ValidationSummary(true);
    ColpatriaSAI.UI.MVC.Models.ParticipanteViewModel participante = (ColpatriaSAI.UI.MVC.Models.ParticipanteViewModel)ViewData["ParticipanteViewModel"]; %>
    <fieldset>
        <table width="100%">
            <tr>
                <td><u><%: Html.Label("Nombre")%></u></td>
                <td><%: Html.TextBox("nombre", participante.ParticipanteView.nombre, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.nombre)%></td>

                <td><u><%: Html.Label("Apellidos")%></u></td>
                <td><%: Html.TextBox("apellidos", participante.ParticipanteView.apellidos, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.apellidos)%></td>
            </tr>
            <tr>
                <td><u><%: Html.Label("Tipo de Documento")%></u></td>
                <td><%: Html.DropDownList("tipoDocumento_id", (SelectList)participante.TipoDocumentoList, "Seleccione un Valor", new { @class = "required", style = "width:250px" })%></td>

                <td><u><%: Html.Label("Documento")%></u></td>
                <td><%: Html.TextBox("documento", participante.ParticipanteView.documento, new { @class = "required" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.documento)%></td>
            </tr>
            <tr>
                <td><u><%: Html.Label("Estado")%></u></td>
                <td><%: Html.DropDownList("estadoParticipante_id", (SelectList)participante.EstadoParticipanteList, "Seleccione un Valor", new { @class = "required", style = "width:250px" })%></td>

                <td><label for="FechaIngreso">Fecha Ingreso:</label></td> <% Nullable<DateTime> fechaIngreso = participante.ParticipanteView.fechaIngreso; %>
                <td><%: Html.TextBox("fechaIngreso", fechaIngreso != null ? fechaIngreso.Value.ToShortDateString() : "",
                        new { @readonly = "true", id = "fechaIngresoEdit" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.fechaIngreso)%></td>
            </tr>
            <tr>                
                <td><label for="FechaRetiro">Fecha Retiro:</label></td> <% Nullable<DateTime> fechaRetiro = participante.ParticipanteView.fechaRetiro; %>
                <td><%: Html.TextBox("fechaRetiro", fechaRetiro != null ? fechaRetiro.Value.ToShortDateString() : "", new { @readonly = "true", id = "fechaRetiroEdit" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.fechaRetiro)%></td>

                <td><label for="FechaNacimiento">Fecha Nacimiento:</label></td> <% Nullable<DateTime> fechaNac = participante.ParticipanteView.fechaNacimiento; %>
                <td><%: Html.TextBox("fechaNacimiento", fechaNac != null ? fechaNac.Value.ToShortDateString() : "", new { @readonly = "true", id = "fechaNacimientoEdit" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.fechaNacimiento)%></td>
            </tr>
            <tr>                          
                <td><u><%: Html.Label("Compañia")%></u></td>
                <td><%: Html.DropDownList("compania_id", (SelectList)participante.CompaniaList, "Seleccione un Valor", new { @class = "required", style = "width:250px" })%></td>

                <td><%: Html.Label("Nivel")%></td>
                <td><%: Html.DropDownList("nivel_id", (SelectList)participante.NivelList, "Todas", new { style = "width:250px" })%></td>
            </tr>
            <tr>
                <td><%: Html.Label("Zona")%></td>
                <td><%: Html.DropDownList("zona_id", (SelectList)participante.ZonaList, "Todas", new { style = "width:250px" })%></td>

                <td><%: Html.Label("Localidad")%></td>
                <td><%: Html.DropDownList("localidad_id", (SelectList)participante.LocalidadList, "Todas", new { style = "width:250px" })%></td>
            </tr>
            <tr>
                <td><%: Html.Label("Categoría")%></td>
                <td><%: Html.DropDownList("categoria_id", (SelectList)participante.CategoriaList, "Ninguna", new { style = "width:250px" })%></td>
                               
                <td><u><%: Html.Label("Segmento")%></u></td>
                <td><%: Html.DropDownList("segmento_id", (SelectList)participante.SegmentoList, "Seleccione un Valor", new { @class = "required", style = "width:250px" } )%></td>
            </tr>                   
            <tr>
                <td><u><%: Html.Label("Canal")%></u></td>
                <td><%: Html.DropDownList("canal_id", (SelectList)participante.CanalList, "Seleccione un Valor", new { @class = "required", style = "width:250px" })%></td>
                
                <td><%: Html.Label("Email")%></td>
                <td><%: Html.TextBox("email", participante.ParticipanteView.email)%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.email)%></td>
            </tr>
            <tr>
                <td><%: Html.Label("Salario")%></td>
                <td>$<%: Html.TextBox("salario", participante.ParticipanteView.salario, new { style = "width:230px" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.salario)%></td>
                    
                <td><%: Html.Label("Telefono")%></td>
                <td><%: Html.TextBox("telefono", participante.ParticipanteView.telefono)%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.telefono)%></td>
            </tr>
            <tr>
                <td><%: Html.Label("Dirección")%></td>
                <td><%: Html.TextBox("direccion", participante.ParticipanteView.direccion)%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.direccion)%></td>
                <td><%: Html.Label("Porcentaje Participación")%></td>
                <td><%: Html.TextBox("porcentaje_participacion", participante.ParticipanteView.porcentajeParticipacion, new { @class = "number" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.porcentajeParticipacion)%>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td><%: Html.Label("Porcentaje Salario")%></td>
                <td><%: Html.TextBox("porcentaje_salario", participante.ParticipanteView.porcentajeSalario, new { @class = "number" })%>
                    <%: Html.ValidationMessageFor(Model => participante.ParticipanteView.porcentajeSalario)%>
                </td>
            </tr>
        </table>
    </fieldset>
    <%:Html.Hidden("id", (int)ViewBag.participante_id)%>
    <p align="center">
    <input type="button" value="Actualizar" onclick="saveParticipante();" />
<% } %>