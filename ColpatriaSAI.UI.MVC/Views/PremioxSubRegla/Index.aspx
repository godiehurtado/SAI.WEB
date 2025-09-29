<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Asignar Premio - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialogPremio(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 520, width: 700, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close");
                    }
                },
                title: titulo,

                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialogPremio_Edit(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 520, width: 700, modal: true,
                buttons: {
                    Cerrar: function () {
                        $(this).dialog("close");
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

            var meses = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre");
            var i = 0;
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesInicio"));
            }
            for (i = 0; i < 12; i++) {
                $("<option value = " + (i + 1).toString() + ">" + meses[i].toString() + "</option>").appendTo($("#ddlMesFin"));
            }
        });

        $(function () {
            $("#progressbar").progressbar({
                value: 57
            });
        });

        function seleccionarPremio(idPremio, nombreP) {
            $("#premio_id").val(idPremio);
            $("#premio").html(nombreP + "&nbsp;&nbsp;&nbsp;");
            $("#dialogPremio").dialog('destroy'); $("#dialogPremio").dialog("close");
        }            
                    
    </script>
    <script type="text/javascript">
        function productoConcursoSave() {
            if ($("#ProductoConcurso").valid()) {
                $("#crear").attr('disabled', true);
                $("#ProductoConcurso").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>
    <%--VALIDATOR--%>
    <script type="text/javascript">
        $.validator.setDefaults({

        });

        $().ready(function () {
            $("#formPremioxSubRegla").validate();

            $("#formPremioxSubRegla").validate({
                rules: {
                    nombre: "required"
                }
            });
            $("#bCrear").button({ icons: { primary: "ui-icon-circle-plus"} });
            $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
        });
    </script>
    <script type="text/javascript">        javascript: window.history.forward(1);</script>
    <script type="text/javascript">
        function premioxsubreglaSave() {
            if ($("#formPremioxSubRegla").valid()) {
                $("#crear").attr('disabled', true);
                mostrarCargando("Enviando informacion. Espere Por Favor...");
                $("#formPremioxSubRegla").submit();
            }
        }
    </script>
    <div id="encabezadoConcurso" align="center">
        <div id="infoPasoActual" align="center">
            <h2>
                Paso 3: Reglas y Premios - Asignar Premio</h2>
            <div>
                <%: ViewData["Concursos"] + " > " + "Regla: " + ViewData["Reglas"] + " > " + "Subregla: " + ViewData["subReglas"]%></div>
        </div>
        <div id="progreso" align="center">
            <%--<div id="progressbar"></div>--%>
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
    <%--<p align = "center"><a href="<%= Url.Action("Index", "SubRegla", new { valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }) %>" style='float:center;' title='Regresar al Listado de SubReglas'><span class='ui-icon ui-icon-arrowthick-1-w'/></a></p>     --%>
    <p>
    </p>
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
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% using (Html.BeginForm("Crear", "PremioxSubRegla", FormMethod.Post, new { id = "formPremioxSubRegla" }))
                   {
                       Html.ValidationSummary(true); %>
                <% ColpatriaSAI.UI.MVC.Models.PremioxSubReglaViewModel premioxsubregla = (ColpatriaSAI.UI.MVC.Models.PremioxSubReglaViewModel)ViewData["PremioxSubReglaViewModel"]; %>
                <fieldset style="border: 1px solid gray">
                    <table cellpadding="2">
                        <tr>
                            <td>
                                <b><span id="premio" style="text-transform: uppercase;">&nbsp;&nbsp;&nbsp;</span></b>
                                <%: Html.Hidden("premio_id", 0 ,new { id = "premio_id"}  ) %>
                            </td>
                            <td>
                                <a href="javascript:mostrarDialogPremio('<%: ruta %>Premio1?r=<%: num %>', 'Premio', 'dialogPremio');"
                                    style='float: none;' title='Buscar Premio'>Buscar Premio</a>
                            </td>
                            <td>
                                Mes inicio:
                            </td>
                            <td>
                                <select id="ddlMesInicio" style="width: 100%" name="ddlMesInicio">
                                </select>
                            </td>
                            <td>
                                Mes fin:
                            </td>
                            <td>
                                <select id="ddlMesFin" style="width: 100%" name="ddlMesFin">
                                </select>
                            </td>
                            <td>
                                <input type="hidden" id="subregla_id" name="subregla_id" value="<%: ViewData["valuesr"] %>" />
                                <input type="button" value="Asignar" id="crear" onclick="premioxsubreglaSave()" />
                            </td>
                            <td>
                                <%=Html.ActionLink("Crear Premio", "Index", "Premio", new { valuesr = Request.QueryString["valuesr"], valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }, new { id = "bCrear" })%>
                            </td>
                        </tr>
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
            </td>
        </tr>
    </table>
    <table id="tablaLista">
        <thead>
            <tr>
                <th>
                    Opciones
                </th>
                <th>
                    Premio
                </th>
                <th>
                    SubRegla
                </th>
                <th>
                    Condiciones
                </th>
            </tr>
        </thead>
        <tbody>
            <% foreach (var item in ((IEnumerable<PremioxSubregla>)ViewData["PremioxSubReglas"]))
               { %>
            <tr>
                <td align="center">
                    <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar PremioxSubRegla', 'dialogEditar');"
                        style='float: left;' title='Editar PremioxSubRegla'><span class='ui-icon ui-icon-pencil' />
                    </a><a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');"
                        style='float: right;' title='Eliminar PremioxSubRegla'><span class='ui-icon ui-icon-trash' />
                    </a>
                </td>
                <td align="center">
                    <%: item.Premio.descripcion %>
                </td>
                <td align="center">
                    <%: item.SubRegla.descripcion %>
                </td>
                <td align="center">
                     <% 
                   var item1 = ((IEnumerable<CondicionxPremioSubregla>)ViewData["CondicionPremio"]).Where(c => c.premioxsubregla_id == item.id).Count();                           
                     %>
                    <%=Html.ActionLink("Condicion Premio", "Index", "CondicionxPremioSubRegla", new { valueps = item.id,valuesr = Request.QueryString["valuesr"], valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }, new { })%> (<%: item1 %>)
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id='dialogEditar' style="display: none;">
    </div>
    <div id='dialogEliminar' style="display: none;">
    </div>
    <div id='dialogPremio' style="display: none;">
    </div>
</asp:Content>
