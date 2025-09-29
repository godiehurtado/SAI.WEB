<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.AjustesModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ajustes Franquicias - Sistema de Administración de Incentivos
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
            $("#FranquiciasCrear").validate({
                submitHandler: function (form) {
                    $('td:nth-child(4)', $('#tablaLista').dataTable().fnGetNodes()).each(function () {
                        var tid = $(this).find("input")[0].id;
                        if ($(this).find("input")[0].value == '') {
                            $('#' + tid).remove();
                        }
                        else {
                            $('#FranquiciasCrear').append($(this).find("input")[0]);
                        }
                    });

                    $('td:nth-child(6)', $('#tablaLista').dataTable().fnGetNodes()).each(function () {
                        var tid = $(this).find("textarea")[0].id;
                        if ($(this).find("textarea")[0].value == '') {
                            $('#' + tid).remove();
                        }
                        else {
                            $('#FranquiciasCrear').append($(this).find("textarea")[0]);
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
                Ajustes Franquicias</h2>
            <p>
                <%=Html.ActionLink("Regresar", "liquiIndex", "LiquidacionFranqui/liquiIndex")%>
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <% using (Html.BeginForm("ActualizarFranquicias", "Ajustes", FormMethod.Post, new { @id = "FranquiciasCrear" }))
       {
           Html.ValidationSummary(true);
    %>
    <table id="tablaLista">
        <thead>
            <tr>
                <th>
                    Documento
                </th>
                <th>
                    Descripción
                </th>
                <th>
                    Total Participación
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
                <th>
                    Comentario
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in Model.listaPagosFranquicia)
               { %>
            <tr>
                <td>
                    <%: Html.DisplayFor(modelItem => item.documento) %>
                </td>
                <td>
                    <%: Html.DisplayFor(modelItem => item.descripcion) %>
                </td>
                <td>
                    <%: Html.DisplayFor(modelItem => item.totalParticipacion) %>
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
                <td>
                    <%: Html.DisplayFor(modelItem => item.AuditoriaAjustes.OrderByDescending(x => x.id).FirstOrDefault().descripcion) %>
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
