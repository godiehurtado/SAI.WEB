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
        $('#nivel').change(function () {
            $("#inicio").val(0);
        });
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

        var nivel    = $("#nivel_id").val(); //(typeof ($("#nivel_id").val()) != 'undefined') ? $("#nivel_id").val() : 0;
        var zona     = $("#zona_id").val(); // (typeof ($("#zona_id").val()) != 'undefined') ? $("#zona_id").val() : 0;
        var texto    = $("#texto").val();
        var canal    = $("#canal_id").val();
        var codNivel = $("#codNivel").val();

        if (texto == 'Escriba un nodo de la jerarquía') texto = '';
        if (codNivel == 'Escriba un código de nivel') codNivel = '';
        canal = canal != "" ? canal : 0;

        $.ajax({ url: '/Modelo/getNodos', data: { texto: texto, inicio: inicio, cantidad: cantidad,
            nivel: nivel, zona: zona, canal: canal, codNivel: codNivel }, type: "POST",
            success: function (result) {
                $("#resultados tbody tr").remove();
                if (accion == "buscar") {
                    var d = 0;
                    $("#inicio").val(d);
                }
                if (inicio == 0) $("#atras").attr('disabled', 'disabled'); else $("#atras").removeAttr('disabled');
                if (cantidad > result.length) $("#siguiente").attr('disabled', 'disabled'); else $("#siguiente").removeAttr('disabled');

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
        $("#participante_id").val(id);
        $("#dialogPart").dialog("close");
    }
</script>

<%: Html.Label("Buscar")%>
<input type="text" id="texto" name="texto" value="Escriba un nodo de la jerarquía" size="28"
    onfocus="if (value == 'Escriba un nodo de la jerarquía') { value = ''; }"
    onblur="if (value== '') { value = 'Escriba un nodo de la jerarquía'; }" />
<%: Html.DropDownList("canal_id", (SelectList)ViewBag.Canales, "Todos los canales")%>
<input type="text" id="codNivel" name="codNivel" value="Escriba un código de nivel" size="28"
    onfocus="if (value == 'Escriba un código de nivel') { value = ''; }"
    onblur="if (value== '') { value = 'Escriba un código de nivel'; }" />

<input type="button" value="Buscar" onclick="consultar('buscar')" />
<input type="hidden" value="0" id="inicio" />
<input type="hidden" value="20" id="cantidad" />
<div style="float:right">
    <input type="button" value="Atras" id="atras" onclick="consultar('atras', false)" disabled="disabled" />
    <input type="button" value="Siguiente" id="siguiente" onclick="consultar('siguiente', false)" />
</div>
<br />
<table align="center" id="resultados" cellspacing="2">
    <thead>
    <tr> <th>Selección</th><th>Nodo de la jerarquía</th><%--<th>Zona</th>--%><th>Canal</th><th>Código de Nivel</th><%--<th>Nivel</th>--%> </tr>
    </thead>
    <tbody></tbody>
</table>