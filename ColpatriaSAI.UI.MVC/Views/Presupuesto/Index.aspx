<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Presupuesto - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $("#bMetas").button({ icons: { primary: "ui-icon-gear"} });
            $("#bPresupuesto").button({ icons: { primary: "ui-icon-calculator"} });
            $("#bAnticipos").button({ icons: { primary: "ui-icon-tag"} });
        })
   

	</script>

    <div id="encabezadoSeccion">
        <div id="infoSeccion">
             <h2>Presupuesto</h2>
            <p>
                Este módulo permite realizar la carga del presupuesto del año. Para cada uno de los presupuestos cargados, el sistema
                permite visualizar los reportes de ejecución así como calcular las metas compuestas y acumuladas.
                La opción Metas permite definir las metas a utilizar en el presupuesto y en la contratación al desempeño.
            </p>
        </div>
        <div id="progresoSeccion">
        </div>
        <div style="clear:both;"><hr /></div>
    </div>
    <div id="seccionPresupuesto">
        <a href="/Presupuesto/Presupuestos" id="bPresupuesto">Presupuestos</a>
        <a href="/Meta" id="bMetas">Metas</a>
    </div>
</asp:Content>
