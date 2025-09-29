function IsNumeric(input) {
    var vlr = input.replace(',', '.');
    var RE = /^-{0,1}\d*\.{0,1}\d+$/;
    return (RE.test(vlr));
}

function capturarQueryString() {
    var str = window.location.search.substring(1).split("&");
    var qs = null;
    for (i = 0; i < str.length; i++) {
        str = str[i].split("=");
        if (str[1] != undefined) {
            qs = str[1];
            break;
        }
    }
    return qs;
}

function QueryStringList() {
    return str = window.location.search.substring(1).split("&");
}

function popup(url) {
    params = 'width=' + screen.width;
    params += ', height=' + screen.height;
    params += ', top=0, left=0'
    params += ', fullscreen=yes';
    params += ', scrollbars=1';

    newwin = window.open(url, 'windowname4', params);
    if (window.focus) { newwin.focus() }
    return false;
}

function popupReport(report, paramsGet) {
    params = 'width=' + screen.width;
    params += ', height=' + screen.height;
    params += ', top=0, left=0'
    params += ', fullscreen=no';
    params += ', scrollbars=1';

    var url = 'https://' + window.location.host + '/Reportes/VerReporte.aspx?Reporte=' + report + "&" + paramsGet
    newwin = window.open(url, 'ventanaReportes', params);
    if (window.focus) { newwin.focus() }
    return false;
}

function redondear(numero, decimal) {
    var result = Math.round(numero * Math.pow(10, decimal)) / Math.pow(10, decimal);
    return result;
}

function validarProcesosEnCurso() {
    $.getJSON('/SessionLess/ValidarProcesos', {}, function (data) {
        if (data[0] != null) {
            datosProcesos = new Array();
            datosProcesos.push(data);
            var item = "", link = "";
            $(data).each(function () {
                /*var tipo = "tipo";
                switch (this.tipo) { case 1: tipo += "Concurso"; break; case 2: tipo += "Contratacion"; break; case 3: tipo += "Franquicia"; break; }*/

                link = this.tipo == 1 ? "&nbsp;<a href='#' title='Cancelar proceso' onclick=\"cancelarProceso(" + this.id + "," + this.tipo + ");\">" +
                    "<img id='proceso" + this.id + "' src='/App_Themes/SAI.Estilo/Imagenes/delete.png' alt='' border='0' /></a>" : "";
                item = item + "<li><div class='textoProceso'>" + this.mensaje + "</div><div class='borrarProceso'>" + link + "</div></li>"; // id=" + this.id + " + "<div id='" + tipo + "' style='display:none'></div>"
            });
            var visible = ($("#listado").css("display") != "block");

            $("#listado").remove();

            $("<div id='listado' style='display:none; bottom:" + ((data.length * 14) + 39) + "px;'><ul id='lista'>" + item + "</ul><div style='clear:both'></div>").appendTo($("#global"));

            $("#tituloListado").text("Procesos en curso: " + data.length);

            if (!visible) $("#listado").show();

            if ($("#notificacion").css("display").toLowerCase() != "block")
                $("#notificacion").show("clip");

            eliminarProcesosEnCurso();
        }
        else {

            $("#listado").remove();
            if ($("#notificacion").css("display").toLowerCase() == "block")
                $("#notificacion").hide("clip");
            else
                $("#notificacion").hide();
        }
    });
    parar = setTimeout(validarProcesosEnCurso, 5000);
}

function eliminarProcesosEnCurso() {

    var stUrl = '/SessionLess/EliminarProcesos';
    $.ajax({
        type: 'POST',
        url: stUrl,
        data: {},
        success: function (responseProceso) {
            if (responseProceso.Success) {
            }
        }
    });

}

function cancelarProceso(id, tipo) {
    if (confirm("¿Esta seguro de cancelar este proceso?")) {
        $("#proceso" + id).attr("src", "/App_Themes/SAI.Estilo/Imagenes/ajax-loader_black.gif");

        $.ajax({ url: "/SessionLess/CancelarProceso/", data: { id: id }, type: 'POST', // async: false,
            success: function (result) {
                
            }
        });
    }
}

function selectAll(checked) {

    if (checked)
        $("input[type='checkbox']").attr('checked', 'checked');
    else
        $("input[type='checkbox']").attr('checked', '');

}