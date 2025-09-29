<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<style>
    #resultados {
        width:100%; 
        margin-left:auto;
        margin-right:auto;
        border-collapse: collapse;
    }
    #resultados thead th {
        color:#CC0000;
        background-color:#D4D0C8;
        border: 1px solid #D4D0C8;
	    padding: 2px 0px 2px 0px;
    }
    #resultados td {
        border: 1px solid #D4D0C8;
	    padding: 0 0.5em;
	    text-align: center;
    }
</style>

 <script type="text/javascript">
     $(function () {
         consultar('siguiente', true);
     });

     function consultar(accion, inicioBusqueda) {
         if (accion == "buscar") {
             $("#inicio").val(0);
             $("#atras").attr("disabled", "disabled");
         }
         var inicio = $("#inicio").val();
         var cantidad = $("#cantidad").val();

         if (accion == "atras" && inicio > 0) inicio = parseInt(inicio) - parseInt(cantidad);
         if (accion == "siguiente" && !inicioBusqueda) inicio = parseInt(inicio) + parseInt(cantidad);

         $("#inicio").val(inicio);

         var texto = $("#buscar").val();

         $.ajax({ url: '/ParticipacionDirector/Directores', data: { texto: texto, inicio: inicio, cantidad: cantidad }, type: "POST",
             success: function (result) {

                 $("#resultados tbody tr").remove();
                 if (accion == "siguiente") {
                     $("#inicio").val(inicio);
                     $("#atras").removeAttr('disabled');
                 }
                 else if ((accion == "atras") && ($("#inicio").val() >= 20)) {
                     $("#inicio").val(inicio);
                 }
                 else if (accion == "buscar") {
                     var d = 0;
                     $("#inicio").val(d);
                     $("#atras").attr("disabled", "disabled");
                 }
                 if (inicio <= 0) $("#atras").attr('disabled', 'disabled'); else $("#atras").removeAttr('disabled');
                 if (cantidad <= result.length) $("#siguiente").attr('disabled', 'disabled'); else $("#siguiente").removeAttr('disabled');

                 $(result).each(function () {
                     $("<tr>" +
                        "<td><input id='seleccionado' name='radiobtn' type='radio' onclick='seleccionarNodo(" + this.id + ", \"" + this.nombreNodo + "\");'/></td>" +
                        "<td>" + this.nombreNodo + "</td>" +
                     //"<td>" + this.nombreZona + "</td>" +
                        "<td>" + this.nombreCanal + "</td>" +
                        "<td>" + this.codigoNivel + "</td>" +
                     //"<td>" + this.nombreNivel + "</td>" +
                    "</tr>").appendTo("#resultados tbody");
                 });

             }
         });
     }

     function seleccionarNodo(id, nombre) {
         $("#participante").val(nombre);
         $("#jerarquiaDetalle_id").val(id);
         $("#participanteEdit").val(nombre);
         $("#jerarquiaDetalleEdit_id").val(id);
         $("#dialogPart").dialog("close");
     } 
</script>

<%: Html.Label("Buscar")%>
<input type="text" id="buscar" name="buscar" value="" size="28"/>
<input type="button" value="Buscar" onclick="consultar('buscar')" />
<input type="hidden" value="0" id="inicio" />
<input type="hidden" value="20" id="cantidad" />
<div style="float:right">
    <input type="button" value="Atras" id="atras" onclick="consultar('atras')" disabled="disabled"/>
    <input type="button" value="Siguiente" onclick="consultar('siguiente')" />
</div>

<table  align = "center" id="resultados">
    <thead>
    <tr> <th>Selección</th><th>Nodo de la jerarquía</th><%--<th>Zona</th>--%><th>Canal</th><th>Código de Nivel</th><%--<th>Nivel</th>--%> </tr>
    </thead>
    <tbody>
    </tbody>
</table>