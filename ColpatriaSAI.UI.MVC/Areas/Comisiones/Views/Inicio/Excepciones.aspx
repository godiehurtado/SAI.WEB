<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Excepciones
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Excepciones</h2>
            <p>
            </p>
        </div>
        <div id="progresoSeccion">
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <div id="cuadroAdministracion">
        <div class="seccion">
            <h3>
                Excepciones</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Excepciones", "ExcepcionFijaVariable", new { id = ViewBag.id, controller = "ExcepcionesComision" })%>
                    </li>
                    <li>
                    <%: Html.ActionLink("Cargar Excepciones", "CargueExcepcionFijaVariable", new { id = ViewBag.id, controller = "ExcepcionesComision" })%>
                    </li>

            </ul>
            <div style="clear: both;">
            </div>
        </div>
        
        <div class="seccion">
            <h3>
                Excepción a Penalización</h3>
            <ul>
                <li>
                    <%: @Html.ActionLink("Excepción a Penalización", "ExcepcionPenalizacion", new { id = ViewBag.id, controller = "ExcepcionesComision" })%>
                </li>
                <li>
                <%: @Html.ActionLink("Cargue Excepción a Penalización", "CargueExcepcionPenalizacion", new { id = ViewBag.id, controller = "ExcepcionesComision" })%>
                    
                </li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
    </div>
</asp:Content>
