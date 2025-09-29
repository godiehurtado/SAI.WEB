<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Bancos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
        });

        function eliminarBanco(idBanco) {

            if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
                var stUrl = '/Banco/DeleteBanco';
                mostrarCargando("Eliminando Banco. Espere Por Favor...");
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: {
                        idBanco: idBanco
                    },
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');

                            if (response.Result == 1) {
                                mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                                window.location.href = window.location.href;
                            }
                            else if (response.Result == 0) {
                                mostrarError("El Banco no se puede eliminar por que hay registros relacionados.")
                            }

                        }
                    }
                });
            }
        }

    </script>

    <h2>Bancos</h2>
    <p>
        <a href="/Administracion">Regresar</a> | <%: Html.ActionLink("Crear nuevo Banco", "Create") %>
    </p>
        
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <%  string ruta = Request.Url.ToString();  if (!ruta.EndsWith("/")) { ruta = Request.Url + "/"; } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>

                <table id="tablaLista">
                <thead>
                    <tr>                        
                        <th>Código</th>
                        <th>Banco</th>
                        <th>Opciones</th>
                    </tr>
                </thead>
                <tbody>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<Banco>)ViewData["Bancos"]))
                   { %>
                    <tr>
                        <td align= "center"><%: item.id %></td>
                        <td><%: item.nombre %></td>
                        <td nowrap = "nowrap" align="center">
                            <a href="/Banco/Create/?bancoId=<%: item.id %>" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                
                            <a href="/Banco/Detalle/?idBanco=<%: item.id %>" title='Agrupar Bancos' style="float:left;"><span class='ui-icon ui-icon-newwin'/></a>                
                            <a href="javascript:eliminarBanco(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                        </td>
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>
   
</asp:Content>