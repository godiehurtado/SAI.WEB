<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Condiciones del Concurso - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 250, width: 650, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close"); $(this).dialog('destroy');
                    }
                },
                title: titulo,
                open: function (event, ui) { $(".ui-dialog-titlebar-close").hide(); $(this).load(pagina); },
                beforeclose: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 180, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialogVariable(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 520, width: 700, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close"); $(this).dialog('destroy');
                    }
                },
                title: titulo,

                open: function (event, ui) { $(this).load(pagina); }
                //close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialogVariable_Edit(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 520, width: 700, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close"); ; $(this).dialog('destroy');
                    }
                },
                title: titulo,

                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function cerrarDialog(dialog) {
            $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
            $("#operador_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });

            $("#campoSeleccion").hide("slow");
            $("#campoValor").hide("slow");
            $("#campoFecha").hide("slow");
            $("#campoMes").hide("slow");

            /*$("#ddlMesInicio").htmlAttributes(new { style = "width:200px;", @class = "required", title = "Seleccionar Operador" });*/

            var meses = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
            var i = 0;
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i+1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesInicio"));
            }
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i+1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin"));
            }

            var variable = $('#seleccionVariable');
            variable.change(function () {
                $('#seleccion').find('option').remove();
                $.getJSON('/Condicion/ListarTablas', { idtabla: variable.val() },
                    function (data) {
                        $("<option value='0' selected>--Seleccione--</option>").appendTo($('#seleccion'));
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#seleccion'));
                        });
                    });

                $.getJSON('/Condicion/ListarTipoDato', { idtabla: variable.val() },
                    function (data) {
                        if (data == "Fecha") {
                            $("#campoSeleccion").hide("slow");
                            $("#campoValor").hide("slow");
                            $("#campoFecha").show("slow");
                            $("#campoMes").hide("slow");
                        } else if (data == "Numero") {
                            $("#campoSeleccion").hide("slow");
                            $("#campoValor").show("slow");
                            $("#campoFecha").hide("slow");
                            $("#campoMes").show("slow");
                        } else if (data == "Seleccion") {
                            $("#campoSeleccion").show("slow");
                            $("#campoValor").hide("slow");
                            $("#campoFecha").hide("slow");
                            $("#campoMes").hide("slow");
                        }
                    });
            });

                $("#ddlMesInicio").change(function () {
                    $("#ddlMesFin").find('option').remove();
                    var mesini = $("#ddlMesInicio").val();
                    var i = mesini - 1;
                    for (i; i < 12; i++) {
                        $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin"));
                    }
            });
        });

        function seleccionarVariable(idVariable, nombreV) {
            $("#variable_id").val(idVariable);
            $("#variable").html(nombreV + ":" + "&nbsp;&nbsp;&nbsp;");
            $('#seleccion').find('option').remove();
            $.getJSON('/Condicion/ListarTablas', { idtabla: idVariable },
                    function (data) {
                        $("<option value='0' selected>--Seleccione--</option>").appendTo($('#seleccion'));
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#seleccion'));
                        });
                    });

            $.getJSON('/Condicion/ListarTipoDato', { idtabla: idVariable },
                    function (data) {
                        if (data == "Fecha") {
                            $("#campoSeleccion").hide("slow");
                            $("#campoValor").hide("slow");
                            $("#campoFecha").show("slow");
                            $("#campoMes").hide("slow");
                        } else if (data == "Numero") {
                            $("#campoSeleccion").hide("slow");
                            $("#campoValor").show("slow");
                            $("#campoFecha").hide("slow");
                            $("#campoMes").show("slow");
                        } else if (data == "Seleccion") {
                            $("#campoSeleccion").show("slow");
                            $("#campoValor").hide("slow");
                            $("#campoFecha").hide("slow");
                            $("#campoMes").hide("slow");
                        }
                    });
            $("#dialogVariable").dialog('destroy'); $("#dialogVariable").dialog("close");

        }

        function nombreSeleccion() {
            $('#textoSeleccion').val($("#seleccion :selected").text());
        }

        $(function () {
            $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            $("#seleccion option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
        });
    </script>
    <%--DATEPICKER --%>
    <script type="text/javascript">
        $(function () {
            var dates = $("#FechaInicio, #FechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "FechaInicio" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });       
    </script>
    <script type="text/javascript">
        function condicionSave() {
            if ($("#formCondicion").valid()) {
                $("#crear").attr('disabled', true);
                $("#formCondicion").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>
    <script type="text/javascript">        javascript: window.history.forward(1);</script>
    <div id="encabezadoConcurso" align="center">
        <div id="infoPasoActual" align="center">
            <h2>
                Paso 3: Reglas y Premios: Crear nueva condición
            </h2>
            <div>
                <%: ViewData["Concursos"] + " > Regla: " + "" + ViewData["Reglas"] + " > " + "Subregla: " + ViewData["subReglas"]%></div>
        </div>
        <div id="progreso" align="center">
            <ul id="pasos">
                <li>1. <a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>"
                    id="A1">Participantes</a></li>
                <li>2. <a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>"
                    id="A2">Productos</a></li>
                <li><b>3.Reglas y Premios</b></li>
            </ul>
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
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
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <fieldset>
        <table id="tablaAdmin" width="100%" cellpadding="2">
            <% using (Html.BeginForm("Crear", "Condicion", FormMethod.Post, new { id = "formCondicion" }))
               {
                   Html.ValidationSummary(true); %>
            <% ColpatriaSAI.UI.MVC.Models.CondicionViewModel condicion = (ColpatriaSAI.UI.MVC.Models.CondicionViewModel)ViewData["CondicionViewModel"]; %>
            <thead>
                <tr>
                    <th align="center">
                        <a href="javascript:mostrarDialogVariable('<%: ruta %>Variable1?r=<%: num %>&concurso_id=<%: ViewData["value"] %>&subregla_id=<%: ViewData["valuesr"] %>', 'Variable', 'dialogVariable');"
                            style='float: none;' title='Buscar Variable'>Buscar Variable</a>
                    </th>
                    <th align="center">
                        <%: Html.Label("Operador") %>
                    </th>
                    <th align="center">
                        <%: Html.Label("Valor/Fecha/Selección") %>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <b><span id="variable" style="text-transform: uppercase;">&nbsp;&nbsp;&nbsp;</span></b>
                        <%: Html.Hidden("variable_id", 0 ,new { id = "variable_id"}  ) %>
                    </td>
                    <td>
                        <%: Html.DropDownList("operador_id", (SelectList)condicion.OperadorList, "Seleccione un Valor", new { style = "width:200px;", @class = "required", title = "Seleccionar Operador" })%>
                    </td>
                    <td>
                        <div id="campoSeleccion">
                            <%: Html.DropDownList("seleccion", new List<SelectListItem>(), "Seleccione un Valor", new { style = "width:350px;", @onchange="nombreSeleccion();", title = "Seleccionar Condicion" })%>
                            <div id="seleccionado">
                            </div>
                            <%: Html.Hidden("textoSeleccion") %>
                        </div>
                        <div id="campoValor">
                            <%: Html.TextBox("valor", null, new { title = "Ingresar Valor" })%>
                            <%: Html.ValidationMessageFor(Model => condicion.CondicionView.valor)%>
                        </div>
                        <div id="campoFecha">
                            <%: Html.TextBox("FechaInicio", null, new { @readonly = "true", id = "FechaInicio" })%>
                            <%: Html.ValidationMessageFor(Model => condicion.CondicionView.fecha)%>
                        </div>
                        <div id="campoMes">
                            <table>
                                <tr>
                                    <td>
                                        Mes inicio:
                                    </td>
                                    <td>
                                        <select id="ddlMesInicio" style="width: 100%" name="ddlMesInicio">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Mes fin:
                                    </td>
                                    <td>
                                        <select id="ddlMesFin" style="width: 100%" name="ddlMesFin">
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="Guardar" id="crear" onclick="condicionSave()" />
                    </td>
                    <td>
                        <input type="hidden" id="valorTipoVariable" name="tipovariable" />
                    </td>
                    <td>
                        <input type="hidden" id="subregla_id" name="subregla_id" value="<%: ViewData["valuesr"] %>" />
                    </td>
                    <td>
                        <input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["valuer"] %>" />
                    </td>
                    <td>
                        <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
                    </td>
                </tr>
            </tbody>
        </table>
    </fieldset>
    <table align="center">
        <tr>
            <td>
                <a href="<%= Url.Action("Index", "SubRegla", new { valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }) %>"
                    id="bAnterior" title="Volver al listado de sub-reglas">Anterior</a>
            </td>
            <td>
                <a href="../Concursos" id="bInicio">Inicio</a>
            </td>
        </tr>
    </table>
    <% } %>
    <table id="tablaLista">
        <thead>
            <tr>
                <th align="center">
                    Opciones
                </th>
                <th align="center">
                    Condicion
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in ((IEnumerable<Condicion>)ViewData["Condiciones"]))
               { %>
            <tr>
                <td align="center">
                    <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?idsr=<%: item.subregla_id %>?r=<%: num %>&concurso_id=<%: ViewData["value"] %>&subregla_id=<%: ViewData["valuesr"] %>', 'Editar Condicion', 'dialogEditar');"
                        style='float: left;' title='Editar Condición'><span class='ui-icon ui-icon-pencil' />
                    </a><a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Condicion', 'dialogEliminar');"
                        style='float: center;' title='Eliminar Condición'><span class='ui-icon ui-icon-trash' />
                    </a>
                </td>
                <td align="center">
                    <%: item.descripcion %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id='dialogEditar' style="display: none;">
    </div>
    <div id='dialogEliminar' style="display: none;">
    </div>
    <div id='dialogVariable' style="display: none;">
    </div>
</asp:Content>
