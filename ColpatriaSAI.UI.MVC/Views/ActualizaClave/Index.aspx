<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3>
        La actualización de los registros sera lleva a cabo al finalizar el dia..</h3>
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 200, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 300, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function cerrarDialog(dialog) {
            $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".defaultText").focus(function (srcc) {
                if ($(this).val() == $(this)[0].title) {
                    $(this).removeClass("defaultTextActive");
                    $(this).val("");
                }
            });

            $(".defaultText").blur(function () {
                if ($(this).val() == "") {
                    $(this).addClass("defaultTextActive");
                    $(this).val($(this)[0].title);
                }
            });

            $(".defaultText").blur();
        });        
       
    </script>
    <script type="text/javascript" language="javascript">

        $(document).ready(function () {

            $("#formParametrizacionClave").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });
        });

        function parametrizacionSave() {
            if ($("#formParametrizacionClave").valid()) {
                var stUrl = '/ActualizaClave/Create';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#create").attr('disabled', true);
                var dataForm = $("#formParametrizacionClave").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = "/ActualizaClave";
                        }
                    }
                });
            }
        }

    </script>
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <% using (Html.BeginForm("Create", "ParametrizacionClave", FormMethod.Post, new { id = "formParametrizacionClave" }))
       {
           Html.ValidationSummary(true); %>
    <% ColpatriaSAI.UI.MVC.Models.ClaveProveedorHistorico clave = (ColpatriaSAI.UI.MVC.Models.ClaveProveedorHistorico)ViewData["ParametrizacionClave"]; %>
    <fieldset style="border: 1px solid gray">
        <table>
            <% Html.EnableClientValidation(); %>
            <tr>
                <td style="width: 129px">
                    <%: Html.Label("Realizar Reverso") %>
                </td>
                <td style="width: 172px">
                    <%: Html.CheckBox("idreversa")%>
                </td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <%: Html.Label("Clave Nueva")%>
                </td>
                <td style="width: 172px">
                    <%: Html.TextBox("ClaveNew", null, new { @class = "required number" })%>
                </td>
            </tr>
            <tr>
                <td style="width: 129px">
                    <%: Html.Label("Clave Antigua") %>
                </td>
                <td style="width: 172px">
                    <%: Html.TextBox("ClaveOld", null, new { @class = "required number" })%>
                </td>
            </tr>
            <td style="width: 129px">
                <u>
            </td>
            <td style="width: 172px">
            </td>
            <tr>
                <td style="width: 129px">
                </td>
                <td style="width: 172px">
                    <input type="button" value="Guardar" id="crear" onclick="parametrizacionSave()" />
                </td>
            </tr>
        </table>
        <%-- se agrega grilla--%>
        <table id="tablaLista">
            <thead>
                <tr>
                    <th align="center">
                        Clave Antigua
                    </th>
                    <th align="center">
                        Clave Nueva
                    </th>
                    <th align="center">
                        Fecha de Modificacion
                    </th>
                    <th align="center">
                        Usuario
                    </th>
                </tr>
            </thead>
            <tbody>
                <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<ColpatriaSAI.Negocio.Entidades.clave_historico>)ViewData["GetHistricoCambioClave"]))
                   { %>
                <tr class="modo2">
                    <td align="center" class="modo2">
                        <%: item.clave_old %>
                    </td>
                    <td align="center">
                        <%: item.clave_new %>
                    </td>
                    <td align="center">
                        <%: item.fecha%>
                    </td>
                    <td align="center">
                        <%:  item.usuario %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </fieldset>
</asp:Content>
