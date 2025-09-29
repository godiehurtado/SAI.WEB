<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Presupuesto>>" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Cargue de Presupuesto
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script  type="text/javascript"> // Scripts para los selectores de fechas
        $(document).ready(function () {
            var dates = $("#fechaIni, #fechaFin").datepicker({
                defaultDate: "+1w", numberOfMonths: 3, dateFormat: "yy-mm-dd",
                showButtonPanel: true, changeMonth: true, changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "fechaIni" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });
	</script>
    <script type="text/javascript">
        function subirArchivo() {
            if (validar()) {
                if (confirm('¿Esta seguro de cargar la información?')) {
                    mostrarCargando(Procesando);
                    $("#form1").attr("action", $("#form1").attr("action") + '?anio=' + $('#anio').val() + '&segmento_id=' + $('#segmento_id').val());
                    $("#form1").submit();
                }
            }
        }

        function validar() {
            if (($('#fechaIni').val() == '') || ($('#fechaFin').val() == '') || ($('#file1').val() == '')) {
                var mensaje = "Por favor, suministre toda la información para el cargue.";
                mostrarError(mensaje);
                return false;
            }
            return true;
        }

	</script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" >
			<h2>Cargue de Presupuesto.</h2>
			<p>
				Seleccione un archivo con el formato requerido para procesar su informacion.<br />
				<h4><%: Html.ActionLink("Regresar","Presupuestos","Presupuesto") %></h4>
			</p>
		</div>
		<div id="progresoSeccion">
			<br />
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
       
    <form action="/Presupuesto/Carge/" method="post" enctype="multipart/form-data" id="form1">
        <fieldset id="fieldCarge" style="vertical-align:top">
            <legend><h3>Ejecutar cargue de presupuestos</h3></legend>
            <table>
                <tr>
                    <td>Año:</td>
                    <td><%: Html.ComboAnios("anio") %></td>
                    <td><input type="file" name="file" id="file1" style="width:300px; font-size:8pt" /></td>
                    <td style="width:140px" rowspan="2" valign="top">
                        <a href='/Presupuesto/Descargar/?tipo=1' target="_blank"><div><img style="border:0" src="../../App_Themes/SAI.Estilo/Imagenes/xls.gif" /> Descargar formato</div></a>
                    </td>
                </tr>
                <tr>
                    <td>Segmento:</td>
                    <td><%: Html.DropDownList("segmento_id", (SelectList)ViewBag.Segmentos, "Todos") %></td>
                    <td rowspan="2" align="right"><input type="button" onclick="subirArchivo()" style="font-size:9pt" value="Cargar presupuesto" /></td>
                </tr>
            </table>
        </fieldset>
    </form>    
</asp:Content>