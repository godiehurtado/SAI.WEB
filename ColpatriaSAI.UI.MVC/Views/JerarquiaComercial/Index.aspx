<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Jerarquía Comercial - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript">
	$(function () {
	    $("#opciones a").button();
	    $("#bExcepciones").button({ disabled: true });
	});
</script>
<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Jerarquía Comercial</h2>
			<p>
				Módulo de administración de los participantes y la jerarquía comercial                
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>
	<div id="opciones">
		<%: Html.ActionLink("Participantes","Index","Participante") %>
		<%: Html.ActionLink("Jerarquía Comercial", "Crear","Jerarquia") %>
        <%: Html.ActionLink("Auditoría", "Index","Auditoria") %>
	</div>
</asp:Content>
