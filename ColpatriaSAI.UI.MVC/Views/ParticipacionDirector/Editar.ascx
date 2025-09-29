<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.Negocio.Entidades.ParticipacionDirector>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#ParticipacionEditar").validate({
            rules: {
                fechaIni: "required",
                fechaFin: "required",
                compania_id: "required",
                participanteEdit: "required",
                porcentaje: "required"
            }
        });
        var dates = $("#fechaIni1, #fechaFin1").datepicker({
            defaultDate: "+1w",
            changeMonth: true,
            numberOfMonths: 3,
            dateFormat: "yy-mm-dd",
            showButtonPanel: true,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selectedDate) {
                var option = this.id == "fechaIni1" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                dates.not(this).datepicker("option", option, date);
            }
        });
    });
</script>

<% ColpatriaSAI.UI.MVC.Models.PpacionDirectorViewModel part = (ColpatriaSAI.UI.MVC.Models.PpacionDirectorViewModel)ViewData["PpanteDirector"];
    string ruta = Request.Url.ToString(); if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; }
    Random random = new Random(); int num = random.Next(1, 10000);  %>

<% using (Html.BeginForm("Editar", "ParticipacionDirector", FormMethod.Post, new { id = "ParticipacionEditar" }))
   { %>
    <%: Html.ValidationSummary(true) %>
    <table>
        <tr>
            <td>Fecha inicial:</td> <% string fechaIniEdit = String.Format("{0:d}", part.PpanteDirectorView.fechaIni); %>
            <td><%: Html.TextBoxFor(Model => fechaIniEdit, new { @readonly = "true", @id = "fechaIni1" })%></td>
        </tr>
        <tr>
            <td>Fecha final:</td> <% string fechaFinEdit = String.Format("{0:d}", part.PpanteDirectorView.fechaFin); %>
            <td><%: Html.TextBoxFor(Model => fechaFinEdit, new { @readonly = "true", @id = "fechaFin1" })%></td>
        </tr>
        <tr>
            <td>Compañia:</td>
            <td><%: Html.DropDownList("compania_id", (SelectList)part.CompaniaList, "Seleccione...", new { @id = "compania_id", @class = "required" })%></td>
        </tr>
        <tr>
            <td>Canal:</td>
            <td><%: Html.DropDownList("canal_id", (SelectList)part.CanalList, new { @id = "canal_id" })%>
            </td>
        </tr>
        <tr>
            <td>Director:</td>
            <td><%--<%: Html.DropDownList("participante_id", (SelectList)ViewBag.participante_id, "Seleccione...", new { @class = "required" })%>--%>
                <%: Html.TextBoxFor(Model => part.PpanteDirectorView.JerarquiaDetalle.nombre, new { @id = "participanteEdit", @readonly = "true", style = "width:230px" })%>
                <%: Html.Hidden("jerarquiaDetalleEdit_id", part.PpanteDirectorView.jerarquiaDetalle_id, new { id = "jerarquiaDetalleEdit_id" })%>
                <a href="javascript:mostrarDialogDirectores('/ParticipacionDirector/Directores?r=<%: num %>', 'Lista de Directores', 'dialogPart');" style='float:right;' title='Buscar Participantes'><span class='ui-icon ui-icon-search'/></a>
            </td>
        </tr>
        <tr>
            <td>Porcentaje:</td>
            <td><%: Html.TextBoxFor(Model => part.PpanteDirectorView.porcentaje, new { @id = "porcentaje", @class = "required" })%></td>
        </tr>
    </table>
    <p style="text-align:right"><input type="submit" value="Actualizar participacion" id="btnCrear" /></p>
<% } %>