<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%--ColpatriaSAI.Negocio.Entidades.Moneda--%>
<script type="text/javascript">
    $().ready(function () {
        $("#MonedaConcursoEditar").validate();
        $("#MonedaConcursoEditarCombo").validate();
    });
</script>
<script type="text/javascript">
    $(function () {
        var companias = $("#compania_id_Edit");
        var ramos = $("#ramo_id_Edit");
        var productos = $("#producto_id_Edit");
        var actividadEconomica = $("#actividadEconomica_id_Edit");
        companias.change(function () {
            ramos.find('option').remove();
            $("#producto_id_Edit").attr("disabled", "disabled");
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
        var ramos = $("#ramo_id_Edit");
        var productos = $("#producto_id_Edit");
        var planes = $("#plan_id_Edit");
        ramos.change(function () {
            productos.find('option').remove();
            $("#plan_id_Edit").attr("disabled", "disabled");
            $("#producto_id_Edit").removeAttr("disabled");
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
        var ramos = $("#ramo_id_Edit");
        var tiposVehiculo = $("#tipoVehiculo_id_Edit");
        ramos.change(function () {
            tiposVehiculo.find('option').remove();
            $("#tipoVehiculo_id_Edit").removeAttr("disabled");
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
        var zonas = $("#zona_id_Edit");
        var localidades = $("#localidad_id_Edit");
        zonas.change(function () {
            localidades.find('option').remove();
            $("#localidad_id_Edit").removeAttr("disabled");
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
        var productos = $("#producto_id_Edit");
        var planes = $("#plan_id_Edit");
        productos.change(function () {
            planes.find('option').remove();
            $("#plan_id_Edit").removeAttr("disabled");
            $.getJSON('/MonedaxNegocio/getPlanes', { producto_id: productos.val() }, function (data) {
                $("<option value='0' selected>Todas</option>").appendTo(planes);
                $(data).each(function () {
                    $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(planes);
                });
            });
        });
    });

    function validarCombinacionesEdit() {

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

        if ($("#compania_id_Edit").val() != 0) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#ramo_id_Edit").val() != 0 && $("#ramo_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#producto_id_Edit").val() != 0 && $("#producto_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#plan_id_Edit").val() != 0 && $("#plan_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#lineaNegocio_id_Edit").val() != 0 && $("#lineaNegocio_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#amparo_id_Edit").val() != "") combinacionActual += "1"; else combinacionActual += "0";
        if ($("#modalidadPago_id_Edit").val() != 0 && $("#modalidadPago_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#actividadEconomica_id").val() != 0 && $("#actividadEconomica_id").val() != "null" && $("#actividadEconomica_id").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#red_id_Edit").val() != 0 && $("#red_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#banco_id_Edit").val() != 0 && $("#banco_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#segmento_id_Edit").val() != 0 && $("#segmento_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#tipoVehiculo_id_Edit").val() != 0 && $("#tipoVehiculo_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#zona_id_Edit").val() != 0 && $("#zona_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";
        if ($("#localidad_id_Edit").val() != 0 && $("#localidad_id_Edit").val() != null) combinacionActual += "1"; else combinacionActual += "0";

        $.each(combinaciones, function (i, val) { if (val == combinacionActual) resultado = true; });

        if (!resultado)
            mostrarError("La parametrización no es una combinación valida");


        return resultado;
    }

    function monedaEditSave() {

        if ($("#MonedaConcursoEditar").valid() && validarCombinacionesEdit()) {
            $("#actualizar").attr('disabled', true);
            $("#MonedaConcursoEditar").submit();
            mostrarCargando("Enviando informacion. Espere Por Favor...");
        }
    }

    function monedaEditSaveCombo() {

        if ($("#MonedaConcursoEditarCombo").valid()) {
            $("#actualizarCombo").attr('disabled', true);
            $("#MonedaConcursoEditarCombo").submit();
            mostrarCargando("Enviando informacion. Espere Por Favor...");
        }
    }

</script>
<script type="text/javascript">
    function ValidateNmber(obj, evt) {
        var texto = $("#factor").val();
        var charCode = (evt.which) ? evt.which : event.keyCode;
        var operatorComman = texto.indexOf(',');
        var operatorpoint = texto.indexOf('.');
        if (charCode == 46) {
            return true;
        }
        if ((charCode == 188 || charCode == 190) && (operatorComman < 0 && operatorpoint < 0)) {
            return true;
        }
        else {
            if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105)) {
                mostrarError("Solo valores numéricos");
                return false;
            }
            else {
                return true;
            }
        }
    }
    </script>
<% if (ViewBag.Combo == 0)
   { %>
<div>
    <h4>
        Combinaciones válidas</h4>
    <div>
        <a href="#" onclick="$('#combinacionesEditar').toggle('slow')">Ver combinaciones</a></div>
    <ul id="combinacionesEditar" style="display: none; position: absolute; background-color: #EEE;
        border: 1px solid #CCC; padding-top: 5px; padding-bottom: 5px;">
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
    <div style="clear: both;">
        <hr />
    </div>
</div>
<% using (Html.BeginForm("Editar", "MonedaxNegocio", FormMethod.Post, new { id = "MonedaConcursoEditar" }))
   {
       Html.ValidationSummary(true); %>
<% ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel monedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel)ViewData["MonedaxNegocioViewModel"]; %>
<table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0"
    cellpadding="2">
    <tr>
        <td>
            <%: Html.Label("Linea de Negocio") %>
        </td>
        <td>
            <%: Html.DropDownList("lineaNegocio_id_Edit", (SelectList)monedaxnegocio.LineaNegocioList, "Todas", new { style = "width:150px;" })%>
        </td>
        <td>
            <%: Html.Label("Amparo") %>
        </td>
        <td>
            <%: Html.DropDownList("amparo_id_Edit", (SelectList)monedaxnegocio.AmparoList, "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <u>
                <%: Html.Label("Compañia") %></u>
        </td>
        <td>
            <%: Html.DropDownList("compania_id_Edit", (SelectList)monedaxnegocio.CompaniaList, "Seleccione un Valor", new { @class = "required", style = "width:150px;", id = "compania_id_Edit" })%>
        </td>
        <td>
            <%: Html.Label("Actividad Economica")%>
        </td>
        <td>
            <%: Html.DropDownList("actividadEconomica_id_Edit",(SelectList)monedaxnegocio.ActividadEconomicaList , "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <u>
                <%: Html.Label("Ramo") %></u>
        </td>
        <td>
            <%: Html.DropDownList("ramo_id_Edit", (SelectList)monedaxnegocio.RamoList, "Seleccione un Valor", new { style = "width:150px;", id = "ramo_id_Edit", @class = "required" })%>
        </td>
        <td>
            <%: Html.Label("Modalidad de Pago") %>
        </td>
        <td>
            <%: Html.DropDownList("modalidadPago_id_Edit", (SelectList)monedaxnegocio.ModalidadPagoList, "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Producto") %>
        </td>
        <td>
            <%: Html.DropDownList("producto_id_Edit", (SelectList)monedaxnegocio.ProductoList, "Todas", new {style = "width:150px;", id = "producto_id_Edit" })%>
        </td>
        <td>
            <u>
                <%: Html.Label("Factor") %></u>
        </td>
        <td>
            <%: Html.TextBox("factor", String.Format("{0:0.00}", monedaxnegocio.MonedaxNegocioView.factor), new { onkeydown = "javascript:return ValidateNmber(this,event);", @class = "required decimal", id = "factor" })%>
            <%: Html.ValidationMessageFor(model => monedaxnegocio.MonedaxNegocioView.factor)%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Plan") %>
        </td>
        <td>
            <%: Html.DropDownList("plan_id_Edit", (SelectList)monedaxnegocio.PlanList, "Todas", new {style = "width:150px;", id = "plan_id_Edit" })%>
        </td>
        <td>
            <%: Html.Label("Red") %>
        </td>
        <td>
            <%: Html.DropDownList("red_id_Edit", (SelectList)monedaxnegocio.RedList, "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Banco")%>
        </td>
        <td>
            <%: Html.DropDownList("banco_id_Edit", (SelectList)monedaxnegocio.BancoList, "Todas", new { style = "width:150px;" })%>
        </td>
        <td>
            <%: Html.Label("Segmento")%>
        </td>
        <td>
            <%: Html.DropDownList("segmento_id_Edit", (SelectList)monedaxnegocio.SegmentoList, "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Tipo Vehiculo")%>
        </td>
        <td>
            <%: Html.DropDownList("tipoVehiculo_id_Edit", (SelectList)monedaxnegocio.TipoVehiculoList, "Todos", new { style = "width:150px;", id = "tipoVehiculo_id_Edit" })%>
        </td>
        <td>
            <%: Html.Label("Zona")%>
        </td>
        <td>
            <%: Html.DropDownList("zona_id_Edit", (SelectList)monedaxnegocio.ZonaList, "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
    <tr>
        <td>
            <%: Html.Label("Localidad")%>
        </td>
        <td>
            <%: Html.DropDownList("localidad_id_Edit", new List<SelectListItem>(), "Todas", new { style = "width:150px;" })%>
        </td>
    </tr>
</table>
<input type="hidden" id="maestromoneda_id" name="maestromoneda_id" value="<%: ViewData["value"] %>" />
<p align="center">
    <input type="button" id="actualizar" value="Actualizar" onclick="monedaEditSave()" /></p>
<% } %>
<% } %>
<% else if (ViewBag.Combo != 0)
   { %>
<% using (Html.BeginForm("Editar", "MonedaxNegocio", FormMethod.Post, new { id = "MonedaConcursoEditarCombo" }))
   {
       Html.ValidationSummary(true); %>
<% ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel monedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MonedaxNegocioViewModel)ViewData["MonedaxNegocioViewModel"]; %>
<div style="background-position: center; margin: 25px 75px 25px 75px; padding: 20px;
    border: 1px solid #c2c2c2;">
    <center>
        <h3>
            COMBOS</h3>
        <table id="contenidoEditarCombo" class="tablesorter" width="100%" border="0" cellspacing="0"
            cellpadding="2" style="margin: 10px;">
            <tr>
                <td align="left">
                    <u>
                        <%: Html.Label("Combo") %>
                    </u>
                </td>
                <td align="right">
                    <%: Html.DropDownList("combo_id_Edit", (SelectList)monedaxnegocio.ComboList, "Seleccione un Valor", new { @class = "required", style = "width:150px;", id = "compania_id_Edit" })%>
                </td>
            </tr>
            <tr>
                <td align="left">
                    <u>
                        <%: Html.Label("Factor") %></u>
                </td>
                <td align="right">
                    <%: Html.TextBox("factor_Edit", String.Format("{0:0.00}",monedaxnegocio.MonedaxNegocioView.factor), new { @class = "required decimal"})%>
                    <%: Html.ValidationMessageFor(model => monedaxnegocio.MonedaxNegocioView.factor)%>
                </td>
            </tr>
        </table>
    </center>
</div>
<div style="background-position: center; margin: 25px">
    <p align="center">
        <input type="button" id="actualizarCombo" value="Actualizar" onclick="monedaEditSaveCombo()" /></p>
</div>
<% } %>
<% } %>
