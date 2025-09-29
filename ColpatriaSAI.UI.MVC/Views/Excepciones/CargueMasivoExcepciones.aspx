<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    CargueMasivoExcepciones
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function subirArchivo() {
            if (validar()) {
                if (confirm('¿Esta seguro de cargar la información?')) {
                    mostrarCargando(Procesando);
                    $("#form1").attr("action", $("#form1").attr("action") + '?anio=' + $('#anio').val() + '&segmento_id=' + $('#segmento_id').val());
                    $("#form1").submit();
                }
            }
        }

        function validar() {
            if (($('#fechaIni').val() == '') || ($('#fechaFin').val() == '') || ($('#file1').val() == '')) {
                var mensaje = "Por favor, suministre toda la información para el cargue.";
                mostrarError(mensaje);
                return false;
            }
            return true;
        }

    </script>
    <div id="encabezadoSeccion">
        <div id="infoSeccion">
            <h2>
                Cargue de Masivo Excepciones.</h2>
            <p>
                Seleccione un archivo con el formato requerido para procesar su informacion.<br />
            </p>
        </div>
        <div id="progresoSeccion">
            <br />
        </div>
        <div style="clear: both;">
            <hr />
        </div>
    </div>
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <form action="/Excepciones/Carge/" method="post" enctype="multipart/form-data" id="form1">
    <fieldset id="fieldCarge" style="vertical-align: top">
        <legend>
            <h3>
                Ejecutar cargue masivo Excepciones</h3>
        </legend>
        <table>
        <tr>
        <td>
            (Descargue el formato de carga <a href='<%=ViewData["partArchivoFormato"]%>'>aquí</a>)
        </td>
        </tr>
            <tr>
                <td>
                    <input type="file" name="file" id="file1" style="width: 300px; font-size: 8pt" />
                </td>
            </tr>
            <tr>
                <td rowspan="2" align="right">
                    <input type="button" onclick="subirArchivo()" style="font-size: 9pt" value="Cargar Excepciones" />
                </td>
            </tr>
        </table>
    </fieldset>
    </form>
</asp:Content>
