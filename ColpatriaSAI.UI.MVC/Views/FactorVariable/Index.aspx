<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Factor Variable
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Factor Variable</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarNombre").attr("value", "");
            $("#buscarDirecto").attr("value", "");
            $("#buscarContratacion").attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNombre = document.getElementById('buscarNombre').value;
	            var bDirecto = document.getElementById('buscarDirecto').value;
	            var bContratacion = document.getElementById('buscarContratacion').value;

	            var Nombre = aData[2];
	            var Directo = aData[3];
	            var Contratacion = aData[4];

	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
	            var comparaDirecto = Directo.toUpperCase().indexOf(bDirecto.toUpperCase());
	            var comparaContratacion = Contratacion.toUpperCase().indexOf(bContratacion.toUpperCase());

	            if ((comparaNombre >= 0) && (comparaDirecto >= 0) && (comparaContratacion >= 0)) {
	                return true;
	            }
	            return false;
	        }
        );
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });
            /* Event Listener del campo de búsqueda avanzada */
            $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
            $('#buscarDirecto').keyup(function () { oTable.fnDraw(); });
            $('#buscarContratacion').keyup(function () { oTable.fnDraw(); });
        });
    </script>

    <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formFactorVariable").validate({
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

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Definir los porcentajes</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "FactorVariable", FormMethod.Post, new { id = "formFactorVariable" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% FactorVariable factorVariable = new FactorVariable(); %>
                    <p>
                        <%: Html.Label("Nombre")%>
                        <%: Html.TextBox("nombre", null, new { @class = "required", maxlength = 70 })%>
                        <%: Html.ValidationMessageFor(Model => factorVariable.nombre)%>
                    </p>
                    <p>
                        <%: Html.Label("Valor directo")%>
                        <%: Html.TextBox("valorDirecto", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => factorVariable.valorDirecto)%>
                    </p>
                    <p>
                        <%: Html.Label("Valor contratación")%>
                        <%: Html.TextBox("valorContratacion", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => factorVariable.valorContratacion)%>
                    </p>
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>
            
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		            <tr>
			            <td><label for="buscarNombre">Nombre:</label></td>
			            <td><input type="text" id="buscarNombre" name="buscarNombre" /></td>
			            <td><label for="buscarDirecto">Valor directo:</label></td>
			            <td><input type="text" id="buscarDirecto" name="buscarDirecto" size="12" /></td>
			            <td><label for="buscarContratacion">Valor contratación:</label></td>
			            <td><input type="text" id="buscarContratacion" name="buscarContratacion" size="12" /></td>
		            </tr>
	            </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Nombre</th>
                        <th>Valor directo</th>
                        <th>Valor contratación</th>
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
                <% foreach (var item in ((IEnumerable<FactorVariable>)ViewData["Factores"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar factor variable', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar factor variable', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td><%: item.nombre %></td>
                        <td align="center"><%: item.valorDirecto %></td>
                        <td align="center"><%: item.valorContratacion %></td>
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
