<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ColpatriaSAI.UI.MVC.Models.MetaModel>" %>

<script type="text/javascript">

    $(document).ready(function () {
        /*Para Excepciones*/
        var companias = $("#compania_id");
        var ramos = $("#ramo_id");
        var productos = $("#producto_id");
        companias.change(function () {
            ramos.find('option').remove();
            $("#producto_id").attr("disabled", "disabled");
            $("<option value='0' selected>Todos</option>").appendTo(productos);
            $("<option value='0' selected>Todos</option>").appendTo(ramos);
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
                $("<option value='0' selected>Todos</option>").appendTo(productos);
                $(data).each(function () {
                    $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                });
            });
        });

        $("#ProductoMetaCrear").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function productoMetaSave() {
        if ($("#ProductoMetaCrear").valid()) {
            var stUrl = '/Meta/SaveProductoMeta';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnCrear").attr('disabled', true);
            var dataForm = $("#ProductoMetaCrear").serialize();
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

<% using (Html.BeginForm("Create", "ProductoMeta", FormMethod.Post, new { id = "ProductoMetaCrear" }))
   {       
       %>
    <fieldset  style="border:1px solid gray">

        <input type="hidden"  id="metaId" name="metaId" value="<%=this.Model.Meta.id %>" />
        <input type="hidden"  id="productoMetaId" name="productoMetaId" value="<%=this.Model.ProductosMeta.id %>" />
        <table>
            <tr>
                <td>Compañia:</td>
                <td><%= Html.DropDownList("compania_id", this.Model.CompaniaList, "Seleccione uno...", new { style = "width:300px;", id = "compania_id" , @class = "required"})%></td>
            </tr>
            <tr>
                <td>Ramo:</td> 
                <td>                
                <%= Html.DropDownList("ramo_id", this.Model.RamoList, "Todos", new { style = "width:300px;", id = "ramo_id" })%>
                </td>     
            </tr>
            <tr>
                <td>Producto:</td> 
                <td>
                    <%= Html.DropDownList("producto_id", this.Model.ProductoList, "Todos", new { style = "width:300px;", id = "producto_id" })%>
                </td>     
            </tr>
            <tr>
                <td>Linea Negocio:</td> 
                <td>
                <%= Html.DropDownList("lineaNegocio_id", this.Model.LineaNegocioList, "Todas", new { style = "width:300px;", id = "lineaNegocio_id" })%>
                </td>     
            </tr>
            <tr>
                <td>Modalidad de Pago:</td> 
                <td>
                <%= Html.DropDownList("modalidadPago_id", this.Model.ModalidadPagoList, "Todas", new { style = "width:300px;", id = "modalidadPago_id" })%>
                </td>     
            </tr>
            <tr>
                <td>Amparo:</td> 
                <td>
                <%= Html.DropDownList("amparo_id", this.Model.AmparoList, "Todos", new { style = "width:300px;", id = "amparo_id" })%>
                </td>     
            </tr>
        </table>
        <p><input type="button" value="Guardar" onclick="productoMetaSave();" id="btnCrear"/></p>
    </fieldset>
<% } %>
