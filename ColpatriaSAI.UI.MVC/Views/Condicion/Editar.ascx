<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

    <script type="text/javascript">
        $(document).ready(function () {            
            $("#campoSeleccion_Edit").hide("slow");
            $("#campoValor_Edit").hide("slow");
            $("#campoFecha_Edit").hide("slow");
            $("#campoMes_Edit").hide("slow");

            var meses = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
            var i = 0;
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i+1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesInicio_Edit"));
            }
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i+1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin_Edit"));
            }
            
            $("#formCondicionEditar").validate({});
            $.getJSON('/Condicion/ListarTablas', { idtabla: <%: TempData["idVariable"] %> },
                function (data) {                        
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#seleccion_Edit'));
                    });                        
                });
            $.getJSON('/Condicion/ListarTipoDato', { idtabla: <%: TempData["idVariable"] %> },
                function (data) {
                    if (data == "Fecha") {
                        $("#campoSeleccion_Edit").hide("slow");
                        $("#campoValor_Edit").hide("slow");
                        $("#campoFecha_Edit").show("slow"); 
                        $("#campoMes_Edit").hide("slow");                           
                    } else if (data == "Numero") {
                        $("#campoSeleccion_Edit").hide("slow");
                        $("#campoValor_Edit").show("slow");                            
                        $("#campoFecha_Edit").hide("slow");
                        $("#campoMes_Edit").show("slow");
                    } else if (data == "Seleccion") {
                        $("#campoSeleccion_Edit").show("slow");
                        $("#campoValor_Edit").hide("slow");
                        $("#campoFecha_Edit").hide("slow");
                        $("#campoMes_Edit").hide("slow");
                    }
                });
            
            $("#ddlMesInicio_Edit").val(<%=TempData["mesinicio"] %>);
            $("#ddlMesFin_Edit").val(<%=TempData["mesfin"] %>);

            setTimeout(function () {
                $('#seleccion_Edit').val(<%=TempData["seleccionado"] %>);
            },500);
            
            var variable = $('#variable_id_Edit');
            variable.change(function () {
                $('#seleccion_Edit').find('option').remove();
                $.getJSON('/Condicion/ListarTablas', { idtabla: variable.val() },
                    function (data) {
                        $("<option value='0' selected>--Seleccione--</option>").appendTo($('#seleccion_Edit'));
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#seleccion_Edit'));
                        });
                    });

                $.getJSON('/Condicion/ListarTipoDato', { idtabla: variable.val() },
                    function (data) {
                        if (data == "Fecha") {
                            $("#campoSeleccion_Edit").hide("slow");
                            $("#campoValor_Edit").hide("slow");
                            $("#campoFecha_Edit").show("slow");
                            $("#campoMes_Edit").hide("slow");
                        } else if (data == "Numero") {
                            $("#campoSeleccion_Edit").hide("slow");
                            $("#campoValor_Edit").show("slow");
                            $("#campoFecha_Edit").hide("slow");
                            $("#campoMes_Edit").show("slow");
                        } else if (data == "Seleccion") {
                            $("#campoSeleccion_Edit").show("slow");
                            $("#campoValor_Edit").hide("slow");
                            $("#campoFecha_Edit").hide("slow");
                            $("#campoMes_Edit").hide("slow");
                        }
                    });
                });

                $("#ddlMesInicio_Edit").change(function () {
                    $("#ddlMesFin_Edit").find('option').remove();
                    var mesini = $("#ddlMesInicio_Edit").val();
                    var i = mesini - 1;
                    for (i; i < 12; i++) {
                        $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin_Edit"));
                    }
                });
            });

            function seleccionarVariable1(idVariable, nombreV) {
                $("#variable_id_Edit").val(idVariable);
                $("#variable_Edit").html(nombreV + ":" + "&nbsp;&nbsp;&nbsp;");
                $('#seleccion_Edit').find('option').remove();
                $('#VariableNombreEdit').hide("slow");
                $.getJSON('/Condicion/ListarTablas', { idtabla: idVariable },
                    function (data) {
                        $("<option value='0' selected>--Seleccione--</option>").appendTo($('#seleccion_Edit'));
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo($('#seleccion_Edit'));
                        });
                    });

                $.getJSON('/Condicion/ListarTipoDato', { idtabla: idVariable },
                    function (data) {
                        if (data == "Fecha") {
                            $("#campoSeleccion_Edit").hide("slow");
                            $("#campoValor_Edit").hide("slow");
                            $("#campoFecha_Edit").show("slow");
                            $("#campoMes_Edit").hide("slow");
                        } else if (data == "Numero") {
                            $("#campoSeleccion_Edit").hide("slow");
                            $("#campoValor_Edit").show("slow");
                            $("#campoFecha_Edit").hide("slow");
                            $("#campoMes_Edit").show("slow");
                        } else if (data == "Seleccion") {
                            $("#campoSeleccion_Edit").show("slow");
                            $("#campoValor_Edit").hide("slow");
                            $("#campoFecha_Edit").hide("slow");
                            $("#campoMes_Edit").hide("slow");
                        }
                    });
                    $("#dialogVariable_Edit").dialog('destroy'); $("#dialogVariable_Edit").dialog("close");

            }

        function nombreSeleccion() {
            $('#textoSeleccion_Edit').val($("#seleccion_Edit :selected").text());
        }        
    </script>

    <script type="text/javascript">
        $(function () {
            $("#seleccion_Edit option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
        });
    </script>

    <script type="text/javascript">
        function condicionSave() {
            if ($("#formCondicionEditar").valid()) {
                $("#editar").attr('disabled', true);
                $("#formCondicionEditar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>

    <%--DATEPICKER --%>
    <script type="text/javascript">
        $(function () {
            var dates = $("#FechaInicio_Edit, #FechaFin_Edit").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "FechaInicio_Edit" ? "minDate" : "maxDate",
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

    <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
	<% Random random = new Random(); int num = random.Next(1, 10000);  %>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
       
    <% } %>


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Condicion", FormMethod.Post, new { id = "formCondicionEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CondicionViewModel condicion = (ColpatriaSAI.UI.MVC.Models.CondicionViewModel)ViewData["CondicionViewModel"]; %>
        <table id="tablaAdmin" width="100%" cellpadding="2">
          <thead>
            <tr>
                <th align = "center"><a href="javascript:mostrarDialogVariable('/Condicion/Variable?r=<%: num %>&concurso_idEdit=<%: ViewData["value"] %>&subregla_idEdit=<%: ViewData["valuesr"] %>', 'Editar Variable', 'dialogVariable_Edit');" style='float:none;' title='Buscar Variable'>Buscar Variable</a></th>
                <th align = "center"><%: Html.Label("Operador") %></th>
                <th align = "center"><%: Html.Label("Valor/Fecha/Selección") %></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><b><span id = "variable_Edit" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;</span></b>
                					<%: Html.Hidden("variable_id_Edit", 0, new { id = "variable_id_Edit" })%><span id = "VariableNombreEdit" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;<%: TempData["VariableNombre"]%></span>
				</td>
                <td>
                    <%: Html.DropDownList("operador_id_Edit", (SelectList)condicion.OperadorList, "Seleccione un Valor", new { style = "width:200px;", @class = "required", title = "Seleccionar Operador" })%>
                </td>
                <td>
                    <div id="campoSeleccion_Edit">
                        <%: Html.DropDownList("seleccion_Edit", new List<SelectListItem>(), "Seleccione un Valor", new { style = "width:200px;", @onchange="nombreSeleccion();", title = "Seleccionar Condicion" })%>
                        <div id="seleccionado">
                        </div>
                        <%: Html.Hidden("textoSeleccion_Edit") %>
                    </div>
                    <div id="campoValor_Edit">
                        <%: Html.TextBox("valor_Edit", TempData["valor"], new { title = "Ingresar Valor" })%>
                        <%: Html.ValidationMessageFor(Model => condicion.CondicionView.valor)%>
                    </div>
                    <div id="campoFecha_Edit">
                        <%: Html.TextBox("FechaInicio_Edit", String.Format("{0:d}",TempData["fecha"]), new { @readonly = "true", id = "FechaInicio_Edit" })%>
                        <%: Html.ValidationMessageFor(Model => condicion.CondicionView.fecha)%>
                    </div>
                    <div id="campoMes_Edit">
                            <table>
                                <tr>
                                    <td>
                                        Mes inicio:
                                    </td>
                                    <td>
                                        <select id="ddlMesInicio_Edit" style="width: 100%" name="ddlMesInicio_Edit">
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Mes fin:
                                    </td>
                                    <td>
                                        <select id="ddlMesFin_Edit" style="width: 100%" name="ddlMesFin_Edit">
                                        </select>
                                    </td>
                                </tr>
                            </table>
                        </div>
                </td>
            </tr>
            <tr>
                <td align = "center"><input type="button" value="Actualizar" id="editar" onclick="condicionSave()" /></td>                 
                <td><input type="hidden" id="valorTipoVariable_Edit" name="tipovariable_Edit" /></td>
                <td><input type="hidden" id="subregla_idEdit" name="subregla_idEdit" value="<%: ViewData["valuesr"] %>" /></td>                    
                <td><input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["valuer"] %>" /></td>
                <td><input type="hidden" id="concurso_idEdit" name="concurso_idEdit" value="<%: ViewData["value"] %>" /></td>
            </tr>
        </tbody>
        </table>
      
    <% } %>

    <div id='dialogVariable_Edit' style="display: none;">
    </div>