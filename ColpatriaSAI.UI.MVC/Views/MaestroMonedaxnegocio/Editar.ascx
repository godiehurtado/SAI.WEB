<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
        
        <script type="text/javascript">
            $().ready(function () {
                $("#formMaestroMonedaxNegocioEditar").validate({

            });

        });
        </script>
        <script type="text/javascript">
            $(function () {
                var dates = $("#FechaInicioEdit, #FechaFinEdit").datepicker({
                    defaultDate: "+1w",
                    changeMonth: false,
                    numberOfMonths: 3,
                    dateFormat: "dd/mm/yy",
                    showButtonPanel: true,
                    changeMonth: true,
                    changeYear: true,
                    altField: "#alternate",
                    altFormat: "DD, d MM, yy",
                    onSelect: function (selectedDate) {
                        var option = this.id == "FechaInicioEdit" ? "minDate" : "maxDate",
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

        <script type="text/javascript">
            function maestroMonedaSave() {
                if ($("#formMaestroMonedaxNegocioEditar").valid()) {
                    $("#editar").attr('disabled', true);
                    $("#formMaestroMonedaxNegocioEditar").submit();
                    mostrarCargando("Enviando informacion. Espere Por Favor...");
                }
            }
        </script>

        <% Html.EnableClientValidation(); %>
        <% using (Html.BeginForm("Editar", "MaestroMonedaxNegocio", FormMethod.Post, new { id = "formMaestroMonedaxNegocioEditar" })) {
               Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.MaestroMonedaxNegocioViewModel maestromonedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MaestroMonedaxNegocioViewModel)ViewData["MaestroMonedaxNegocioViewModel"]; %>
        <table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0"
            cellpadding="0" style="padding-left: 50px">
            <tr>
                <td><u><%: Html.Label("Fecha Inicial")%></u></td>
                <td><%: Html.TextBox("FechaInicial", String.Format("{0:d}",maestromonedaxnegocio.MaestroMonedaxNegocioView.fecha_inicial), new { @readonly = "true", @class = "required", id = "FechaInicioEdit" })%>
                    <%: Html.ValidationMessageFor(Model => maestromonedaxnegocio.MaestroMonedaxNegocioView.fecha_inicial)%></td>
            </tr>
            <tr>
                <td><u><%: Html.Label("Fecha Final")%></u></td>
                <td><%: Html.TextBox("FechaFinal", String.Format("{0:d}",maestromonedaxnegocio.MaestroMonedaxNegocioView.fecha_final), new { @readonly = "true", @class = "required", id = "FechaFinEdit" })%>
                    <%: Html.ValidationMessageFor(Model => maestromonedaxnegocio.MaestroMonedaxNegocioView.fecha_final)%></td>
            </tr>
        </table>
        <%: Html.Hidden("moneda_id",maestromonedaxnegocio.MaestroMonedaxNegocioView.moneda_id)%>
        <p align="center"><input type="button" value="Actualizar" id = "editar" onclick="maestroMonedaSave()" /></p>
<% } %>