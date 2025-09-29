<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Agrupar SubReglas - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <script type="text/javascript">
            function mostrarDialog(pagina, titulo, dialog) {
                $("#" + dialog).dialog({
                    height: 180, width: 800, modal: true, title: titulo,
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

            function mostrarDialogSubRegla(pagina, titulo, dialog) {
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

            function mostrarDialogSubRegla_Edit(pagina, titulo, dialog) {
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
                oTable = $('#tablaLista').dataTable({"bJQueryUI": true,"sPaginationType": "full_numbers","bStateSave": true});
                $("#operador_id option").each(function () {
                    $(this).attr({ 'title': $.trim($(this).html()) });
                });
                $("#progressbar").progressbar({
                    value: 57
                });
                $("#bCrear").button({ icons: { primary: "ui-icon-circle-plus"} });
                $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
                $("#bInicio").button({ icons: { primary: "ui-icon-home"} });

            });

            function seleccionarSubRegla(idSubRegla, nombreS) {
                $("#subregla_id1").val(idSubRegla);
                $("#subregla1").html(nombreS + "&nbsp;&nbsp;&nbsp;");                
                $("#dialogSubRegla").dialog('destroy'); $("#dialogSubRegla").dialog("close");
            }

            function seleccionarSubRegla1(idSubRegla, nombreS) {
                $("#subregla_id2").val(idSubRegla);
                $("#subregla2").html(nombreS + "&nbsp;&nbsp;&nbsp;");
                $("#dialogSubRegla1").dialog('destroy'); $("#dialogSubRegla1").dialog("close");
            }      
    </script>

    <script type="text/javascript">
        function cAgrupadaSave() {
            if ($("#CondicionAgrupada").valid()) {
                $("#crear").attr('disabled', true);
                $("#CondicionAgrupada").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>

    <script  type="text/javascript">javascript: window.history.forward(1);</script>   

    <div id="encabezadoConcurso" align = "center">
        <div id="infoPasoActual" align = "center">
            <h2>Paso 3: Reglas y Premios - Agrupar subreglas</h2>
            <div>
              <% if (TempData["Mensaje"] != null){ %>
                <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
              <% } %>            
            </div>
        </div>
        <div id="progreso" align = "center">
            <%--<div id="progressbar"></div>--%>
                <ul id="pasos">					
					<li>1. <a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>" id="A1">Participantes</a></li>
					<li>2. <a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="A2">Productos</a></li>					
					<li><b>3.Reglas y premios</b></li>
                </ul>
        </div>
       <div style="clear:both;"><hr /></div>
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

    <table id="tablaAdmin" >
        <tr valign="top">
            <td>
                 <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "CondicionAgrupada", FormMethod.Post, new { id = "CondicionAgrupada" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.CondicionAgrupadaViewModel condicionagrupada = (ColpatriaSAI.UI.MVC.Models.CondicionAgrupadaViewModel)ViewData["CondicionAgrupadaViewModel"]; %>
                    
                    <fieldset style="border:1px solid gray">

                        <table width="100%" cellpadding="2">
                            <tr>
                                <td><a href="javascript:mostrarDialogSubRegla('<%: ruta %>SubRegla?r=<%: num %>&regla_id=<%: ViewData["valuer"] %>', 'SubRegla', 'dialogSubRegla');" style='float:none;' title='Buscar SubRegla'>Buscar SubRegla A</a></td>
                                <td><b><span id = "subregla1" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;</span></b></td>
                                <%: Html.Hidden("subregla_id1", 0, new { id = "subregla_id1" })%>	                                
                            </tr>
                            <tr>
                                <td><u><%: Html.Label("Operador")%></u></td>
                                <td><%: Html.DropDownList("operador_id", (SelectList)condicionagrupada.OperadorList, "Seleccione un Valor", new { style = "width:200px;", id = "operador_id", @class = "required" })%></td>
                            </tr>
                            <tr>
                                <td><a href="javascript:mostrarDialogSubRegla('<%: ruta %>SubRegla1?r=<%: num %>&regla_id=<%: ViewData["valuer"] %>', 'SubRegla', 'dialogSubRegla1');" style='float:none;' title='Buscar SubRegla'>Buscar SubRegla B</a></td>
                                <td><b><span id = "subregla2" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;</span></b></td>
                                <%: Html.Hidden("subregla_id2", 0, new { id = "subregla_id2" })%>                                
                            </tr>                              
                            </table>
                            <table>
                            <tr>
                                <td><u><%: Html.Label("Nombre")%></u>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
                                <td colspan="5"><%: Html.TextBox("nombre", null, new { style = "width:740px;", id = "nombre", @class = "required" })%>
                                    <%: Html.ValidationMessageFor(Model => condicionagrupada.CondicionAgrupadaView.nombre)%></td>
                            </tr>
                            <tr>
                                <td><input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["valuer"] %>" /></td>
                                <td colspan="5"><input type="button" value="Guardar" id = "crear" onclick="cAgrupadaSave()" /></td>
                            </tr>
                        </table>                      
                    </fieldset>

                <% } %>

            </td>
          
        </tr>
    </table>
	                <table align="center">
		                <tr >
			                <td><a href="<%= Url.Action("Index", "SubRegla", new { valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }) %>" id="bAnterior" title="Volver al listado de sub-reglas">Anterior</a></td>
			                <td><a href="../Concursos" id="bInicio">Inicio</a></td>
		                </tr>
	                </table>

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Opciones</th>                   
                        <th align = "center">Subregla A</th>
                        <th align = "center">Operador</th>
                        <th align = "center">Subregla B</th>
                        <th align = "center">Descripción</th>
                    </tr>
                </thead>
                <tbody>

                <% foreach (var item in ((IEnumerable<CondicionAgrupada>)ViewData["CondicionesAgrupadas"]))
                   { %>
                   
                    <tr>
                       <td align= "center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?idr=<%: item.regla_id %>&idc=<%: item.Regla.concurso_id %>&r=<%: num %>', 'Editar Agrupación', 'dialogEditar');" style='float:left;' title='Editar Productos'><span class='ui-icon ui-icon-pencil'/></a> 
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Productos'><span class='ui-icon ui-icon-trash'/></a>
                        </td>             
                        <td align = "center"><%: item.SubRegla.descripcion %></td>
                        <td align = "center"><%: item.Operador.nombre %></td>     
                        <td align = "center"><%: item.SubRegla1.descripcion %></td>            
                        <td align = "center"><%: item.nombre %></td> 
                    </tr>
                <% } %>
                </tbody>
                </table>   



    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
    <div id='dialogSubRegla' style="display:none;"></div>
    <div id='dialogSubRegla1' style="display:none;"></div>

</asp:Content>