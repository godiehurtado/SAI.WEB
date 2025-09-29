<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Contratación al desempeño
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(function () {
            $("#seccionContratacion").accordion();
        });
	</script>

    <h2>Contratación al desempeño</h2>
    
    <div id="seccionContratacion">
        <h3><a href="#">Opciones</a></h3>
        <div id="contratacion">
            <ul>
                <li><a href="/Contratacion/Parametrizacion">Parametrización</a></li>
                <li><a href="/LiquidacionContrat/">Liquidación</a></li>
            </ul>
        </div>
    </div>
</asp:Content>