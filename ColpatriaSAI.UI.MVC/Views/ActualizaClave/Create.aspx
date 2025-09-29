<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.clave_historico>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Cambio de Clave
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

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

      
            <p>Los cambios realizados seran llevados a Cabo al finalizar el dia.</p>
                <% using (Html.BeginForm("Create", "ParametrizacionClave", FormMethod.Post, new { id = "formParametrizacionClave" }))
                   {
                       Html.ValidationSummary(true); %>
                <% ColpatriaSAI.UI.MVC.Models.ClaveProveedorHistorico clave = (ColpatriaSAI.UI.MVC.Models.ClaveProveedorHistorico)ViewData["ParametrizacionClave"]; %>
                <fieldset style="border: 1px solid gray">
                    <table>
                        <tr>
                            <td style="width: 129px">
                                <u>
                                     <%: Html.Label("Clave Nueva") %></u>
                            </td>
                            <td style="width: 172px">
                                <%: Html.TextBox("ClaveNueva", clave.clave_new, new {@class = "required"}) %>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 129px">
                                <u>
                                    <%: Html.ComboMeses("FechaInicio") %></u>
                            </td>
                            <td style="width: 172px">
                                    <%: Html.TextBox("ClaveAntigua", clave.clave_old, new {@class = "required"}) %>
                                    
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
                    <% } %>

    </fieldset>
    </asp:Content>
