<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reporte de Participacion
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        //tabla que llena
        $(document).ready(function () {
           
        });         
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

        <script type="text/javascript" language="javascript">
            function reporteGenerar() {
                if ($("#formRptFranquicias").valid()) {
                    mostrarCargando("En unos minutos el reporte solicitado estará disponible en el FTP. Consultelo en la opción 'Ver Reportes'");
                    window.setTimeout(function () {
                        $("#formRptFranquicias").submit();
                    }, 3000);
                }
            }
//            function reporteGenerar() {
//                if ($("#formRptFranquicias")) {
//                    var stUrl = '/RptFranquicias/Create';
//                    mostrarCargando("Enviando información. Espere Por Favor...");
//                    $("#create").attr('disabled', true);
//                    var dataForm = $("#formRptFranquicias").serialize();
//                    $.ajax({
//                        type: 'POST',
//                        url: stUrl,
//                        data: dataForm,
//                        success: function (response) {
//                            if (response.Success) {
//                                closeNotify('jNotify');
//                                mostrarExito("El proceso se realizó con éxito...");
//                                window.location.href = "/RptFranquicias";
//                            }
//                        }
//                    });
//                }
//            }

    </script>
    
    <h2>
        Reporte de Pagos Franquicias</h2>
    <div>
    <% using (Html.BeginForm("GenerarReporte", "RptFranquicias", FormMethod.Post, new { id = "formRptFranquicias" }))
       {
           Html.ValidationSummary(true); %>
           <fieldset style="border: 1px solid gray">
        <table cellspacing="2" width="100%">
             <tr id="liquidaciones_tr" >
            <td style="width:20%">
                Liquidaciones
            </td>
            <td style="width:60%">
                <%: Html.DropDownList("liquidaciones_id", ViewBag.Liquidaciones as SelectList)%>
            </td>
                <td style="width:20%">
                <input type="button" onclick="reporteGenerar()" id="generar" value="Generar" />
                </td>
            </tr>
        </table>
        </fieldset>
    </div>
    
                        <% } %>
</asp:Content>
