<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ReglaViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Liquidacion Asesores
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">

    $(document).ready(function () {

        $("#concurso_id").change(function () {

            if ($("#concurso_id").val() != "") {

                var regla = $("#regla_id");
                var subregla = $("#subregla_id");

                regla.find('option').remove();
                subregla.find('option').remove();

                $.getJSON('/concursos/ListarReglas', { concurso_id: $("#concurso_id").val() }, function (data) {

                    if (data != 0) {
                        $("<option value='' selected>Seleccione uno... </option>").appendTo(regla);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(regla);
                        });
                    }
                });
            }
        });

        $("#regla_id").change(function () {

            if ($("#regla_id").val() != "") {

                var subregla = $("#subregla_id");
                subregla.find('option').remove();
                mostrarCargando("Obteniendo sub - reglas. Espere Por Favor...");
                $.getJSON('/concursos/ListarSubReglas', { regla_id: $("#regla_id").val() }, function (data) {
                    closeNotify('jNotify');
                    if (data != 0) {
                        $("<option value='' selected>Seleccione uno... </option>").appendTo(subregla);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.descripcion + "</option>").appendTo(subregla);
                        });
                    }
                    else
                        mostrarError("La regla no tiene sub regla principal.");
                });
            }
        });

        $("#FormLiquidacionAsesor").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function generarLiquidacionAsesor() {

        if ($("#FormLiquidacionAsesor").valid()) {
            var stUrl = '/Concursos/GenerarLiquidacionAsesor';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnGuardar").attr('disabled', true);
            var dataForm = $("#FormLiquidacionAsesor").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    closeNotify('jNotify');
                    mostrarCargando("La liquidación del concurso se está ejecutando. Cuando el proceso termine puede generar el reporte del Asesor");
                    window.setTimeout(function () {
                        closeNotify('jNotify');
                    }, 3000);
                }
            });
        }
        else
            mostrarError("Por favor revise los campos marcados.");
    }

</script>

<h2>Liquidación Asesores</h2>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<br /><%: Html.ActionLink("Regresar", "Index", "Concursos")%>
		</div>
        <div id="progresoSeccion">
        </div>
        <div style="clear: both;">
            <hr />
        </div>
	</div>
    <div style="clear:both;"></div>
	<% 
     
        using (Html.BeginForm("GenerarLiquidacionAsesor", "Concursos", FormMethod.Post, new { id = "FormLiquidacionAsesor" }))
	   {%>

			<br />
        	<fieldset style="border:1px solid gray">
	        <legend>Generar liquidación asesor</legend>
		    <table cellspacing="2" width="100%" border="0">

			    <tr>
				    <td>Concurso:*</td>
				    <td>
					    <%: Html.DropDownList("concurso_id", this.Model.ConcursoList, "Seleccione uno...", new { style = "width:300px;", id = "concurso_id", @class = "required" })%>
				    </td>
			    </tr>
			    <tr>
				    <td>Regla:*</td>
				    <td>
					    <select id="regla_id" name="regla_id" class="required"><option value="">Seleccione uno...</option></select>
				    </td>
			    </tr>
			    <tr>
				    <td>Sub - Regla principal:*</td>
				    <td>
					    <select id="subregla_id" name="subregla_id" class="required"><option value="">Seleccione uno...</option></select>
				    </td>
			    </tr>
			    <tr>
				    <td colspan="4" align="center">
                        <input type="button" onclick="generarLiquidacionAsesor()" value="Generar"/>
                        <div id="mensaje" style="color: #FF0000">Tenga en cuenta que los campos requeridos estan marcados con (*)</div>
                    </td>
			    </tr>
		    </table>
		</fieldset>

	<% } %>
	  


</asp:Content>
