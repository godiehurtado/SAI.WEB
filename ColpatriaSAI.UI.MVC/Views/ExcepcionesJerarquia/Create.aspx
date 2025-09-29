<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ExcepcionJerarquiaDetalleModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Excepciones Franquicias - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var excepcionId = 0;
    var fechaInicial = string.Empty;
    var fechaFinal = string.Empty;
    var numNegocio = string.Empty;
    var codigoAgrupador = string.Empty;
    var participante = string.Empty;
    var idParticipante = string.Empty;
    var porcentaje = string.Empty;
    var clave = string.Empty;
    Boolean estado = true;
    if (this.Model.Excepcion != null)
    {
        excepcionId = this.Model.Excepcion.id;
        if (this.Model.Excepcion.fecha_ini.Value != DateTime.Parse("01/01/1900"))
            fechaInicial = this.Model.Excepcion.fecha_ini.Value.Year + "-" + this.Model.Excepcion.fecha_ini.Value.Month + "-" + this.Model.Excepcion.fecha_ini.Value.Day;

        if (this.Model.Excepcion.fecha_fin.Value.ToShortDateString() != DateTime.MaxValue.ToShortDateString())
            fechaFinal = this.Model.Excepcion.fecha_fin.Value.Year + "-" + this.Model.Excepcion.fecha_fin.Value.Month + "-" + this.Model.Excepcion.fecha_fin.Value.Day;
        
        numNegocio = this.Model.Excepcion.negocio_id.ToString();
        codigoAgrupador = this.Model.Excepcion.codigoAgrupador.ToString();
        
        if (this.Model.Excepcion.Participante != null){
            participante = this.Model.Excepcion.Participante.nombre + " " + this.Model.Excepcion.Participante.apellidos;
            idParticipante = this.Model.Excepcion.participante_id.ToString();
            clave = this.Model.Excepcion.clave;
        }
        
        porcentaje = this.Model.Excepcion.Porcentaje.ToString();
        
        if (!this.Model.Excepcion.Estado)
            estado = false;
    }
    
%>

<script type="text/javascript">
		 $(function () {
			var companias = $("#compania_id");
			var ramos = $("#ramo_id");
			var productos = $("#producto_id");
			companias.change(function () {
				ramos.find('option').remove();
				$("#producto_id").attr("disabled", "disabled");
				$("<option value='0' selected>Seleccione un Valor</option>").appendTo(productos);
				$.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
					$("<option value='0' selected>Seleccione un Valor</option>").appendTo(ramos);
					$(data).each(function () {
						$("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
					});
				});
			});
			ramos.change(function () {
				productos.find('option').remove();
				$("#producto_id").removeAttr("disabled");
				$.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
				    $("<option value='0' selected>Seleccione un Valor</option>").appendTo(productos);
					$(data).each(function () {
						$("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
					});
				});
			});
		});

		function mostrarDialogParticipantes(pagina, titulo, dialog) {
			
			$("#" + dialog).dialog({
				height: 620, width: 550, modal: true,
				buttons: {
					Cerrar: function () {
						$(this).dialog("close");
					}
				},
				title: titulo,
				open: function (event, ui) { $(this).load(pagina); },
				close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
			});
		}

        function deleteParticipant(){
            $("#participante").val("");
            $("#participante_id").val("");
        }

		$(document).ready(function () {
			oTable = $('#tablaLista').dataTable({
				"bJQueryUI": true,
				"sPaginationType": "full_numbers","bStateSave": true
			});
		});

	</script>
<script type="text/javascript">

    $(document).ready(function () {
        $('#fecha_ini').datepicker({ dateFormat: 'yy-mm-dd' });
        $('#fecha_fin').datepicker({ dateFormat: 'yy-mm-dd' });

        $.validator.addMethod("numberDecimal", function (value, element) {
            element.value = value.replace('.', ',');
            return this.optional(element) || IsNumeric(value);
        }, "Valid number decimal");

        $("#FormExcepciones").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            },
            rules: {
                Porcentaje: {
                    numberDecimal: true
                }
            }
        });


    });

    function validarCombinaciones() {

        // Los valores en uno indican los que deben venir del formulario y en este orden:
        //Compañía (C) – Línea de negocio (Ln) - Ramo (R) - negocio (N) - producto (P) - poliza (Po) - participante (Pa) - (localidad (Lo): ESTA NO VA) - codigoagrupador (Ca)
        var combinaciones = { "CLnRPPa": "11101010", "CRPPa": "10101010", "CLnRNP": "11111000", "CLnRP": "11101000", "CLnCa": "11000001", "CLnR": "11100000", "CLn": "11000000", "CLnPa": "11000010","CRPPa": "10101010","CRPN": "10111000","CRP": "10101000","CR": "10100000","CCa": "10000001","CPa": "10000010","C":"10000000"};
        
        var combinacionActual = "";
        var resultado = false;

        var compania = "0", lineaNegocio = "0", ramo = "0";
        var negocio = "0", producto = "0", poliza = "0", participante = "0", agrupador = "0";

        if ($("#compania_id").val() != 0) compania = "1";

        if ($("#lineaNegocio_id").val() != "") lineaNegocio = "1";

        if ($("#ramo_id").val() != 0 && $("#ramo_id").val() != null) ramo = "1";

        if ($("#negocio_id").val() != "") negocio = "1";

        if ($("#producto_id").val() != 0 && $("#producto_id").val() != null) producto = "1";

        if ($("#poliza").val() != "") poliza = "1";

        if ($("#participante_id").val() != "" && $("#participante_id").val() != "0") participante = "1";

        if ($("#codigoAgrupador").val() != "") agrupador = "1";

        combinacionActual = compania + lineaNegocio + ramo + negocio + producto + poliza + participante + agrupador;

        $.each(combinaciones, function (i, val) { if (val == combinacionActual) resultado = true; });

        if (!resultado) {
            mostrarError("La parametrización de esta excepción no es una combinación valida");
        }

        return resultado;
    }

    function excepcionesSave() {

        if ($("#FormExcepciones").valid() && validarCombinaciones()) {
            $("#guardar").attr('disabled', true);
            mostrarCargando("Enviando informacion. Espere Por Favor...");
            $("#FormExcepciones").submit();
        }
    }

	</script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2><%= ViewData["Title"]%> excepción</h2>
            <h4><%= ViewData["Localidad"]%></h4>
			<p>La parametrización de Excepciones admite cierto número de Combinaciónes en la creación de una Excepción</p>
		    <div >
			    Tenga en cuenta que además de las combinaciones aceptadas debe diligenciar los campos <b><u>Fecha Inicial</u></b>, <b><u>Fecha Final</u></b> y <b><u>Porcentaje</u></b> 
			    como campos obligatorios para completar la tarea sobre éste formulario.
			</div>
			<br /><%: Html.ActionLink("Regresar", "Index", "Excepciones", new { id = ViewBag.localidadId }, null)%>
		</div>
		<div id="progresoSeccion">		   
			<div>
				<h4>Combinaciones válidas</h4>
                <div><a href="#" onclick="$('#combinaciones').toggle('slow')">Ver combinaciones</a></div>
				<ul id="combinaciones" style="display:none; position:absolute; background-color:#EEE; border:1px solid #CCC; padding-top:10px; padding-bottom:10px; ">
					<li>Compañía + Línea de Negocio + Ramo + Producto + Participante </li>
					<li>Compañía + Línea de Negocio + Ramo + Producto + Negocio </li>
					<li>Compañía + Línea de Negocio + Ramo + Producto </li>					
					<li>Compañía + Línea de Negocio + Ramo </li> 
                    <li>Compañía + Línea de Negocio + Código Agrupador </li>
                    <li>Compañía + Línea de Negocio + Participante </li>
					<li>Compañía + Línea de Negocio </li>
					<li>Compañía + Ramo + Producto + Participante </li>
					<li>Compañía + Ramo + Producto + Negocio </li>
					<li>Compañía + Ramo + Producto </li>
                    <li>Compañía + Ramo </li> 
					<li>Compañía + Código Agrupador </li>										
					<li>Compañía + Participante </li>
                    <li>Compañía </li>
				</ul>
			</div>    
	   
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

	<% 
     
        using (Html.BeginForm("SaveException", "Excepciones", FormMethod.Post, new { id = "FormExcepciones" }))
	   {%>

			<fieldset style="border:1px solid gray">
			
            <input type="hidden"  id="ExcepcionId" name="ExcepcionId" value='<%= excepcionId %>' />

			<table cellspacing="2" width="100%">
				<tr>
					<td>Fecha Inicial</td>
					<td>
						<%: Html.TextBox("fecha_ini", fechaInicial)%>
					</td>
					<td>Fecha Final</td>
					<td>
						<%: Html.TextBox("fecha_fin", fechaFinal)%>
					</td>
				</tr>
			</table>
			</fieldset>
			<br />
	<fieldset style="border:1px solid gray">
	 <legend>Detalle excepción</legend>
		<table cellspacing="2" width="100%" border="0">
			<tr>
				<td>Compañía*</td>
				<td>
					<%: Html.DropDownList("compania_id", this.Model.CompaniaList, "Seleccione un Valor", new { style = "width:300px;", id = "compania_id", @class = "required" })%>
				</td>
				<td>Línea de Negocio</td>
				<td>
					<%: Html.DropDownList("lineaNegocio_id", this.Model.LineaNegocioList, "Todas", new { style = "width:300px;", id = "lineaNegocio_id" })%>
				</td>
			</tr>
			<tr>
				<td>Ramo</td>
				<td>
					<%: Html.DropDownList("ramo_id", this.Model.RamoList, "Seleccione un Valor", new { style = "width:300px;", id = "ramo_id" })%>        
				</td>
				<td>Número de Negocio</td>
				<td>
				<%: Html.TextBox("negocio_id", numNegocio, new { size = 10, id = "negocio_id" })%>
				</td>
			</tr>
			<tr>
				<td>Producto</td>
				<td>
					<%: Html.DropDownList("producto_id", this.Model.ProductoList, "Seleccione un Valor", new { style = "width:300px;", id = "producto_id" })%>
				</td>
				<td><%--Póliza--%></td>
				<td>
					<%: Html.Hidden("poliza")%>
				</td>
			</tr>
			<tr>
				<td>Participante</td>
				<td>                   
					<%  //string ruta = Request.Url.ToString().Split('?')[0].ToString();
					string ruta = "http://"+ Request.Url.Authority.ToString()+"/ParticipanteConcurso/";
					if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
					<% Random random = new Random();
					int num = random.Next(1, 10000);  %>
                    <a href="javascript:mostrarDialogParticipantes('<%: ruta %>Participantes?r=<%: num %>', 'Participantes', 'dialogEditar');" style='float:left;' title='Buscar Participantes'><span class='ui-icon ui-icon-search'/></a>
                    <a href="javascript:deleteParticipant();" style='float:left;' title='Eliminar Participante'><span class='ui-icon ui-icon-cancel'/></a>                    
					<%:  Html.TextBox("participante", participante, new { @readonly = "true", style = "width:262px;" })%>
					<%: Html.Hidden("participante_id", idParticipante, new { id = "participante_id" })%>					
                    <%: Html.Hidden("clave", clave, new { id = "clave" })%>					
				</td>
				<td>Código Agrupador</td>
				<td> <%: Html.TextBox("codigoAgrupador", codigoAgrupador, new { size = 10, id = "codigoAgrupador" })%></td>
			</tr>
			<tr>
				<td>Porcentaje*</td>
				<td>
					<%: Html.TextBox("Porcentaje", porcentaje, new { @class = "required", size = 5 })%>%            
				</td>
				<td>Activa?</td>
				<td> <%    
                       if (estado)
                       {                    
                            %><input type="checkbox" id="estado" name="estado" checked="checked" /><%
                       }
                       else
                       {
                            %><input type="checkbox" id="estado" name="estado" /><%
                       }

                     %>
                </td>
			</tr>
			<tr>
				<td colspan="4" align="center">
                    <input name="Localidad_id" id="Localidad_id" type="hidden" value="<%=ViewBag.localidadId %>" />
                    <input type="button" onclick="excepcionesSave()" id="guardar" value="Guardar"/>
                    <div id='dialogEditar' style="display:none;"></div>
                    <div id="mensaje" style="color: #FF0000">Tenga en cuenta que los campos requeridos estan marcados con (*)</div>
                </td>
			</tr>
		</table>
		</fieldset>

	<% } %>
	  
</asp:Content>

