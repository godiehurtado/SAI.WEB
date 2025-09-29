<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Liquidación de Franquicias - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#bParametrizacion").button({ icons: { primary: "ui-icon-gear"} });
            $("#bLiquidacion").button({ icons: { primary: "ui-icon-calculator"} });
            $("#bAnticipos").button({ icons: { primary: "ui-icon-tag"} });
        })
    </script>


    <div id="encabezadoSeccion">
        <div id="infoSeccion">
             <h2>Liquidación de Franquicias</h2>
        </div>
        <div id="progresoSeccion">
            <p>
                Este módulo permite realizar el proceso de liquidación de franquicias. Para definir los valores de participación de cada una de las franquicias haga clic en parametrización. 
                Para visualizar las liquidaciones realizadas previamente, realizar una nueva o realizar un anticipo haga clic en Pagos y liquidaciones.
            </p>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>
    
        <%: Html.ActionLink("Parametrización", "Index", "Franquicias",null, new { id = "bParametrizacion" })%>
        <%: Html.ActionLink("Liquidaciones", "liquiindex", "LiquidacionFranqui",null, new { id = "bLiquidacion" })%>
        <%: Html.ActionLink("Anticipos", "Index", "AnticiposFranquicias", null, new { id = "bAnticipos" })%>
    
</asp:Content>
