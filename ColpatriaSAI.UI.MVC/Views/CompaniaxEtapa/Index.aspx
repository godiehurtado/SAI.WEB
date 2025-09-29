<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Etapas por Compañía
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Etapas por Compañía</h2>
  
        <script type="text/javascript">
            function mostrarDialog(pagina, titulo, dialog) {
                $("#" + dialog).dialog({
                    height: 150, width: 300, modal: true, title: titulo,
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
                $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            });            
    </script>        

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({
                    
                });

                $().ready(function () {
                      $("#CompaniaxEtapa").validate();                   
                    $("#CompaniaxEtapa").validate({
                        rules: {
                            nombre: "required"
                        },                       
                    }); });
            </script>
			
<script  type="text/javascript">javascript: window.history.forward(1);</script>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                 <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "CompaniaxEtapa", FormMethod.Post, new { id = "CompaniaxEtapa" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.CompaniaxEtapaViewModel companiaxetapa = (ColpatriaSAI.UI.MVC.Models.CompaniaxEtapaViewModel)ViewData["CompaniaxEtapaViewModel"]; %>

                    <table align = "center">
                    <tr>
                    <td>
                    <a href="<%= Url.Action("Index", "EtapaProducto") %>" id="bAnterior">Anterior</a>
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
                        <th>Opciones</th>                   
                        <th>Compañia</th>
                        <th>Mes Inicial</th>
                        <th>Mes Final</th>   
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
                <% foreach (var item in ((IEnumerable<CompaniaxEtapa>)ViewData["CompaniaxEtapas"])) { 
                %>
                    
                    <tr>
                       <td align= "center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Compañia x Etapa'><span class='ui-icon ui-icon-pencil'/></a>                            
                        </td>                
                        <td align = "center"><div class="tdItem"><%: item.Compania.nombre %></div></td>
                        <% DateTime fechaIni = new DateTime(2000, Convert.ToInt16(item.mes_inicial), 1); string fechaInicial = fechaIni.ToString("MMMM"); %>
                        <td align = "center"><div class="tdItem"><%: fechaInicial.ToUpper() %></div></td>
                        <% DateTime fechaFin = new DateTime(2000, Convert.ToInt16(item.mes_final), 1); string fechaFinal = fechaFin.ToString("MMMM"); %>
                        <td align = "center"><div class="tdItem"><%: fechaFinal.ToUpper()%></div></td>              
                    </tr>
                <% } %>
                </tbody>
                </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
