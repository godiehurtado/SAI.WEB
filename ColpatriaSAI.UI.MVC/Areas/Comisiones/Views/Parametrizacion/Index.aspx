<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Comisiones - Parametrizaci&oacute;n
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Parametrizaci&oacute;n</h2>
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
                Parametrización</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Módelo", "Index", "ModeloCalculo")%></li>                
            </ul>
            <div style="clear: both;">
            </div>
        </div>        
    </div>
</asp:Content>
