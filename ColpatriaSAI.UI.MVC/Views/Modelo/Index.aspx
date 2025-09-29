<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Modelo>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Modelos de Contratación
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function subirArchivo() {
            if (validar()) {
                if (confirm('¿Esta seguro de cargar la información?')) {
                    mostrarCargando(Procesando);
                    $("#ArchivoForm").submit();
                }
            }
        }

        function subirArchivoParticipantes() {

            if ($('#file').val() == '') {
                mostrarError("Por favor, suministre toda la información para el cargue.");
            }
            else {
                if (confirm('¿Esta seguro de cargar la información?')) {
                    mostrarCargando(Procesando);
                    $("#ArchivoParticipantesForm").submit();
                }
            }

        }

        function validar() {
            if ($('#archivo').val() == '') {
                var mensaje = "Por favor, suministre toda la información para el cargue.";
                mostrarError(mensaje);
                return false;
            }
            return true;
        }

        function eliminarModelo(id) {
            if (confirm('¿Esta seguro de eliminar éste modelo?')) {
                $.ajax({
                    url: '/Modelo/EliminarModelo', data: { id: id }, type: "POST",
                    success: function (result) {
                        if (result == "1") $('#fila' + id).remove(); else alert("No se puede eliminar. El registro tiene información asociada!");
                    }
                });
            }
        }

        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers", "bStateSave": true
            });
            $("#bRegresar").button({ icons: { primary: "ui-icon-circle-arrow-w"} });
            $("#bNuevo").button({ icons: { primary: "ui-icon-circle-plus"} });
            //$("#bMostrar").button({ icons: { primary: "ui-icon-circle-plus"} });
        });

    </script>

    <%--<div id="div1">
        <div id="div2" style="float:left"></div>
        <div id="div3" style="float:right"><%: Html.ActionLink("Regresar", "../Contratacion/Parametrizacion", null, new { id = "bRegresar" }) %></div>
    </div>--%>
    <h2>Modelos de Contratación</h2>
    <br />
    
    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    
    <div id="divCargue">
        <div style="float:left">
            <%: Html.ActionLink("Regresar", "../Contratacion/Parametrizacion", null, new { id = "bRegresar" }) %>
            <%: Html.ActionLink("Crear nuevo", "Crear", new { id = 0 }, new { id = "bNuevo" })%>
        </div>
        <div style="float:right">
            <fieldset style="vertical-align:top; padding:0px 10px 10px 10px"><legend>Ejecutar cargue de modelos</legend>
                <div style="float:left">
                    <form action="/Modelo/Cargue" method="post" enctype="multipart/form-data" id="ArchivoForm">
                        <input type="file" name="archivo" id="archivo" style="width:300px; font-size:8pt" />
                        <input type="button" onclick="subirArchivo()" style="font-size:9pt" value="Cargar modelos" />
                    </form>
                </div>
                <div style="float:left; padding-left:20px">
                    <a href='/Modelo/Descargar' target="_blank">
                        <img alt="" style="border:0" src="../../App_Themes/SAI.Estilo/Imagenes/xls.gif" /> Descargar formato
                    </a>
                </div>
            </fieldset>

            <%
                if (Model.Count() > 0)
                {
            %>
                    <fieldset style="vertical-align:top; padding:0px 10px 10px 10px"><legend>Ejecutar cargue de participantes</legend>
                        <div style="float:left">
                            <form action="/Modelo/ProcesarCargueParticipantes" method="post" enctype="multipart/form-data" id="ArchivoParticipantesForm">
                                <input type="file" name="file" id="file" style="width:300px; font-size:8pt" />
                                <input type="button" onclick="subirArchivoParticipantes()" style="font-size:9pt" value="Cargar participantes" />
                            </form>
                        </div>
                        <div style="float:left; padding-left:20px">
                            <a href='<%=ViewData["pathArchivoFormato"]%>' target="_blank">
                                <img alt="" style="border:0" src="../../App_Themes/SAI.Estilo/Imagenes/xls.gif" /> Descargar formato
                            </a>
                        </div>
                    </fieldset>
            <%
                }
            %>

        </div>
    </div>
    <br />

    <div style="float:left; padding-top:10px; width:100%;">
    <fieldset style="vertical-align:top"><legend>Listado de modelos de contratación</legend>
        <br />
        <table id="tablaLista" width="100%">
            <thead>
            <tr>
                <th>Id</th><th>Descripcion</th><th>Opciones</th>
            </tr>
            </thead>
            <tbody>
            <% foreach (var item in Model) { %>
                <tr id="fila<%: item.id %>">
                    <td style="width:30px"><%: item.id %> </td>
                    <td><%: item.descripcion %> </td>
                    <td style="width:75px">
                        <a href="/Modelo/Crear/<%: item.id %>" title='Editar modelo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-pencil'/></a>
                        <a href="/Modelo/Participantes/<%: item.id %>" title='Gestionar participantes' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-person'/></a>
                        <a onclick='eliminarModelo(<%: item.id %>)' title='Eliminar modelo' class='ui-state-default ui-corner-all' style='float:left;'><span class='ui-icon ui-icon-trash'/></a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <%=ViewData["Mensaje"]%>
    </fieldset>
    </div>
    
</asp:Content>