<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%--<%@ Register src="Crear.ascx" tagname="Crear" tagprefix="uc1" %>
<%@ Register src="Listar.ascx" tagname="Listar" tagprefix="uc2" %>--%>


<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Zonas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Zonas</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 150, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $().ready(function () {
            $("#ZonaCrear").validate({
                rules: {
                    nombre: "required"
                },
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }
            });
        });



        /* Filtro para buscar en la 3ra columna exclusivamente
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bZona = document.getElementById('buscarZona').value;
	            var Zona = aData[2];
	            var compara = Zona.toUpperCase().indexOf(bZona.toUpperCase());
	            if (compara >= 0) {
	                return true;
	            } else if (Zona = "") {
	                return true;
	            }
	            return false;
	        }
        );*/
	    /*function mostrarBusqueda() {
	        $("#busquedaAvanzada").toggle('slow');
	        $("#buscarZona").attr("value", "");
	        oTable.fnDraw();
	    }*/
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });

            /* Event Listener del campo de búsqueda avanzada 
            $('#buscarZona').keyup(function () { oTable.fnDraw(); });*/
            

        });
        $('#addStatusBarMessage').click(function () {
            $('#StatusBar').jnotifyAddMessage({
                text: 'This is a non permanent message.',
                permanent: false,
                showIcon: false
            });
        });
	</script>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    <%--<div id='bloqueMensaje' class="ui-widget" style="padding: 0 .7em;">
        <div id='Mensaje' class="ui-state-error ui-corner-all" style="float: left; margin-right: .3em;">Mensaje de prueba de error</div>
    </div>--%>
    <%--<a href="#" class="success">Mostrar mensaje</a>--%>
    <%--<input type="submit" value="mensaje" class="success" />--%>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Crear una nueva Zona</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "Zona", FormMethod.Post, new { id = "ZonaCrear" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% List<Zona> zonas = (List<Zona>)ViewData["Zonas"]; %>
                    <div>
                        <%: Html.Label("Nombre") %>
                        <%: Html.TextBox("nombre", null, new { @class = "required", id = "nombre", maxlength = "50" })%>
                        <%: Html.ValidationMessageFor(model => zonas.First().nombre)%>
                    </div>
                    <p><input type="submit" id="crear" value="Crear" /></p>
                <% } %>

            </td>
            <td>
            <%--<div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> Avanzada</div>
            <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
				<tr>
					<td><label for="buscarZona">Zona:</label></td>
					<td><input type="text" id="buscarZona" name="buscarZona" /></td>
				</tr>
			</table>--%>
                <table  id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Zona</th>
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
                <% foreach (var item in ((IEnumerable<Zona>)ViewData["Zonas"])) { %>
                <% %>

                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td><%: item.nombre %></td>
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
    
    <%--<% Html.RenderPartial("EditorTemplates/LocalidadView"); %>--%>
    <%--<%  string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>

    <a href="javascript:mostrarDialog('<%= ruta %>Crear', 'Crear zona', 'dialogCrear');">Crear zona...</a>
    <div id='dialogCrear'></div>
    <div id='dialogEditar'></div>
    <div id='dialogEliminar'></div>

    <% Html.RenderPartial("Listar"); %>--%>

</asp:Content>