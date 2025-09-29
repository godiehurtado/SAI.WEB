<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<script type="text/javascript">
    $().ready(function () {
        $("#PremioxSubReglaEditar").validate();
        var meses = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
        var i = 0;
        for (i = 0; i < 12; i++) {
            $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesInicio_Edit"));
        }
        for (i = 0; i < 12; i++) {
            $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin_Edit"));
        }
        $("#ddlMesInicio_Edit").val(<%=TempData["mesinicio"] %>);
        $("#ddlMesFin_Edit").val(<%=TempData["mesfin"] %>);

        $("#ddlMesInicio_Edit").change(function () {
            $("#ddlMesFin_Edit").find('option').remove();
            var mesini = $("#ddlMesInicio_Edit").val();
            var i = mesini - 1;
            for (i; i < 12; i++) {
                $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin_Edit"));
            }
        });
    });
</script>
<script type="text/javascript">
    function seleccionarPremio(idPremio, nombreP) {
        $("#premio_id_Edit").val(idPremio);
        $("#premio_Edit").html(nombreP + "&nbsp;&nbsp;&nbsp;");
        $('#PremioNombreEdit').hide("slow");
        $("#dialogPremio_Edit").dialog('destroy'); $("#dialogPremio_Edit").dialog("close");
    }         
</script>
<script type="text/javascript">
    function premioxsubreglaSave() {
        if ($("#PremioxSubReglaEditar").valid()) {
            $("#editar").attr('disabled', true);
            $("#PremioxSubReglaEditar").submit();
            mostrarCargando("Enviando informacion. Espere Por Favor...");
        }
    }
</script>
<%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
<% Random random = new Random(); int num = random.Next(1, 10000);  %>
<% if (TempData["Mensaje"] != null)
   { %>
<div id="Mensaje" style="display: none;">
    <%: TempData["Mensaje"] %></div>
<% } %>
<% using (Html.BeginForm("Editar", "PremioxSubRegla", FormMethod.Post, new { id = "PremioxSubReglaEditar" }))
   {
       Html.ValidationSummary(true); %>
<% ColpatriaSAI.UI.MVC.Models.PremioxSubReglaViewModel premioxsubregla = (ColpatriaSAI.UI.MVC.Models.PremioxSubReglaViewModel)ViewData["PremioxSubReglaViewModel"]; %>
<table id="tablaAdmin" class="tablesorter" width="100%" border="0" cellspacing="0"
    cellpadding="0" style="padding-left: 50px">
    <thead>
        <tr>
            <th align="center">
                <a href="javascript:mostrarDialogPremio_Edit('/PremioxSubRegla/Premio?r=<%: num %>', 'Editar Premio', 'dialogPremio_Edit');"
                    style='float: none;' title='Buscar Premio'>Buscar Premio</a>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td align="center">
                <b><span id="premio_Edit" style="text-transform: uppercase;">&nbsp;&nbsp;&nbsp;</span></b>
                <%: Html.Hidden("premio_id_Edit", 0, new { id = "premio_id_Edit" })%>
                <span id="PremioNombreEdit" style="text-transform: uppercase;">&nbsp;&nbsp;&nbsp;<%: TempData["PremioxSubRegla"]%></span>
                <div id="campoMes_Edit">
                    <table>
                        <tr>
                            <td>
                                Mes inicio:
                            </td>
                            <td>
                                <select id="ddlMesInicio_Edit" style="width: 100%" name="ddlMesInicio_Edit">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Mes fin:
                            </td>
                            <td>
                                <select id="ddlMesFin_Edit" style="width: 100%" name="ddlMesFin_Edit">
                                </select>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td align="center">
                <input type="button" value="Actualizar" id="editar" onclick="premioxsubreglaSave()" />
            </td>
            <td>
                <input type="hidden" id="subregla_id" name="subregla_id" value="<%: ViewData["valuesr"] %>" />
            </td>
        </tr>
    </tbody>
</table>
<% } %>
<div id='dialogPremio_Edit' style="display: none;">
</div>
