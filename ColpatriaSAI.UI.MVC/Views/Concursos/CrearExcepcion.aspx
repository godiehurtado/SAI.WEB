<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.ExcepcionesGenerale>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    CrearExcepcion - Sistema de Administración de Incentivos
</asp:Content>
 
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $().ready(function () {
        $("#factor").attr('disabled', 'disabled');
        $("#FrmExcepciones").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
         
    });
    $(function () {
        var dates = $("#FechaInicio, #FechaFin").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            numberOfMonths: 3,
            dateFormat: "dd/mm/yy",
            showButtonPanel: true,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selectedDate) {
                var option = this.id == "FechaInicio" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                dates.not(this).datepicker("option", option, date);
            }
        });
    });

    $(function () {
        $("#ddlcompani").change(function () {

            var ramo = $("#ddlramo");
            ramo.attr('disabled', '');

            $.getJSON('/concursos/ListarCompaniaRamo', { idcompani: $("#ddlcompani").val() }, function (data) {
                if (data != 0) {

                    ramo.show();
                    ramo.find('option').remove();
                    ramo.attr('disabled', '');
                    ramo.addClass('required');
                    ramo.css('title', 'seleccion un ramo');

                    $("<option value='0' selected> Seleccione </option>").appendTo(ramo);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramo);
                    });
                } else {
                    ramo.attr('disabled', 'disabled');
                    ramo.atrr('required', '');
                    ramo.find('option').remove();
                }

            });
        });

    });

    $(function () {
        $("#ddltipo").change(function () {

            var id = $(this).val();
            var factor = $("#factor");
           if (id == 2) {
                factor.removeAttr('disabled');
            } else {
                factor.attr('disabled', 'disabled');
            }
        });
    
    });
  
    function saveExcepcion() {

        if ($("#FrmExcepciones").valid()) {
            var stUrl = '/Concursos/saveExepcion';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnGuardar").attr('disabled', true);
            var dataForm = $("#FrmExcepciones").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success && response.result != 0) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = "/concursos/Excepciones";
                    } else {
                        closeNotify('jNotify'); mostrarExito("Esta Excepcion ya existe. Espere Por Favor...");
                        window.location.href = "/concursos/CrearExcepcion"
                     }
                }
            });
        }
    }
           
    </script>
   
    <h2>
        Crear
        Excepciones</h2>

         <div>
        <%: Html.ActionLink("Regresar", "Excepciones") %>
    </div>
    <p>
    </p>

    <% using (Html.BeginForm("Excepciones", "ConcursoController", FormMethod.Post, new { id = "FrmExcepciones" }))
       { %>
    <%: Html.ValidationSummary(true)%>
    
    <fieldset>
        <legend>Crear Excepciones</legend>
        <table>
         <tr>
                <td>
                    Compañia:
                </td>
                <td>
                    <%: Html.DropDownList("ddlcompany",(SelectList) ViewData["LstCompany"],"Seleccione",
                               new { id = "ddlcompani", Title = "Seleccione la Compañia", @style = "width:209px;" })%>
                </td>
            </tr>
            <tr id="trramo" >
                <td>
                    Ramo:
                </td>
                <td>
                    <select id="ddlramo" name="ddlramo"   title="Seleccione un ramo" style="width:209px;" ></select>
                </td>
            </tr>
            <tr>
                <td>
                    Tipo Medida:
                </td>
                <td>
                    <%: Html.DropDownList("ddlTipoMedida", (SelectList)ViewData["LstTipoMoneda"], "Seleccione",
                                                     new { id = "ddltipo", @style = "width:209px;", @class = "required", title = "Seleccione  el Tipo de Medida" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Año:
                </td>
                <td>
                   <select id="ano" name="ano" required="required" title="Seleccione un año" style="width:210px;">
                    <option value="">Seleccione</option>
                   <option value="2012">2012</option>
                   <option value="2013">2013</option>
                   <option value="2014">2014</option>
                   </select>
                </td>
            </tr>
            <tr>
                <td>
                    Factor:
                </td>
                <td>
                    <input type="text" id="factor" name="factor" title="Factor Requerido" disabled="disabled" style="width:205px;" />
                </td>
            </tr>
            <tr>
                <td>
                    Clave:
                </td>
                <td>
                    <%: Html.TextBox("clave","",new { @class="required", @size="30",title="La Clave es requerida"}) %>
                </td>
            </tr>
            <tr>
                <td>
                    Número De Negocio:
                </td>
                <td>
                    <%: Html.TextBox("numeroDeNegocio","",new {  @size="30"}) %>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Inicio:
                </td>
                <td>
                    <%= Html.TextBox("FechaInicio", null, new { @readonly = "true", @class = "required", Title = "La Fecha De Inicio es Requerida", @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Fin:
                </td>
                <td>
                    <%= Html.TextBox("FechaFin", null, new { @readonly = "true", @class = "required", Title = "La Fecha Fin es Requerida", @size = "30" })%>
                </td>
            </tr>
        </table>
        <p>
            <input type="button" value="Guardar" id="btnGuardar" onclick="saveExcepcion();" name="btnGuardar" />
        </p>
    </fieldset>
    <% } %>

</asp:Content>
