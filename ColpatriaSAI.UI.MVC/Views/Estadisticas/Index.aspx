<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Index
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-ui.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js") %>'></script>
    <script type="text/jscript" src='<% =Url.Content("/Scripts/yui-min.js")%>')></script>
    <script type="text/jscript" src='<% =Url.Content("/Scripts/numeral.min.js")%>')></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/toolkit.js") %>'></script>--%>
    <script type="text/javascript">
        var monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
        var monthNamesShort = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        $(function () {
            var d = new Date();
            var n = d.getMonth();
            var y = d.getFullYear();
            var meses = "";
            for (i = 0; i <= n; i++) {
                meses += "<li><a href=\"javascript:ConstruirReporteRecaudosMesPromedio(" + y + "," + (i + 1) + ")\">" + monthNames[i] + "</a></li>";
            }
            $("#ulmes1").html(meses);
            ConstruirReporteRecaudosMesPromedio(y, (n + 1));
            meses = "";
            for (i = 0; i <= n; i++) {
                meses += "<li><a href=\"javascript:ConstruirReporteRegistrosRecaudosMesPromedio(" + y + "," + (i + 1) + ")\">" + monthNames[i] + "</a></li>";
            }
            $("#ulmes2").html(meses);
            ConstruirReporteRegistrosRecaudosMesPromedio(y, (n + 1));
            meses = "";
            for (i = 0; i <= n; i++) {
                meses += "<li><a href=\"javascript:ConstruirReportePrimasMesPromedio(" + y + "," + (i + 1) + ")\">" + monthNames[i] + "</a></li>";
            }
            $("#ulmes3").html(meses);
            ConstruirReportePrimasMesPromedio(y, (n + 1));
            meses = "";
            for (i = 0; i <= n; i++) {
                meses += "<li><a href=\"javascript:ConstruirReporteRegistrosPrimasMesPromedio(" + y + "," + (i + 1) + ")\">" + monthNames[i] + "</a></li>";
            }
            $("#ulmes4").html(meses);
            ConstruirReporteRegistrosPrimasMesPromedio(y, (n + 1));
        });

        function ConstruirReporteRecaudosMesPromedio(_anio,_mes) {
            $("#ddlmes1").html(monthNames[_mes-1]);
            $("#report_chart_valorrecaudos").empty();
            var stUrl = '/Estadisticas/ConstruirReporteRecaudosMesPromedio';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    anio: _anio,
                    mes: _mes
                },
                success: function (response) {
                    if (response.Success) {
                        $("#titulo1").html("Recaudos " + monthNames[_mes - 1] + " Vs. Promedio Ene - " + monthNamesShort[_mes - 2]);
                        $("#report_chart_container").show();
                        YUI().use('charts-legend', function (Y) {
                            var myDataValues = response.ChartData;

                            //Define axes and assign keys
                            var myAxes = {
                                recaudos: {
                                    type: "numeric",
                                    position: "left",
                                    keys: ["TotalRecaudos", "PromedioRecaudos"],
                                    labelFormat: {
                                        prefix: "$",
                                        thousandsSeparator: ","
                                    }
                                },
                                compania: {
                                    type: "category",
                                    position: "bottom",
                                    keys: ["Categoria"],
                                    legend: {
                                        styles: {
                                            display: "none"
                                        }
                                    },
                                    styles: {
                                        legend: {
                                            display: "none"
                                        },
                                        label: {
                                            rotation: -45,
                                            margin: { top: 5 }
                                        }
                                    }
                                }
                            };

                            //Define a series collection so that we can assign nice display names
                            var mySeries = [
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "TotalRecaudos", xKey: "Categoria", yDisplayName: "Total Recaudos", xDisplayName: "Compania" },
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "PromedioRecaudos", xKey: "Categoria", yDisplayName: "Promedio Recaudos", xDisplayName: "Compania" }
                            ];

                            var mychart = new Y.Chart({
                                legend: {
                                    position: "right",
                                    width: 300,
                                    height: 300,
                                    styles: {
                                        hAlign: "center",
                                        hSpacing: 4
                                    }
                                },
                                dataProvider: myDataValues,
                                categoryKey: "Categoria",
                                axes: myAxes,
                                seriesCollection: mySeries,
                                horizontalGridlines: true,
                                verticalGridlines: true,
                                render: "#report_chart_valorrecaudos"
                            });
                        });
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                }
            });
        }

        function ConstruirReporteRegistrosRecaudosMesPromedio(_anio,_mes) {
            $("#ddlmes2").html(monthNames[_mes - 1]);
            $("#report_chart_registrosrecaudos").empty();
            var stUrl = '/Estadisticas/ConstruirReporteRegistrosRecaudosMesPromedio';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    anio: _anio,
                    mes: _mes
                },
                success: function (response) {
                    if (response.Success) {
                        $("#titulo2").html("Registros Recaudos " + monthNames[_mes - 1] + " Vs. Promedio Ene - " + monthNamesShort[_mes - 2]);
                        $("#report_chart_container").show();
                        YUI().use('charts-legend', function (Y) {
                            var myDataValues = response.ChartData;

                            //Define axes and assign keys
                            var myAxes = {
                                recaudos: {
                                    type: "numeric",
                                    position: "left",
                                    keys: ["TotalRegistros", "PromedioRegistros"]
                                },
                                compania: {
                                    type: "category",
                                    position: "bottom",
                                    keys: ["Categoria"],
                                    legend: {
                                        styles: {
                                            display: "none"
                                        }
                                    },
                                    styles: {
                                        legend: {
                                            display: "none"
                                        },
                                        label: {
                                            rotation: -45,
                                            margin: { top: 5 }
                                        }
                                    }
                                }
                            };

                            //Define a series collection so that we can assign nice display names
                            var mySeries = [
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "TotalRegistros", xKey: "Categoria", yDisplayName: "Total Registros", xDisplayName: "Compania" },
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "PromedioRegistros", xKey: "Categoria", yDisplayName: "Promedio Registros", xDisplayName: "Compania" }
                            ];

                            var mychart = new Y.Chart({
                                legend: {
                                    position: "right",
                                    width: 300,
                                    height: 300,
                                    styles: {
                                        hAlign: "center",
                                        hSpacing: 4
                                    }
                                },
                                dataProvider: myDataValues,
                                categoryKey: "Categoria",
                                axes: myAxes,
                                seriesCollection: mySeries,
                                horizontalGridlines: true,
                                verticalGridlines: true,
                                render: "#report_chart_registrosrecaudos"
                            });
                        });
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                }
            });
        }

        function ConstruirReportePrimasMesPromedio(_anio, _mes) {
            $("#ddlmes3").html(monthNames[_mes - 1]);
            $("#report_chart_valorprimas").empty();
            var stUrl = '/Estadisticas/ConstruirReportePrimasMesPromedio';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    anio: _anio,
                    mes: _mes
                },
                success: function (response) {
                    if (response.Success) {
                        $("#titulo3").html("Primas " + monthNames[_mes - 1] + " Vs. Promedio Ene - " + monthNamesShort[_mes - 2]);
                        $("#report_chart_container").show();
                        YUI().use('charts-legend', function (Y) {
                            var myDataValues = response.ChartData;

                            //Define axes and assign keys
                            var myAxes = {
                                recaudos: {
                                    type: "numeric",
                                    position: "left",
                                    keys: ["TotalPrimas", "PromedioPrimas"],
                                    labelFormat: {
                                        prefix: "$",
                                        thousandsSeparator: ","
                                    }
                                },
                                compania: {
                                    type: "category",
                                    position: "bottom",
                                    keys: ["Categoria"],
                                    legend: {
                                        styles: {
                                            display: "none"
                                        }
                                    },
                                    styles: {
                                        legend: {
                                            display: "none"
                                        },
                                        label: {
                                            rotation: -45,
                                            margin: { top: 5 }
                                        }
                                    }
                                }
                            };

                            //Define a series collection so that we can assign nice display names
                            var mySeries = [
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "TotalPrimas", xKey: "Categoria", yDisplayName: "Total Primas", xDisplayName: "Compania" },
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "PromedioPrimas", xKey: "Categoria", yDisplayName: "Promedio Primas", xDisplayName: "Compania" }
                            ];

                            var mychart = new Y.Chart({
                                legend: {
                                    position: "right",
                                    width: 300,
                                    height: 300,
                                    styles: {
                                        hAlign: "center",
                                        hSpacing: 4
                                    }
                                },
                                dataProvider: myDataValues,
                                categoryKey: "Categoria",
                                axes: myAxes,
                                seriesCollection: mySeries,
                                horizontalGridlines: true,
                                verticalGridlines: true,
                                render: "#report_chart_valorprimas"
                            });
                        });
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                    }
                }
            });
        }

        function ConstruirReporteRegistrosPrimasMesPromedio(_anio, _mes) {
            $("#ddlmes4").html(monthNames[_mes - 1]);
            $("#report_chart_registrosrecaudos").empty();
            var stUrl = '/Estadisticas/ConstruirReporteRegistrosPrimasMesPromedio';
            mostrarCargando("Consultando. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    anio: _anio,
                    mes: _mes
                },
                success: function (response) {
                    if (response.Success) {
                        $("#titulo4").html("Registros Primas " + monthNames[_mes - 1] + " Vs. Promedio Ene - " + monthNamesShort[_mes - 2]);
                        $("#report_chart_container").show();
                        YUI().use('charts-legend', function (Y) {
                            var myDataValues = response.ChartData;

                            //Define axes and assign keys
                            var myAxes = {
                                recaudos: {
                                    type: "numeric",
                                    position: "left",
                                    keys: ["TotalRegistros", "PromedioRegistros"]
                                },
                                compania: {
                                    type: "category",
                                    position: "bottom",
                                    keys: ["Categoria"],
                                    legend: {
                                        styles: {
                                            display: "none"
                                        }
                                    },
                                    styles: {
                                        legend: {
                                            display: "none"
                                        },
                                        label: {
                                            rotation: -45,
                                            margin: { top: 5 }
                                        }
                                    }
                                }
                            };

                            //Define a series collection so that we can assign nice display names
                            var mySeries = [
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "TotalRegistros", xKey: "Categoria", yDisplayName: "Total Registros", xDisplayName: "Compania" },
                                { type: "column", yAxis: "recaudos", xAxis: "compania", yKey: "PromedioRegistros", xKey: "Categoria", yDisplayName: "Promedio Registros", xDisplayName: "Compania" }
                            ];

                            var mychart = new Y.Chart({
                                legend: {
                                    position: "right",
                                    width: 300,
                                    height: 300,
                                    styles: {
                                        hAlign: "center",
                                        hSpacing: 4
                                    }
                                },
                                dataProvider: myDataValues,
                                categoryKey: "Categoria",
                                axes: myAxes,
                                seriesCollection: mySeries,
                                horizontalGridlines: true,
                                verticalGridlines: true,
                                render: "#report_chart_registrosprimas"
                            });
                        });
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
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

    <div class="row">        
        <div class="col-xs-9" style="padding:0 0 0 0;">
            <h1 class="uppercase title">
                Estadísticas</h1>
            <br />
            <div id="report_chart_container" class="col-xs-12">
                <div class="col-xs-12" style="height: 400px;">
                    <div class="col-xs-9">
                        <h1 id="titulo1" class="main_title"></h1>
                    </div>                    
                    <div class="col-xs-3" style="text-align: right">
                        <a href="" class="btn btn-default btn-circle">Tabla <i class="glyphicon glyphicon-chevron-right"></i></a>
                    </div>
                    <div class="dropdown">
                        <button id="ddlmes1" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="width: 100%">
                            Escoja la entidad que quiere consultar 
                            <span class="caret"></span>
                        </button>
                        <ul id="ulmes1" class="dropdown-menu" aria-labelledby="ddlmes1" style="width:100%; text-align:right"></ul>
                    </div>
                    <div id="report_chart_valorrecaudos" style="width: 100%; height: 100%;">
                    </div>
                </div>
                <div class="col-xs-12" style="height: 100px;"></div>
                <div class="col-xs-12" style="height: 400px;">
                    <div class="col-xs-9">
                        <h1 id="titulo2" class="main_title"></h1>
                    </div>
                    <div class="col-xs-3" style="text-align: right">
                        <a href="" class="btn btn-default btn-circle">Tabla <i class="glyphicon glyphicon-chevron-right"></i></a>
                    </div>
                    <div class="dropdown">
                        <button id="ddlmes2" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="width: 100%">
                            Escoja la entidad que quiere consultar 
                            <span class="caret"></span>
                        </button>
                        <ul id="ulmes2" class="dropdown-menu" aria-labelledby="ddlmes2" style="width:100%; text-align:right"></ul>
                    </div>
                    <div id="report_chart_registrosrecaudos" style="width: 100%; height: 100%;">
                    </div>
                </div>
                <div class="col-xs-12" style="height: 100px;"></div>
                <div  class="col-xs-12" style="height: 400px;">
                    <div class="col-xs-9">
                        <h1 id="titulo3" class="main_title"></h1>
                    </div>
                    <div class="col-xs-3" style="text-align: right">
                        <a href="" class="btn btn-default btn-circle">Tabla <i class="glyphicon glyphicon-chevron-right"></i></a>
                    </div>
                    <div class="dropdown">
                        <button id="ddlmes3" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="width: 100%">
                            Escoja la entidad que quiere consultar 
                            <span class="caret"></span>
                        </button>
                        <ul id="ulmes3" class="dropdown-menu" aria-labelledby="ddlmes3" style="width:100%; text-align:right"></ul>
                    </div>
                    <div id="report_chart_valorprimas" style="width: 100%; height: 100%;">
                    </div>
                </div>
                <div class="col-xs-12" style="height: 100px;"></div>
                <div class="col-xs-12" style="height: 400px;">
                    <div class="col-xs-9">
                        <h1 id="titulo4" class="main_title"></h1>
                    </div>
                    <div class="col-xs-3" style="text-align: right">
                        <a href="" class="btn btn-default btn-circle">Tabla <i class="glyphicon glyphicon-chevron-right"></i></a>
                    </div>
                    <div class="dropdown">
                        <button id="ddlmes4" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="width: 100%">
                            Escoja la entidad que quiere consultar 
                            <span class="caret"></span>
                        </button>
                        <ul id="ulmes4" class="dropdown-menu" aria-labelledby="ddlmes4" style="width:100%; text-align:right"></ul>
                    </div>
                    <div id="report_chart_registrosprimas" style="width: 100%; height:100%">
                    </div>
                </div>
                <div class="col-xs-12" style="height: 100px;"></div>
            </div>        
        </div>
        <div class="col-xs-3" >
                <div class="scrollbar">
                    <nav class="tools-nav">
                        <ul class="nav">
                            <li><a href="#titulo1">Valor Recaudos Mes Vs Promedio</a></li>
                            <li><a href="#titulo2">Registros Recaudos Mes Vs Promedio</a></li>
                            <li><a href="#titulo3">Valor Primas Mes Vs Promedio</a></li>
                            <li><a href="#titulo4">Registros Primas Mes Vs. Promedio</a></li>
                            <li><a href="#titulo5">Valor Colquines X Compañia - Ramo</a></li>
                            <li><a href="#titulo6">Reporte Recaudos X Ramo</a></li>
                            <li><a href="#titulo7">Reporte Primas X Ramo</a></li>
                            <li><a href="#titulo8">Crecimiento Primas Año</a></li>
                            <li><a href="#titulo9">Crecimiento Recaudos Año</a></li>
                        </ul>
                    </nav>
                </div>
            </div>
    </div>
    

</asp:Content>
