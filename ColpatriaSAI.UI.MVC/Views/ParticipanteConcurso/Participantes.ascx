<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<style>
    #resultados 
    {
        width:100%; 
        margin-left:auto;
        margin-right:auto;
        border-collapse: collapse;
    }
    #resultados thead th
    {
        color:#CC0000;
        background-color:#D4D0C8;
        border: 1px solid #D4D0C8;
	    padding: 2px 0px 2px 0px;

    }
    #resultados td
    {
        border: 1px solid #D4D0C8;
	    padding: 0 0.5em;
	    text-align: center;
    }
</style>
    <script type="text/javascript">
        $(function () {            
            $('#nivel').change(function () {
                $("#inicio").val(0);
            });
            var url = window.location.href.split("/");
            for (i = 0; i < url.length; i++) {
                if (url[i + 1] != null) {
                    if (url[i] + "/" + url[i + 1] == "Jerarquia/Detalle") {
                        $('#nivel option').each(function () {
                            if ($(this).val() == 1) $(this).remove();
                        });
                        break;
                    }
                }
            }
        });
        function consultar(accion, inicioBusqueda) {

            if (accion == "buscar") {
                $("#inicio").val(0);
                $("#atras").attr("disabled", "disabled");
            }

            var inicio = $("#inicio").val();
            var cantidad = $("#cantidad").val();

            if (accion == "atras" && inicio > 0) {
                inicio = parseInt(inicio) - parseInt(cantidad);               
            }

            if (accion == "siguiente" && !inicioBusqueda) {
                inicio = parseInt(inicio) + parseInt(cantidad);               
            }            

             $("#inicio").val(inicio);

            var texto = $("#buscar").val();
            var nivel = $("#nivel").val();
            var concurso = 0;
            var zona  = 0;
            if (typeof ($("#zona_id")) == 'object') {
                if ($("#zona_id").val() != null)
                    zona = ($("#zona_id").val() == "" ? 0 : $("#zona_id").val());
            }
            if (typeof ($("#concurso_id")) == 'object') {
                if ($("#concurso_id").val() != null)
                    concurso = $("#concurso_id").val();
            }

            if (texto == 'Digite nombre, apellido o clave') texto = '';
            nivel = nivel != "" ? nivel : 0;

            $.ajax({ url: '/ParticipanteConcurso/getParticipantes', data: { texto: texto, inicio: inicio, cantidad: cantidad, nivel: nivel, zona: zona, concurso: concurso }, type: "POST",
                success: function (result) {
                    $("#resultados tbody tr").remove();

                    if (accion == "buscar") {
                        var d = 0;
                        $("#inicio").val(d);
                    }

                    if (inicio == 0)
                        $("#atras").attr('disabled', 'disabled');
                    else
                        $("#atras").removeAttr('disabled');

                    if (cantidad > result.length)
                        $("#siguiente").attr('disabled', 'disabled');
                    else
                        $("#siguiente").removeAttr('disabled');


                    $(result).each(function () {
                        $("<tr>" +
                            "<td><input id='seleccionado' name='radiobtn' type='radio' " +
                            "onclick='seleccionarParticipante(" + this.id + ", \"" + this.nombre + " " + this.apellidos + " " + this.clave + " \",\"" + this.clave + "\");'  /></td>" +
                            "<td>" + this.nombre + "</td>" +
                            "<td>" + this.apellidos + "</td>" +
                            "<td>" + this.clave + "</td>" +
                            "<td>" + this.nivel + "</td>" +
                        "</tr>").appendTo("#resultados tbody");
                    });
                }
            });
        }
     
        function seleccionarParticipante(id, nombre, clave) {
            $("#participante").val(nombre);
            $("#participante_id").val(id);
            $("#clave").val(clave);
            $("#dialogEditar").dialog('destroy'); $("#dialogEditar").dialog("close");
        }
    </script>

    <%: Html.Label("Buscar")%>
    <input type="text" id="buscar" name="buscar" value="Digite nombre, apellido o clave"
        onfocus="if (value == 'Digite nombre, apellido o clave') { value = ''; }"
        onblur="if (value== '') { value = 'Digite nombre, apellido o clave'; }" size="28" />
    <%: Html.DropDownList("nivel", null, "Seleccione el nivel...")%>
    <input type="button" value="Buscar" onclick="consultar('buscar')" />
    <br />

    <table  align = "center" id="resultados" cellspacing="2">
    <thead>
        <tr>
            <th>Selección</th><th>Nombres</th><th>Apellidos</th><th>Clave</th><th>Nivel</th>
        </tr>
    </thead>
    <tbody></tbody>
    </table>
    <br />
    <input type="hidden" value="0" id="inicio" />
    <input type="hidden" value="20" id="cantidad" />
    <input type="button" value="Atras" id="atras" onclick="consultar('atras', false)" disabled="disabled" />
    <input type="button" value="Siguiente" id="siguiente" onclick="consultar('siguiente', false)" />    