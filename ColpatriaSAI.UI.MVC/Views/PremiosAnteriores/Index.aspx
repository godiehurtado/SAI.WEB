<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Premios Anteriores - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Premios Años Anteriores</h2>

     <script type="text/javascript">
         function mostrarDialog(pagina, titulo, dialog) {
             $("#" + dialog).dialog({
                 height: 220, width: 550, modal: true, title: titulo,
                 open: function (event, ui) { $(this).load(pagina); },
                 close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
             });
         }

         function mostrarDialog1(pagina, titulo, dialog) {
             $("#" + dialog).dialog({
                 height: 150, width: 250, modal: true, title: titulo,
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


    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({
                    
                });

                $().ready(function () {
                      $("#formPremiosAnteriores").validate();                   
                    $("#formPremiosAnteriores").validate({
                        rules: {
                            clave: "required"
                        },                       
                    }); });
            </script>

            
            <script type="text/javascript">
                var era;
                function uncheckRadio(rbutton) {
                    if (rbutton.checked == true && era == true) { rbutton.checked = false; }
                    era = rbutton.checked;
                }
            </script>

            <script type="text/javascript">
                function PremioAnteriorSave() {
                    if ($("#formPremiosAnteriores").valid()) {

                        if ($("#FASECOLDA")[0].checked == true || $("#LIMRA")[0].checked == true) {
                            $("#crear").attr('disabled', true);
                            $("#formPremiosAnteriores").submit();
                            mostrarCargando("Enviando informacion. Espere Por Favor...");
                        }

                        else {
                            mostrarError("El Premio no se ha asignado!");
                        }      
                    }
                }
            </script>

    <table id="tablaAdmin" style="clear:left;">
        <tr valign="top">
            <td>
                 <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "PremiosAnteriores", FormMethod.Post, new { id = "formPremiosAnteriores" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.PremiosAnterioresViewModel premiosanteriores = (ColpatriaSAI.UI.MVC.Models.PremiosAnterioresViewModel)ViewData["PremiosAnterioresViewModel"]; %>
                    
                    <fieldset style="border:1px solid gray">
                    <table width="100%" cellpadding="2" >
                    <tr>                                             
                        <td><%: Html.Label("FASECOLDA:")%></td>
                        <td><%: Html.RadioButton("FASECOLDA", true, new { title = "Premio FASECOLDA", onclick = "uncheckRadio(this)" } )%></td>
                    </tr>
                    <tr>
                        <td><%: Html.Label("LIMRA:")%></td>                        
                        <td><%: Html.RadioButton("LIMRA", true, new { title = "Premio LIMRA", onclick = "uncheckRadio(this)" } )%></td>
                    </tr>               
                    <tr>
                         <td><%: Html.Label("Clave:")%></td>
                         <td><%: Html.TextBox("clave", null, new { title = "Ingrese Clave", size="4" })%>
                         <%: Html.ValidationMessageFor(Model => premiosanteriores.PremiosAnterioresView.clave)%></td>
                    </tr>
                    <tr>
                         <td><%:Html.Label("Año:")%></td>
                         <td><%=Html.ComboAnios("anio") %></td> 
                    </tr>                   
                    <tr>
                        <td><input type="button" value="Guardar" id = "crear" onclick="PremioAnteriorSave()" /></td>
                    </tr>
                    </table>
                    </fieldset>
                    
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
                        <th>Clave</th>
                        <th>Año</th>   
                        <th>FASECOLDA</th>
                        <th>LIMRA</th>
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
                <% foreach (var item in ((IEnumerable<PremiosAnteriore>)ViewData["PremiosAnteriores"]))
                   { %>
            
                    <tr>
                       <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Premio Anterior'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Premio Anterior'><span class='ui-icon ui-icon-trash'/></a> 
                        </td>
                        <td align = "center"><%: item.clave %></td>
                        <td align = "center"><%: item.año %></td>             
                        <td align = "center"><%: ((item.FASECOLDA == true) ? "SI" : "NO") %></td>                     
                        <td align = "center"><%: ((item.LIMRA == true) ? "SI" : "NO") %></td>                     
                    </tr>
                <% } %>
                </tbody>
                </table> 

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>