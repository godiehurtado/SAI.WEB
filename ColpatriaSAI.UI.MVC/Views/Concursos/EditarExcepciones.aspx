<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.ExcepcionesGenerale>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Editar Excepciones - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
 
<script type="text/javascript">
    $().ready(function () {
    
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
            numberOfMonths: 1,
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

    function ActualizarExcepcion() {
        if ($("#FrmExcepciones").valid()) {
            var stUrl = '/Concursos/ActualizarExcepcion';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnGuardar").attr('disabled', true);
            var dataForm = $("#FrmExcepciones").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success && response.result==1) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = "/concursos/Excepciones";
                    }
                }
            });
        }
     };
    </script>
<h2>
        Editar
        Excepciones</h2>
        <p></p>
         <div>
        <%: Html.ActionLink("Regresar", "Excepciones") %>
    </div>
     <p></p>
        

    <% using (Html.BeginForm("EditarExcepciones", "ConcursoController", FormMethod.Post, new { id = "FrmExcepciones" }))
       { %>
    <%: Html.ValidationSummary(true)%>
    <input type="hidden" id="id" name="id" value='<%= this.Model.id %>' />
    <fieldset>
        <legend>Editar Excepciones</legend>

        <table>
         <tr>
                <td>
                    Compañia:
                </td>
                <td>
                 <%: Html.TextBox("compania", Model.Compania.nombre, new { @readonly = "true", @class = "required",@size="30"})%>
                    </td>
            </tr>
            <tr id="trramo" >
                <td>
                    Ramo:
                </td>
                <td>
                     <%: Html.TextBox("ramo", Model.Ramo.nombre, new { @readonly = "true",  @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Tipo Medida:
                </td>
                <td>
                    <%: Html.TextBox("medida", Model.TipoMedida.nombre, new { @readonly = "true", @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Año:
                </td>
                <td>
                   <select id="ano" name="ano" required="required"   title="Seleccione un año" style="width:210px;">
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
                     <%: Html.TextBox("factor", Model.factor, new { @readonly = "true", @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Clave:
                </td>
                <td>
                   <%: Html.TextBox("clave", Model.clave, new { @size = "30", @readonly = "true"})%>
                </td>
            </tr>
            <tr>
                <td>
                    Número De Negocio:
                </td>
                <td>
               <%: Html.TextBox("negocio", Model.numeroNegocio, new { id = "negocio", @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Inicio:
                </td>
                <td>
                    <%: Html.TextBox("FechaInicio",string.Format("{0:d}",  Model.fechaInicio), new { @readonly = "true", @class = "required", Title = "La Fecha De Inicio es Requerida", @size = "30" })%>
                </td>
            </tr>
            <tr>
                <td>
                    Fecha Fin:
                </td>
                <td>
                    <%: Html.TextBox("FechaFin", string.Format("{0:d}", Model.fechaFin), new { @readonly = "true", @class = "required", Title = "La Fecha Fin es Requerida", @size = "30" })%>
                </td>
            </tr>
        </table>
        <p>
            <input type="button" value="Guardar" id="btnGuardar" onclick="ActualizarExcepcion();" name="btnGuardar" />
        </p>
    </fieldset>
    <% } %>

</asp:Content>
