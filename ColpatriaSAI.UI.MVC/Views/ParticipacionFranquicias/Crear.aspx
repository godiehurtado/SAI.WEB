<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Porcentajes de participación franquicias - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%

    var fechaInicial = string.Empty;
    var fechaFinal = string.Empty;
    if (ViewData["FechaInicio"] != null && ViewData["FechaInicio"] != "")
        fechaInicial = this.Model.ParticipacionFranquiciaView.fecha_ini.Year + "-" + this.Model.ParticipacionFranquiciaView.fecha_ini.Month + "-" + this.Model.ParticipacionFranquiciaView.fecha_ini.Day;

    if (ViewData["FechaFin"] != null && ViewData["FechaFin"] != "")
        fechaFinal = this.Model.ParticipacionFranquiciaView.fecha_fin.Year + "-" + this.Model.ParticipacionFranquiciaView.fecha_fin.Month + "-" + this.Model.ParticipacionFranquiciaView.fecha_fin.Day;
%>


    <script type="text/javascript">
        $(document).ready(function () {
            $('#tablaLista').dataTable({ "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });

            $('#FechaInicio').datepicker({ dateFormat: 'yy-mm-dd' });
            $('#FechaFin').datepicker({ dateFormat: 'yy-mm-dd' });

            $.validator.addMethod("numberDecimal", function (value, element) {
                element.value = value.replace('.', ',');
                return this.optional(element) || IsNumeric(value);
            }, "Valid number decimal");

            $("#FormPartFranquicias").validate({
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

            var hoy = new Date();
            var fecha = (hoy.getFullYear() + '/' + hoy.getMonth() + 1) + '/' + hoy.getDate();
            $('#FechaActualizacion').val(fecha);
        });

        $(function () {
            var companias = $("#compania_id");
            var ramos = $("#ramo_id");
            var productos = $("#producto_id");
            var planes = $("#planes_id");
            var tipoVehiculo = $("#TipoVehiculo");
            var Amparo = $("#Amparo_id");

            companias.change(function () {
                if ($("#compania_id option:first-child").index() == 0) {
                    ramos.text("Todos"); ramos.attr("disabled", "disabled");
                }
                ramos.find('option').remove();
                productos.attr("disabled", "disabled");
                planes.attr("disabled", "disabled");
                tipoVehiculo.attr("disabled", "disabled");
                if ($("#compania_id").val() == "2")
                    Amparo.removeAttr("disabled");
                else {
                    Amparo.attr("disabled", "disabled");
                    Amparo.val("Todas");
                }
                $("<option value='0' selected>Seleccione un Valor</option>").appendTo(ramos);
                $("<option value='0' selected>Seleccione un Valor</option>").appendTo(productos);
                $("<option value='0' selected>Seleccione un Valor</option>").appendTo(tipoVehiculo);

                $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                    });
                    ramos.removeAttr("disabled");
                });
            });

            ramos.change(function () {
                productos.find('option').remove();
                $("#TipoVehiculo").find('option').remove();
                productos.removeAttr("disabled");
                tipoVehiculo.attr("disabled", "disabled");

                $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
                    $("<option value='0' selected>Seleccione un Valor</option>").appendTo(productos);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                    });
                    productos.removeAttr("disabled");
                });
                $.getJSON('/ParticipacionFranquicias/getTipoVehiculos', { ramo_id: ramos.val() }, function (data) {
                    var cantidad = 0;
                    $("<option value='0' selected>Seleccione un Valor</option>").appendTo(tipoVehiculo);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.Nombre + "</option>").appendTo(tipoVehiculo);
                        cantidad++;
                    });
                    if (cantidad > 0)
                        tipoVehiculo.removeAttr("disabled");
                });
            });

            productos.change(function () {
                planes.find('option').remove();
                $("#planes_id").removeAttr("disabled");
                $.getJSON('/ProductoConcurso/getPlanes', { producto_id: productos.val() },
                    function (data) {
                        $("<option value='0' selected>Todas</option>").appendTo(planes);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(planes);
                        });
                        planes.removeAttr("disabled");
                    });
            });

            planes.attr("disabled", "disabled");
            tipoVehiculo.attr("disabled", "disabled");
            Amparo.attr("disabled", "disabled");

            if (document.location.pathname.indexOf('Create') != -1)
                $('#formulario').toggle();
        });
    </script>
    <script type="text/javascript">
        function validarCombinaciones() {

            var combinacionActual = "";
            var resultado = false;
            //Compañia-Ramo-Producto-Planes-Linea Negocio-TipoVehiculo-RangoInf-RangoSup-Amparo
            var combinaciones = { "CRPTv": "111001000", "CRP": "111000000", "CRPTvRiRs": "111001110", "CRPRiRs": "111000110",
                "CRPLnA": "111010001", "CRPLnTvA": "111011001", "CRPLn": "111010000", "CRPLnTv": "111011000",
                "CRPLnRiRsA": "111010111", "CRPLnTvRiRsA": "111011111", "CRPLnRiRs": "111010110", "CRPLnTvRiRs": "111011110",
                "CRPA": "111000001", "CRPARiRs": "111000111", "CR":"110000000"
            };

            if ($("#compania_id").val() != 0) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#ramo_id").val() != 0 && $("#ramo_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#producto_id").val() != 0 && $("#producto_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#planes_id").val() != 0 && $("#planes_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#lineaNegocio_id").val() != 0 && $("#lineaNegocio_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#TipoVehiculo").val() != 0 && $("#TipoVehiculo").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#Rangoinferior").val() != "") combinacionActual += "1"; else combinacionActual += "0";
            if ($("#Rangosuperior").val() != "") combinacionActual += "1"; else combinacionActual += "0";
            if ($("#Amparo_id").val() != 0 && $("#Amparo_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";

            $.each(combinaciones, function (i, val) { if (val == combinacionActual) resultado = true; });

            if (!resultado)
                mostrarError("La parametrización de esta participación no es una combinación valida");

            return resultado;
        }

        function porcentajesSave() {

            if ($("#FormPartFranquicias").valid() && validarCombinaciones()) {
                $("#guardar").attr('disabled', true);
                mostrarCargando("Enviando informacion. Espere Por Favor...");
                if ($('#idDetPartFranq').val() != "") {
                    $.ajax({ url: '/DetallePartFranquicia/Edit', data: $("#FormPartFranquicias").serialize(), type: 'POST', async: false,
                        success: function (result) {
                            closeNotify('jNotify');
                            if (result.Success)
                                msj = "Proceso Terminado. Espere por favor...";
                            else
                                msj = "No se actualizaron los registros por duplicidad o error en la base de datos. Espere por favor...";

                            mostrarExito(msj);
                            window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' + document.location.port : '') + '/ParticipacionFranquicias/Edit/' + $("#PartFranqId").val();
                        }
                    });
                }
                else {
                    $.ajax({ url: '/ParticipacionFranquicias/Create', data: $("#FormPartFranquicias").serialize(), type: 'POST', async: false,
                        success: function (result) {
                            closeNotify('jNotify');
                            if (result.Success)
                                msj = "Proceso Terminado. Espere por favor...";
                            else
                                msj = "No se crearon los registros por duplicidad en la base de datos. Espere por favor...";

                            mostrarExito(msj);
                            if ($("#idpartfranq").val() != "")
                                window.location.href = window.location.pathname;
                            else
                                window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' + document.location.port : '') + '/ParticipacionFranquicias/Index/' + $("#PartFranqId").val();
                        }
                    });
                }
            }
        }

        function cancelarEdicion() {
            inicializarControles();
            $('#btnCancelarEdit').css("display", "none");
        }

        function inicializarControles() {
            $('#idDetPartFranq').val('');
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
            $("#Amparo_id").attr("disabled", "disabled");
        }

        function editardata(id) {
            $('#btnCancelarEdit').css("display", "block");
            $("#ramo_id").removeAttr("disabled"); $("#producto_id").removeAttr("disabled");
            $('#tablaLista').attr("disabled", "disabled");
            $('#TipoVehiculo').removeAttr("disabled");


            $("#idDetPartFranq").val(id.toString())
            $('#compania_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#compania' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#ramo_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#ramo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#producto_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#producto' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#lineaNegocio_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#lineanegocio' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#planes_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#plan' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#TipoVehiculo option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#tipovehiculo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });

            if ($("#compania_id").val() == "2")
                $("#Amparo_id").removeAttr("disabled");
            else {
                $("#Amparo_id").attr("disabled", "disabled");
                $("#Amparo_id").val("Todas");
            }


            $('#Amparo_id option').each(function () {
                if (jQuery.trim($(this).text().toLowerCase()) == jQuery.trim($('#Amparo' + id).text().toLowerCase())) $(this).attr('selected', 'selected');
            });
            $('#Porcentaje').val(jQuery.trim($('#porcentaje' + id).text().toLowerCase()))
            $('#Rangoinferior').val(jQuery.trim($('#rangoinferior' + id).text().toLowerCase()));
            $('#Rangosuperior').val(jQuery.trim($('#rangosuperior' + id).text().toLowerCase()));
        }

        function eliminarDetalle(id) {
            if (confirm('¿Esta seguro de eliminar este detalle?')) {
                mostrarCargando(Procesando);
                $.ajax({ url: '/DetallePartFranquicia/Delete', data: { id: id }, type: "POST", async: false,
                    success: function (result) {
                        closeNotify('jNotify');
                        if (result.Success) {
                            mostrarExito("Proceso Terminado. Espere por favor...");
                            window.location.href = window.location.pathname;
                        }
                        else
                            mostrarError("El registro no se pudo eliminar.");
                    }
                });
            }
        }

        function actualizarParticipacionFechas() {

            if ($('#ParticipacionFranquiciaId').val() != "" && $('#FechaInicio').val() != "" && $('#FechaFin').val() != "") {

                $("#actualizarFechas").attr('disabled', true);
                mostrarCargando("Actualizando información. Espere Por Favor...");
                $.ajax({ url: '/ParticipacionFranquicias/SaveParticipacionFechas', data: $("#FormPartFranquicias").serialize(), type: 'POST', async: false,
                    success: function (result) {
                        closeNotify('jNotify');
                        if (result.Success)
                            msj = "Proceso Terminado. Espere por favor...";
                        else
                            msj = "No se actualizó la información por que una de las fechas existe en otro rango. Espere por favor...";

                        mostrarExito(msj);
                        window.location.href = document.location.protocol + '//' + document.location.hostname + (document.location.port != '' ? ':' + document.location.port : '') + '/ParticipacionFranquicias/Edit/' + $("#PartFranqId").val();
                    }
                });
            }
            else {
                mostrarError("Los campos fecha inicial y fecha final son obligatorios.");
            }
        }

    </script>

    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2><%= ViewData["Title"]%></h2>
            <h4><%= ViewData["Localidad"]%></h4>
            <p>
                Puede definir simultaneamente los porcentajes por rangos así como los porcentajes puntuales por producto, ramo, línea de negocio o tipo de vehículo.<br /><br />
                <%: Html.ActionLink("Regresar", "Index", "ParticipacionFranquicias", new { id = int.Parse(Session["idfranquicia"].ToString()) }, null)%>
            </p>
        </div>
        <div id="progresoSeccion">
            <div><a href="#" onclick="$('#combinaciones').toggle('slow')">Ver combinaciones</a></div>
            <ul id="combinaciones" style="display:none; position:absolute; background-color:#EEE; border:1px solid #CCC; padding-top:10px; padding-bottom:10px; ">
                <li>Compañia - Ramo </li>            
                <li>Compañia - Ramo - Producto</li>            
                <li>Compañia - Ramo - Producto - Tipo de vehículo</li>
                <li>Compañia - Ramo - Producto - Tipo de vehículo - Rango inferior - Rango superior</li>
                <li>Compañia - Ramo - Producto - Rango inferior - Rango superior</li>
                <li>Compañia - Ramo - Producto - Linea de negocio</li>                
                <li>Compañia - Ramo - Producto - Linea de negocio - Amparo</li>
                <li>Compañia - Ramo - Producto - Linea de negocio - Amparo - Rango inferior - Rango superior </li>                
                <li>Compañia - Ramo - Producto - Linea de negocio - Tipo de vehículo</li>                
                <li>Compañia - Ramo - Producto - Linea de negocio - Tipo de vehículo - Amparo</li>
                <li>Compañia - Ramo - Producto - Linea de negocio - Tipo de vehículo - Amparo - Rango inferior - Rango superior </li>
                <li>Compañia - Ramo - Producto - Linea de negocio - Tipo de vehículo - Rango inferior - Rango superior</li>
                <li>Compañia - Ramo - Producto - Linea de negocio - Rango inferior - Rango superior</li>
                <li>Compañia - Ramo - Producto - Amparo</li>
                <li>Compañia - Ramo - Producto - Amparo - Rango inferior - Rango superior</li>
                
            </ul>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <div id="processing_message" style="display: none" title="Processing">Procesando la información...</div>
    
<% ColpatriaSAI.UI.MVC.Models.DetalleParticipacionFranquicia DetPartFranquicia = (ColpatriaSAI.UI.MVC.Models.DetalleParticipacionFranquicia)ViewData["ParticipacionFranquiciaViewModel"]; %>

<% using (Html.BeginForm("Edit", "ParticipacionFranquicias", FormMethod.Post, new { id ="FormPartFranquicias" })) { %>
<%: Html.ValidationSummary(true) %>
    <fieldset>
        <legend>Fechas de vigencia</legend>
        <input type="hidden" id="ParticipacionFranquiciaId" name="ParticipacionFranquiciaId" value='<%= ViewData["IdLastFranquicia"] %>' />
        <table cellspacing="2" width="100%">
            <tr>
                <td><label for="FechaInicio">Fecha Inicio:</label></td>
                <td><%= Html.TextBox("FechaInicio", fechaInicial, new { @readonly = "true", @class = "required" })%></td>
                <td><label for="FechaFin">Fecha Fin:</label></td>
                <td><%= Html.TextBox("FechaFin", fechaFinal, new { @readonly = "true", @class = "required" })%></td>
                <td>
                    <%
                       if (ViewData["IdLastFranquicia"] != "" && ViewData["IdLastFranquicia"] != null)
                       {                              
                    %>
                        <input type="button" value="Actualizar Fechas" onclick="actualizarParticipacionFechas();" id="actualizarFechas"/>
                    <%
                       } 
                    %>
                </td>
            </tr>
        </table>

    </fieldset>
    <br />
    <fieldset>
        <legend>Porcentajes de  Participación Franquicia</legend>
        <table cellspacing="2" width="100%">
            <tr>
                <td><%: Html.Label("Compañía")%></td>
                <td><%: Html.DropDownList("compania_id", (SelectList)DetPartFranquicia.Compania, "Seleccione un Valor", new { style = "width:300px;", id = "compania_id", @class = "required" })%></td>
                <td></td><td></td>
            </tr>
            <tr>
                <td><%: Html.Label("Ramo")%></td>
                <td>
                    <%: Html.DropDownList("ramo_id", (SelectList)DetPartFranquicia.Ramo, "Seleccione un Valor", new { style = "width:300px;", id = "ramo_id", @class = "required" })%>
                </td>
                <td></td><td></td>
            </tr>
            <tr>
                <td><%: Html.Label("Producto")%></td>
                <td>
                    <%: Html.DropDownList("producto_id", (SelectList)DetPartFranquicia.Producto, "Seleccione un Valor", new { style = "width:300px;", id = "producto_id" })%>
                </td>
                <td></td><td></td>
            </tr>
            <tr>
                <td><%: Html.Label("Línea de Negocio")%></td>             
                <td>
                    <%: Html.DropDownList("lineaNegocio_id", (System.Collections.Generic.List<System.Web.Mvc.SelectListItem>)DetPartFranquicia.LineaNegocio, "Todas", new { style = "width:300px;", id = "lineaNegocio_id" })%>               
                </td>
                <td><%: Html.Label("Porcentaje")%></td>
                <td>
                     <%:Html.TextBox("Porcentaje", ViewData["Porcentaje"], new {@class = "required", size=5})%>%
                </td>
            </tr>
            <tr>
                <td><%: Html.Label("Tipo de Vehículo")%></td>
                <td>
                    <%: Html.DropDownList("TipoVehiculo", (SelectList)DetPartFranquicia.TipoVehiculo, "Seleccione un Valor", new { style = "width:300px;", id = "TipoVehiculo" })%>                    
                </td>
                <td>Salario minimo</td>
                <td><%: String.Format("{0:C0}",Convert.ToDouble(ViewBag.salarioMinimo)) %></td>
            </tr>
            <tr>
                <td><%: Html.Label("Amparo")%></td>
                <td>
                    <%: Html.DropDownList("Amparo_id", (System.Collections.Generic.List<System.Web.Mvc.SelectListItem>)DetPartFranquicia.Amparo, "Todas", new { style = "width:300px;", id = "Amparo_id"})%>                    
                </td>
                <td>Rango Inferior</td>
                <td><%:Html.TextBox("Rangoinferior", ViewData["Rangoinferior"], new { size = 12 })%></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>Rango Superior</td>
                <td><%:Html.TextBox("Rangosuperior", ViewData["Rangosuperior"], new { size = 12 })%></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="button" id="guardar" value="Guardar" onclick="porcentajesSave()" style="float:left" /> &nbsp;&nbsp;&nbsp;
                    <input type="button" value="Cancelar edición" onclick="cancelarEdicion()" style="display:none; float:left;margin-left:5px; " id="btnCancelarEdit" />
                </td>
                <td colspan="2" rowspan="2"><%--<div id="mensaje" style="color:#FF0000; text-align:center"></div>--%></td>
            </tr>
        </table>
    </fieldset>
    <%:Html.Hidden("idpartfranq", ((string)RouteData.Values["action"] == "Create" ? "" : RouteData.Values["id"]), new { id = "idpartfranq" })%>
    <%:Html.Hidden("PartFranqId", RouteData.Values["id"], new { id = "PartFranqId" })%>
    <%:Html.Hidden("idDetPartFranq", "", new { id = "idDetPartFranq" })%>
    <%:Html.Hidden("planes_id", "", new { id = "planes_id" })%>    
<% } %>
    <fieldset id="formulario" style='display:block'>
        <table class="tbl" id="tablaLista">
            <thead><tr><th>Compañía</th><th>Ramo</th><th>Producto</th><th>Línea de Negocio</th><th>Tipo Vehículo</th>
                    <th>Porcentaje</th><th>Rango Inferior</th><th>Rango Superior</th><th>Amparo</th><th></th></tr>
            </thead>
            <tbody>
            <% if (Model != null && ViewData["Title"].ToString().Trim() != "Crear") {
                   foreach (var item in DetPartFranquicia.DetParticipacionFranquiciaView)
                   { %>
                <tr id='<%= item.id.ToString()%>'>
                    <td id='compania<%= item.id%>'> <% string compania = item.Compania != null ? item.Compania.nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => compania) %>
                    </td>
                    <td id='ramo<%= item.id%>'> <% string ramo = item.Ramo != null ? item.Ramo.nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => ramo) %>
                    </td>
                    <td id='producto<%= item.id%>'> <% string producto = (item.Producto != null) ? item.Producto.nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => producto) %>
                    </td>
                    <%--<td id='plan<%= item.id%>'> <% string plan = (item.Plan != null) ? item.Plan.nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => plan) %>
                    </td>--%>
                    <td id='lineanegocio<%= item.id %>'>
                        <% string linea = "";
                           if (item.lineaNegocio_id == 0) linea = ""; else if (item.lineaNegocio_id == 1) linea = "Primer Año"; else linea = "Renovaciones"; %>
                        <%= Html.DisplayTextFor(i => linea) %>
                    </td>
                    <td id='tipovehiculo<%= item.id %>'>
                        <% string tipo = (item.TipoVehiculo != null) ? item.TipoVehiculo.Nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => tipo) %>
                    </td>
                    <td id='porcentaje<%= item.id%>'><%= Html.DisplayTextFor(i => item.porcentaje) %></td>
                    <td id='rangoinferior<%= item.id%>'><%= Html.DisplayTextFor(i => item.rangoinferior) %></td>
                    <td id='rangosuperior<%= item.id%>'><%= Html.DisplayTextFor(i => item.rangosuperior)%></td>
                    <td id='Amparo<%= item.id%>'>
                        <% string amparo = (item.Amparo != null) ? item.Amparo.nombre : "Todos"; %>
                        <%= Html.DisplayTextFor(i => amparo) %>
                    </td>
                    <td>
                        <a href="#" onclick="editardata(<%: item.id.ToString() %>);" title='Editar' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-pencil' /></a>
                        <a href='javascript:eliminarDetalle(<%: item.id %>)' title='Eliminar' class='ui-state-default ui-corner-all' style='float: left;'><span class='ui-icon ui-icon-trash' /></a>
                    </td>
                </tr>
            <% }
            } %>
            </tbody>
        </table>
    </fieldset>
</asp:Content>
