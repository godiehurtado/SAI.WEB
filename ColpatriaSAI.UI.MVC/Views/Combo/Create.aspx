<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ComboModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Combos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            oTable = $('#tablaLista1').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            oTable = $('#tablaLista2').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            $("#ComboCrear").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });

        });

        function comboSave() {

            if ($("#ComboCrear").valid()) {
                var stUrl = '/Combo/SaveCombo';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnCrear").attr('disabled', true);
                var dataForm = $("#ComboCrear").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            if ($("#comboId").val() == 0)
                                window.location.href = window.location.href + "?comboId=" + response.IdCombo;
                            else
                                window.location.href = window.location.href;
                        }
                    }
                });
            }
        }

        function productoCombo(idProductoCombo, idCombo) {
            $("#productoCombo").dialog({
                width: 500,
                minHeight: 250,
                title: 'Producto Combo',
                position: 'center',
                modal: true
            });

            var stUrl = '/Combo/ProductoCombo';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idProductoCombo: idProductoCombo,
                        idCombo: idCombo
                    },
                success: function (response) {
                    $("#productoCombo").html(response);
                }
            });         
        }

        function eliminarProductoCombo(idProductoCombo) {

            if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
                var stUrl = '/Combo/DeleteProductoCombo';
                mostrarCargando("Eliminando Producto. Espere Por Favor...");
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: {
                        idProductoCombo: idProductoCombo
                    },
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

        function validarCombo(idCombo) {
            mostrarCargando("Validando. Espere Por Favor...");
            $("#btnCrear").attr('disabled', true);
            var stUrl = '/Combo/ValidarCombo';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idCombo: idCombo
                    },
                success: function (response) {
                    closeNotify('jNotify');
                    if (response.Success) {
                        mostrarExito("El combo fue validado con éxito.");
                        $("#btnValidar").hide();
                        $("#msjValidado").text(" Combo Validado ");
                        $("#msjValidado").removeClass("no-validado");
                        $("#msjValidado").addClass("validado");
                    }
                    else {
                        mostrarError(response.Message);
                    }
                }
            });    
        }

    </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Crear nuevo combo</h2>
            <h4></h4>
		    <div>
			    En este módulo podrá crear combos de productos.
			</div>
			<br /><%: Html.ActionLink("Regresar", "Index") %>
		</div>
		<div id="progresoSeccion">		      
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

<% using (Html.BeginForm("Create", "Combo", FormMethod.Post, new { id = "ComboCrear" })) { %>
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="comboId" name="comboId" value='<%= this.Model.Combo.id %>' />
        <table>
            <tr><td>Nombre: </td>
                <td>
                    <%: Html.TextBox("nombre", this.Model.Combo.nombre, new { @class = "required", @size = "50" })%>
                </td>
            </tr>
            <tr><td>Descripción: </td>
                <td>
                    <%: Html.TextArea("descripcion", this.Model.Combo.descripcion, new { @class = "required", @rows = "5", @cols = "37" })%>
                </td>
            </tr>
        </table>
        <p>
        <input type="button" value="Guardar" onclick="comboSave();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>

        <%
            var styleValidado = "validado";
            var textValidado = " Combo Validado ";
            if (this.Model.Combo.validado == 0 && this.Model.Combo.validado != null)
            {
                styleValidado = "no-validado";
                textValidado = " El combo aún no se encuentra validado. Recuerde que hasta que no se cumpla con este proceso este combo no sera tenido en cuenta para calculos. ";
        %>
            <input type="button" value="Validar Combo" onclick="validarCombo(<%= this.Model.Combo.id %>);" id="Button1" name="btnValidar"/>
        <%
            } 
        %>
        <br/><br/>
        <div id="msjValidado" class="<%=styleValidado%>">
            <%=textValidado%>
        </div>
        </p>
        <hr/>
        <%
            var styleProductoCombo = "display:block;";
            if (this.Model.Combo.id == 0)
                styleProductoCombo = "display:none;";                   
        %>
        <div id="productoComboList" style="<%=styleProductoCombo%>">
            <input type="button" value="Adicionar Producto" onclick="productoCombo(0,<%= this.Model.Combo.id %>);" id="btnCrearProductoCombo"/>
            <table id="tablaLista">
                <thead>
                <tr>
                    <th>Compañia</th>
                    <th>Ramo</th>
                    <th>Producto</th>
                    <th>Es principal?</th>
                    <th align="center">Opciones</th>
                </tr>
                </thead>
                <% foreach (var item in this.Model.ProductoComboList) { %>
                <tr>
                    <td><%: item.Compania.nombre %></td>
                    <td><%: item.Ramo.nombre %></td>
                    <td><%: item.Producto.nombre %></td>
                    <td><%: item.es_principal == 0 ? "No" : "Si" %></td>
                    <td nowrap = "nowrap" align="right">
                        <a href="javascript:productoCombo(<%= item.id %>,<%= this.Model.Combo.id %>);" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                                    
                        <a href="javascript:eliminarProductoCombo(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>

    </fieldset>
<% } %>
<div id="productoCombo" style="display:none;"></div>
</asp:Content>