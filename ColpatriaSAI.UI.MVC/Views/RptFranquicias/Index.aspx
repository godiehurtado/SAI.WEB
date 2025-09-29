<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reporte de Participacion
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

                    
                    $("#txtFecha").text("Fecha corte");
                    $("#fecha_ini").addClass("required");

                    $("#fechaIni_tr").show();

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
    
    <h2>
        Reporte de Pagos Franquicias</h2>
    <div>
        <table cellspacing="2" width="100%">
            <tr id="liquidaciones_tr" >
            <td>
                Liquidaciones
            </td>
            <td>
                <%: Html.DropDownList("liquidaciones_id", ViewBag.Liquidaciones as SelectList)%>
            </td>
        </tr>
        </table>
    </div>
    <input type="button" onclick="reporteGenerar()" id="generar" value="Generar" />
</asp:Content>
