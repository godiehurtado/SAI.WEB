<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Ejecuciones Manuales
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        $(function () {
            $("#formCargue").validate({
                onsubmit: false,
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });
        });

        function enviarCargue() {
            mostrarCargando("Cargando Metas Manuales. Espere Por Favor...");
            if ($("#formCargue").valid()) {
                $("#formCargue").submit();
            }
        }

    </script>

    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>Cargar Ejecución Manuales</h2>
            <p>En esta página puede cargar la ejeucion del presupuesto de metas manuales generada a un participante.</p>
            <p>
            <%: Html.ActionLink("Regresar", "Detalle/" + ViewData["idPresupuesto"], "Presupuesto")%>            
            </p>
        </div>
        <div id="progreso">
           
        </div>
       <div style="clear:both;"><hr /></div>
    </div>
    <% if (TempData["Mensaje"] != null) { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>
    <form action="/Ejecucion/ProcesarCargueManualEjecucionDetalle/" method="post" enctype="multipart/form-data" id="formCargue">
    <input type="hidden" name="idPresupuesto" value="<%=ViewData["idPresupuesto"]%>"/>
    <fieldset id="fieldCarge" style="vertical-align:top"><legend><h3>Ejecutar cargue de ejecuciones</h3></legend>
        (Descargue el formato de carga <a href='<%=ViewData["partArchivoFormato"]%>'>aquí</a>)
        <table>
            <tr>
                <td>
                    <input type="file" name="file" id="file1" size="50" class="required" />
                </td>
            </tr>
            <tr>
                <td align="left"><input type="button" onclick="enviarCargue()" value="Cargar Ejecuciones" /></td>
            </tr>
        </table>
    </fieldset>
    </form>
</asp:Content>