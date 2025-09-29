<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidación de concursos - Sistema de administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $(document).ready(function () {
        $("#botonLiquidar").button({
            icons: {
                primary: "ui-icon-gear"
            },
            text: false
        });
        oTable = $('#tablaLista').dataTable({
            "bJQueryUI": true,
            "sPaginationType": "full_numbers","bStateSave": true
        });
    });
</script>

    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <% 
                var nombre = "";
                foreach (var item in ((List<Concurso>)ViewBag.concursos))
                    nombre = item.nombre;
                   %>
            <h2>Liquidación del concurso <%: nombre %></h2>
            <p>Seleccione una de las reglas del concurso <b><%: nombre %></b> y haga clic en el botón liquidar. 
            Al hacer clic en liquidar podrá visualizar las liquidaciones realizadas previamente así como las condiciones de esta regla.
            </p>
            <p>
            <%: Html.ActionLink("Regresar", "Index", "Concursos")%>
            </p>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    
    <div id="ListaReglas">
        <% using (Html.BeginForm("Liquidaciones", "LiquidacionConcurso", FormMethod.Post, new  { id="liquidacion" }))
           { %>
        <table id="tablaLista">
        <thead>
            <tr>
            <% if (ViewBag.cuentaParticipante != 0) { %>
                <th>Liquidación</th>
            <% } %>
                <th>Regla</th>
                <th>Fecha inicio</th>
                <th>Fecha fin</th>
            </tr>
        </thead>
        <tbody>
             <% foreach (var item in ((IEnumerable<Regla>)ViewBag.reglas))
                { %>
            <tr>
                <% if (ViewBag.cuentaParticipante != 0) { %>
                <td align="center"><input type="radio" id="regla<%: item.id %>" name="regla" value="<%: item.id %>" onclick="$('#liquidacion').submit();" /></td>
                <% } %>
                <td><%: item.nombre%></td>
                <td><%: String.Format("{0:d}",item.fecha_inicio) %></td>
                <td><%: String.Format("{0:d}",item.fecha_fin) %></td>
            </tr>
        <% } %>
        </tbody>
        </table>
        <br />
        <%: Html.Hidden("concurso_id",(int)Convert.ToInt32(ViewBag.concurso_id)) %>
        <% } %>
    </div>

</asp:Content>
