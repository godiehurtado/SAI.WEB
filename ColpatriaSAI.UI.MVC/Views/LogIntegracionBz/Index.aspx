<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Parametrización Integración
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function mostrarDialog1(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 190, width: 300, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function cerrarDialog(dialog) {
            $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
        }
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers","bStateSave": true
            });

        });
        
    </script>

    <div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Información de fechas de Extracción de GP</h2>			
			<p>
                <a href="<%= Url.Action("Index", "PeriodoCierre") %>" >Regresar</a>
            </p>          
		</div>

		<div id="progresoSeccion">
	</div>

		<div style="clear:both;"><hr /></div>
	</div>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Editar</th>                       
                        <th align = "center">Aplicación</th>
                        <th align = "center">Tipo de Extracción</th>
                        <th align = "center">Fecha Inicial</th>
                    </tr>
                </thead>
                <tbody>
                  <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<LogIntegracionwsIntegrador>)ViewData["LogIntegracions"]))
                   { %>
                    
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog1('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Fecha de Inicio'><span class='ui-icon ui-icon-pencil'/></a>
                        </td>
                  
                        <td align = "center"><%: item.aplicacion %></td>
                        <td align = "center"><%: item.tipoExtraccion %></td>
                        <td align = "center"><%: String.Format("{0:d}", item.fechaInicial)%></td>
                    </tr>
                <% } %>
                </tbody>
                </table>   

    
    <div id='dialogEditar' style="display:none;"></div>

</asp:Content>
