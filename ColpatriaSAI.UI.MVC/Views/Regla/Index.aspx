<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reglas del concurso - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            var dates = $("#FechaInicio, #FechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "yy-mm-dd",
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
          function mostrarDialog(pagina, titulo, dialog) {
              $("#" + dialog).dialog({
                  height: 500, width: 680, modal: true, title: titulo,
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

          function mostrarDialog2(pagina, titulo, dialog) {
              $("#" + dialog).dialog({
                  height: 200, width: 450, modal: true, title: titulo,
                  open: function (event, ui) { $(this).load(pagina); },
                  close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
              });
          }

          function cerrarDialog(dialog) {
              $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
          }
          $(document).ready(function () {
              oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
              $("#tipoRegla_id option").each(function () {
                  $(this).attr({ 'title': $.trim($(this).html()) });
              });
              $("#periodoRegla_id option").each(function () {
                  $(this).attr({ 'title': $.trim($(this).html()) });
              });        
          });         
    </script>

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({
                    
                });

                $().ready(function () {
                      $("#formRegla").validate();
                   
                    $("#formRegla").validate({
                        rules: {
                            nombre: "required"
                        }
                    });

                    $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
                    $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
                    $("#bResumen").button({ icons: { secondary: "ui-icon-note"} });
                    $("#bNueva").button({ icons: { secondary: "ui-icon-circle-plus"} });
                });
            </script>

            <script type="text/javascript">
                function reglaSave() {
                    if ($("#formRegla").valid()) {
                        $("#crear").attr('disabled', true);
                        $("#formRegla").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>            

        <script type="text/javascript">javascript: window.history.forward(1);</script>

        <div id="encabezadoConcurso" align = "center">
        <div id="infoPasoActual" align = "center">
            <h2>Paso 3: Definir Reglas</h2>
            <div><%: ViewData["Concursos"] %> </div>
        </div>
        <div id="progreso" align = "center">
            <ul id="pasos">					
					<li>1. <a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>" id="A1">Participantes</a></li>
					<li>2. <a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="A2">Productos</a></li>					
					<li><b>3.Reglas y Premios</b></li>
            </ul>
        </div>
       <div style="clear:both;"><hr /></div>
    </div>
  
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
   
   <a href="#" id="bNueva" onclick="$('#tablaAdmin').toggle('slow');">Nueva Regla</a><br />
    <table id="tablaAdmin" style="display:none">
        <tr valign="top">
            <td>
          
                <% using (Html.BeginForm("Crear", "Regla", FormMethod.Post, new { id = "formRegla"}))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.ReglaViewModel regla = (ColpatriaSAI.UI.MVC.Models.ReglaViewModel)ViewData["ReglaViewModel"]; %>
                    <fieldset style="border:1px solid gray">
                    <table width="100%" cellpadding="2">
                    <tr>
                        <td><u><%: Html.Label("Nombre") %></u></td>
                        <td><%: Html.TextBox("nombre", null, new { @class = "required" })%>
                        <%: Html.ValidationMessageFor(model => regla.ReglaView.nombre)%></td>                   
                    </tr> 
                    <tr>
                        <td><u><label for="FechaInicio">Fecha Inicio:</label></u></td>
                        <td><%= Html.TextBox("FechaInicio", null, new { @readonly = "true", @class = "required" })%></td>              
                    </tr>
                    <tr>
                        <td><u><label for="FechaFin">Fecha Fin:</label></u></td>
                        <td><%= Html.TextBox("FechaFin", null, new { @readonly = "true", @class = "required" })%></td>              
                    </tr>  
                    <tr>                          
                        <td><u><%: Html.Label("Tipo de Regla")%></u></td>
                        <td><%: Html.DropDownList("tipoRegla_id", (SelectList)regla.TipoReglaList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>
                    </tr>
                     <tr>
                        <td><u><%: Html.Label("Periodo Regla")%></u></td>
                        <td><%: Html.DropDownList("periodoRegla_id", (SelectList)regla.PeriodoReglaList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>
                    </tr>               
                    <tr>
                        <td><%: Html.Label("Descripcion") %></td>
                        <td><%: Html.TextArea ("descripcion", null, new {@style = "border:#000000 1px solid;", cols="70", rows="5" })%>
                            <%: Html.ValidationMessageFor(model => regla.ReglaView.descripcion)%></td>
                    </tr>
                    <tr>
                        <td><%: Html.Label("Premio a sumar")%></td>
                        <td><%: Html.DropDownList("regla_id", (SelectList)ViewBag.ListaPremios, "Seleccione...") %>
                            <%: Html.ValidationMessageFor(Model => regla.ReglaView.regla_id)%></td>    
                    </tr>
                    <tr>
                        <td><%: Html.Label("Concepto Descuento")%></td>
                        <td><%: Html.ListBox("conceptoDescuento_id", (MultiSelectList)regla.ConceptoDescuentoList, new { id = "conceptoDescuento_id", style = "width:300px; height:70px;", cols = "70", rows = "5", })%></td>    
                    </tr>
                    <tr>
                        <td><input type="button" value="Guardar" id = "crear" onclick="reglaSave()" /></td>
                        <td><input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" /></td>
                    </tr>
                    </table>
                    </fieldset>
                <% } %>
            </td>
            <td>
            </td>
        </tr>
    </table>    
	<table align="center">
		<tr>
			<td><a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="bAnterior">Anterior</a></td>
			<td><a href="../Concursos" id="bInicio">Inicio</a></td>
			<td><a href='#' onclick="popupReport('ReporteResumenConcurso','concurso_id=<%: ViewData["value"] %>&Formato=Excel');" id="bResumen">Resumen</a></td>            
		</tr>
	</table>
     <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Nombre</th>
                        <th>Fecha Inicio</th>
                        <th>Fecha Fin</th>
                        <th>Tipo Regla</th>
                        <th>Periodo Regla</th>
                        <th>Descuentos</th>
                        <th>Subreglas</th>
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
                <% foreach (var item in ((IEnumerable<Regla>)ViewData["Reglas"])) { %>
                    
                    <tr>
                        <td align= "center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?concurso_id=<%: Request.QueryString["value"] %>&r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Regla'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Regla'><span class='ui-icon ui-icon-trash'/></a> 
                            <a href="javascript:mostrarDialog2('<%: ruta %>Duplicar/<%: item.id %>?r=<%: num %>', 'Duplicar Concurso', 'dialogEditar');" title='Duplicar Regla'><span class='ui-icon ui-icon-copy'></span></a>
                        </td>
                     
                        <td><%: item.nombre %></td>
                        <td align = "center"><%: String.Format("{0:d}",item.fecha_inicio) %></td>
                        <td align = "center"><%: String.Format("{0:d}",item.fecha_fin) %></td>
                        <td align = "center"><%: item.TipoRegla.nombre %></td>
                        <td align = "center"><%: item.PeriodoRegla.periodo %></td>
                        <td align = "center">
                        <% 
                            var item1 = ((IEnumerable<ReglaxConceptoDescuento>)ViewData["ReglaxConceptoDescuento"]).Where(rcd => rcd.regla_id == item.id).Count();
                            if (int.Parse(ViewData["TipoConcurso"].ToString()) == 1)
                            {%>
                            <%=Html.ActionLink("Descuentos", "Index", "ReglaxConceptoDescuento", new { valuer = item.id, value = Request.QueryString["value"] }, new { })%> (<%: item1 %>)
                        <%}
                            else if (int.Parse(ViewData["TipoConcurso"].ToString()) == 2)
                            {%>
                            <%=Html.ActionLink("Descuentos", "Index", "CategoriaxRegla", new { valuer = item.id, value = Request.QueryString["value"] }, new { })%>
                        <%} %>
                        </td>
                        <td align= "center">
                            <%=Html.ActionLink("SubRegla", "Index", "SubRegla", new { valuer = item.id, value = Request.QueryString["value"] }, new { })%>
                        </td>                        
                   </tr>
                <% } %>
                </tbody>
                </table>   
   
    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
