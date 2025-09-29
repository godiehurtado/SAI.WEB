<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<List<ColpatriaSAI.UI.MVC.Models.CategoriaReglaModel>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Categorías por Regla
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "bPaginate": false,"bStateSave": true });
            $('#buscarCategoria').keyup(function () { oTable.fnDraw(); });
        });

        var era;
        function uncheckRadio(rbutton) {
            if (rbutton.checked == true && era == true) { rbutton.checked = false;}
            
        }

        function CategoriaxReglaSave() {
            $("#formCategoriaxRegla").submit();
            mostrarCargando("Enviando informacion. Espere Por Favor...");
        }
    </script>

<h2>Categorías por Regla</h2>
    <p>
        <a href="<%= Url.Action("Index", "Regla", new { value = ViewData["concurso_id"] }) %>" id="bAnterior">Anterior</a>
    </p>
    <% using (Html.BeginForm("Editar", "CategoriaxRegla", FormMethod.Post, new { id = "formCategoriaxRegla" }))
       { %>
    <table id="tablaLista">
        <thead>
        <tr>
            <th>Nombre de la categoría</th>
            <th>Recaudos</th>
            <th>Colquines</th>
            <th>Ninguno</th>
        </tr>
        </thead>
        <% 
            foreach (var item in Model)
           {%>
        <tr>
            <td><%: item.categoria_nombre%></td>
            <td align="center">
                <%: Html.RadioButton("cat_" + item.categoriaxRegla_id + "_" + item.categoria_id, "recaudo", item.esRecaudo)%>
            </td>
            <td align="center">
                <%: Html.RadioButton("cat_" + item.categoriaxRegla_id + "_" + item.categoria_id, "colquin", item.esColquin)%>
            </td>
            <td align="center">
                <%: Html.RadioButton("cat_" + item.categoriaxRegla_id + "_" + item.categoria_id, "ninguno", (!item.esRecaudo && !item.esColquin))%>
            </td>
        </tr>
        <% } %>
    </table>
    <br />
    <input type="button" value="Guardar" id = "crear" onclick="CategoriaxReglaSave()" />
    <input type="hidden" id="regla_id" name="regla_id" value="<%: ViewData["regla_id"] %>" />
    <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["concurso_id"] %>" />
    <% } %>
</asp:Content>