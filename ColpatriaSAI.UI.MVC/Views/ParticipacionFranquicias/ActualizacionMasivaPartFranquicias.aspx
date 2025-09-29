<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="System.Web.Mvc.Html" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    ActualizacionMasivaPartFranquicias
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script src="../../Scripts/json2.js" type="text/javascript"></script>
<script src="../../Scripts/json.js" type="text/javascript"></script> 
<script src="../../Scripts/jquery.toChecklist.min.js" type="text/javascript"></script>   
<script type="text/javascript">

        $(document).ready(function () {

            $('#FechaInicio').datepicker({ dateFormat: 'yy-mm-dd' });
            $('#FechaFin').datepicker({ dateFormat: 'yy-mm-dd' });

            $.validator.addMethod("numberDecimal", function (value, element) {
                element.value = value.replace('.', ',');
                return this.optional(element) || IsNumeric(value);
            }, "Valid number decimal");

            $("#formactfranq").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                },
                rules: {
                    Porcentaje: {
                        numberDecimal: true
                    },
                    Rangoinferior: {
                        required: function (element) {
                            return $("#Rangosuperior").val() != '';
                        }
                    },
                    Rangosuperior: {
                        required: function (element) {
                            return $("#Rangoinferior").val() != '';
                        }
                    }
                }
            });

            $('#Franquicias').toChecklist({
                addSearchBox: false,
                searchBoxText : 'Digite aqui su busqueda...',
                showSelectedItems : true,
                submitDataAsArray: true,
                checkAll: true
            });

            var companias = $("#compania_id");
            var ramos = $("#ramo_id");
            var productos = $("#producto_id");

            companias.change(function () {
                if ($("#compania_id option:first-child").index() == 0) {
                    ramos.text("Todos"); ramos.attr("disabled", "disabled");
                }

                ramos.find('option').remove();
                $("#producto_id").attr("disabled", "disabled");
                $("<option value='0' selected>Todas</option>").appendTo(ramos);
                $("<option value='0' selected>Todas</option>").appendTo(productos);
                $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                    });
                    ramos.removeAttr("disabled");
                });
            });

            ramos.change(function () {
                productos.find('option').remove();
                $("#producto_id").removeAttr("disabled");
                $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
                    $("<option value='0' selected>Todas</option>").appendTo(productos);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                    });
                    productos.removeAttr("disabled");
                });
            });
        });

        function inicializarControles() {
            $('#idpartfranq').val('');
            $("#compania_id option:first-child").attr("selected", "selected");
            $("#ramo_id option:first-child").attr("selected", "selected");
            $("#producto_id option:first-child").attr("selected", "selected");
            $("#planes_id option:first-child").attr("selected", "selected");
            $("#lineaNegocio_id option:first-child").attr("selected", "selected");
            $("#TipoVehiculo option:first-child").attr("selected", "selected");
            $('#Amparo_id option:first-child').attr("selected", "selected");
            $('#Porcentaje').val(''); $('#Rangoinferior').val(''); $('#Rangosuperior').val('');
            $("#ramo_id").attr("disabled", "disabled"); $("#producto_id").attr("disabled", "disabled");
            $('#tablaLista').removeAttr("disabled");
        }

        function ActualizarMasivo() {

            if ($("#formactfranq").valid()) {

                $("#btnActualizar").attr('disabled', true);

                $.ajax({ url: '/ParticipacionFranquicias/ActualizacionMasivaPartFranquicias', data: $("#formactfranq").serialize(), type: 'POST', async: false,
                    success: function (result) {
                        closeNotify('jNotify');
                        mostrarExito("Proceso Terminado. Se actualizarón " + result.totalActualizacion + " participaciones.");
                        setTimeout("window.location.href = '/Franquicias'", 2000);
                    }
                });
            }
        }

</script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" style="width:auto;">
			<h2>Actualización Masiva de Participaciones por franquicias</h2>
			<p>
				Seleccione la franquicia a la cual quiere actualizar sus porcentajes de participación.<br /><br />
				<%: Html.ActionLink("Regresar", "Index","Franquicias") %>
			</p>
		</div>
		<div id="progresoSeccion">	</div>
		<div style="clear:both;"><hr /></div>
	</div>

<% using (Html.BeginForm("ActualizacionMasivaPartFranquicias","ParticipacionFranquicias",FormMethod.Post,new{id="formactfranq"}))
   { %>
    <fieldset>
        <legend>Fechas de vigencia</legend>
        <input type="hidden" id="ParticipacionFranquiciaId" name="ParticipacionFranquiciaId" value='<%= ViewData["IdLastFranquicia"] %>' />
        <table cellspacing="2" width="100%">
            <tr>
                <td><label for="FechaInicio">Fecha Inicio:</label></td>
                <td><%= Html.TextBox("FechaInicio", String.Format("{0:d}", ViewData["FechaInicio"]), new { @readonly = "true", @class = "required" })%></td>
                <td><label for="FechaFin">Fecha Fin:</label></td>
                <td><%= Html.TextBox("FechaFin", String.Format("{0:d}", ViewData["FechaFin"]), new { @readonly = "true", @class = "required" })%></td>
            </tr>
        </table>

    </fieldset>
     <fieldset>
        <legend>Porcentajes de  Participación Franquicia</legend>
        <% ColpatriaSAI.UI.MVC.Models.DetalleParticipacionFranquicia detalleParticipacionFranquicia = (ColpatriaSAI.UI.MVC.Models.DetalleParticipacionFranquicia)ViewData["ParticipacionFranquiciaViewModel"]; %>
    
        
        <table cellspacing="2" width="100%">
        <tr>
                <td>
                   Franquicias
                </td>
                <td>
                <table >
                <tr>
                <td>
                <%= Html.ListBox("Franquicias", new MultiSelectList((SelectList)ViewBag.Localidades, "Value", "Text"), new { size = "8" })%>
               
                </td>
                <td> <ul id="Franquicias_selectedItems"></ul></td>
                </tr>
                </table>
             
                
                </td>
                <td></td>
                <td></td>
               
            </tr>
            <tr>
                <td><%: Html.Label("Compañía")%></td>
                <td><%: Html.DropDownList("compania_id", (SelectList)detalleParticipacionFranquicia.Compania, "Seleccione un Valor", new { style = "width:300px;", id = "compania_id", @class = "required" })%></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td><%: Html.Label("Ramo")%></td>
                <td>
                    <%: Html.DropDownList("ramo_id", (SelectList)detalleParticipacionFranquicia.Ramo, "Seleccione un Valor", new { style = "width:300px;", id = "ramo_id", @class = "required" })%>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    <%: Html.Label("Producto")%>
                </td>
                <td>
                    <%: Html.DropDownList("producto_id", (SelectList)detalleParticipacionFranquicia.Producto, "Seleccione un Valor", new { style = "width:300px;", id = "producto_id", @class = "required" })%>
                </td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    <%: Html.Label("Línea de Negocio")%>
                </td>
             
                <td>
                    <%: Html.DropDownList("lineaNegocio_id", (System.Collections.Generic.List<System.Web.Mvc.SelectListItem>)detalleParticipacionFranquicia.LineaNegocio, "Seleccione un Valor", new { style = "width:300px;", id = "lineaNegocio_id" })%>
                </td>
                <td>
                    <%: Html.Label("Porcentaje")%>
                </td>
                <td>
                     <%:Html.TextBox("Porcentaje", ViewData["Porcentaje"], new {@class = "required", size=5})%>%
                </td>
            </tr>
            <tr>
                <td>
                    <%: Html.Label("Tipo de Vehículo")%>
                </td>
                <td>
                    <%: Html.DropDownList("TipoVehiculo", (SelectList)detalleParticipacionFranquicia.TipoVehiculo, "Seleccione un Valor", new { style = "width:300px;", id = "TipoVehiculo" })%>
                </td>
                <td>Rango Inferior</td>
                <td><%:Html.TextBox("Rangoinferior", ViewData["Rangoinferior"], new { size = 12 })%></td>
            </tr>
            <tr>
                <td><%: Html.Label("Amparo")%></td>
                <td>
                    <%: Html.DropDownList("Amparo_id", (System.Collections.Generic.List<System.Web.Mvc.SelectListItem>)detalleParticipacionFranquicia.Amparo, "Seleccione un Valor", new { style = "width:300px;", id = "Amparo_id" })%>                    
                </td>
                <td>Rango Superior</td>
                <td><%:Html.TextBox("Rangosuperior", ViewData["Rangosuperior"], new { size = 12 })%></td>
            </tr>
             

            <tr>
                <td></td>
                <td>
                <%:Html.Hidden("planes_id", "", new { id = "planes_id" })%>    
                <input type="button" value="Actualizar" onclick="ActualizarMasivo()" id="btnActualizar"/>                 
                </td>
            </tr>
        </table>

    </fieldset>
<% } %>

</asp:Content>
