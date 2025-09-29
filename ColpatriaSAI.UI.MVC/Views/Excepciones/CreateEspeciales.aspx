<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ExcepcionFranquiciaModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Excepciones Especiales Franquicias - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var excepcionId = 0;
    var fechaInicial = string.Empty;
    var fechaFinal = string.Empty;
    var numNegocio = string.Empty;   
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
        //Localidad (L) – negocio (N) - participante (Pa) 
        var combinaciones = { "LPa": "101", "LNPa": "111"};
        
        var combinacionActual = "";
        var resultado = false;

        var localidad = "0";
        var negocio = "0", participante = "0";

        if ($("#localidad_id").val() != 0) localidad = "1";       

        if ($("#negocio_id").val() != "") negocio = "1";        

        if ($("#participante_id").val() != "" && $("#participante_id").val() != "0") participante = "1";

        combinacionActual = localidad + negocio + participante;

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
		    <div >
			    Los campos <b><u>Fecha Inicial</u></b> y <b><u>Fecha Final</u></b> son opcionales.  El <b><u>Porcentaje</u></b> 
			    es un campo obligatorio. Si desea activar/desactivar temporalmente una excepción puede utilizar el campo "Activa"
			</div>
			<br /><%: Html.ActionLink("Regresar", "ExcepcionesEspeciales", "Excepciones", new { id = ViewBag.localidadId }, null)%>
		</div>
		<div id="progresoSeccion">		   
			<div>
				<h4>Combinaciones válidas</h4>
                <div><a href="#" onclick="$('#combinaciones').toggle('slow')">Ver combinaciones</a></div>
				<ul id="combinaciones" style="display:none; position:absolute; background-color:#EEE; border:1px solid #CCC; padding-top:10px; padding-bottom:10px; ">
					<li>Localidad De + Clave </li>
                    <li>Localidad De + Clave + Número Negocio</li>
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
				<td>Localidad Para:*</td>
				<td>
					<%: Html.DropDownList("localidad_id", this.Model.LocalidadList, "Seleccione un Valor", new { style = "width:300px;", id = "localidad_id", @class = "required" })%>
				</td>
			</tr>
			<tr>
				<td>Localidad De:*</td>
				<td>
					<%: Html.DropDownList("localidad_de_id", this.Model.LocalidadDeList, "Seleccione un Valor", new { style = "width:300px;", id = "localidad_de_id", @class = "required" })%>
				</td>
			</tr>
			<tr>
				<td>Número de Negocio</td>
				<td>
				<%: Html.TextBox("negocio_id", numNegocio, new { size = 10, id = "negocio_id" })%>
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
			</tr>
			<tr>
				<td>Porcentaje*</td>
				<td>
					<%: Html.TextBox("Porcentaje", porcentaje, new { @class = "required", size = 5 })%>%            
				</td>
            </tr>
            <tr>
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
                    <input type="hidden" name="poliza" id="poliza"/>
                    <input type="hidden" name="excepcionRecaudo" id="excepcionRecaudo" value="1"/>
                    <input type="button" onclick="excepcionesSave()" id="guardar" value="Guardar"/>
                    <div id='dialogEditar' style="display:none;"></div>
                    <div id="mensaje" style="color: #FF0000">Tenga en cuenta que los campos requeridos estan marcados con (*)</div>
                </td>
			</tr>
		</table>
		</fieldset>

	<% } %>
	  
</asp:Content>

