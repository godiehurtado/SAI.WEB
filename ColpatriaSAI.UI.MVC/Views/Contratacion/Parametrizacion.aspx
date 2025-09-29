<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Parametrización de Contrato al Desempeño
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(function () {
            $("#seccionContratacion").accordion();
        });
	</script>

    <h2>Contratación al desempeño / Parametrización</h2>

    <div id="seccionContratacion">
        <h3><a href="#">Opciones de Parametrización</a></h3>
        <div id="contratacion">
            <ul>
                <li><a href="../FactorxNota">Escalas</a></li>
                <li><a href="../Meta">Metas</a></li>
                <li><a href="../Modelo">Modelos</a></li>
                <li><a href="../Participacion">Participación Producto</a></li>
                <li><a href="../ParticipacionDirector">Participación por Director</a></li>
            </ul>
        </div>
    </div>
</asp:Content>
