<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $(document).ready(function () {
        oTable = $('#tablaLista3').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers", "bStateSave": true            
        });
    });
</script>

 <table id="tablaLista3">
        <thead>
            <tr>
                <th align = "center">Seleccionar</th>                
                <th align = "center">Nombre</th>                
                <th align = "center">Descripción</th> 
            </tr>
        </thead>
        <tbody>
            <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
            <% Random random = new Random();
               int num = random.Next(1, 10000);  %>
            <% foreach (var item in ((IEnumerable<Premio>)ViewData["Premios"]))
               { %>
            <tr>
                <td align="center"><%: Html.RadioButton("seleccionPremio1", item.id, new { @onclick = "seleccionarPremio("+item.id+", \"" + item.descripcion + "\")" })%></td> 
                <td><%: item.descripcion %></td> 
                <td><%: item.descripcion_premio %></td>                       
            </tr>
            <% } %>
        </tbody>
    </table>