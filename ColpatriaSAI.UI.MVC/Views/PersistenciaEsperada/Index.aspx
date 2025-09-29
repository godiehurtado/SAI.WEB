<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Persistencia Esperada - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

     <script type="text/javascript">
         function mostrarDialog(pagina, titulo, dialog) {
             $("#" + dialog).dialog({
                 height: 250, width: 600, modal: true, title: titulo,
                 open: function (event, ui) { $(this).load(pagina); },
                 close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
             });
         }

         function mostrarDialog1(pagina, titulo, dialog) {
             $("#" + dialog).dialog({
                 height: 150, width: 300, modal: true, title: titulo,
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
             $("#tipoPersistenciaVIDA").click(function () {
                 if (this.checked)
                     $('#plazo_id').attr('disabled', 'disabled');
                 else
                     $('#plazo_id').removeAttr('disabled');
             });
             $("#tipoPersistenciaCAPI").click(function () {
                 if (this.checked)
                     $('#plazo_id').removeAttr('disabled');
                 else                     
                     $('#plazo_id').attr('disabled', 'disabled');
             });
         });
         $(function () {
             $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
             $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
             $("#bSiguiente").button({ icons: { secondary: "ui-icon-circle-arrow-e"} });
         });
    </script>

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({                    
                });

                $().ready(function () {
                      $("#PersistenciaEsperada").validate();                   
                    $("#PersistenciaEsperada").validate({
                        rules: {
                            nombre: "required"
                        },                       
                    }); });
            </script>
			
        <script type="text/javascript">javascript: window.history.forward(1);</script>

    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>Persistencia Esperada</h2>
            <div><%: ViewData["Concursos"] %> </div>
        </div>
        <div id="progreso">        
            <div style="clear:both;"><hr /></div>
        </div>
    </div>

    <table id="tablaAdmin" style="clear:left;">
        <tr valign="top">
            <td>
                 <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "PersistenciaEsperada", FormMethod.Post, new { id = "PersistenciaEsperada" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.PersistenciaEsperadaViewModel persistenciaesperada = (ColpatriaSAI.UI.MVC.Models.PersistenciaEsperadaViewModel)ViewData["PersistenciaEsperadaViewModel"]; %>
                    
                    <fieldset style="border:1px solid gray">
                    <table width="100%" cellpadding="2" align = "center">                   
                    <tr>
                        <td><u><%: Html.Label("Tipo de Persistencia:")%></u></td>
                        <td align = "center"><%: Html.RadioButton("tipoPersistencia", false, new { title = "Capitalización Tradicional", id = "tipoPersistenciaCAPI" })%><label>Capitalización Tradicional</label></td>
                        <td align = "center" colspan="2"><%: Html.RadioButton("tipoPersistencia", true, new { title = "Vida Individual", id = "tipoPersistenciaVIDA" })%><label>Vida Individual</label></td>
                    </tr>               
                    <tr>
                         <td><u><%: Html.Label("Valor")%></u></td>
                         <td align = "center"><%: Html.TextBox("valor", null, new { @class = "required decimal", title = "Ingrese Porcentaje de Persistencia Esperado", size="4" })%> %
                             <%: Html.ValidationMessageFor(Model => persistenciaesperada.PersistenciaEsperadaView.valor)%></td>
                             
                         <td align = "center"><%: Html.Label("Plazo")%></td>
                         <td align = "center"><%: Html.DropDownList("plazo_id", (SelectList)persistenciaesperada.PlazoList, new { style = "width:300px;", title = "Seleccione Plazo" })%></td>                        
                    </tr>
                    <tr>
                        <td><input type="submit" value="Guardar" /></td>
                        <td colspan="3">
                            <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
                            Recuerde usar "," (coma) para identificar los números decimales</td>
                    </tr>
                    </table>
                    </fieldset>

					<table align="center">
						<tr>							
							<td><a href="../Concursos" id="bInicio">Inicio</a></td>
							<td><a href="<%= Url.Action("Index", "SiniestralidadEsperada", new { value = Request.QueryString["value"] }) %>" id="bSiguiente">Siguiente </a></td>
						</tr>
					</table>

                <% } %>

            </td>          
        </tr>
    </table>
    
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Tipo de Persistencia</th>
                        <th>Valor</th>   
                        <th>Plazo</th>   
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
                <% foreach (var item in ((IEnumerable<PersistenciaEsperada>)ViewData["PersistenciaEsperadas"]))
                   { %>            
                    <tr>
                       <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?tipo=<%: item.tipoPersistencia %>&r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Persistencia'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Persistencia'><span class='ui-icon ui-icon-trash'/></a> 
                        </td>
                        <td align = "center"><%: ((item.tipoPersistencia == true) ? "Vida Individual" : "Tradicional") %></td>
                        <td align = "center"><%: item.valor %></td>             
                        <td align = "center"><%: ((item.plazo_id == 0) ? "N/A" : item.Plazo.nombre) %></td>                     
                    </tr>
                <% } %>
                </tbody>
                </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>