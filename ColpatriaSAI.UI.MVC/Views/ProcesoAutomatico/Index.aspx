<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Administración de Proceso Automático
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-ui.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/toolkit.js") %>'></script>
    <script type="text/javascript">
        $(function () {
            $.datepicker.regional['es'] = {
                closeText: 'Cerrar',
                prevText: '<Ant',
                nextText: 'Sig>',
                currentText: 'Hoy',
                monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Juv', 'Vie', 'Sáb'],
                dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'],
                weekHeader: 'Sm',
                dateFormat: 'dd/mm/yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };
            $.datepicker.setDefaults($.datepicker.regional['es']);
            $("#FechaInicio").datepicker({ dateFormat: 'DD dd \'de\' MM \'de\' yy' });

            cargarData();
        });

        function cargarData() {
            var stUrl = '/ProcesoAutomatico/Consultar';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    fechaEj: document.getElementById("FechaInicio").value
                },
                success: function (response) {
                    if (response.Success) {
                        $("#tablaResultados").show("slow");
                        $("#resultados").html(response.htmlresult);

                        $("#idEjecucion").html(response.idEjecucion);
                        $("#fechaInicio").html(response.fechaInicio);
                        $("#fechaFin").html(response.fechaFin);
                        $("#estado").html(response.estado);

                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                }
            });
        }

        function cargarDetalle(control) {
            var valor = $("#" + control).text();
            $("#detalle").text(valor);
        }

        function cargarDetalleProceso(id) {
            $("#hproceso").val(id);
            var stUrl = '/ProcesoAutomatico/ConsultarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso: id
                },
                success: function (response) {
                    if (response.Success) {
                        $("#modalLabel").html(response.nombreProceso);
                        $("#txtMaxReintentos").val(response.maxReintentos);
                        $("#txtEmailInicio").val(response.emailInicio);
                        $("#txtEmailFin").val(response.emailFin);
                        $("#txtEmailError").val(response.emailError);
                        $("#dependencias").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo habilitar el proceso.");
                    }
                }
            });
        }

        function encenderProceso() {
            var stUrl = '/ProcesoAutomatico/EncenderProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {},
                success: function (response) {
                    if (response.Success) {
                        $("#divProAutGen").html(response.estadoProcesoAutomatico);
                        $("#ultimaFechaEjecucion").html(response.ultimaFechaEjecucion);
                        $("#proximafechaejecucion").html(response.proximafechaejecucion);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo encender el proceso.");
                    }
                }
            });
        }

        function activarProceso() {
            var stUrl = '/ProcesoAutomatico/ActivarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {},
                success: function (response) {
                    if (response.Success) {
                        $("#divProAutGen").html(response.estadoProcesoAutomatico);
                        $("#ultimaFechaEjecucion").html(response.ultimaFechaEjecucion);
                        $("#proximafechaejecucion").html(response.proximafechaejecucion);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo encender el proceso.");
                    }
                }
            });
        }

        function apagarProceso() {
            var stUrl = '/ProcesoAutomatico/ApagarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {},
                success: function (response) {
                    if (response.Success) {
                        $("#divProAutGen").html(response.estadoProcesoAutomatico);
                        $("#ultimaFechaEjecucion").html(response.ultimaFechaEjecucion);
                        $("#proximafechaejecucion").html(response.proximafechaejecucion);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo apagar el proceso.");
                    }
                }
            });
        }

        function habilitarProceso(id) {
            var stUrl = '/ProcesoAutomatico/HabilitarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso : id
                },
                success: function (response) {
                    if (response.Success) {
                        $("#tablaProcesos").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo habilitar el proceso.");
                    }
                }
            });
        }

        function deshabilitarProceso(id) {
            var stUrl = '/ProcesoAutomatico/DeshabilitarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso: id
                },
                success: function (response) {
                    if (response.Success) {
                        $("#tablaProcesos").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("No se pudo deshabilitar el proceso.");
                    }
                }
            });
        }

        function editarDependencia(contador) {
            $("#txtprocesodep" + contador).hide();
            $("#divprocesodep" + contador).show();
            $("#txtacciondep" + contador).hide();
            $("#divacciondep" + contador).show();
            $("#editardep" + contador).hide();
            $("#guardardep" + contador).show();
        }

        function guardarDependencia(contador) {
            var stUrl = '/ProcesoAutomatico/ActualizarDependencias';
            var nomProceso = $("#txtprocesodep" + contador).text();
            var nomAccion = $("#txtacciondep" + contador).text();
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso: document.getElementById("hproceso").value,
                    contador: contador,
                    procesodep: nomProceso,
                    tipoaccion: nomAccion
                },
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("El proceso no se realizó con éxito.");
                    }
                }
            });
            $("#txtprocesodep" + contador).show();
            $("#divprocesodep" + contador).hide();
            $("#txtacciondep" + contador).show();
            $("#divacciondep" + contador).hide();
            $("#editardep" + contador).show();
            $("#guardardep" + contador).hide();
        }

        function agregarDependencia() {
            var stUrl = '/ProcesoAutomatico/AgregarDependencias';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    
                },
                success: function (response) {
                    if (response.Success) {
                        $("#dependencias").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("El proceso no se realizó con éxito.");
                    }
                }
            });
        }

        function eliminarDependencia(contador) {
            var stUrl = '/ProcesoAutomatico/EliminarDependencias';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso: document.getElementById("hproceso").value,
                    contador: contador
                },
                success: function (response) {
                    if (response.Success) {
                        $("#dependencias").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        closeNotify('jNotify');
                        mostrarError("El proceso no se realizó con éxito.");
                    }
                }
            });
        }

        function cambiarDependencia(proId,proNom,contador) {
            $("#btnprocesodep" + contador).html(proNom);
            $("#txtprocesodep" + contador).html(proNom);
        }

        function cambiarAccion(accId, accNom, contador) {
            $("#btnacciondep" + contador).html(accNom);
            $("#txtacciondep" + contador).html(accNom);
        }

        function guardarProceso() {            
            var stUrl = '/ProcesoAutomatico/GuardarProceso';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    idProceso: document.getElementById("hproceso").value,
                    maxReintentos: document.getElementById("txtMaxReintentos").value,
                    emailInicio: document.getElementById("txtEmailInicio").value,
                    emailFin: document.getElementById("txtEmailFin").value,
                    emailError: document.getElementById("txtEmailError").value
                },
                success: function (response) {
                    if (response.Success) {
                        $("#modalDetProceso").modal('hide');                        
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        $("#modalDetProceso").modal('hide');
                        closeNotify('jNotify');
                        mostrarError("No se pudo habilitar el proceso.");
                    }
                }
            });
        }

        function cerrarProceso() {
            var stUrl = '/ProcesoAutomatico/LimpiarDiccionario';
            mostrarCargando("Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                },
                success: function (response) {
                    $("#modalDetProceso").modal('hide');
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                    else {
                        $("#modalDetProceso").modal('hide');
                        closeNotify('jNotify');
                        mostrarError("No se pudo habilitar el proceso.");
                    }
                }
            });
        }

    </script>
    <link href='<% =Url.Content("/Content/toolkit/css/normalize.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/bootstrap/bootstrap.min.css") %>'
        rel="stylesheet" type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/fonts.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/axa_icons.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/toolkit.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/site/login.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 8]>
      <link href="@Url.Content("~/Content/toolkit/css/bootstrap/bootstrap-ie7.css")" rel="stylesheet">
      <link href="@Url.Content("~/Content/toolkit/css/ie/ie7.css")" rel="stylesheet">
      <script src="@Url.Content("~/Content/toolkit/js/ie/html5shiv.min.js")"></script>
      <script src="@Url.Content("~/Content/toolkit/js/ie/ie7.js")"></script>
      <link href="http://externalcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
      <script src="@Url.Content("~/Content/toolkit/js/bootstrap/respond.min.js")"></script>
      <![endif]-->
    <!--[if IE 9]>
        <link href="@Url.Content("~/Content/toolkit/css/ie/ie9.css")" rel="stylesheet">
    <![endif]-->
    <div class="row">
        <br />
        <div id="tabs">
            <h1 class="uppercase title">
                Administración de Proceso Automático</h1>
            <br />
            <div class="bs-example bs-example-tabs" data-example-id="togglable-tabs">
                <br />
                <ul id="myTabs" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active col-xs-4 text-center no-pad"><a href="#general"
                        id="general-tab" role="tab" data-toggle="tab" aria-controls="general" aria-expanded="true">
                        <i class="hidden-xs glyphicon glyphicon-ok-circle"></i>Información General</a></li>
                    <li role="presentation" class="col-xs-4 text-center no-pad"><a href="#procesos" role="tab"
                        id="procesos-tab" data-toggle="tab" aria-controls="procesos"><i class="hidden-xs glyphicon glyphicon-ok-circle">
                        </i>Procesos</a></li>
                    <li role="presentation" class="col-xs-4 text-center no-pad"><a href="#ejecuciones"
                        role="tab" id="ejecuciones-tab" data-toggle="tab" aria-controls="ejecuciones"><i
                            class="hidden-xs glyphicon glyphicon-ok-circle"></i>Ejecuciones</a></li>
                </ul>
                <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade in active" id="general" aria-labelledby="general-tab">
                        <form class="form-horizontal">
                            <div id="divProAutGen" class="form-group">
                                <div class="col-lg-6" style="text-align: center">
                                    <h1 class=" uppercase title">PROCESO AUTOMÁTICO</h1>
                                    <%if (Model.estado != "EN PROCESO")
                                      {
                                          if (DateTime.Parse(Model.ultimaFecha) > DateTime.Now)
                                          {%>
                                    <h5 style="color: Green">(Se encuentra encendido)</h5>
                                </div>
                                <div class="col-lg-3" style="text-align: center">
                                    <h5 style="color: Red">Apagar</h5>
                                    <a href="javascript:apagarProceso()"><i class="glyphicon glyphicon-off" data-toggle="tooltip" data-placement="right" style="color: Red;font-size: xx-large"></i></a>
                                </div>
                                        <%}
                                          else
                                          {%>
                                    <h5 style="color: Red">(Se encuentra apagado)</h5>
                                </div>
                                <div class="col-lg-3" style="text-align: center">
                                    <h5 style="color: Green">Encender</h5>
                                    <a href="javascript:encenderProceso()"><i class="glyphicon glyphicon-off" data-toggle="tooltip" data-placement="right" style="color: Green;font-size: xx-large"></i></a>
                                </div>
                                        <%}
                                      %>
                                 <div class="col-lg-3" style="text-align: center">
                                    <h5 style="color: Blue">Activar</h5>
                                    <a href="javascript:activarProceso()"><i class="glyphicon glyphicon-off" data-toggle="tooltip" data-placement="right" style="color: Blue;font-size: xx-large"></i></a>
                                </div>
                                    <%}
                                      else
                                      {%>
                                   <h5 style="color: Blue">(Se encuentra EN PROCESO)</h5>
                                </div>
                                <%} %>
                            </div>
                        </form>
                        <br />
                        <br />
                        <form class="form-horizontal">
                            <div class="form-group">
                                <div class="col-lg-6" style="text-align: center">
                                    <h2 class=" uppercase title">ÚLTIMA FECHA DE EJECUCIÓN:</h2>
                                </div>
                                <div id="ultimaFechaEjecucion" class="col-lg-6" style="text-align: center">                        
                                    <%if (DateTime.Parse(Model.ultimaFecha) > DateTime.Now)
                                    { %>
                                    <h4><%=Html.Encode(Model.penultimaFecha)%></h4>
                                    <%}else{%>
                                    <h4><%=Html.Encode(Model.ultimaFecha)%></h4>
                                    <%}%>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-lg-6" style="text-align: center">
                                    <h2 class="uppercase title">PRÓXIMA FECHA DE EJECUCIÓN:</h2>
                                </div>
                                <div id="proximafechaejecucion" class="col-lg-6" style="text-align: center">                        
                                    <%if (DateTime.Parse(Model.ultimaFecha) > DateTime.Now)
                                    { %>
                                    <h4><%=Html.Encode(Model.ultimaFecha)%></h4>
                                    <%}else{%>
                                    <h4>NO APLICA</h4>
                                    <%}%>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="procesos" aria-labelledby="procesos-tab">
                        <div class="bs-example" data-example-id="simple-table">
                            <table class="table table-condensed table-striped table-header">
                                <thead>
                                    <tr>
                                        <th>Nombre Proceso</th>
                                        <th>Estado</th>
                                        <th style="text-align:center">On/Off</th>                                         
                                    </tr>
                                </thead>
                                <tbody id="tablaProcesos">
                                    <%foreach (AUT_Proceso proceso in Model.procesos)
                                        { %>
                                    <tr>
                                        <td class="col-lg-6">
                                            <a style="cursor:pointer;" onclick="javascript:cargarDetalleProceso(<%=Html.Encode(proceso.id)%>)" data-toggle="modal" data-target="#modalDetProceso"><%=Html.Encode(proceso.nombre_proceso)%></a>                                            
                                        </td>
                                        <%if (proceso.habilitado == 1)
                                            {%>
                                        <td class="col-lg-3" style="color: Green;">Habilitado</td>
                                            <%}
                                        else
                                            { %>
                                        <td class="col-lg-3" style="color: Red;">Deshabilitado</td>
                                            <%} %>
                                        <td class="col-lg-3" style="text-align:center">
                                            <%if (proceso.habilitado == 1)
                                                {%>
                                            <h6 style="color: Red">Deshabilitar</h6>
                                            <a href="javascript:deshabilitarProceso(<%=Html.Encode(proceso.id)%>)"><i class="glyphicon glyphicon-off" data-toggle="tooltip" data-placement="right" style="color: Red;font-size: xx-large"></i></a>
                                                <%}
                                            else
                                                { %>
                                            <h6 style="color: Green">Habilitar</h6>
                                            <a href="javascript:habilitarProceso(<%=Html.Encode(proceso.id)%>)"><i class="glyphicon glyphicon-off" data-toggle="tooltip" data-placement="right" style="color: Green;font-size: xx-large"></i></a>
                                                <%} %>
                                        </td>
                                    </tr>
                                    <%} %>
                                </tbody>
                            </table>
                        </div>   
                        <!-- Modal Detalle Procesos -->
                        <div class="modal fade" id="modalDetProceso" tabindex="-1" role="dialog" aria-labelledby="modalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>--%>
                                        <h4 class="modal-title" id="modalLabel">Detalle</h4>
                                        <input id="hproceso" type="hidden" />
                                    </div>
                                    <div id="detallePro" class="modal-body text-center">
                                        <div class="form-group">
                                            <div class="col-lg-4" style="text-align: left">
                                                <label for="txtMaxReintentos">Máximo de reintentos:</label>
                                            </div>
                                            <div class="col-lg-8" style="text-align: center">
                                                <input id="txtMaxReintentos" type="text" class="form-control animated"/>
                                            </div>
                                            <div class="col-lg-4" style="text-align: left">
                                                <label for="txtEmailInicio">Correo de notificación de inicio:</label>
                                            </div>
                                            <div class="col-lg-8" style="text-align: center">
                                                <input id="txtEmailInicio" type="text" class="form-control animated"/>
                                            </div>
                                            <div class="col-lg-4" style="text-align: left">
                                                <label for="txtEmailFin">Correo de notificación de fin:</label>
                                            </div>
                                            <div class="col-lg-8" style="text-align: center">
                                                <input id="txtEmailFin" type="text" class="form-control animated"/>
                                            </div>                                            
                                            <div class="col-lg-4" style="text-align: left">
                                                <label for="txtEmailError">Correo de notificación de error:</label>
                                            </div>
                                            <div class="col-lg-8" style="text-align: center">
                                                <input id="txtEmailError" type="text" class="form-control animated"/>
                                            </div>                                            
                                        </div>
                                        <br />
                                        <div class="form-group">
                                            <div class="col-lg-6" style="text-align:left">
                                                <h4 class="modal-title" id="H1">Dependencias</h4>
                                            </div>
                                            <div class="col-lg-6" style="text-align:right">
                                                <a href="javascript:agregarDependencia()" class="btn btn-primary btn-circle"><i class="glyphicon glyphicon-plus-sign"></i></a>
                                            </div>
                                            <table class="table table-condensed table-striped table-header">
                                                <thead>
                                                    <tr>
                                                        <th>PROCESO</th>
                                                        <th>ACCION EN CASO DE ERROR</th>
                                                        <th>OPCIONES</th>                              
                                                    </tr>
                                                </thead>
                                                <tbody id="dependencias">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <a href="javascript:cerrarProceso()" class="btn btn-primary">Cerrar</a>
                                        <a href="javascript:guardarProceso()" class="btn btn-default">Guardar</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="ejecuciones" aria-labelledby="ejecuciones-tab">
                        <div class="col-lg-12">
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <label for="FechaInicio" class="col-sm-2 control-label">
                                        Día de ejecución:
                                    </label>
                                    <div class="col-sm-7">
                                        <input type="text" class="form-control animated" style="font-family: ITCFranklinGothicBook;
                                        font-size: 0.87em; color: #666; text-align: center" id="FechaInicio" required />
                                    </div>
                                    <div class="col-sm-3" style="text-align: right">
                                        <a href="javascript:cargarData()" class="btn btn-default btn-circle">Consultar </a>
                                    </div>
                                </div>
                                <div class="division">
                                </div>
                            </form>
                            <br />
                            <form class="form-horizontal">
                                <div class="form-group">
                                    <div class="col-sm-5">
                                        <h1 class="main_title">Ejecucion:</h1>
                                    </div>
                                    <div class="col-sm-7">
                                        <p id="idEjecucion"><% =Html.Encode(Model.idEjecucion) %></p>
                                    </div>
                                    <br />
                                    <div class="col-sm-5">
                                        <h1 class="main_title">Fecha y Hora de Inicio:</h1>
                                    </div>
                                    <div class="col-sm-7">
                                        <p id="fechaInicio"><% =Html.Encode(Model.fechaInicio) %></p>
                                    </div>
                                    <br />
                                    <div class="col-sm-5">
                                        <h1 class="main_title">Fecha y Hora de Finalización:</h1>
                                    </div>
                                    <div class="col-sm-7">
                                        <p id="fechaFin"><% =Html.Encode(Model.fechaFin) %></p>
                                    </div>
                                    <br />
                                    <div class="col-sm-5">
                                        <h1 class="main_title">Estado:</h1>
                                    </div>
                                    <div class="col-sm-7">
                                        <p id="estado"><% =Html.Encode(Model.estado) %></p>
                                    </div>
                                </div>
                            </form>
                            <div id="tablaResultados" class="bs-example" data-example-id="simple-table" style="display: none">
                                <table class="table table-condensed table-striped table-header">
                                    <caption>Resultados</caption>
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Proceso</th>
                                            <th>Fecha Inicio</th>
                                            <th>Fecha Fin</th>
                                            <th>Estado</th>
                                            <th class="hidden-xs hidden-sm hidden-md hidden-lg">Detalle</th>
                                        </tr>
                                    </thead>
                                    <tbody id="resultados"></tbody>
                                </table>
                            </div>
                        </div>                        
                        <!-- Modal Detalle Ejecucion Procesos-->
                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                        <h4 class="modal-title" id="myModalLabel">Detalle</h4>
                                    </div>
                                    <div id="detalle" class="modal-body text-center">
                                        Bienvenido al ToolKit Axa Colpatria
                                    </div>
                                    <div class="modal-footer">
                                        <a class="btn btn-primary" data-dismiss="modal">Cerrar</a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
