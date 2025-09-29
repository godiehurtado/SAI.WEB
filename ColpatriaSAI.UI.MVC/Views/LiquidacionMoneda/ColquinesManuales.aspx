<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Colquines Manuales
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

            if ($("#formCargue").valid()) {
                $("#formCargue").submit();
            }
        }

    </script>

    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>Cargar Colquines Manuales</h2>
            <p>En esta página puede cargar los colquines manuales generados a un participante por conceptos diferentes a recaudos y premios</p>
            <p>
            <%: Html.ActionLink("Regresar", "Index", "LiquidacionMoneda")%>
            </p>
        </div>
        <div id="progreso">
           
        </div>
       <div style="clear:both;"><hr /></div>
    </div>

    <form action="/LiquidacionMoneda/ColquinesManualesGuardar/" method="post" enctype="multipart/form-data" id="formCargue">
    <fieldset id="fieldCarge" style="vertical-align:top"><legend><h3>Ejecutar cargue de colquines</h3></legend>
        <table>
            <tr>
                <td>
                    <input type="file" name="file" id="file1" size="50" class="required" />
                </td>
            </tr>
            <tr>
                <td align="left"><input type="button" onclick="enviarCargue()" value="Cargar colquines" /></td>
            </tr>
            <tr>
                <td align="left">
                <hr/>
                <%
                    if (ViewData["Mensaje"] != null && ViewData["Mensaje"] != "")
                    {
                        Response.Write(ViewData["Mensaje"]);
                    } 
                %>
                    
                </td>
            </tr>

        </table>
    </fieldset>
    </form>
    

</asp:Content>
