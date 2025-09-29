<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Persistencia de CAPI (Detalle) - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Persistencia de CAPI (Detalle)</h2>

      <script type="text/javascript">
          function mostrarDialog(pagina, titulo, dialog) {
              $("#" + dialog).dialog({
                  height: 331, width: 540, modal: true, title: titulo,
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
          });
          $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
          $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
          $("#bSiguiente").button({ icons: { secondary: "ui-icon-circle-arrow-e"} });         
      </script>  

      <script type="text/javascript">
                function PersistenciadeCAPIDetalleSave() {
                    if ($("#formPersistenciadeCAPIDetalle").valid()) {
                        $("#buscar").attr('disabled', true);
                        $("#formPersistenciadeCAPIDetalle").submit();
                            mostrarCargando("Enviando informacion. Espere Por Favor...");                      
                    }
                }
      </script>

    <div class="seccion">
    <ul>
        <li><%: Html.ActionLink("Ver reporte CAPI detalle", "VerReporte", "ReportesSAI", new { @id = "ReportePersistenciadeCAPIDetalle" }, new { @target = "_blank" })%></li>                
    </ul>  
    </div>    

    <table id="tablaAdmin" style="clear:left;">
        <tr valign="top">
            <td>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("BuscarRegistroPersistencia", "PersistenciaCAPIDetalle", FormMethod.Post, new { id = "formPersistenciadeCAPIDetalle" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.PersistenciaCAPIDetalleViewModel persistenciadecapidetalle = (ColpatriaSAI.UI.MVC.Models.PersistenciaCAPIDetalleViewModel)ViewData["PersistenciaCAPIDetalleViewModel"]; %>
                    
                    <fieldset style="border:1px solid gray">
                    <table width="100%" cellpadding="2" >                            
                    <tr>
                         <td><%: Html.Label("Clave:")%></td>
                         <td><%: Html.TextBox("clave", null, new { title = "Ingrese Clave", size="4" })%>
                         <%: Html.ValidationMessageFor(Model => persistenciadecapidetalle.PersistenciaCAPIDetalleView.clave)%></td>
                    </tr>
                    <tr>
                         <td><%: Html.Label("Número de Negocio:")%></td>
                         <td><%: Html.TextBox("numeroNegocio", null, new { title = "Ingrese Número Negocio", size="12" })%>
                         <%: Html.ValidationMessageFor(Model => persistenciadecapidetalle.PersistenciaCAPIDetalleView.numeroNegocio)%></td>
                    </tr>                  
                    <tr>
                        <td><input type="button" value="Buscar" id = "buscar" onclick="PersistenciadeCAPIDetalleSave()" /></td>
                    </tr>
                    </table>
                    </fieldset>
                    
                <% } %>

            </td>          
        </tr>                  
    </table>

    <h4 align = "center"><b>La búsqueda filtra únicamente los negocios del año vigente y de los tres meses anteriores al mes abierto en CAPI. </b></h4>
    
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Editar</th>
                        <th>Clave</th>
                        <th>Número Negocio</th>   
                        <th>Plazo</th>
                        <th>Valor Prima</th>
                        <th>Cuotas Pagas</th>
                        <th>Cuotas Vencidas</th>
                        <th>Fecha Último Recaudo</th>
                        <th>Fecha Cierre</th>
                        <th>Mes Expedición</th>
                        <th>Año Cierre</th>
                        <th>Cumple</th>
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
                <% foreach (var item in ((IEnumerable<PersistenciadeCAPIDetalle>)ViewData["PersistenciaCAPIDetalle"]))
                   { %>
            
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Premio Anterior'><span class='ui-icon ui-icon-pencil'/></a>                            
                        </td>
                        <td align = "center"><%: item.clave %></td>
                        <td align = "center"><%: item.numeroNegocio %></td>             
                        <td align = "center"><%: item.Plazo.nombre %></td>
                        <td align = "center"><%: String.Format("{0:C}", item.valorPrimaTotal) %></td>
                        <td align = "center"><%: item.cuotasPagadas %></td>
                        <td align = "center"><%: item.cuotasVencidas %></td>
                        <td align = "center"><%: String.Format("{0:d}", item.fechaUltimoRecaudo)%></td>
                        <td align = "center"><%: String.Format("{0:d}", item.fechaCierre)%></td>
                        <td align = "center"><%: item.mesCierre %></td>
                        <td align = "center"><%: item.anioCierreNegocio %></td>
                        <td align = "center"><%: ((item.cumple == true) ? "SI" : "NO") %></td>                        
                    </tr>
                <% } %>
                </tbody>
                </table> 

    <div id='dialogEditar' style="display:none;"></div>

</asp:Content>