<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.UI.MVC.Models.ComboModel>" %>

<script type="text/javascript">

    $(document).ready(function () {
        /*Para Excepciones*/
        var companias = $("#compania_id");
        var ramos = $("#ramo_id");
        var productos = $("#producto_id");
        companias.change(function () {
            productos.find('option').remove();
            ramos.find('option').remove();
            $("#producto_id").attr("disabled", "disabled");
            $("<option value=''>Seleccione Uno</option>").appendTo(productos);
            $("<option value=''>Seleccione Uno</option>").appendTo(ramos);
            $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
                $(data).each(function () {
                    $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                });
            });
        });
        ramos.change(function () {
            productos.find('option').remove();
            $("#producto_id").removeAttr("disabled");
            $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
                $("<option value='' selected>Seleccione Uno</option>").appendTo(productos);
                $(data).each(function () {
                    $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                });
            });
        });

        $("#ProductoComboCrear").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function productoComboSave() {
        if ($("#ProductoComboCrear").valid()) {
            var stUrl = '/Combo/SaveProductoCombo';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnCrear").attr('disabled', true);
            var dataForm = $("#ProductoComboCrear").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = window.location.href;
                    }
                }
            });
        }
    }

</script>

<% using (Html.BeginForm("Create", "ProductoCombo", FormMethod.Post, new { id = "ProductoComboCrear" }))
   {       
       %>
    <fieldset  style="border:1px solid gray">

        <input type="hidden"  id="comboId" name="comboId" value="<%=this.Model.Combo.id %>" />
        <input type="hidden"  id="productoComboId" name="productoComboId" value="<%=this.Model.ProductoCombo.id %>" />
        <table>
            <tr>
                <td>Compañia:</td>
                <td><%= Html.DropDownList("compania_id", this.Model.CompaniaList, "Seleccione uno...", new { style = "width:300px;", id = "compania_id" , @class = "required"})%></td>
            </tr>
            <tr>
                <td>Ramo:</td> 
                <td>                
                <%= Html.DropDownList("ramo_id", this.Model.RamoList, "Seleccione Uno", new { style = "width:300px;", id = "ramo_id", @class = "required" })%>
                </td>     
            </tr>
            <tr>
                <td>Producto:</td> 
                <td>
                    <%= Html.DropDownList("producto_id", this.Model.ProductoList, "Seleccione Uno", new { style = "width:300px;", id = "producto_id", @class = "required" })%>
                </td>     
            </tr>
            <tr>
                <td>Es principal?:</td> 
                <td>
                    <%
                        var strChecked = "";
                        if (this.Model.ProductoCombo.es_principal == 1)
                            strChecked = "checked='checked'";
                    %>
                    <input type="checkbox" name="es_principal" id="es_principal" <%=strChecked %> />
                </td>     
            </tr>
        </table>
        <p><input type="button" value="Guardar" onclick="productoComboSave();" id="btnCrear"/></p>
    </fieldset>
<% } %>
