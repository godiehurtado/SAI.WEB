<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.JerarquiaDetalle>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Jerarquía Comercial - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="/Content/JsTree/themes/default/style.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/Content/JsTree/jquery.jstree.js"></script>
    <script type="text/javascript" src="/Content/JsTree/_lib/jquery.hotkeys.js"></script>
    <script type="text/javascript">
        var jerarquia_id = 0;
        var datosNodo;
        var clickDerecho;
        var nodo_id;
        var x;
        var y;
        document.onmouseup = capturarClick;
        window.onload = init;
        function init() {
            document.onmousemove = getXY;
        }
        function getXY(e) {
            if (e) {
                x = e.pageX; y = e.pageY;
            } else {
                x = event.clientX; y = event.clientY;
            }
//            x = (window.Event) ? e.pageX : event.clientX;
//            y = (window.Event) ? e.pageY : event.clientY;
        }

        function capturarClick(e) {
            if (e) {
                clickDerecho = e.which;
            } else {
                clickDerecho = window.event.button;
            }
            return true;
        }

        $(document).ready(function () {
            sembrarArbol();

            var zona = $("#zona_id");
            var localidad = $("#localidad_id");

            zona.change(function () {
                localidad.find('option').remove();
                $("<option value='0'>Seleccione...</option>").appendTo(localidad);
                $.getJSON('/Modelo/getLocalidades', { idZona: zona.val() }, function (data) {
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidad);
                    });
                });
            });
            $("#Arbol0").attr("style", "background-color: white");

            /*Para Excepciones*/
            var companias = $("#compania_id");
            var ramos = $("#ramo_id");
            var productos = $("#producto_id");
            companias.change(function () {
                ramos.find('option').remove();
                $("#producto_id").attr("disabled", "disabled");
                $("<option value='0' selected>Todos</option>").appendTo(productos);
                $("<option value='0' selected>Todos</option>").appendTo(ramos);
                $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {                   
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                    });
                });
            });
            ramos.change(function () {
                productos.find('option').remove();
                $("#producto_id").removeAttr("disabled");
                $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
                    $("<option value='0' selected>Todos</option>").appendTo(productos);
                    $(data).each(function () {
                        $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                    });
                });
            });

            /*Para Metas*/
            $("#metaForm").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });
        });

        function inicializarFormNodo() {
            $('#detalle_id').val($('#detalle_id').val() == "" ? 0 : $('#detalle_id').val());
            $('#nombre').val("");
            $('#descripcion').val("");
            $("#zona_id option:first-child").attr("selected", "selected");
            $("#localidad_id option:first-child").attr("selected", "selected");
            $("#canal_id option:first-child").attr("selected", "selected");
            $('#participante').val("");
            $('#participante_id').val(0);
            $('#codigoNivel').val("");
        }

        function sembrarArbol() {
            var str = window.location.search.substring(1).split("&");
            for (i = 0; i < str.length; i++) {
                str = str[i].split("=");
                if (str[1] != undefined) {
                    jerarquia_id = str[1];
                    break;
                }
                else window.location.href = document.location.protocol + '//' + document.location.hostname + 
                    (document.location.port != '' ? ':' + document.location.port : '') + '/Jerarquia/Crear';
            }

            $("#Arbol0").jstree({
                "json_data": {
                    "ajax": {
                        "url": "/Jerarquia/getJerarquiaPorId/" + jerarquia_id,
                        "data": function (n) {
                            return {
                                "padre_id": n.attr ? n.attr("id") : 0
                            };
                        }
                    }
                },
                //"ui" : { "initially_select" : [ "1" ] },
                "contextmenu": {
                    items: { // Could be a function that should return an object like this one
                        "excepcion": {
                            "separator_before": true,
                            "separator_after": true,
                            "label": "Excepciones",
                            "action": function (obj) {
                                if (obj.attr('rel') != "asesor")
                                    formAnadirExcepcion(obj.attr("id"));
                            }
                        },
                        "meta": {
                            "separator_before": true,
                            "separator_after": true,
                            "label": "Metas",
                            "action": function (obj) {
                                if (obj.attr('rel') != "asesor")
                                    formAnadirMeta(obj.attr("id"));
                            }
                        }
                    }
                },
                "plugins": ["themes", "json_data", "ui", "crrm", "dnd", "contextmenu", "types", "hotkeys"],
                "types": {
                    "max_depth": -2,
                    "max_children": -2,
                    "types": {
                        "asesor": {
                            "icon": { "image": "/Content/JsTree/themes/default/asesor.png" },
                            "valid_children": "all", "create_node": false, "move_node": false,
                            "start_drag": false, "delete_node": true, "remove": false
                        },
                        "director": {
                            "icon": { "image": "/Content/JsTree/themes/default/director.png" },
                            "valid_children": "all"
                        },
                        "gerente_oficina": {
                            "icon": { "image": "/Content/JsTree/themes/default/gerente.png" },
                            "valid_children": "all"
                        },
                        "gerente_regional": {
                            "icon": { "image": "/Content/JsTree/themes/default/gerente.png" },
                            "valid_children": "all"
                        },
                        "vicepresidente": {
                            "icon": { "image": "/Content/JsTree/themes/default/vice.png" },
                            "valid_children": "all"
                        },
                        "root": {
                            "icon": { "image": "/Content/JsTree/themes/default/organigram.png" },
                            "valid_children": "all", //"create_node": false, "hover_node" : false
                            "move_node": false, "start_drag": false, "delete_node": false,
                            "remove": false
                        }
                    }
                },
                "languages": ["es"],
                "core": { "strings": { loading: "Cargando...", new_node: "Nuevo nodo" }, "animation": 200 }
            })
            .bind("select_node.jstree", function (e, data) {// Despues de seleccionar un nodo en el UI
                datosNodo = data;

                //DETERMINAMOS SI ESTA AÑADIENDO EXCEPCIONES
                var excepcion = $("#contentExcepcionHidden").val();
                if (excepcion == 1)
                    adicionarDestino(data.rslt.obj.attr('id'));
                else
                    obtenerInfo(data.rslt.obj.attr('id'));

            })
            .bind("create.jstree", function (e, data) {// Despues de crear un nodo en el UI
                datosNodo = data;
                $("#detalle_id").val(0);
                mostrarDialog('Crear nodo \"' + data.rslt.name + '\"', 'dialog', data.rslt);
            })
            .bind("rename.jstree", function (e, data) {// Despues de renombrar un nodo en el UI
                datosNodo = data;
                mostrarDialog('Editar nodo \"' + data.rslt.old_name + '\"', 'dialog', data.rslt);
            })
            .bind("remove.jstree", function (e, data) { // Despues de eliminar un nodo en el UI
                datosNodo = data;
                eliminarNodo();
            })
            .bind("move_node.jstree", function (e, data) {
                data.rslt.o.each(function (i) {
                    $.ajax({ url: "/Jerarquia/ActualizarNodos", type: 'POST', //async: false,
                        data: {
                            id: $(this).attr("id").replace("node_", ""),
                            padre_id: data.rslt.cr === -1 ? 1 : data.rslt.np.attr("id").replace("node_", "")
                        },
                        success: function (r) {
                            if (!r.status) { $.jstree.rollback(data.rlbk); mostrarError(Error_Edit); }
                            else {
                                $(data.rslt.oc).attr("id", "node_" + r.id);
                                if (data.rslt.cy && $(data.rslt.oc).children("UL").length) data.inst.refresh(data.inst._get_parent(data.rslt.oc));
                                mostrarExito(Exito_Edit);
                            }
                        }
                    });
                });
            })/*
            .bind("mouseout", function (e, data) { // Despues de que el cursor sale del nodo
                if ($('#dialogInfo').css('display') == 'block')
                    $('#dialogInfo').hide('clip');
            })*/;
        }

        function consultarNodo(id) {
            var nodo;
            $.ajax({ url: '/Jerarquia/ConsultarNodo/', data: { id: id }, type: 'POST', async: false,
                success: function (r) {
                    if (r.nombre) nodo = r;
                }
            });
            return nodo;
        }

        function mostrarDialog(titulo, dialog, datos) {
            if (datos.obj.attr("rel") != "asesor") {
                inicializarFormNodo();
                var padre_id = (datos.parent != null) ? datos.parent.attr("id") : "0";
                if (padre_id == "0") var nodo = consultarNodo(datos.obj.attr('id'));

                $("#" + dialog).dialog({
                    height: 350, width: 400, modal: true, title: titulo,
                    open: function (event, ui) {
                    },
                    close: function (event, ui) {
                        $(this).dialog('destroy'); $(this).dialog("close");
                        $.jstree.rollback(datosNodo.rlbk);
                    }
                });
                $('#padre_id').val(padre_id.replace(/[^0-9]/gi, ''));

                if (padre_id != "0") {
                    $('#nombre').val(datos.name);
                    $('#btnCrear').attr('value', 'Crear nodo');
                } else {
                    $('#detalle_id').val(datos.obj.attr('id'));
                    $('#nombre').val(datos.new_name);
                    $('#descripcion').val(nodo.descripcion);
                    $('#zona_id option').each(function () {
                        if ($(this).val() == nodo.zona_id) $(this).attr('selected', 'selected');
                    });

                    var localidad = $('#localidad_id');
                    localidad.find('option').remove();
                    $("<option value='0'>Seleccione...</option>").appendTo(localidad);
                    $.getJSON('/Modelo/getLocalidades', { idZona: nodo.zona_id }, function (data) {
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidad);
                        });
                        $('#localidad_id option').each(function () {
                            if ($(this).val() == nodo.localidad_id) $(this).attr('selected', 'selected');
                        });
                    });

                    $('#canal_id option').each(function () {
                        if ($(this).val() == nodo.canal_id) $(this).attr('selected', 'selected');
                    });
                    $('#participante').val(nodo.nombrePpante);
                    $('#participante_id').val(nodo.participante_id);
                    $('#nivel_id').val(nodo.nivel_id);
                    $('#codigoNivel').val(nodo.codigoNivel);
                    $('#btnCrear').attr('value', 'Actualizar nodo');
                }
            } else {
                $.jstree.rollback(datosNodo.rlbk);
            }
        }

        function validar() {
            if (($('#nombre').val() != "") && ($('#padre_id').val() != "") && ($('#zona_id').val() != "") && ($('#canal_id').val() != "")
                  && ($('#codigoNivel').val() != "") && ($('#nivel_id').val() != "")) {
                return true;
            }
            return false;
        }

        function crearNodo() {
            if (validar()) {
                mostrarCargando(Procesando);
                $.ajax({ url: "/Jerarquia/CrearNodo", data: $("#formCrear").serialize(), type: 'POST', //async: false,
                    success: function (nodo) {
                        if ($('#detalle_id').val() == 0) {
                            if (nodo) {
                                if (nodo.id) {                                 
                                    $(datosNodo.rslt.obj).attr("id", nodo.id);
                                    $(datosNodo.rslt.obj).attr("cod", nodo.codJerarquia);
                                    $(datosNodo.rslt.obj).attr("rel", $("#nivel_id option:selected").text().toLowerCase().replace(' de ', ' ').replace(' ', '_'));
                                    $("#" + nodo.id + " > a ").html("<ins class='jstree-icon'>&nbsp;</ins>" + $('#nombre').val());
                                    mostrarExito(Exito_Insert); $("#dialog").dialog('destroy'); $("#dialog").dialog("close");
                                } else {
                                    mostrarError("Imposible completar el proceso. El código de nivel ya existe o El participante ya este creado para el canal seleccionado.");
                                }
                            }
                            else { mostrarError(Error_Insert); }
                        } else {
                            if (nodo) {
                                if (nodo.id) {
                                    $("#" + nodo.id + " > a ").html("<ins class='jstree-icon'>&nbsp;</ins>" + $('#nombre').val());
                                    $(datosNodo.rslt.obj).attr("rel", $("#nivel_id option:selected").text().toLowerCase().replace(' de ', ' ').replace(' ', '_'));
                                    mostrarExito(Exito_Edit); $("#dialog").dialog('destroy'); $("#dialog").dialog("close");
                                } else {
                                    mostrarError("Imposible completar el proceso. El código de nivel ya existe o El participante ya este creado para el canal seleccionado.");
                                }
                            }
                            else { mostrarError(Error_Edit); }
                        }
                    },
                    complete: function (nodo) { closeNotify("jNotify"); }
                });
            } else {
                mostrarError(Error_Validacion);
            }
        }

        function eliminarNodo() {
            if (datosNodo.rslt.obj) {
                mostrarCargando(Procesando);
                $.ajax({ url: "/Jerarquia/EliminarNodo/", data: { id: datosNodo.rslt.obj.attr('id') }, type: 'POST', async: false,
                    success: function (result) {
                        if (result != 0)
                            mostrarExito(Exito_Delete);
                        else {
                            $.jstree.rollback(datosNodo.rlbk); 
                            mostrarError("Error al eliminar la información. Este nodo contiene elementos dependientes. <br>Revise las excepciones que pueda tener asociadas y que no tenga nodos dependientes en la jerarquía. ");
                        }
                    },
                    complete: function (nodo) { closeNotify("jNotify"); }
                });
            }
        }

        function obtenerInfo(id) {
            $('#dialogInfo').css('top', y - 10);

            if ((clickDerecho == 1)/* && (id != nodo_id)*/) {
                nodo_id = id;
                $.ajax({ url: "/Jerarquia/ConsultarNodo/", data: { id: id }, type: 'POST', async: false,
                    success: function (nodo) {
                        if (nodo.nombre) {
                            $('#nombreNodo').text(nodo.nombre);
                            $('#descrip').text(nodo.descripcion);
                            $('#nombrePpante').text(nodo.nombrePpante);
                            $('#nombreZona').text(nodo.nombreZona);
                            $('#nombreLocalidad').text(nodo.nombreLocalidad);
                            $('#nombreCanal').text(nodo.nombreCanal);
                            $('#nombreNivel').text(nodo.nombreNivel);
                            $('#codNivel').text(nodo.codigoNivel);
                            $('#codigoJerarquia').text(obtenerCodJerarquia(id) + nodo.codJerarquia);
                        }
                        $('#dialogInfo').show('clip');
                    }
                });
            } else if (id == nodo_id) $('#dialogInfo').toggle('clip');
        }

        function obtenerCodJerarquia(id) {
            var codigo = "";
            $('#' + id).parents('li').each(function () {
                if ($(this).attr('cod') != 'null')
                    codigo = $(this).attr('cod') + codigo;
            });
            return codigo;
        }

        function mostrarDialogParticipantes(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 630, width: 650, modal: true, title: titulo,
                buttons: { Cerrar: function () { $(this).dialog("close"); } },
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        }

        function formAnadirExcepcion(idNodo) {

            $("#contentExcepcionList").hide();
            $("#contentExcepcionEdit").show();            
            $("#destino").text("");
            $("#origen").text("");
            $("#meta_id_exc").val(0);
            $("#guardarExcepcion").attr('disabled', false);

            var nodo = consultarNodo(idNodo);

            $("#origen").text(nodo.nombre);

            $("#contentExcepcion").dialog({
                width:600,
                minHeight:350,
                title: 'Excepciones',
                position: 'center',
                close: function (ev, ui) {
                    $("#contentExcepcionHidden").val(0);
                }                                            
            });

            $("#contentExcepcionHidden").val(1);
            $("#origenId").val(idNodo);
            $("#destinoIds").val(0);

        }

        function adicionarDestino(idNodo) {

            var idNodoOrigen = $("#origenId").val();
            var destinosIds = $("#destinoIds").val();
            var existe = false;
            var arrNodosDestinos = destinosIds.split(',');

            for (i = 0; i < arrNodosDestinos.length; i++){             
                if (idNodo == arrNodosDestinos[i])
                    existe = true;
            }

            if (idNodoOrigen != idNodo && !existe) {

                var nodo = consultarNodo(idNodo);

                $("#destino").append(nodo.nombre + "<br/>");                
                $("#destinoIds").val(destinosIds + "," + idNodo);
            }
        }

        function excepcionesSave() {

            var destinos = $("#destino").text();

            if (destinos != "") {
                var stUrl = '/Jerarquia/guardarExcepcion';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#guardarExcepcion").attr('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: $("#excepcionForm").serialize(),
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito.");
                            $("#destinoIds").val(0);
                            mostrarExcepcionList();
                            $("#destino").text("");
                            $("#guardarExcepcion").attr('disabled', false);
                            $("#meta_id_exc").val(0);
                            selectAll(false);
                        }
                    }
                });
            }
            else {
                mostrarError("Debe seleccionar por lo menos un participante para el destino.");
            }
        }

        function mostrarExcepcionEdit() {
            $("#contentExcepcionList").hide();
            $("#contentExcepcionEdit").show();  

        }

        function mostrarExcepcionList() {

            var stUrl = '/Jerarquia/listadoExcepcionesJerarquia';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idJerarquia: $("#origenId").val()
                    },
                success: function (response) {
                    $("#contentExcepcionList").html(response);
                }
            });            
                                
            $("#contentExcepcionList").show();
            $("#contentExcepcionEdit").hide();

        }

        function deleteExcepcionJerarquia(idExcepcionJerarquia) {

            var stUrl = '/Jerarquia/eliminarExcepcionJerarquia';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idExcepcionJerarquia: idExcepcionJerarquia
                    },
                success: function (response) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    mostrarExcepcionList();
                }
            });

        }

        function eliminarTodasExcepciones() {

            if (confirm(" Esta seguro de borrar todas las excepciones?  \n El proceso no se podra deshacer. ")) {
                
                var stUrl = '/Jerarquia/eliminarExcepcionJerarquiaAll';
                mostrarCargando("Borrando información. Espere Por Favor...");
                var idNodoOrigen = $("#origenId").val();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data:
                    {
                        idNodoOrigen: idNodoOrigen
                    },
                    success: function (response) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        mostrarExcepcionList();
                    }
                });
            }
        }

        function excepcionesCancelar() {
            $("#destinoIds").val(0);
            $("#destino").text("");
            $("#meta_id_exc").val(0);
            selectAll(false);
        }

        function formAnadirMeta(idNodo) {

            $("#contentMetaList").hide();
            $("#contentMetaEdit").show();
            $("#origenMeta").text("");
            $("#guardarMeta").attr('disabled', false);

            var nodo = consultarNodo(idNodo);

            $("#origenMeta").text(nodo.nombre);

            $("#contentMeta").dialog({
                width: 600,
                minHeight: 350,
                title: 'Metas',
                position: 'center',
                modal:true
            });

            $("#origenIdMeta").val(idNodo);
        }

        function metaSave() {

            if ($("#metaForm").valid()){

                var stUrl = '/Jerarquia/guardarMeta';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#guardarMeta").attr('disabled', true);
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data:
                    {
                        metaId: $("#meta_id").val(),
                        origenId: $("#origenIdMeta").val(),
                        anio: $("#anio").val()
                    },
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito.");
                            mostrarMetaList();
                            $("#guardarMeta").attr('disabled', false);
                            $("#meta_id").val(0);
                            var currentTime = new Date();
                            $("#anio").val(currentTime.getFullYear());
                        }
                    }
                });
            }
        }

        function mostrarMetaEdit() {
            $("#contentMetaList").hide();
            $("#contentMetaEdit").show();
        }

        function mostrarMetaList() {

            var stUrl = '/Jerarquia/listadoMetasJerarquia';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idJerarquia: $("#origenIdMeta").val()
                    },
                success: function (response) {
                    $("#contentMetaList").html(response);
                }
            });

            $("#contentMetaList").show();
            $("#contentMetaEdit").hide();

        }

        function deleteMetaJerarquia(idMetaJerarquia) {

            var stUrl = '/Jerarquia/eliminarMetaJerarquia';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idMetaJerarquia: idMetaJerarquia
                    },
                success: function (response) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    mostrarMetaList();
                }
            });

        }

        function metaCancelar() {
            $("#meta_id").val(0);
        }



    </script>
    
    <div id="encabezadoSeccion">
        <div id="infoSeccion" >
            <h3>Administración Jerarquía Comercial</h3>
            <%: Html.ActionLink("Regresar", "Crear") %><br />
        </div>
        <div id="progresoSeccion">
            <div id="ayuda">
                Puede desplegar los nodos haciendo clic en el icono al lado izquierdo de cada uno para visualizar los nodos dependientes.
                Haga clic derecho en los nodos para visualizar las opciones de creación, edición y eliminación.
                Puede arrastrar un nodo o una rama del árbol donde desee para modificar su dependencia. <br />
            </div>
        </div>
        <div style="clear:both;"><hr /></div>
    </div>

    <div id="Arbol0" oncontextmenu="return false"><%----%>
    </div>

    <% string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }
       int num = new Random().Next(1, 10000); %>
<% JerarquiaDetalle detalle = ViewBag.JerarquiaDetalle; %>

    <div id='dialog' style="display:none;">
        <% using (Html.BeginForm("CrearNodo", "Jerarquia", FormMethod.Post, new { id = "formCrear" })) { %>
        <%: Html.ValidationSummary(true)%>
        <fieldset>
            <table>
                <tr>
                    <td>Nombre:</td>
                    <td><%: Html.TextBox("nombre", "", new { size=40 })%></td>
                </tr>
                <tr>
                    <td>Descripción:</td>
                    <td><%: Html.TextBox("descripcion", "", new { size = 40 })%></td>
                </tr>
                <tr>
                    <td>Zona:</td>
                    <td><%: Html.DropDownList("zona_id", (SelectList)ViewBag.zona_id, "Seleccione...")%></td>
                </tr>
                <tr>
                    <td>Localidad:</td>
                    <td><%: Html.DropDownList("localidad_id", (SelectList)ViewBag.localidad_id)%></td>
                </tr>
                <tr>
                    <td>Canal:</td>
                    <td><%: Html.DropDownList("canal_id", (SelectList)ViewBag.canal_id, "Seleccione...")%></td>
                </tr>
                <tr>
                    <td>Participante:</td>
                    <td><%: Html.TextBox("participante", "", new { style = "float:left;", @readonly = "true", size = 40 })%>
                        <a href="javascript:mostrarDialogParticipantes('/ParticipanteConcurso/Participantes?r=<%: num %>', 'Lista de Participantes', 'dialogPart');"
                            title='Seleccionar participante' style="float:left"><span class='ui-icon ui-icon-search'></span></a>
                    </td>
                </tr>
                <tr>
                    <td>Nivel:</td>
                    <td><%: Html.DropDownList("nivel_id", (SelectList)ViewBag.nivel_id, "Seleccione...")%></td>
                </tr>
                <tr>
                    <td>Código de Nivel:</td>
                    <td><%: Html.TextBox("codigoNivel", "") %></td>
                </tr>
            </table>
            <%:Html.Hidden("detalle_id")%>
            <%:Html.Hidden("jerarquia_id", TempData["jerarquia_id"])%>
            <%:Html.Hidden("padre_id")%>
            <%:Html.Hidden("participante_id")%>
            <%:Html.Hidden("codJerarquia")%>
            <p><input type="button" value="Crear nodo" id="btnCrear" onclick="crearNodo()" /></p>
        </fieldset>
        <% } %>
    </div>
    <div id='dialogPart' style="display:none;"></div>

    <div id="dialogInfo" style="display:none;" class="info">
        <table>
            <tr><td id="nombreNodo" colspan="2" style=""></td></tr>
            <tr>
                <td>Descripción:</td> <td id="descrip"></td>
            </tr>
            <tr>
                <td>Funcionario:</td> <td id="nombrePpante"></td>
            </tr>
            <tr>
                <td>Zona:</td> <td id="nombreZona"></td>
            </tr>
            <tr>
                <td>Localidad:</td> <td id="nombreLocalidad"></td>
            </tr>
            <tr>
                <td>Canal:</td> <td id="nombreCanal"></td>
            </tr>
            <tr>
                <td>Nivel:</td> <td id="nombreNivel"></td>
            </tr>
            <tr>
                <td>Código de nivel:</td> <td id="codNivel"></td>
            </tr>
            <tr>
                <td>Código de Jerarquia:</td> <td id="codigoJerarquia"></td>
            </tr>
        </table>
    </div>

    <div id="contentExcepcion" style="display:none;">
        <a href="javascript:mostrarExcepcionEdit();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Nueva Excepción</span></a>
        <a href="javascript:mostrarExcepcionList();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Ver Excepciones</span></a>
        <a href="javascript:eliminarTodasExcepciones();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Eliminar todas Excepciones</span></a>
        <hr/>
        <div id="contentExcepcionEdit" style="display:block;">
            <form id="excepcionForm" name="excepcionForm" action="">
            <input type='hidden' id='contentExcepcionHidden' value='0' />
            Origen:<br/>
            <div id="origen"></div>
            <input type="hidden" id="origenId" name="origenId" value="0" />
            <hr/>
            <div class="table_format">Para adicionar un participante en el destino por favor haga clic en el nodo del arbol de jerarquia.</div>
            <table border="0">
            <tr>
                <td valign="top">Destino:</td>
                <td align="left">
                    <div id="destino"></div>
                    <input type="hidden" id="destinoIds" name="destinoIds" value="" />           
                </td>            
            </tr>
            <tr>
                <td valign="top">Meta:</td>
                <td>       
                    <div style="overflow:auto;height:400px;">  
                    Seleccionar Todas: <input type="checkbox" name="seleccionar" onclick="selectAll(this.checked);" />
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <%
                        int cols = 1;
                        List<Meta> metasList = ( List<Meta>)ViewData["MetasListExcepciones"];                        
                        foreach (Meta meta in metasList)
                        {
                            if (cols==1){
                                %>
                                  <tr>  
                                <%        
                            }
                            
                            %>
                                <td>
                                <input type="checkbox" name="metas[]" value="<%=meta.id%>" /><%=meta.nombre%>
                                </td>
                            <%
                            if (cols==3){
                                %>
                                  </tr>  
                                <%     
                                cols = 0;       
                            }                           
                                    
                            cols++;    
                        }
                    %>
                    </table>
                    </div>
                </td>
            </tr>
            </table>
            <br/>
            
            <center>
            <input type="button" onclick="excepcionesSave()" id="guardarExcepcion" value="Guardar"/>
            <input type="button" onclick="excepcionesCancelar()" id="cancelarExcepcion" value="Cancelar"/>
            </center>
            </form>
        </div>
        <div id="contentExcepcionList" style="display:none;">
        </div>
    </div>

    <div id="contentMeta" style="display:none;">
        <a href="javascript:mostrarMetaEdit();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Nueva Meta</span></a>
        <a href="javascript:mostrarMetaList();" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"><span class="ui-button-text">Ver Metas</span></a>
        <hr/>
        <div id="contentMetaEdit" style="display:block;">
            <form id="metaForm" name="metaForm" action="">
            Origen:<br/>
            <div id="origenMeta"></div>
            <input type="hidden" id="origenIdMeta" name="origenIdMeta" value="0" />
            <hr/>
            <table border="0">
            <tr>
                <td valign="top">Meta:</td>
                <td>
                        <%= Html.DropDownList("meta_id", (SelectList)ViewData["MetasList"], "Seleccione una...", new { style = "width:300px;", id = "meta_id", @class="required" })%>
                </td>            
            </tr>
            <tr>
                <td>Año:</td>
                <td><%=Html.ComboAnios("anio") %></td>
            </tr>
            </table>
            <br/>
            <center>
            <input type="button" onclick="metaSave()" id="guardarMeta" value="Guardar"/>
            <input type="button" onclick="metaCancelar()" id="cancelarMeta" value="Cancelar"/>
            </center>
            </form>
        </div>
        <div id="contentMetaList" style="display:none;">
        </div>
    </div>

</asp:Content>