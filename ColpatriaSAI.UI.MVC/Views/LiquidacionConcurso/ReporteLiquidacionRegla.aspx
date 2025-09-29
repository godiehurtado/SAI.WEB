<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Reporte Liquidación Asesores - Sistema de Administración de Incentivos
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            var stUrl = '/LiquidacionConcurso/ReporteLiquidacion';
            //        mostrarCargando("Generando reporte. Por favor espere...");
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: {
                    liquidacionReglaId: $("#liquidacionRegla").val(),
                    reglaId: $("#idRegla").val()
                },
                success: function (response) {
                    FillGrid(response);
                }
            });
        });

        function FillGrid(data) {
            jQuery("#toolbar").jqGrid('GridUnload');            
            var array = new Array();
            if (data.error) {
                MsgAceptar("Error", data.mensaje, function () {
                });
            }
            $.each(data.grid, function (index, Item) {
                var dato1 = $.parseJSON(Item);
                array.push(dato1);
            });

            var grid = array;
            var namesCol = data.namesCol;
            var modelCol = data.modelCol;
            $("#msg_NoData").hide();
            if (grid.length == 0) {
                $("#msg_NoData").show();
                return;
            }

            jQuery("#toolbar").jqGrid({
                data: grid,
                datatype: 'local',
                //url: 'ConInfEstadoCuentaCliente.aspx/GetDataClient',
                //height: 220,
                width: 830,
                //width: 'auto',
                height: 'auto',
                shrinkToFit: true,
                colNames: namesCol,
                colModel: modelCol,
                rowNum: 20,
                rownumbers: true,
                pgbuttons: true,
                pginput: true,
                altRows: true,
                loadonce: true,
                viewrecords: true,
                recordtext: 'Mostrando {1} resultados',
                mtype: "POST",
                pager: '#ptoolbar',
                sortname: 'ID_REPORTE',
                sortorder: "asc",
                caption: "Resultados",
                onClick: function () {
                    alert("jhdf");
                }
                //                onSelectRow: function (rowid, status) {
                //                    var reporte = jQuery(this).getRowData(rowid);
                //                    selectedRow = reporte.ID_REPORTE;
                //                    userRow = reporte.USUARIO_CREACION;
                //                }
            });


            jQuery("#toolbar").jqGrid('navGrid', '#ptoolbar', { edit: false, add: false, del: false, search: false, refresh: false });

            $("#gview_toolbar").css('overflow', 'auto');
            var w = $("#gview_toolbar table[class='ui-jqgrid-htable']").css('width');
            $("#gview_toolbar .ui-jqgrid-titlebar").css('width', w);
            //muestra el cursor hand sobre las filas de la grilla
            $('#gview_toolbar   tr').css('cursor', 'pointer');
            //Opción 1: Filtros arriba siempre visibles
            //            jQuery("#toolbar").jqGrid('filterToolbar', {
            //                stringResult: true,
            //                searchOnEnter: false
            //            });

            //Esconder el PopUp Seleccione Una Fila
            //$("#alertmod").hide();
            $("#gridDiv").show();
        }
    </script>
    <div>
        <%: Html.Hidden("liquidacionRegla", (string)ViewBag.liquidacionregla_id)%>
        <input id="hola" type="text" />
        <div id="pnlResultado" style="text-align: center">
            <div id="gridDiv" class="ui_content">
                <table id="toolbar">
                </table>
                <div id="ptoolbar">
                </div>
                <div id="text_gridPolizas_bottom" class="ui_info_text">
                </div>
                <div id="msg_NoData" class="ui-widget ui_content" style="width: 200px; margin-top: 20px;">
                    <div class="ui-state-error ui-corner-all" style="padding: 0pt 0.7em;">
                        <p>
                            <span class="ui-icon ui-icon-alert" style="float: left; margin-right: 0.3em;"></span>
                            No se han encontrado resultados.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
