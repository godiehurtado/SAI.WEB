<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<script type="text/javascript">
    $(document).ready(function () {
        oTable = $('#tablaLista8').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers", "bStateSave": true
        });
    });
</script>

 <table id="tablaLista8">
        <thead>
            <tr>
                <th align = "center">Seleccionar</th>                
                <th align = "center">Nombre</th>
                <th align = "center">Principal</th>
                <th align = "center">Regla</th>
            </tr>
        </thead>
        <tbody>
            <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
            <% Random random = new Random();
               int num = random.Next(1, 10000);  %>
            <% foreach (var item in ((IEnumerable<SubRegla>)ViewData["SubReglas"]))
               { %>
            <tr>
                <td align="center"><%: Html.RadioButton("seleccionSubReglaEdit1", item.id, new { @onclick = "seleccionarSubReglaEdit1(" + item.id + ", \"" + item.descripcion + "\")" })%></td> 
                <td><%: item.descripcion %></td>                                    
                <td><%: ((item.principal == true) ? "Si" : "No") %></td>  
                <td><%: item.Regla.nombre %></td>  
            </tr>
            <% } %>
        </tbody>
    </table>