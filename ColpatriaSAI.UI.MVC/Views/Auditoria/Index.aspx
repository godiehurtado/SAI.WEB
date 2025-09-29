<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Auditoria
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-ui.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js")%>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js")%>'></script>
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
            $("#FechaFin").datepicker({ dateFormat: 'DD dd \'de\' MM \'de\' yy' });
        });

        function cambiarTabla(tabla) {
            $("#txttabla").html(tabla);
            $("#htabla").val(tabla);
        }

        function consultarauditoria() {
            var stUrl = '/Auditoria/Consultar';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    tabla: document.getElementById("htabla").value,
                    fechainicio: document.getElementById("FechaInicio").value,
                    fechafin: document.getElementById("FechaFin").value
                },
                success: function (response) {
                    if (response.Success) {
                        $("#tablaResultados").show("slow");
                        $("#resultados").html(response.htmlresult);
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                }
            });
        }
    </script>
    <link href='<% =Url.Content("/Content/toolkit/css/normalize.css") %>' rel="stylesheet"type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/bootstrap/bootstrap.min.css") %>'rel="stylesheet" type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/fonts.css") %>' rel="stylesheet"type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/axa_icons.css") %>' rel="stylesheet"type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/toolkit.css") %>' rel="stylesheet"type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/site/login.css") %>' rel="stylesheet"type="text/css" />
    <link href='<% =Url.Content("/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />
    <div class="row">
        <h1 class="uppercase title">
        Auditoría</h1>

        <form class="form-horizontal">
            <div class="form-group">            
                <input id="htabla" type="hidden" />
                <label for="txttabla" class="col-sm-2 control-label">Entidad Auditada</label>
                <div class="col-sm-10">
                    <div class="dropdown">
                        <button id="txttabla" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="width: 100%">
                            Escoja la entidad que quiere consultar 
                            <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="txttidoc" style="width:100%; text-align:right">
                            <% foreach (var tabla in Model.Tablas)
                            { %>
                            <li><a href="javascript:cambiarTabla('<%=tabla.Value%>')">
                            <%=tabla.Value%></a></li>
                            <%} %>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="FechaInicio" class="col-sm-2 control-label">Fecha Inicio del Cambio</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control animated" style="font-family:ITCFranklinGothicBook; font-size: 0.87em; color:#666; text-align:center" id="FechaInicio" required/>
                </div>
            </div>
            <div class="form-group">
                <label for="FechaFin" class="col-sm-2 control-label">Fecha Fin del Cambio</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control animated" style="font-family:ITCFranklinGothicBook; font-size: 0.87em; color:#666; text-align:center" id="FechaFin" required/>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10" style="text-align:right">
                    <a href="javascript:consultarauditoria()" class="btn btn-default btn-circle">Consultar </a>
                </div>
            </div>
        </form>
        <h4><%=Html.ActionLink("Regresar","Index","JerarquiaComercial")%></h4>
        <div id="tablaResultados" class="bs-example" data-example-id="simple-table" style="display: none">
            <table class="table table-condensed table-striped table-header">
            <caption>Resultados</caption>
            <thead>
                <tr>
                    <th>Tabla Auditada</th>
                    <th>Usuario</th>
                    <th>Fecha</th>
                    <th>Tipo Evento</th>
                    <th>Versión Anterior</th>
                    <th>Nueva Versión</th>
                </tr>
            </thead>
            <tbody id="resultados">
                
            </tbody>
            </table>
        </div>
        </div>
</asp:Content>
