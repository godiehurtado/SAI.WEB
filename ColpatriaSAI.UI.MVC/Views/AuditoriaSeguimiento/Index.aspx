<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3>
        Auditoria</h3>
    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true
            , "sPaginationType": "full_numbers"
            , "bStateSave": true
            , "sScrollX": "150%"
            , "sScrollXInner": "160%"
            , "bScrollCollapse": false
            });
            $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
        });
    </script>
    <table id="tablaLista">
        <thead>
            <tr>
                <th align="center" style="width: 60px;">
                    Modulo
                </th>
                <th align="center" style="width: 90px;">
                    Tipo de Modificación
                </th>
                <th align="center" style="width: 90px;">
                    Fecha Inicio
                </th>
                <th align="center" style="width: 90px;">
                    Fecha Final
                </th>
                <th align="center" style="width: auto;">
                    Primera Version
                </th>
                <th align="center" style="width: auto;">
                    Version Final
                </th>
                <th align="center" style="width: auto;">
                    Observacion
                </th>
                <th align="center" style="width: 92px;">
                    Usuario Responsable
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in ((IEnumerable<ColpatriaSAI.Negocio.Entidades.view_Auditoria>)ViewData["AuditoriaSeguimiento"]))
               { %>
            <tr>
                <td align="center">
                    <%: item.ModuloProceso%>
                </td>
                <td align="center">
                    <%: item.tipoModificacion%>
                </td>
                <td align="center">
                    <%:  item.fechaInicio %>
                </td>
                <td align="center">
                    <%: item.fechaFinal %>
                </td>
                <td align="center" style="width: auto">
                    <%: Html.Raw(item.PrimeraVersion)%>
                </td>
                <td align="center" style="width: auto">
                    <%: Html.Raw(item.VersionFinal)%>
                </td>
                <td align="center" style="width:auto">
                    <%: item.Observacion %>
                </td>
                <td align="center">
                    <%: item.usuario %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</asp:Content>
