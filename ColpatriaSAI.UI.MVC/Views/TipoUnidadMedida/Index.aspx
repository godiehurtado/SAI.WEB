<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content3" ContentPlaceHolderID="TitleContent" runat="server">
	Tipo Unidad de Medida
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Tipo Unidad de Medida</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers"
            });
        });
    </script>

   
    <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formTipoUnidadMedida").validate({
                        rules: {
                            nombre: "required",
                            codigoCore: "required"
                        },
                        submitHandler: function (form) {
                            $("#crear").attr('disabled', true);
                            form.submit();
                        }
                    });

                });
            </script>

            <script  type="text/javascript">javascript: window.history.forward(1);</script>
            
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>

                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "TipoUnidadMedida", FormMethod.Post, new { id = "formTipoUnidadMedida" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.TipoUnidadMedidaViewModel tipounidadmedida =
                           (ColpatriaSAI.UI.MVC.Models.TipoUnidadMedidaViewModel)ViewData["TipoUnidadMedidaViewModel"]; %>
                    <table>
                       <tr>
                       <td>
                           <%: Html.Label("Nombre") %>
                       </td>
                       <td>
                            <%: Html.TextBox("nombre", null, new { @class = "required" })%>
                            <%: Html.ValidationMessageFor(Model => tipounidadmedida.TipoUnidadMedidaView.nombre)%>
                       </td>                   
                       </tr> 
                       </table>
                            
                       <p><input type="submit" value="Guardar" id="crear" /></p>
                            
                        <p><a href="../UnidadMedida">Atrás</a></p>  
                <% } %>
       

                <table  id="tablaLista">
                     <thead>
                    <tr>
                        <th>Opciones</th>
                        <th>Nombre</th>
                        <%--<th>Tipo Unidad de Medida</th>--%>
                        
                        
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
                <% foreach (var item in ((IEnumerable<TipoUnidadMedida>)ViewData["TipoUnidadMedidas"]))
                   { %>
                    <tr>
                        <td align=center>
                           <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');">Eliminar</a>
                        </td>
                        
                        <td align="center"><%: item.nombre %></td>
                        <%--<td align="center"><%: item.TipoUnidadMedida.nombre %></td>--%>
                        
                        
                    </tr>
                <% } %>

                  </tbody>

        </tfoot>--%>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>
