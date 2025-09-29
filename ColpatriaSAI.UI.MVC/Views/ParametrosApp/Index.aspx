<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administración de sistema - Parametros de la Aplicación
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h2>Parametros de la Aplicación</h2>

    <script type="text/javascript">
        $(function () {
            $("#accordion").accordion({
                collapsible: true,
                event: "mouseover"
        });
    });
	</script>

        
         <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Editar", "ParametrosApp", FormMethod.Post, new { id = "ParametrosAppCrear" }))
                   {
                    Html.ValidationSummary(true); %>
        <div id="accordion">
	        <h3><a href="#">Parametros Generales</a></h3>
	        <div>
            <table id="tabla">
                <thead>
                    <tr>
                        <th align = "left">Parametro</th>
                        <th align = "left">Valor</th>
                    </tr>
                    </thead>
                    <tbody>
                <% string ruta = Request.Url.ToString().Split('?')[0].ToString();  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);
                   int consecutivo = 0 ;
                   %>
                   
                <% 
                   var item1 = ((IEnumerable<ParametrosApp>)ViewData["ParametrosApp"]).Where(pa => pa.tipoParametro == 1).ToList();                   
                   foreach (var item in item1)
                   { %>
                    <tr>                
                        <td><%: item.parametro %></td>
                        <td>
                            <%: Html.TextBox("valor" + consecutivo, item.valor)%>
                            <%: Html.Hidden("Id" + consecutivo,item.id) %>
                        </td>
                    </tr>
                <% 
                       consecutivo++;
                    } %>
                </tbody>
                </table>
                </div>

                <h3><a href="#">Integración</a></h3>
	            <div>
                 <table id="tabla1">
                <thead>
                    <tr>
                        <th align = "left">Parametro</th>
                        <th align = "left">Valor</th>
                    </tr>
                    </thead>
                    <tbody>
                                  
                <% 
                   var item2 = ((IEnumerable<ParametrosApp>)ViewData["ParametrosApp"]).Where(pa => pa.tipoParametro == 2).ToList();                   
                   foreach (var item in item2)
                   { %>
                    <tr>                
                        <td><%: item.parametro %></td>
                        <td>
                            <%: Html.TextBox("valor" + consecutivo, item.valor) %>
                            <%: Html.Hidden("Id" + consecutivo,item.id) %>
                        </td>
                    </tr>
                <% 
                       consecutivo++;
                    } %>
                </tbody>
                </table>
                </div>
            </div>
                <p>
                <%: Html.Hidden("Total",consecutivo) %>
                <input type="submit" value="Editar" id="editar" /></p>
      
    <% } %>

        

</asp:Content>
