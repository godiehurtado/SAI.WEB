<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reportes Asíncronos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        //tabla que llena
        $(document).ready(function () {
            $('#fecha_ini').datepicker({ dateFormat: 'yy-mm-dd' });
            $('#fecha_fin').datepicker({ dateFormat: 'yy-mm-dd' });

            $("#etl_id").change(function () {
                var strSelected = $(this).val();

                $("#compania_tr").hide();
                $("#anio_tr").hide();
                $("#Sucursales").hide();
                $("#parametrizacion").hide();
                $("#fechaIni_tr").hide();
                $("#fechaFin_tr").hide();
                $("#mesIni_tr").hide();
                $("#mesFin_tr").hide();

                $("#fecha_ini").removeClass("required");
                $("#fecha_fin").removeClass("required");

                $("#txtFecha").text("Fecha Inicial");

                if (strSelected == 2 || strSelected == 5 || strSelected == 7) {
                    $("#fecha_ini").addClass("required");
                    $("#fecha_fin").addClass("required");

                    $("#compania_tr").show();
                    $("#fechaIni_tr").show();
                    $("#fechaFin_tr").show();
                }
                if (strSelected == 3 || strSelected == 4 || strSelected == 6 || strSelected == 14 || strSelected == 15) {
                    $("#compania_tr").show();
                    $("#anio_tr").show();
                    $("#mesIni_tr").show();
                    $("#mesFin_tr").show();
                }
                if (strSelected == 8 || strSelected == 16 || strSelected == 17) {
                    $("#anio_tr").show();
                }
                if (strSelected == 9) {
                    $("#compania_tr").show();
                    $("#anio_tr").show();
                }
                if (strSelected == 28 || strSelected == 31) {
                    $("#Sucursales").show();
                    if (strSelected == 28) {
                        $("#parametrizacion").show();
                    }
                }
                if (strSelected == 35) {
                    $("#fechaIni_tr").show();

                }
                if (strSelected == 33 || strSelected == 34 || strSelected == 36)
                {
                    $("#anio_tr").show();
                    $("#mesIni_tr").show();
                    $("#mesFin_tr").show();
                }
                if (strSelected == 10 || strSelected == 11) {
                    if (strSelected == 10) {
                        $("#txtFecha").text("Fecha Actual (Mes/Año)");
                    }
                    else {
                        $("#txtFecha").text("Fecha corte");
                    }

                    $("#fecha_ini").addClass("required");

                    $("#fechaIni_tr").show();

                }
            });
        });
        $("#localidad_id option").each(function () {
            $(this).attr({ 'title': $.trim($(this).html()) });
        });
        function reporteGenerar() {
            if ($("#FormReporte").valid()) {
                mostrarCargando("En unos minutos el reporte solicitado estará disponible en el FTP. Consultelo en la opción 'Ver Reportes'");
                window.setTimeout(function () {
                    $("#FormReporte").submit();
                }, 3000);
            }
        }       
    </script>
    <script type="text/javascript">
        $(function () {
            var localidad = $("#localidad_id");
            var Parametro = $("#Parametros_id");
            localidad.change(function () {
                Parametro.find('option').remove();

                $("<option value='0' selected>Todas</option>").appendTo(Parametro);

                //Carga el Combo de Actividad por Negocio de acuerdo a la compañia
                Parametro.find('option').remove();
                $.getJSON('/ReportesSAI/getParamParticipacionFranquiciaByLocalidad', { localidadID: localidad.val() }, function (data) {
                    $("<option value='' selected>Todos</option>").appendTo(Parametro);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.rangoParametros + "</option>").appendTo(Parametro);
                    });
                });
            });
        });
    </script>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Reportes Asíncronos</h2>
            <p>
            </p>
        </div>
        <div id="progresoSeccion">
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <%      
        using (Html.BeginForm("GenerarReporte", "ReportesSAI", FormMethod.Post, new { id = "FormReporte" }))
        {%>
    <table cellspacing="2" width="100%">
        <tr>
            <td>
                Reporte a generar
            </td>
            <td>
                <%: Html.DropDownList("etl_id", ViewBag.ETLs as SelectList, "Seleccione...", new { @class = "required" })%>
            </td>
        </tr>
    </table>
    <div style="clear: both;">
        <hr />
    </div>
    <table cellspacing="2" width="100%">
        <tr id="Sucursales" style="display: none">
            <td>
                Sucursales
            </td>
            <td>
                <%: Html.DropDownList("localidad_id", ViewBag.Localidad as SelectList, "Seleccione un Valor")%>
            </td>
        </tr>
        <tr id="parametrizacion" style="display: none">
            <td>
                Parametrizacion
            </td>
            <td>
                <%: Html.DropDownList("Parametros_id", new List<SelectListItem>(), "Todos", new { style = "width:300px;" })%>
            </td>
        </tr>
        <tr id="compania_tr" style="display: none">
            <td>
                Compañia
            </td>
            <td>
                <%: Html.DropDownList("compania_id", ViewBag.Companias as SelectList)%>
            </td>
        </tr>
        <tr id="anio_tr" style="display: none">
            <td>
                Año
            </td>
            <td>
                <%: Html.ComboAnios("anio") %>
            </td>
        </tr>
        <tr id="fechaIni_tr" style="display: none">
            <td>
                <span id="txtFecha">Fecha Inicial</span>
            </td>
            <td>
                <%: Html.TextBox("fecha_ini")%>
            </td>
        </tr>
        <tr id="fechaFin_tr" style="display: none">
            <td>
                Fecha Final
            </td>
            <td>
                <%: Html.TextBox("fecha_fin")%>
            </td>
        </tr>
        <tr id="mesIni_tr" style="display: none">
            <td>
                Mes Inicial
            </td>
            <td>
                <%: Html.ComboMeses("mes_ini") %>
            </td>
        </tr>
        <tr id="mesFin_tr" style="display: none">
            <td>
                Mes Final
            </td>
            <td>
                <%: Html.ComboMeses("mes_fin") %>
            </td>
        </tr>
    </table>
    <input type="button" onclick="reporteGenerar()" id="generar" value="Generar" />
    <% } %>
</asp:Content>
