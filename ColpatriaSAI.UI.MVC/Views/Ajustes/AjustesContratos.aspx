<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.AjustesModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ajustes Contratación - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sScrollY": "500px",
                "bPaginate": false,
                "bFilter": false
            });
        });

        $().ready(function () {
            $("#ContratosCrear").validate({
                submitHandler: function (form) {
                    $('td:nth-child(4)', $('#tablaLista').dataTable().fnGetNodes()).each(function () {
                        var tid = $(this).find("input")[0].id;
                        if ($(this).find("input")[0].value == '') {
                            $('#' + tid).remove();
                        }
                        else {
                            $('#ContratosCrear').append($(this).find("input")[0]);
                        }
                    });

                    $('td:nth-child(6)', $('#tablaLista').dataTable().fnGetNodes()).each(function () {
                        var tid = $(this).find("textarea")[0].id;
                        if ($(this).find("textarea")[0].value == '') {
                            $('#' + tid).remove();
                        }
                        else {
                            $('#ContratosCrear').append($(this).find("textarea")[0]);
                        }
                    });

                    form.submit();
                }
            });
        });

        function descValidation(object) {
            var id = $(object).attr('id');
            if ($(object).val() == '') {
                $('#ta_' + id).empty();
                $('#ta_' + id).removeAttr("class");
            }
            else
                $('#ta_' + id).attr("class", "required");
        }
    </script>
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Ajustes Contratación</h2>
            <p>
                <%= Html.ActionLink("Regresar", "Index", "LiquidacionContrat/Index")%>
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <% using (Html.BeginForm("ActualizarContratos", "Ajustes", FormMethod.Post, new { @id = "ContratosCrear" }))
       {
           Html.ValidationSummary(true);
    %>
    <table id="tablaLista">
        <thead>
            <tr>
                <th>
                    Nota definitiva
                </th>
                <th>
                    Factor
                </th>
                <th>
                    Total Pago
                </th>
                <th>
                    Ajuste
                </th>
                <th>
                    Total ajustado
                </th>
                <th>
                    Descripción
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in Model.listaPagosContratos)
               { %>
            <tr>
                <td>
                    <%: Html.DisplayFor(modelItem => item.JerarquiaDetalle.Participante.documento) %>
                </td>
                <td>
                    <%: Html.DisplayFor(modelItem => item.JerarquiaDetalle.nombre) %>
                </td>
                <td>
                    <%: Html.DisplayFor(modelItem => item.totalPago) %>
                </td>
                <td>
                    <%: Html.TextBox(item.id.ToString(), "", new { @id = item.id.ToString(), @class = "number", onblur = "descValidation(this)" })%>
                </td>
                <td>
                    <%: Html.DisplayFor(modelItem => item.totalAjuste) %>
                </td>
                <td>
                    <%: Html.TextArea("ta_" + item.id.ToString(), new { @id = "ta_" + item.id.ToString() })%>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <p>
        <input type="submit" id="actualizar" value="Guardar ajustes" />
    </p>
    <% } %>
</asp:Content>