<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Sub reglas y condiciones : Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

      <script type="text/javascript">
          function mostrarDialog(pagina, titulo, dialog) {
              $("#" + dialog).dialog({
                  height: 190, width: 350, modal: true, title: titulo,
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

          function cerrarDialog(dialog) {
              $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
          }
          $(document).ready(function () {
              oTable = $('#tablaLista').dataTable({
                  "bJQueryUI": true,
                  "sPaginationType": "full_numbers","bStateSave": true
              });
            
          });          
    </script>

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({
                    
                });

                $().ready(function () {
                      $("#formSubRegla").validate();
                   
                    $("#formSubRegla").validate({
                        rules: {
                            nombre: "required"
                        },
                    });

                    $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
                    $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
                    $("#bAgrupar").button({ icons: { secondary: "ui-icon-transferthick-e-w"} });
                    $("#bSumar").button({ icons: { primary: "ui-icon-plusthick"} });
                });
            </script>

            <script type="text/javascript">
                var era;
                function uncheckRadio(rbutton) {
                    if (rbutton.checked == true && era == true) { rbutton.checked = false; }
                    era = rbutton.checked;
                }
            </script>

            <script type="text/javascript">
                function subreglaSave() {
                    if ($("#formSubRegla").valid()) {
                        $("#crear").attr('disabled', true);
                        $("#formSubRegla").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>            

    <script type="text/javascript">javascript: window.history.forward(1);</script>

    <div id="encabezadoConcurso" align = "center">
            <div id="infoPasoActual" align = "center">
                <h2>Paso 3: Reglas y Premios - Definir Sub - Reglas</h2>
                <div><%: ViewData["Concursos"] + " > " + "" + ViewData["Reglas"]%></div>
            </div>
            <div id="progreso" align = "center">
                <ul id="pasos">					
					<li>1. <a href="<%= Url.Action("Index", "ParticipanteConcurso", new { value = Request.QueryString["value"] }) %>" id="A1">Participantes</a></li>
					<li>2. <a href="<%= Url.Action("Index", "ProductoConcurso", new { value = Request.QueryString["value"] }) %>" id="A2">Productos</a></li>					
					<li><b>3.Reglas y Premios</b></li>
                </ul>
                <h4><b>Para eliminar las subreglas hagalo de forma descendente, es decir, empiece por la mayor agrupación o subregla principal.</b><br />
                Si ud elimina una subregla simple antes de la correspondiente agrupación podrían generarse incosistencias de información.</h4>
                

            </div>
           <div style="clear:both;"><hr /></div>
        </div>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

      <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
    <% Random random = new Random();  int num = random.Next(1, 10000); %>
   
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% using (Html.BeginForm("Crear", "SubRegla", FormMethod.Post, new { id = "formSubRegla" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.SubReglaViewModel subregla = (ColpatriaSAI.UI.MVC.Models.SubReglaViewModel)ViewData["SubReglaViewModel"]; %>
                    <fieldset style="border:1px solid gray">
                    <table>
                    <tr>                          
                        <td><%: Html.Label("Nueva sub - regla:") %></td>
                        <td><%: Html.TextBox("descripcion")%>
                            <%: Html.ValidationMessageFor(model => subregla.SubReglaView.descripcion)%></td>
                        <td><%: Html.Label("Es Excepción?") %></td>
                        <td><%: Html.RadioButton("tipoSubRegla", true, new { title = "Es Excepción?", onclick = "uncheckRadio(this)" })%></td>
                    </tr>
                    <tr>
                    <td><input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["valuer"] %>" />
                        <input type="button" value="Guardar" id = "crear" onclick="subreglaSave()" /></td>
                    </tr>
                    </table>
                    </fieldset>
					<table align="center">
						<tr >
							<td><a href="<%= Url.Action("Index", "Regla", new { value = Request.QueryString["value"] }) %>" id="bAnterior" title="Volver al listado de reglas">Anterior</a></td>
							<td><a href="../Concursos" id="bInicio">Inicio</a></td>
							<td><%=Html.ActionLink("Agrupar SubReglas", "Index", "condicionAgrupada", new { valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }, new { id="bAgrupar" })%></td>
						</tr>
					</table>
                <% } %>
            </td>
        </tr>
    </table>    

     <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Opciones</th>
                        <th align = "center">Descripcion</th>
                        <th align = "center">Es Principal</th>
                        <th align = "center">Es Excepción</th>
                        <th align = "center">Condiciones</th>                        
                        <th align = "center">Asignar Premio</th>
                    </tr>
                </thead>
                <tbody>
                <% foreach (var item in ((IEnumerable<SubRegla>)ViewData["subreglas"])) { %>                    
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar SubRegla'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar SubRegla'><span class='ui-icon ui-icon-trash'/></a> 
                        </td>                     
                        <td align><%: item.descripcion %></td>
                        <td align = "center"><%: ((item.principal == true) ? "Si" : "No") %></td>
                        <td align = "center"><%: ((item.tipoSubregla == 3) ? "Si" : "No") %></td>
                        <td align= "center">
                        <% 
                          var item1 = ((IEnumerable<Condicion>)ViewData["condiciones"]).Where(c => c.subregla_id == item.id).Count();                           
                        %>
                        <% if (item.condicionAgrupada_id == null) { %> 
                            <%=Html.ActionLink("Condicion", "Index", "Condicion", new { valuesr = item.id, valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }, new { })%> (<%: item1 %>)
                        <% } %>
                        </td>                        
                        <td align= "center">
                        <% 
                          var item2 = ((IEnumerable<PremioxSubregla>)ViewData["premiosxsubregla"]).Where(ps => ps.subregla_id == item.id).Count();                           
                        %>
                        <% if (item.tipoSubregla != 3) { %>                          
                            <%=Html.ActionLink("Asignar Premio", "Index", "PremioxSubRegla", new { valuesr = item.id, valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }, new { })%> (<%: item2 %>)
                        <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
                </table>   
   
    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
    <div id='dialogSuma' style="display:none;"></div>

</asp:Content>
