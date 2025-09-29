<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content3" ContentPlaceHolderID="TitleContent" runat="server">
	Estados de grupos endoso por tipos
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Estados de grupos endoso por tipos</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 200, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
            function mostrarDialog1(pagina, titulo, dialog) {
                $("#" + dialog).dialog({
                    height: 230, width: 500, modal: true, title: titulo,
                    open: function (event, ui) { $(this).load(pagina); },
                    close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
                });
            }     
        
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true
            });
            $("#grupoEndoso_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
            $("#tipoEndoso_id option").each(function () {
                $(this).attr({ 'title': $.trim($(this).html()) });
            });
        });
    </script>

    <script type="text/javascript">
        function GrupotipoEndosoSave() {
            if ($("#formGrupoTipoEndoso").valid()) {
                $("#crear").attr('disabled', true);
                $("#formGrupoTipoEndoso").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>

    <%--VALIDATOR--%>
    <script type="text/javascript">
        $.validator.setDefaults({
            });
        $().ready(function () {
            $("#formGrupoTipoEndoso").validate();
            });
    </script>
            
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <div style="clear:both;"><hr /></div>

    <p>
        <a href="/Administracion">Regresar</a>
    </p>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "GrupoTipoEndoso", FormMethod.Post, new { id = "formGrupoTipoEndoso" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.ExcepcionesporGrupoTipoEndosoViewModel exgrupoEndoso =
                           (ColpatriaSAI.UI.MVC.Models.ExcepcionesporGrupoTipoEndosoViewModel)ViewData["GTEViewModel"]; %>
                    <fieldset style="border:1px solid gray">
                    <table width="100%" cellpadding="2">         
                        <tr>
                            <td><%: Html.Label("Grupo de endoso")%></td>
                            <td><%: Html.DropDownList("grupoEndoso_id", (SelectList)exgrupoEndoso.GrupoEndosoList, "Seleccione", new { @class = "required",style = "width:200px;" })%></td>
                        </tr>
                        <tr>
                            <td><%: Html.Label("Tipo de endoso")%></td>
                            <td><%: Html.DropDownList("tipoEndoso_id", (SelectList)exgrupoEndoso.TipoEndosoList, "Seleccione", new { @class = "required", style = "width:200px;" })%></td>
                        </tr>
                        <tr>
                            <td><%: Html.Label("Estado destino")%></td>
                            <td><%: Html.DropDownList("estadoDestino", new SelectList(new List<string>() { "V", "NV" }))%></td>
                        </tr>
                        <tr>
                            <td><input type="button" value="Guardar" id="crear" onclick="GrupotipoEndosoSave()" /></td>
                        </tr>
                </table>
                </fieldset>
                <% } %>   
            </td>
        </tr>
    </table>

    <h4 align = "center"><b>De acuerdo a la combinación de grupo endoso + tipo endoso,</b> <br />
                         <b>parametrice el estado real de las polizas (Vigente o No Vigente)</b> <br />
                         <b>que se tomará para el calculo de la persistencia de VIDA</b> </h4>

            <table id="tablaLista">
                     <thead>
                    <tr>
                        <th align="center">Opciones</th>
                        <th align="center">Compañía</th>
                        <th>Grupo de endoso</th>
                        <th>Tipo de endoso</th>
                        <th align="center">Estado destino</th>
                    </tr>
                  <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
                 </thead>
                <tbody>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<ExcepcionesxGrupoTipoEndoso>)ViewData["GruposTipos"]))
                   { %>
                    <tr>
                        <td align="center">
                           <a href="javascript:mostrarDialog1('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float: left;' title='Editar Detalle Moneda'><span class='ui-icon ui-icon-pencil'>Editar</a>
                           <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar' );" style='float: right;' title='Eliminar Detalle Moneda'><span class='ui-icon ui-icon-trash'>Eliminar</a>
                        </td>                        
                        <td align="center"><%: item.Compania.nombre %></td>
                        <td><%: item.GrupoEndoso.nombre %></td>
                        <td><%: item.TipoEndoso.nombre %></td>
                        <td align="center"><%: ((item.estado == "V") ? "Vigente" : "No Vigente") %></td>
                    </tr>
                <% } %>

                  </tbody>
            </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>
