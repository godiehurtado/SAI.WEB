<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Monedas por producto - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 350, width: 650, modal: true, title: titulo,
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
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true
            , "sPaginationType": "full_numbers"
            , "bStateSave": true
            , "sScrollX": "150%"
            , "sScrollXInner": "160%"
            , "bScrollCollapse": false
            });
            $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            $("#lineaNegocio_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#compania_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#amparo_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#actividadEconomica_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#modalidadPago_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#red_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#banco_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#segmento_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#tipoVehiculo_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#zona_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#localidad_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
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
    <script type="text/javascript">
        $().ready(function () {
            $("#formMonedaConcurso").validate();
            $("#formMonedaConcursoCombo").validate();
        });

        function validarCombinaciones() {

            var combinacionActual = "";
            var resultado = false;
            var combinaciones = { "CRP": "11100000000000", "CRPLnAMp": "11101110000000", "CRA": "11000100000000", "CRPPlLn": "11111000000000",
                "CR": "11000000000000", "CRLnAMpAe": "11001111000000", "CRLnAAe": "11001101000000", "CRPPl": "11110000000000", "CRPA": "11100100000000",
                "CRRe": "11000000100000", "CRPRe": "11100000100000", "CRLnRe": "11001000100000", "CRLnA": "11001100000000", "CRPLn": "11101000000000", "CRPLnA": "11101100000000",
                "CRPLnAMpAe": "11101111000000", "CRLn": "11001000000000", "CRReB": "11000000110000", "CRPReB": "11100000110000", "CRLnReB": "11001000110000",
                "CRPLnReB": "11101000110000", "CRS": "11000000001000", "CRLnS": "11001000001000", "CRPPlLnS": "11111000001000", "CRPLnS": "11101000001000",
                "CRPLnTv": "11101000000100", "CRPTv": "11100000000100", "CRPLnB": "11101000010000", "CRPLnRe": "11101000100000", "CRPPlLnB": "11111000010000", "CRPPlLnRe": "11111000100000",

                "CRPZL": "11100000000011", "CRPLnAMpZL": "11101110000011", "CRAZL": "11000100000011", "CRPPlLnZL": "11111000000011",
                "CRZL": "11000000000011", "CRLnAMpAeZL": "11001111000011", "CRLnAAeZL": "11001101000011", "CRPPlZL": "11110000000011", "CRPAZL": "11100100000011",
                "CRReZL": "11000000100011", "CRPReZL": "11100000100011", "CRLnReZL": "11001000100011", "CRLnAZL": "11001100000011", "CRPLnZL": "11101000000011", "CRPLnAZL": "11101100000011",
                "CRPLnAMpAeZL": "11101111000011", "CRLnZL": "11001000000011", "CRReBZL": "11000000110011", "CRPReBZL": "11100000110011", "CRLnReBZL": "11001000110011",
                "CRPLnReBZL": "11101000110011", "CRSZL": "11000000001011", "CRLnSZL": "11001000001011", "CRPPlLnSZL": "11111000001011", "CRPLnSZL": "11101000001011",
                "CRPLnTvZL": "11101000000111", "CRPTvZL": "11100000000111", "CRPLnBZL": "11101000010011", "CRPLnReZL": "11101000100011", "CRPPlLnBZL": "11111000010011", "CRPPlLnReZL": "11111000100011",

                "CRPZ": "11100000000010", "CRPLnAMpZ": "11101110000010", "CRAZ": "11000100000010", "CRPPlLnZ": "11111000000010",
                "CRZ": "11000000000010", "CRLnAMpAeZ": "11001111000010", "CRLnAAeZ": "11001101000010", "CRPPlZ": "11110000000010", "CRPAZ": "11100100000010",
                "CRReZ": "11000000100010", "CRPReZ": "11100000100010", "CRLnReZ": "11001000100010", "CRLnAZ": "11001100000010", "CRPLnZ": "11101000000010", "CRPLnAZ": "11101100000010",
                "CRPLnAMpAeZ": "11101111000010", "CRLnZ": "11001000000010", "CRReBZ": "11000000110010", "CRPReBZ": "11100000110010", "CRLnReBZ": "11001000110010",
                "CRPLnReBZ": "11101000110010", "CRSZ": "11000000001010", "CRLnSZ": "11001000001010", "CRPPlLnSZ": "11111000001010", "CRPLnSZ": "11101000001010",
                "CRPLnTvZ": "11101000000110", "CRPTvZ": "11100000000110", "CRPLnBZ": "11101000010010", "CRPLnReZ": "11101000100010", "CRPPlLnBZ": "11111000010010", "CRPPlLnReZ": "11111000100010",
                "CAe": "11000001000000"
            };

            if ($("#compania_id").val() != 0) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#ramo_id").val() != 0 && $("#ramo_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#producto_id").val() != 0 && $("#producto_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#plan_id").val() != 0 && $("#plan_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#lineaNegocio_id").val() != 0 && $("#lineaNegocio_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#amparo_id").val() != "") combinacionActual += "1"; else combinacionActual += "0";
            if ($("#modalidadPago_id").val() != 0 && $("#modalidadPago_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#actividadEconomica_id").val() != 0 && $("#actividadEconomica_id").val() != "null" && $("#actividadEconomica_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#red_id").val() != "" && $("#red_id").val() != 0 && $("#red_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#banco_id").val() != 0 && $("#banco_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#segmento_id").val() != 0 && $("#segmento_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#tipoVehiculo_id").val() != 0 && $("#tipoVehiculo_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#zona_id").val() != 0 && $("#zona_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
            if ($("#localidad_id").val() != 0 && $("#localidad_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";

            $.each(combinaciones, function (i, val) { if (val == combinacionActual) resultado = true; });

            if (!resultado)
                mostrarError("La parametrización no es una combinación valida");
            return resultado;
        }

        function monedaSave() {
            if ($("#formMonedaConcurso").valid() && validarCombinaciones()) {
                $("#guardar").attr('disabled', true);
                $("#formMonedaConcurso").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }

        function monedaSavexCombo() {
            if ($("#formMonedaConcursoCombo").valid()) {
                $("#guardarCombo").attr('disabled', true);
                $("#formMonedaConcursoCombo").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>
    <script type="text/javascript">
        $(function () {
            var companias = $("#compania_id");
            var ramos = $("#ramo_id");
            var productos = $("#producto_id");
            var actividadEconomica = $("#actividadEconomica_id");
            companias.change(function () {
                ramos.find('option').remove();
                $("#producto_id").attr("disabled", "disabled");
                $("<option value='0' selected>Todas</option>").appendTo(productos);
                //Carga el combo de Ramos de acuerdo a la compañia
                $.getJSON('/MonedaxNegocio/getRamos', { compania_id: companias.val() }, function (data) {
                    $("<option value='null' selected>Seleccione un Valor</option>").appendTo(ramos);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                    });
                });
                //Carga el Combo de Actividad por Negocio de acuerdo a la compañia
                actividadEconomica.find('option').remove();
                $.getJSON('/MonedaxNegocio/getActividaEconomicaByCompany', { companiaID: companias.val() }, function (data) {
                    $("<option value='' selected>Todos</option>").appendTo(actividadEconomica);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(actividadEconomica);
                    });
                });
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            var ramos = $("#ramo_id");
            var productos = $("#producto_id");
            var planes = $("#plan_id");
            ramos.change(function () {
                productos.find('option').remove();
                $("#plan_id").attr("disabled", "disabled");
                $("#producto_id").removeAttr("disabled");
                $.getJSON('/MonedaxNegocio/getProductos', { ramo_id: ramos.val() }, function (data) {
                    $("<option value='0' selected>Todas</option>").appendTo(productos);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                    });
                });
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            var productos = $("#producto_id");
            var planes = $("#plan_id");
            productos.change(function () {
                planes.find('option').remove();
                $("#plan_id").removeAttr("disabled");
                $.getJSON('/MonedaxNegocio/getPlanes', { producto_id: productos.val() }, function (data) {
                    $("<option value='0' selected>Todas</option>").appendTo(planes);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(planes);
                    });
                });
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            var ramos = $("#ramo_id");
            var tiposVehiculo = $("#tipoVehiculo_id");
            ramos.change(function () {
                tiposVehiculo.find('option').remove();
                $("#tipoVehiculo_id").removeAttr("disabled");
                $.getJSON('/MonedaxNegocio/getTiposVehiculo', { ramo_id: ramos.val() }, function (data) {
                    $("<option value='0' selected>Todas</option>").appendTo(tiposVehiculo);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.Nombre + "</option>").appendTo(tiposVehiculo);
                    });
                });
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            var zonas = $("#zona_id");
            var localidades = $("#localidad_id");
            zonas.change(function () {
                localidades.find('option').remove();
                $("#localidad_id").removeAttr("disabled");
                $.getJSON('/MonedaxNegocio/getLocalidades', { zona_id: zonas.val() }, function (data) {
                    $("<option value='0' selected>Todas</option>").appendTo(localidades);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
                    });
                });
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            $("#tabs").tabs({
            });
        });
    </script>
    <script type="text/javascript">
        function ValidateNmber(obj, evt) 
        {
            var texto = $("#factor").val();
            var charCode = (evt.which) ? evt.which : event.keyCode;
            var operatorComman = texto.indexOf(',');
            var operatorpoint = texto.indexOf('.');
            if (charCode == 46)
            {
                return true;
            }
            if ((charCode == 188 || charCode == 190) && (operatorComman < 0 && operatorpoint < 0)) 
            {
                return true;
            }
            else 
            {
                if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105))
                {
                    mostrarError("Solo valores numéricos");
                    return false;
                }
                else 
                {
                    return true;
                }
            }
        }
    </script>
    <script type="text/javascript">        javascript: window.history.forward(1);</script>
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <div id="tabs">
        <ul>
            <li><a href="#ParametrizacionColquines">Tabla de Colquines (Sencilla)</a></li>
            <li><a href="#Combo">Tabla de Colquines (Combos)</a></li>
        </ul>
        <div id="ParametrizacionColquines">
            <div id="encabezadoConcurso">
                <div id="infoPasoActual">
                    <div>
                        <div>
                            <a href="#" onclick="$('#combinaciones').toggle('slow')">Ver combinaciones válidas</a>
                        </div>
                        <br />
                        <ul id="combinaciones" style="display: none; position: absolute; background-color: #EEE;
                            border: 1px solid #CCC; padding-top: 10px; padding-bottom: 10px; z-index: 100">
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Amparo + Modalidad de Pago + Actividad
                                Económica </li>
                            <li>Compañía + Ramo + Línea de Negocio + Amparo + Modalidad de Pago + Actividad Económica
                            </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Amparo + Modalidad de Pago </li>
                            <li>Compañía + Ramo + Línea de Negocio + Amparo + Actividad Económica </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Red + Banco </li>
                            <li>Compañía + Ramo + Producto + Plan + Linea de Negocio + Banco </li>
                            <li>Compañía + Ramo + Producto + Plan + Linea de Negocio + Red </li>
                            <li>Compañía + Ramo + Producto + Plan + Linea de Negocio + Segmento </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Amparo</li>
                            <li>Compañía + Ramo + Línea de Negocio + Red + Banco </li>
                            <li>Compañía + Ramo + Producto + Red + Banco </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Red </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Banco </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Segmento </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio + Tipo Vehiculo </li>
                            <li>Compañía + Ramo + Producto + Línea de Negocio </li>
                            <li>Compañía + Ramo + Línea de Negocio + Red </li>
                            <li>Compañía + Ramo + Producto + Amparo </li>
                            <li>Compañía + Ramo + Producto + Plan + Linea de Negocio </li>
                            <li>Compañía + Ramo + Producto + Plan </li>
                            <li>Compañía + Ramo + Producto + Red </li>
                            <li>Compañía + Ramo + Producto + Tipo Vehiculo </li>
                            <li>Compañía + Ramo + Línea de Negocio + Amparo </li>
                            <li>Compañía + Ramo + Red + Banco </li>
                            <li>Compañía + Ramo + Línea de Negocio + Segmento </li>
                            <li>Compañía + Ramo + Línea de Negocio </li>
                            <li>Compañía + Ramo + Actividad Economica</li>
                            <li>Compañía + Ramo + Amparo </li>
                            <li>Compañía + Ramo + Producto </li>
                            <li>Compañía + Ramo + Segmento </li>
                            <li>Compañía + Ramo + Red </li>
                            <li>Compañía + Ramo </li>
                            <li>* Las mismas combinaciones aplican para la variable Zona </li>
                            <li>** Las mismas combinaciones aplican para las variables Zona + Localidad </li>
                        </ul>
                    </div>
                </div>
                <div style="clear: both;">
                    <hr />
                </div>
            </div>
            <table id="tablaAdmin">
                <tr valign="top">
                    <td>
                        <% using (Html.BeginForm("Crear", "MonedaxNegocio", FormMethod.Post, new { id = "formMonedaConcurso" }))
                           {
                               Html.ValidationSummary(true); %>
                        <% ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel monedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel)ViewData["MonedaxNegocioViewModel"]; %>
                        <fieldset style="border: 1px solid gray">
                            <table>
                                <tr>
                                    <td>
                                        <%: Html.Label("Línea de Negocio")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("lineaNegocio_id", (SelectList)monedaxnegocio.LineaNegocioList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Amparo")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("amparo_id", (SelectList)monedaxnegocio.AmparoList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <u>
                                            <%: Html.Label("Compañía")%></u>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("compania_id", (SelectList)monedaxnegocio.CompaniaList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Actividad Economica")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("actividadEconomica_id", new List<SelectListItem>(), "Todos", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <u>
                                            <%: Html.Label("Ramo")%></u>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("ramo_id", new List<SelectListItem>(), "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Modalidad de Pago")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("modalidadPago_id", (SelectList)monedaxnegocio .ModalidadPagoList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%: Html.Label("Producto")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("producto_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;" })%>
                                    </td>
                                    <td>
                                        <u>
                                            <%: Html.Label("Factor") %></u>
                                    </td>
                                    <td>
                                        <%: Html.TextBox("factor", null, new { onkeydown = "javascript:return ValidateNmber(this,event);", @class = "required decimal", id = "factor" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%: Html.Label("Plan")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("plan_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Red")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("red_id", (SelectList)monedaxnegocio.RedList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%: Html.Label("Banco")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("banco_id", (SelectList)monedaxnegocio.BancoList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Segmento")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("segmento_id", (SelectList)monedaxnegocio.SegmentoList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%: Html.Label("Tipo Vehiculo")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("tipoVehiculo_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;" })%>
                                    </td>
                                    <td>
                                        <%: Html.Label("Zona")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("zona_id", (SelectList)monedaxnegocio.ZonaList, "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <%: Html.Label("Localidad")%>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("localidad_id", new List<SelectListItem>(), "Todas", new { style = "width:300px;" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="hidden" id="maestromoneda_id" name="maestromoneda_id" value="<%: ViewData["value"] %>" />
                                        <input type="button" id="guardar" value="Guardar" onclick="monedaSave()" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
        <div id="Combo">
            <table>
                <tr valign="top">
                    <td>
                        <% using (Html.BeginForm("CrearCombo", "MonedaxNegocio", FormMethod.Post, new { id = "formMonedaConcursoCombo" }))
                           {
                               Html.ValidationSummary(true); %>
                        <% ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel monedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel)ViewData["MonedaxNegocioViewModel"]; %>
                        <fieldset style="border: 1px solid gray">
                            <table>
                                <tr>
                                    <td>
                                        <u>
                                            <%: Html.Label("Combo")%></u>
                                    </td>
                                    <td>
                                        <%: Html.DropDownList("combo_id", (SelectList)monedaxnegocio.ComboList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <u>
                                            <%: Html.Label("Factor") %></u>
                                    </td>
                                    <td>
                                        <%: Html.TextBox("factor", null, new { onkeydown = "javascript:return ValidateNmber(this,event);", @class = "required decimal", id = "factorCombo" })%>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" id="guardarCombo" value="Guardar" onclick="monedaSavexCombo()" />
                                    </td>
                                    <td colspan="3">
                                        Recuerde usar "," (coma) para identificar los números decimales
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <table style="margin: 5px;">
        <tr>
            <td>
                <a href="<%= Url.Action("Index", "MaestroMonedaxNegocio") %>" id="bAnterior" title='Atrás'>
                    Anterior</a>
            </td>
        </tr>
    </table>
    <table id="tablaLista">
        <thead>
            <tr>
                <th align="center">
                    Opciones
                </th>
                <th align="center">
                    Factor
                </th>
                <th align="center">
                    L.Negocio
                </th>
                <th align="center">
                    Compañia
                </th>
                <th align="center">
                    Ramo
                </th>
                <th align="center">
                    Producto
                </th>
                <th align="center">
                    Tipo Vehiculo
                </th>
                <th align="center">
                    Plan
                </th>
                <th align="center">
                    Segmento
                </th>
                <th align="center">
                    Amparo
                </th>
                <th align="center">
                    M.Pago
                </th>
                <th align="center">
                    A. Econom.
                </th>
                <th align="center">
                    Red
                </th>
                <th align="center">
                    Banco
                </th>
                <th align="center">
                    Zona
                </th>
                <th align="center">
                    Localidad
                </th>
                <th align="center">
                    Combo
                </th>
            </tr>
        </thead>
        <tbody>
              <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
            <% Random random = new Random();
               int num = random.Next(1, 10000);  %>
            <% foreach (var item in ((IEnumerable<MonedaxNegocio>)ViewData["MonedaxNegocios"]))
               { %>
            <tr>
                <td align="center">
                    <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');"
                        style='float: left;' title='Editar Detalle Moneda'><span class='ui-icon ui-icon-pencil' />
                        >Editar</a> <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');"
                            style='float: right;' title='Eliminar Detalle Moneda'><span class='ui-icon ui-icon-trash' />
                        </a>
                </td>
                <td align="center">
                    <%: String.Format("{0:0.00}",item.factor) %>
                </td>
                <td align="center">
                    <%: item.LineaNegocio.nombre %>
                </td>
                <td align="center">
                    <%: item.Compania.nombre %>
                </td>
                <td align="center">
                    <%: item.Ramo.nombre %>
                </td>
                <td align="center">
                    <%: item.Producto.nombre %>
                </td>
                <td align="center">
                    <%: item.TipoVehiculo.Nombre %>
                </td>
                <td align="center">
                    <%: item.Plan.nombre %>
                </td>
                <td align="center">
                    <%: item.Segmento.nombre %>
                </td>
                <td align="center">
                    <%: item.Amparo.nombre %>
                </td>
                <td align="center">
                    <%: item.ModalidadPago.nombre %>
                </td>
                <td align="center">
                    <%: item.ActividadEconomica.nombre %>
                </td>
                <td align="center">
                    <%: item.Red.nombre %>
                </td>
                <td align="center">
                    <%: item.Banco.nombre %>
                </td>
                <td align="center">
                    <%: item.Zona.nombre %>
                </td>
                <td align="center">
                    <%: item.Localidad.nombre %>
                </td>
                <td align="center">
                    <%: item.Combo.nombre %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id='dialogEditar' style="display: none;">
    </div>
    <div id='dialogEliminar' style="display: none;">
    </div>
</asp:Content>
