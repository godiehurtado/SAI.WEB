<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    $().ready(function () {
        $("#TopexEdadEditar").validate();
    });
</script>

        <script type="text/javascript">
            $(function () {
                var companias = $("#compania_id_editar");
                var ramos = $("#ramo_id_editar");
                var productos = $("#producto_id_editar");
                companias.change(function () {
                    ramos.find('option').remove();
                    $("#producto_id_editar").attr("disabled", "disabled");
                    $("<option value='0' selected>Todas</option>").appendTo(productos);
                    $.getJSON('/TopexEdad/getRamos', { compania_id: companias.val() }, function (data) {
                        $("<option value='0' selected>Todas</option>").appendTo(ramos);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                        });
                    });
                });
            });
            </script>

            <script type="text/javascript">
                 $(function () {
                     var ramos = $("#ramo_id_editar");
                     var productos = $("#producto_id_editar");
                     ramos.change(function () {
                         productos.find('option').remove();
                         $("#producto_id_editar").removeAttr("disabled");
                         $.getJSON('/TopexEdad/getProductos', { ramo_id: ramos.val() }, function (data) {
                             $("<option value='0' selected>Todas</option>").appendTo(productos);
                             $(data).each(function () {
                                 $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                             });
                         });
                     });
                 });
            </script>

            <script type="text/javascript">
                function topeEdadSave() {
                    if ($("#TopexEdadEditar").valid()) {
                        $("#editar").attr('disabled', true);
                        $("#TopexEdadEditar").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>

     <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <% using (Html.BeginForm("Editar", "TopexEdad", FormMethod.Post, new { id = "TopexEdadEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.TopexEdadViewModel topexedad = (ColpatriaSAI.UI.MVC.Models.TopexEdadViewModel)ViewData["TopexEdadViewModel"]; %>
        <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        <tr>
            <td><%: Html.Label("Tope") %></td>
            <td><%: Html.TextBox("tope", String.Format("{0:0.00}",topexedad.TopexEdadView.tope), new { @class = "required decimal" })%>
                <%: Html.ValidationMessageFor(model => topexedad.TopexEdadView.tope)%></td>
        </tr>
        <tr>
            <td><%: Html.Label("Edad") %></td>
            <td><%: Html.TextBoxFor(model => topexedad.TopexEdadView.edad, new { @class = "required number" })%>
                <%: Html.ValidationMessageFor(model => topexedad.TopexEdadView.edad)%></td>
        </tr>
        </table>
        <input type="hidden" id="maestromoneda_id" name="maestromoneda_id" value="<%: ViewData["value"] %>" />
        <p align = "center"><input type="button" value="Actualizar" id = "editar" onclick="topeEdadSave()" /></p>

    <% } %>