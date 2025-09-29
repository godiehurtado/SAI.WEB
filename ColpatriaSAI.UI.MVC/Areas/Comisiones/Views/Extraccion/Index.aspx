<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Comisiones
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<div id="cuadroAdministracion">
        <div class="seccion">
            <h3>
                Extracci&oacute;n de datos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Invocación manual", "Manual", "Extraccion")%></li>  
                    <li>
                    <%: Html.ActionLink("Invocación programada", "Programar", "Extraccion")%></li> 
            </ul>
            <div style="clear: both;">
            </div>
        </div>
    </div>
</asp:Content>
