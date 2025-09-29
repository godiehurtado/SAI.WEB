<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Base por participante
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Base por participante</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 200, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        function mostrarBusqueda() {
            $("#busquedaAvanzada").toggle('slow');
            $("#buscarBase").attr("value", "");
            $("#buscarSalario").attr("value", "");
            $("#buscarParticipante").attr("value", "");
            oTable.fnDraw();
        }
        $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bBase = document.getElementById('buscarBase').value;
	            var bSalario = document.getElementById('buscarSalario').value;
	            var bParticipante = document.getElementById('buscarParticipante').value;

	            var Base = aData[2];
	            var Salario = aData[3];
	            var Participante = aData[4];

	            var comparaBase = Base.toUpperCase().indexOf(bBase.toUpperCase());
	            var comparaSalario = Salario.toUpperCase().indexOf(bSalario.toUpperCase());
	            var comparaParticipante = Participante.toUpperCase().indexOf(bParticipante.toUpperCase());

	            if ((comparaBase >= 0) && (comparaSalario >= 0) && (comparaParticipante >= 0)) {
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
            $('#buscarBase').keyup(function () { oTable.fnDraw(); });
            $('#buscarSalario').keyup(function () { oTable.fnDraw(); });
            $('#buscarParticipante').keyup(function () { oTable.fnDraw(); });
        });
    </script>

      
    <%--VALIDATOR--%>
    <script type="text/javascript">
        $.validator.setDefaults({ });
        $().ready(function () {
            //$("#BasexParticipanteCrear").validate();
            $("#BasexParticipanteCrear").validate({
                rules: {
                    salario: "required number",
                    participante_id: "required"
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
                <h4>Definir Base</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "BasexParticipante", FormMethod.Post, new { id = "BasexParticipanteCrear" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.BasexParticipanteViewModel basexParticipante =
                           (ColpatriaSAI.UI.MVC.Models.BasexParticipanteViewModel)ViewData["BasexParticipanteViewModel"]; %>
                    <p>
                        <%: Html.Label("Base") %>
                        <%: Html.TextBox("@base", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => basexParticipante.BasexParticipanteView.@base)%>
                    </p>
                    <p>
                        <%: Html.Label("Salario")%>
                        <%: Html.TextBox("salario")%>
                        <%: Html.ValidationMessageFor(Model => basexParticipante.BasexParticipanteView.salario)%>
                    </p>
                    <p>
                        <%: Html.Label("Participante")%>
                        <%: Html.DropDownList("participante_id", (SelectList)basexParticipante.ParticipanteList, "Seleccione Un Valor")%>
                    </p>
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>
            
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
		            <tr>
			            <td><label for="buscarBase">Base:</label></td>
			            <td><input type="text" id="buscarBase" name="buscarBase" /></td>
			            <td><label for="buscarSalario">Salario:</label></td>
			            <td><input type="text" id="buscarSalario" name="buscarSalario" size="12" /></td>
			            <td><label for="buscarParticipante">Participante:</label></td>
			            <td><input type="text" id="buscarParticipante" name="buscarParticipante" size="12" /></td>
		            </tr>
	            </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Código</th>
                        <th>Base</th>
                        <th>Salario</th>
                        <th>Participante</th>
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
                <% foreach (var item in ((IEnumerable<BasexParticipante>)ViewData["BasexParticipantes"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');">Eliminar</a>
                        </td>
                        <td align="center"><%: item.id %></td>
                        <td align="center"><%: item.@base %></td>
                        <td align="center"><%: item.salario %></td>
                        <td align="center"><%: item.Participante.clave + " - " + item.Participante.nombre %></td>
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