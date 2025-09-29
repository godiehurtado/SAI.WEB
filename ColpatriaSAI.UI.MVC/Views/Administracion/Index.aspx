<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administración de sistema - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $("#seccionesAdmin").accordion({ autoHeight: false });
        });
    </script>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Administración del Sistema</h2>
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
                General</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Zonas", "Index", "Zona")%></li>
                <li>
                    <%: Html.ActionLink("Localidades", "Index", "Localidad")%></li>
                <li>
                    <%: Html.ActionLink("Compañías", "Index", "Compañia")%></li>
                <li>
                    <%: Html.ActionLink("Segmentos", "Index", "Segmento")%></li>
                <li>
                    <%: Html.ActionLink("Canales", "Index", "Canal")%></li>
                <li>
                    <%: Html.ActionLink("Redes de recaudo", "Index", "Red")%></li>
                <li>
                    <%: Html.ActionLink("Bancos", "Index", "Banco")%></li>
                <li>
                    <%: Html.ActionLink("Ocupaciones", "Index", "ActividadEconomica")%></li>
                <li>
                    <%: Html.ActionLink("Persistencia Vida", "Index", "P_P_Vida")%></li>
                <li>
                    <%: Html.ActionLink("Recalcular persistencia CAPI", "Index", "PersistenciaCAPIDetalle")%></li>
                <li>
                    <%: Html.ActionLink("Parametros del Aplicativo", "Index", "ParametrosApp")%></li>
                <li>
                    <%: Html.ActionLink("Salario Minimo", "Index", "SalarioMinimo")%></li>
                <li>
                    <%: Html.ActionLink("Ingresos por Localidad", "Index", "IngresoLocalidad")%></li>
                <li>
                    <%: Html.ActionLink("Premios Anteriores", "Index", "PremiosAnteriores")%></li>
                <li>
                    <%: Html.ActionLink("Excepciones por Grupo y Tipo de Endoso", "Index", "GrupoTipoEndoso")%></li>
                <%--<li>
                    <%:Html.ActionLink("Parametros Eficiencia ARL", "Index", "ParametrizacionEficienciaARL")%></li>--%>
                <li>
                    <%:Html.ActionLink("Actualización de Clave", "Index", "ActualizaClave")%></li>

            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Productos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Agrupación de ramos/productos", "Index", "Ramo")%></li>
                <!--<li><%: Html.ActionLink("Agrupaciones", "Index", "Producto")%></li>
				<li><%: Html.ActionLink("Planes", "Index", "Plan")%></li>-->
                <li>
                    <%: Html.ActionLink("Coberturas", "Index", "Cobertura")%></li>
                <li>
                    <%: Html.ActionLink("Amparos", "Index", "Amparo")%></li>
                <li>
                    <%: Html.ActionLink("Líneas de Negocio", "Index", "LineaNegocio")%></li>
                <li>
                    <%: Html.ActionLink("Combos", "Index", "Combo")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Jerarquía Comercial</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Metas", "Index", "Meta")%></li>
                <li>
                    <%: Html.ActionLink("Categorias", "Index", "Categoria")%></li>
                <li>
                    <%: Html.ActionLink("Niveles", "Index", "Nivel")%></li>
                <li>
                    <%: Html.ActionLink("Requerimientos de Antigüedad por nivel", "Index", "AntiguedadxNivel")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Concursos</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Variables de concursos", "Index", "Variable")%></li>
                <li>
                    <%: Html.ActionLink("Monedas", "Index", "Moneda")%></li>
                <li>
                    <%: Html.ActionLink("Base anual monedas", "Index", "BaseMoneda")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Integración</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Periodos de Cierre", "Index", "PeriodoCierre")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div class="seccion">
            <h3>
                Auditoría</h3>
            <ul>
                <li>
                    <%: Html.ActionLink("Auditoría", "Index", "AuditoriaSeguimiento")%></li>
            </ul>
            <div style="clear: both;">
            </div>
        </div>
        <div style="clear: both;">
        </div>
    </div>
    <%--	<div id="seccionesAdmin">
		<h3><a href="#">General</a></h3>
		<div id="general">
			
			<ul>
				<li><%: Html.ActionLink("Zonas", "Index", "Zona")%></li>
				<li><%: Html.ActionLink("Localidades", "Index", "Localidad")%></li>
				<li><%: Html.ActionLink("Compañías", "Index", "Compañia")%></li>
				<li><%: Html.ActionLink("Segmentos", "Index", "Segmento")%></li>
				<li><%: Html.ActionLink("Canales", "Index", "Canal")%></li>
				<li><%: Html.ActionLink("Redes de recaudo", "Index", "Red")%></li>
				<li><%: Html.ActionLink("Ocupaciones", "Index", "ActividadEconomica")%></li>
			</ul>
			
		</div>
		<h3><a href="#">Productos</a></h3>
		<div id="productos">
			<ul>
				<li><%: Html.ActionLink("Ramos", "Index", "Ramo")%></li>
				<li><%: Html.ActionLink("Productos", "Index", "Producto")%></li>
				<li><%: Html.ActionLink("Planes", "Index", "Plan")%></li>
				<li><%: Html.ActionLink("Coberturas", "Index", "Cobertura")%></li>
				<li><%: Html.ActionLink("Amparos", "Index", "Amparo")%></li>
				<li><%: Html.ActionLink("Líneas de Negocio", "Index", "LineaNegocio")%></li>
			</ul>
		</div>
		<h3><a href="#">Jerarquía Comercial</a></h3>
		<div id="jerarquia">
			<ul>
				<li><%: Html.ActionLink("Categorias", "Index", "Categoria")%></li>
				<li><%: Html.ActionLink("Niveles", "Index", "Nivel")%></li>
				<li><%: Html.ActionLink("Requerimientos de Antigüedad por nivel", "Index", "AntiguedadxNivel")%></li>
			</ul>
		</div>
		<h3><a href="#">Concursos</a></h3>
		<div id="concursos">
			<ul>
				<li><%: Html.ActionLink("Variables de concursos", "Index", "Variable")%></li>
				<li><%: Html.ActionLink("Monedas", "Index", "Moneda")%></li>
				<li><%: Html.ActionLink("Base anual monedas", "Index", "BaseMoneda")%></li>
			</ul>
		</div>
	</div>--%>
</asp:Content>
