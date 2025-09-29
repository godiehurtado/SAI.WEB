<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Antiguedades por Nivel
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <h2>Antiguedades por Nivel</h2>
    
    <%--POP--%>
    <script type="text/javascript">
        $().ready(function () {
            $("#AntiguedadCrear").validate({
                rules: {
                    numeroMeses: "required number",
                    nivel_id: "required"
                },
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }
            });
        });
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 160, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarNivel").attr("value", "");
            $("#buscarMeses").attr("value", "");
            oTable.fnDraw();
        }
        /* Filtro para buscar en la 3ra columna exclusivamente*/
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNivel = document.getElementById('buscarNivel').value;
	            var bMeses = document.getElementById('buscarMeses').value;
	            var Nivel = aData[3];
	            var Meses = aData[2];
	            var comparaNivel = Nivel.toUpperCase().indexOf(bNivel.toUpperCase());
	            var comparaMeses = Meses.toUpperCase().indexOf(bMeses.toUpperCase());

	            if ((comparaNivel >= 0) && (comparaMeses >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                "bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarNivel').keyup(function () { oTable.fnDraw(); });
            $('#buscarMeses').keyup(function () { oTable.fnDraw(); });
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
    
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
            <h4>Definir antigüedad</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "AntiguedadxNivel", FormMethod.Post, new { id = "AntiguedadCrear" }))
                   {
                       Html.ValidationSummary(true); %>
                    <% AntiguedadViewModel antiguedad = (AntiguedadViewModel)ViewData["AntiguedadViewModel"]; %>
                    <p>
                        <%: Html.Label("Número de meses")%>
                        <%: Html.TextBox("numeroMeses", null, new { @class = "required number"})%>
                        <%: Html.ValidationMessageFor(Model => antiguedad.AntiguedadView.numeroMeses)%>
                    </p>
                    <p>
                        <%: Html.Label("Nivel")%>
                        <%: Html.DropDownList("nivel_id", (SelectList)antiguedad.NivelList, "Seleccione un Valor", new { @class = "required" })%>
                    </p>
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>
            </td>
            <td>
                
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
				    <tr>
					    <td><label for="buscarNivel">Nivel:</label></td>
					    <td><input type="text" id="buscarNivel" name="buscarNivel" /></td>
					    <td><label for="buscarMeses">Número de meses:</label></td>
					    <td><input type="text" id="buscarMeses" name="buscarMeses" /></td>
				    </tr>
			    </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Número de meses</th>
                        <th>Nivel</th>
                    </tr>
                </thead>
                <tbody>
                 <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<AntiguedadxNivel>)ViewData["Antiguedades"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar antiguedad', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar antiguedad', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td align="center"><%: item.numeroMeses %></td>
                        <td><%: item.Nivel.nombre %></td>
                    </tr>
    
                <% } %>
                 </tbody>
                 </table>
            </td>
        </tr>
    </table>
    
    <div id='dialogEliminar' style="display:none;"></div>
    <div id='dialogEditar' style="display:none;"></div>

    <%--<p><%: Html.ActionLink("Create New", "Create") %></p>--%>
</asp:Content>
