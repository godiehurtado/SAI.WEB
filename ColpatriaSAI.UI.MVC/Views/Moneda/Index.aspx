<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Monedas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Monedas</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 250, width: 400, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 160, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        /* Filtro para buscar en la 3ra columna exclusivamente*/
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bUnidad = document.getElementById('buscarUnidad').value;
	            var bMoneda = document.getElementById('buscarMoneda').value;
	            var Unidad = aData[3];
	            var Moneda = aData[2];
	            var comparaUnidad = Unidad.toUpperCase().indexOf(bUnidad.toUpperCase());
	            var comparaMoneda = Moneda.toUpperCase().indexOf(bMoneda.toUpperCase());

	            if ((comparaMoneda >= 0) && (comparaUnidad >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarUnidad").attr("value", "");
            $("#buscarMoneda").attr("value", "");
            oTable.fnDraw();
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarUnidad').keyup(function () { oTable.fnDraw(); });
            $('#buscarMoneda').keyup(function () { oTable.fnDraw(); });
            
         });
      
    </script>

     <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#MonedaCrear").validate({
                        rules: {
                             
                            nombre: "required"
                        },
                        submitHandler: function (form) {
                            $("#crear").attr('disabled', true);
                            form.submit();
                        } 
                    });               

                });
            </script>
            
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
    <%--<p><a href="javascript:mostrarDialog('<%= ruta %>Crear', 'Crear moneda', 'dialogCrear');">Crear moneda...</a></p>--%>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Crear nueva Moneda</h4>
                <% using (Html.BeginForm("Crear", "Moneda", FormMethod.Post, new { id = "MonedaCrear" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.MonedaViewModel moneda = (ColpatriaSAI.UI.MVC.Models.MonedaViewModel)ViewData["MonedaViewModel"]; %>
                    <table width="100%" cellpadding="2">
                    <tr>     
                        <td><%: Html.Label("Nombre") %>
                        <%: Html.TextBox("nombre", null, new { @class = "required", maxlength = 70 })%>
                        <%: Html.ValidationMessageFor(Model => moneda.MonedaView.nombre)%></td>
                    <td>
                        <%: Html.Label("Unidad de medida") %>
                        <%: Html.DropDownList("unidadmedida_id", (SelectList)moneda.UnidadMedidaList, "Seleccione un Valor",new {@class = "required"})%>
                    </td>
                    </tr>
                     <tr>
                        <td><%: Html.Label("Segmento") %>
                        <%: Html.DropDownList("segmento_id", (SelectList)moneda.SegmentoList, "Seleccione un Valor",new {@class = "required"})%>
                    </td>
                    </tr>
                    </table>

                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>
            
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
				    <tr>
					    <td><label for="buscarUnidad">Unidad de medida:</label></td>
					    <td><input type="text" id="buscarUnidad" name="buscarUnidad" /></td>
					    <td><label for="buscarMoneda">Moneda:</label></td>
					    <td><input type="text" id="buscarMoneda" name="buscarMoneda" /></td>
				    </tr>
			    </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Moneda</th>
                        <th>Unidad de medida</th>
                        <th>Segmento</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<Moneda>)ViewData["Monedas"]))
                   { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar moneda:  <%: item.nombre %>', 'dialogEditar');" style='float:left;' title='Editar Moneda'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar moneda:  <%: item.nombre %>', 'dialogEliminar');" style='float:right;' title='Eliminar Moneda'><span class='ui-icon ui-icon-trash'/></a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td align="center"><%: item.nombre %></td>
                        <td align="center"><%: item.UnidadMedida.nombre %></td>
                        <td align="center"><%: item.Segmento.nombre %></td>
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>