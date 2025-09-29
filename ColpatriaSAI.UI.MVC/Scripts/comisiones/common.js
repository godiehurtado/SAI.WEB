$.extend(jQuery.validator.methods, {
    number: function (value, element) {
        return this.optional(element)
             || /^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:[,.]\d+)?$/.test(value);
    }
});

function limpiar(ddl, canSelectAll) {
    ddl.empty();
    if (canSelectAll) {
        ddl.append($("<option>", { value: "" }).text("Todos"));
    }
    else {
        ddl.append($("<option>", { value: "" }).text("Seleccionar"));        
    }
}
function limpiarFormulario(form) {
    $(form).find("input[type='text'],select").val("");
    $(form).find("input[type='checkbox']").prop("checked",false);
    $("input,select").each(function () {
        $(this).attr("disabled", false);
    });
}

function mostrarDialogoCrear(form, action, title, dialog) {
    $(form).attr('action', action);
    $(dialog).dialog('option', 'title', title);
    $(dialog).dialog('open');
    limpiarFormulario(form);
}

$(document).ready(function () {
    if ($(".alert-danger").text() == "") {
        $(".alert-danger").hide();
    } else {
        $(".alert-danger").show();
    }
});   