<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $(document).ready(function () {
        oTable = $('#tablaLista').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers", "bStateSave": true
        });
    });
</script>

 <table id="tablaLista">
        <thead>
            <tr>
                <th align = "center">Fecha Inicio</th>                
                <th align = "center">Fecha Fin</th>                
                <th align = "center">Proceso</th> 
                <th align = "center">Estado</th> 
                <th align = "center">Cantidad</th> 
                <th align = "center">Sistema Origen</th> 
                <th align = "center">Sistema Destino</th> 
                <th align = "center">Tabla Destino</th>                 
            </tr>
        </thead>
        <tbody>
            <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
            <% Random random = new Random();
               int num = random.Next(1, 10000);  %>
            <% foreach (var item in ((IEnumerable<LogIntegracion>)ViewData["LogIntegraciones"]))
               { %>
            <tr>                
                <td><%: item.fechaInicio %></td> 
                <td><%: item.fechaFin %></td>                       
                <td><%: item.proceso %></td>                       
                <td><%: item.estado %></td>                       
                <td><%: item.cantidad %></td>                       
                <td><%: item.sistemaOrigen %></td>                       
                <td><%: item.sistemaDestino %></td>                       
                <td><%: item.tablaDestino %></td>                       
            </tr>
            <% } %>
        </tbody>
    </table>