var segundosID = null;
var idIntervalSession = null;
var idActivarSessionAuto = null;

$(document).ready(function () {

    idIntervalSession = setInterval("validarInactividad()", 60000);

});

function validarInactividad() {

    var now = new Date();
    var minutesDiff = DateDiff.inMinutes(now, utcTimeExpireSession);

    if (minutesDiff <= 0) {
        clearInterval(idIntervalSession);
        clearTimeout(segundosID);
        $("#msjCloseSession").dialog({
            width: 300,
            height: 10,
            title: 'Terminando Sesión Automaticamente. Espere por favor...',
            position: 'center',
            modal: true,
            closeOnEscape: false,
            open: function (event, ui) {
                $(this).closest('.ui-dialog').find('.ui-dialog-titlebar-close').hide();
            },
            resizable: false
        });

        $("#msjCloseSession").dialog("open");

        $("#msjSession").fadeOut(1000, function () {
            window.location.href = '/Cuenta/LogOff?expired=true';
        });       
    }

    if (minutesDiff == 2) {
        $("#segundos").text(120);
        $("#msjSession").fadeIn(1000);
        mostrarSegundosInactividad();
    }


    /*var accion = "validarInactividad";
    var divActualizar = "msjOculto";

    var url = "control_usuarios.php";

    var param = {
        parameters: "Ajax=true&validateActivity=true&accion=" + accion,
        onComplete: function (transport) {
            if (transport.responseText == '18') {
                $("segundos").innerHTML = 120;
                document.getElementById("msjSession").style.display = 'block';
                mostrarSegundosInactividad();
            }
            else if (transport.responseText == '20') {
                clearTimeout(segundosID);
                periodical.stop();
                location.href = 'salir.php?sessionauto=expired';
            }
        }
    };

    var peticion = new Ajax.Updater(divActualizar, url, param);*/
}

function activarSession() {

    clearTimeout(segundosID);
    var stUrl = '/Cuenta/ActualizarSession';
    $.ajax({
        type: 'POST',
        data: {},
        url: stUrl,
        success: function (response) {
            if (response.Success) {                
                utcTimeExpireSession = new Date(response.anio,(response.mes - 1), response.dia, response.hora, response.minutos);
                $("#msjSession").fadeOut(2000);
            }
        }
    });
}

function mostrarSegundosInactividad() {

    var segundos = $("#segundos");
    segundos.text(parseInt(segundos.text()) - 1);
    segundosID = setTimeout("mostrarSegundosInactividad()", 1000);
    return true;
}


var DateDiff = {

    inMinutes: function (d1, d2) {
        var t2 = d2.getTime();
        var t1 = d1.getTime();
        return Math.ceil((t2 - t1) / (60000));
    },

    inDays: function (d1, d2) {
        var t2 = d2.getTime();
        var t1 = d1.getTime();

        return parseInt((t2 - t1) / (24 * 3600 * 1000));
    },

    inWeeks: function (d1, d2) {
        var t2 = d2.getTime();
        var t1 = d1.getTime();

        return parseInt((t2 - t1) / (24 * 3600 * 1000 * 7));
    },

    inMonths: function (d1, d2) {
        var d1Y = d1.getFullYear();
        var d2Y = d2.getFullYear();
        var d1M = d1.getMonth();
        var d2M = d2.getMonth();

        return (d2M + 12 * d2Y) - (d1M + 12 * d1Y);
    },

    inYears: function (d1, d2) {
        return d2.getFullYear() - d1.getFullYear();
    }
}
