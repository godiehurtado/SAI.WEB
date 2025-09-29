<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $(document).ready(function () {
            oTable1 = $('#tablaLista2').dataTable({
                "bJQueryUI": true,
                "bDestroy": true,
                "bRetrieve": false,
                "aaSorting": [[0, "asc"], [1, "asc"]],
                "sPaginationType": "full_numbers",
                "bSortClasses": false,
                "bLengthChange": false
            });
        });
</script>

 <table id="tablaLista2">
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
            <% foreach (var item in ((IEnumerable<Variable>)ViewData["Variables"]))
               { %>
            <tr>
                <td align="center"><%: Html.RadioButton("seleccionVariable", item.id, new { @onclick = "seleccionarVariable1("+item.id+", \"" + item.nombre + "\")" })%></td> 
                <td><%: item.nombre %></td> 
                <td><%: item.descripcion %></td>                       
            </tr>
            <% } %>
        </tbody>
    </table>