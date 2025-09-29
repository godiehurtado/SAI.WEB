<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Categorias
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Categorias</h2>

      <script type="text/javascript">
          function mostrarDialog(pagina, titulo, dialog) {
              $("#" + dialog).dialog({
                  height: 180, width: 350, modal: true, title: titulo,
                  open: function (event, ui) { $(this).load(pagina); },
                  close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
              });
          }
          $(document).ready(function () {
              oTable = $('#tablaLista').dataTable({
                  "bJQueryUI": true,
                  "sPaginationType": "full_numbers","bStateSave": true
              });
              /* Event Listener del campo de búsqueda avanzada */
              $('#buscarNombre').keyup(function () { oTable.fnDraw(); });
//              $('#buscarNivel').keyup(function () { oTable.fnDraw(); });
          });

          function mostrarBusqueda() {
              $("#busquedaAvanzada").toggle('slow');
              $("#buscarNombre").attr("value", "");
//              $("#buscarNivel").attr("value", "");
              oTable.fnDraw();
          }

          $.fn.dataTableExt.afnFiltering.push(
	        function (oSettings, aData, iDataIndex) {
	            var bNombre = document.getElementById('buscarNombre').value;
//	            var bNivel = document.getElementById('buscarNivel').value;
	            var Nombre = aData[1];
	            var Nivel = aData[2];
	            var comparaNombre = Nombre.toUpperCase().indexOf(bNombre.toUpperCase());
//	            var comparaNivel = Nivel.toUpperCase().indexOf(bNivel.toUpperCase());
	            if ((comparaNombre >= 0) /*&& (comparaNivel >= 0)*/) {
	                return true;
	            }
	            return false;
	        }
        );
    </script>

        <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formCategoria").validate({
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

    <div style="clear:both;"><hr /></div>

    <table id="tablaAdmin">
        <tr valign="top">
           <%-- <td>
                <h4>Crear nueva Categoria</h4>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "Categoria", FormMethod.Post, new { id = "formCategoria", onsubmit = "return enviado()" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.CategoriaViewModel categoria = (ColpatriaSAI.UI.MVC.Models.CategoriaViewModel)ViewData["CategoriaViewModel"]; %>
                    <fieldset style="border:1px solid gray">                    
                        <table width="100%" cellpadding="2">
                    <tr>
                        <td><%: Html.Label("Nombre")%></td>
                        <td><%: Html.TextBox("nombre", null, new { @class = "required", maxlength = 70 })%>
                        <%: Html.ValidationMessageFor(Model => categoria.CategoriaView.nombre)%></td>
                    </tr>
                    </table>                  
                  
                    <table>
                    <tr>
                        <td><input type="submit" value="Crear" id="crear" /></p></td>
                    </tr>
                    </table>
                    </fieldset>
                <% } %>

            </td>--%>
            <td>                
                <div><input type="checkbox" id="checkBusqueda" onclick="mostrarBusqueda();" /> <label for="checkBusqueda">Avanzada</label></div>
                <table border="0" cellspacing="5" cellpadding="5" id="busquedaAvanzada" style="display:none">
				    <tr>
					    <td><label for="buscarNombre">Nombre:</label></td>
					    <td><input type="text" id="buscarNombre" name="buscarNombre" /></td>
					    <%--<td><label for="buscarNivel">Nivel:</label></td>
					    <td><input type="text" id="buscarNivel" name="buscarNivel" /></td>--%>
					    <%--<td><label for="buscarPrincipal">Principal:</label></td>
					    <td><input type="text" id="buscarPrincipal" name="buscarPrincipal" /></td>--%>
				    </tr>
			    </table>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Nombre</th>
                        <%--<th>Nivel</th> --%>
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

                <% foreach (var item in ((IEnumerable<Categoria>)ViewData["Categorias"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar Categoria', 'dialogEditar');" style='float: left;' title='Editar Categoria'><span class='ui-icon ui-icon-pencil' />Editar</a>
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Categoria', 'dialogEliminar');" style='float: right;' title='Eliminar Categoria'><span class='ui-icon ui-icon-trash' />>Eliminar</a>
                        </td>
                        <td><%: item.nombre %></td><%--
                        <td><%: item.Nivel.nombre %></td> --%>  
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
