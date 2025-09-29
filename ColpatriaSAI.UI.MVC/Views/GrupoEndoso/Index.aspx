<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Grupos de Endoso
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Grupos de Endoso</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }
    </script>

      <%--VALIDATOR--%>
            <script type="text/javascript">
                $().ready(function () {
                    $("#formGrupoEndoso").validate({
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

    <table>
        <tr valign="top">
            <td>

                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "GrupoEndoso", FormMethod.Post, new { id = "formGrupoEndoso" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% GrupoEndoso grupoEndoso = new GrupoEndoso(); %>
                    <p>
                        <%: Html.Label("Nombre")%>
                        <%: Html.TextBox("nombre", null, new { @class = "required", maxlength = 70 })%>
                        <%: Html.ValidationMessageFor(Model => grupoEndoso.nombre)%>
                    </p>
                    <p><input type="submit" value="Crear" id="crear" /></p>
                <% } %>

            </td>
            <td>

                <table style="padding-left:50px">
                    <tr>
                        <th></th>
                       
                        <th>Nombre</th>
                    </tr>
                    <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                  <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
                <% foreach (var item in ((IEnumerable<GrupoEndoso>)ViewData["GrupoEndoso"])) { %>
                    <tr>
                        <td>
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar grupo', 'dialogEditar');">Editar</a> |
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar grupo', 'dialogEliminar');">Eliminar</a>
                        </td>
                       
                        <td><%: item.nombre %></td>
                    </tr>
                <% } %>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>
</asp:Content>
