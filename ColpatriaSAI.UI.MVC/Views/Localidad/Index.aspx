<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Localidades - Sistema de administración de incentivos
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

        /* Filtro para buscar en la 3ra columna exclusivamente*/
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bLocalidad= document.getElementById('buscarLocalidad').value;
	            var bZona = document.getElementById('buscarZona').value;
                var Localidad = aData[2];
	            var Zona = aData[3];
	            var comparaLocalidad = Localidad.toUpperCase().indexOf(bLocalidad.toUpperCase());
                var comparaZona = Zona.toUpperCase().indexOf(bZona.toUpperCase());
                if ((comparaZona >= 0) && (comparaLocalidad >= 0)) {
	                return true;
	            } else if (Zona = "") {
	                return true;
	            }
	            return false;
	        }
        );

	        /* Filtro para buscar en el Tipo de Localidad*/
	        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bLocalidad = document.getElementById('buscarLocalidad').value;
	            var bTipoLocalidad = document.getElementById('buscarTipoLocalidad').value;
	            var Localidad = aData[2];
	            var TipoLocalidad = aData[4];
	            var comparaLocalidad = Localidad.toUpperCase().indexOf(bLocalidad.toUpperCase());
	            var comparaTipoLocalidad = TipoLocalidad.toUpperCase().indexOf(bTipoLocalidad.toUpperCase());
	            if ((comparaTipoLocalidad >= 0) && (comparaLocalidad >= 0)) {
	                return true;
	            } else if (TipoLocalidad = "") {
	                return true;
	            }
	            return false;
	        }
        );
	       
	    function mostrarBusqueda() {
	        $("#busquedaAvanzada").toggle('slow');
	        $("#buscarZona").attr("value", "");
	        $("#buscarLocalidad").attr("value", "");
	        $("#buscarTipoLocalidad").attr("value", "");
	        $("#buscarCodigoSISE").attr("value", "");
	        $("#buscarCodigoCAPI").attr("value", "");
	        $("#buscarCodigoBH").attr("value", "");
	        $("#buscarCodigoEMERMEDICA").attr("value", "");
	        $("#buscarCodigoARP").attr("value", "");
	        oTable.fnDraw();
	    }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                "bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarZona').keyup(function () { oTable.fnDraw(); });
            $('#buscarLocalidad').keyup(function () { oTable.fnDraw(); });
            $('#buscarTipoLocalidad').keyup(function () { oTable.fnDraw(); });
            $('#buscarCodigoSISE').keyup(function () { oTable.fnDraw(); });
            $('#buscarCodigoCAPI').keyup(function () { oTable.fnDraw(); });
            $('#buscarCodigoBH').keyup(function () { oTable.fnDraw(); });
            $('#buscarCodigoEMERMEDICA').keyup(function () { oTable.fnDraw(); });
            $('#buscarCodigoARP').keyup(function () { oTable.fnDraw(); });
            
        });
        $().ready(function () {
            $("#LocalidadCrear").validate({
                rules: { nombre: "required", zona_id: "required" },
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }
            });
        });
    </script>


    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>Localidades</h2>
            <p>
                Listado de localidades existentes en el sistema (Sucursales, Franquicias y Expansiones)<br />
                
            </p>
        </div>
        <div id="progresoSeccion">
            <% if (TempData["Mensaje"] != null)
               { %>
                <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
            <% } %>
        <br />
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    
<% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "Localidad", FormMethod.Post, new { id = "LocalidadCrear" }))
                   { %>
                    <%: Html.ValidationSummary(true) %>
                    <% ColpatriaSAI.UI.MVC.Models.LocalidadViewModel localidad = 
                           (ColpatriaSAI.UI.MVC.Models.LocalidadViewModel)ViewData["LocalidadViewModel"];  %>
     <table id="tablaAdmin">
        <tr valign="top">
            <td><b>NUEVA LOCALIDAD</b></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td><%: Html.Label("Nombre") %></td>
            <td>
                <%: Html.TextBox("nombre", null, new { @class = "required", id = "nombre", maxlength = "70" })%>
                <%: Html.ValidationMessageFor(model => localidad.LocalidadView.nombre)%>
            </td>
            <td rowspan="4" valign="top">
                <table width="100%" cellspacing="2">
                    <tr>
                        <th colspan="5" align="center">TABLA DE HOMOLOGACIÓN</th>
                    </tr>
                    <tr>
                        <th align="center">SISE</th>
                        <th align="center">CAPI</th>
                        <th align="center">BH</th>
                        <th align="center">EMERMEDICA</th>
                        <th align="center">ARP</th>
                    </tr>
                    <tr>
                        <td align="center">
                            <%: Html.TextBox("codigo_sise", null, new { id = "codigo_sise", maxlength = "5", size ="5" })%>
                            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_SISE)%>
                        </td>
                        <td align="center">
                            <%: Html.TextBox("codigo_capi", null, new { id = "codigo_capi", maxlength = "5", size = "5" })%>
                            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_CAPI)%>
                        </td>
                        <td align="center">
                            <%: Html.TextBox("codigo_bh", null, new { id = "codigo_bh", maxlength = "5", size = "5" })%>
                            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_BH)%>
                        </td>
                        <td align="center">
                            <%: Html.TextBox("codigo_emermedica", null, new { id = "codigo_emermedica", maxlength = "5", size = "5" })%>
                            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_EMERMEDICA)%>
                        </td>
                        <td align="center">
                            <%: Html.TextBox("codigo_arp", null, new { id = "codigo_arp", maxlength = "5", size = "5" })%>
                            <%: Html.ValidationMessageFor(model => localidad.LocalidadView.codigo_ARP)%>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>        
        <tr>
            <td><%: Html.Label("Zona") %></td>
            <td><%: Html.DropDownList("zona_id", (SelectList)localidad.ZonaList, new { @class = "required", style = "width:120px" })%></td>
            
        </tr>        
        <tr>
            <td><%: Html.Label("Tipo de Localidad") %></td>
            <td><%: Html.DropDownList("tipolocalidad_id", (SelectList)localidad.TipoLocalidad, new { @class = "required", style = "width:120px" })%></td>
            
        </tr>
        <tr>
            <td><%: Html.Label("Clave Pago") %></td>
            <td><%: Html.TextBox("clave_pago", null, new { id = "clave_pago", maxlength = "40" })%></td>
        </tr>
        <tr>
            <td></td>
            <td><input type="submit" value="Crear" id="crear" /></td>
            <td></td>
        </tr>        
    </table>
     <% } %>
    <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
            <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
				<tr>
					<td><label for="buscarZona">Zona:</label></td>
					<td><input type="text" id="buscarZona" name="buscarZona" /></td>
					<td><label for="buscarLocalidad">Localidad:</label></td>
					<td><input type="text" id="buscarLocalidad" name="buscarLocalidad" /></td>
                    <td><label for="buscarTipoLocalidad">Tipo Localidad:</label></td>
					<td><input type="text" id="buscarTipoLocalidad" name="buscarTipoLocalidad" /></td>
                   <%-- <td><label for="buscarcodigo_sise">Código SISE:</label></td>
					<td><input type="text" id="buscarcodigo_sise" name="buscarcodigo_sise" /></td>
                    <td><label for="buscarcodigo_capi">Código CAPI:</label></td>
					<td><input type="text" id="buscarcodigo_capi" name="buscarcodigo_capi" /></td>
                    <td><label for="buscarcodigo_bh">Código BH:</label></td>
					<td><input type="text" id="buscarcodigo_bh" name="buscarcodigo_bh" /></td>
                    <td><label for="buscarcodigo_emermedica">Código EMERMEDICA:</label></td>
					<td><input type="text" id="buscarcodigo_emermedica" name="buscarcodigo_emermedica" /></td>
                    <td><label for="buscarcodigo_arp">Código ARP:</label></td>
					<td><input type="text" id="Text1" name="buscarcodigo_arp" /></td>--%>
				</tr>
			</table>
    <table  id="tablaLista">
                    <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Localidad</th>
                        <th>Zona</th>
                        <th>Tipo Localidad</th>
                        <th>Código SISE</th>
                        <th>Código CAPI</th>
                        <th>Código BH</th>
                        <th>Código EMERMEDICA</th>
                        <th>Código ARP</th>
                        <th>Clave Pago</th>
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
                <% foreach (var item in ((IEnumerable<Localidad>)ViewData["Localidades"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Localidad'><span class='ui-icon ui-icon-pencil'/></a> |
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Localidad'><span class='ui-icon ui-icon-trash'/></a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td><%: item.nombre %></td>
                        <td><%: item.Zona.nombre %></td>
                        <td><%: item.TipoLocalidad.nombre %></td>
                        <td><%: item.codigo_SISE %></td>
                        <td><%: item.codigo_CAPI %></td>
                        <td><%: item.codigo_BH %></td>
                        <td><%: item.codigo_EMERMEDICA %></td>
                        <td><%: item.codigo_ARP %></td>
                        <td><%: item.clavePago %></td>
                    </tr>
                <% } %>
                </tbody>
                </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>