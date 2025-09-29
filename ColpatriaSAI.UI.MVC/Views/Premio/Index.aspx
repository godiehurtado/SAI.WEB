<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Premio - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Premio</h2>

    <script type="text/javascript">
            function mostrarDialog(pagina, titulo, dialog) {
                $("#" + dialog).dialog({
                    height: 500, width: 500, modal: true, title: titulo,
                    open: function (event, ui) { $(this).load(pagina); },
                    close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
                });
            }

            function mostrarDialog1(pagina, titulo, dialog) {
                $("#" + dialog).dialog({
                    height: 200, width: 300, modal: true, title: titulo,
                    open: function (event, ui) { $(this).load(pagina); },
                    close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
                });
            }

            function cerrarDialog(dialog) {
                $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
            }
            $(document).ready(function () {
                oTable = $('#tablaLista').dataTable({"bJQueryUI": true,"sPaginationType": "full_numbers","bStateSave": true});
                $("#tipoPremio_id option").each(function () {
                    $(this).attr({ 'title': $.trim($(this).html()) });
                });
                $("#variable_id option").each(function () {
                    $(this).attr({ 'title': $.trim($(this).html()) });
                });
                $("#unidadmedida_id option").each(function () {
                    $(this).attr({ 'title': $.trim($(this).html()) });
                });
                $("#operador_id option").each(function () {
                    $(this).attr({ 'title': $.trim($(this).html()) });
                });
                $("#bAnterior").button({ icons: { primary: "ui-icon-circle-arrow-w"} });               
            });          
    </script>

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $.validator.setDefaults({                    
                });

                $().ready(function () {
                      $("#formPremio").validate();                   
                    $("#formPremio").validate({
                        rules: {
                            nombre: "required"
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
                function premioSave() {
                    if ($("#formPremio").valid()) {
                        $("#crear").attr('disabled', true);
                        $("#formPremio").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>       
    <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                 <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "Premio", FormMethod.Post, new { id = "formPremio" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.PremioViewModel premio = (ColpatriaSAI.UI.MVC.Models.PremioViewModel)ViewData["PremioViewModel"]; %>
                     <fieldset style="border:1px solid gray">
                     <table>
                        <tr>
                        <td><u><%: Html.Label("Nombre") %></u></td>
                        <td><%: Html.TextBox("nombre", null , new { @class = "required" })%></td>
                    </tr>
                     <tr>
                        <td><u><%: Html.Label("Tipo de Premio")%></u></td>
                        <td><%: Html.DropDownList("tipoPremio_id", (SelectList)premio.TipoPremiosList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>
                     </tr>
                     <tr>
                        <td><%: Html.Label("Variable")%></td>
                        <td><%: Html.DropDownList("variable_id", (SelectList)premio.VariableList, "Ninguno", new { style = "width:300px;" })%></td>
                     </tr>
                     <tr>
                        <td><%: Html.Label("Unidad de Medida")%></td>
                        <td><%: Html.DropDownList("unidadmedida_id", (SelectList)premio.UnidadMedidaList, "Ninguno", new { style = "width:300px;"})%></td>
                     </tr>
                     <tr>
                        <td><u><%: Html.Label("Operador")%></u></td>
                        <td><%: Html.DropDownList("operador_id", (SelectList)premio.OperadorList, "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>
                     </tr>
                     <tr>
                        <td><u><%: Html.Label("Valor") %></u></td>
                        <td><%: Html.TextBox("valor", null,  new { @class = "required decimal", id = "valor" })%></td>
                    </tr>
                    <tr>
                        <td><%: Html.Label("Regularidad?") %></td>
                        <td><%: Html.RadioButton("regularidad", true, new { title = "Es Regularidad?", onclick = "uncheckRadio(this)" })%></td>
                    </tr>
                     <tr>
                        <td><%: Html.Label("Descripcion") %></td>
                        <td><%: Html.TextArea ("descripcion_premio", null, new {@style = "height:200px;width:350px;border:#000000 1px solid;" })%>
                            <%: Html.ValidationMessageFor(model => premio.PremioView.descripcion_premio)%></td>
                    </tr>           
                    </table>
                    </fieldset>
                       
                    <p><input type="submit" value="Guardar" id = "crear" onclick="premioSave()" /></p>
                    <p><input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" /></p>

                <% } %>

            </td>
        </tr>
    </table>

    <table align ="center">
    <tr>
        <td align = "center"><a href="<%= Url.Action("Index", "PremioxSubRegla", new { valuesr = Request.QueryString["valuesr"], valuer = Request.QueryString["valuer"], value = Request.QueryString["value"] }) %>" id="bAnterior">Anterior</a></td>
    </tr>
    </table>

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>                   
                        <th>Descripción</th>
                        <th>Tipo de Premio</th>
                        <th>Variable</th>
                        <th>Unidad de Medida</th>
                        <th>Operador</th>
                        <th>Valor</th>
                        <th>Regularidad?</th>   
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
                <% foreach (var item in ((IEnumerable<Premio>)ViewData["Premios"]))
                   { %>
                    
                    <tr>
                       <td align= "center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Premio'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Premio'><span class='ui-icon ui-icon-trash'/></a>
                        </td>
                        <td align = "center"><div class="tdItem"><%: item.descripcion %></div></td>
                        <td align = "center"><div class="tdItem"><%: item.TipoPremio.nombre %></div></td>
                        <td align = "center"><div class="tdItem"><%: item.Variable.nombre %></div></td>
                        <td align = "center"><div class="tdItem"><%: item.UnidadMedida.nombre %></div></td>
                        <td align = "center"><div class="tdItem"><%: item.Operador.nombre %></div></td>
                        <td align = "center"><div class="tdItem"><%: String.Format("{0:0.00}",item.valor) %></div></td>
                        <td align = "center"><div class="tdItem"><%: ((item.regularidad == true) ? "Si" : "No")  %></div></td>
                                  
                    </tr>
                <% } %>
                </tbody>
                </table>   



    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>