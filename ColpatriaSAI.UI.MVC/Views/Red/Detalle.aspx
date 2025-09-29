<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Red>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Redes - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $().ready(function () {
        $("#formRedEditar").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function redDetalleSave() {

        var stUrl = '/Red/guardarRedDetalle';
        mostrarCargando("Enviando información. Espere Por Favor...");
        $("#btnCrear").attr('disabled', true);
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: $("#formRedDetalleEditar").serialize(),
            success: function (response) {
                if (response.Success) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    setTimeout(function () {
                        window.location.href = "/Red/Detalle/?idRed=" + $("#redId").val();
                    }, 2000);
                    selectAll(false);
                }
            }
        });
    }

</script>

<div id="encabezadoSeccion">
	<div id="infoSeccion">
		<h2>Agrupar Redes</h2>
        <h4></h4>
		<div>
			En este módulo se puede agrupar Redes.
		</div>
		<br /><%: Html.ActionLink("Regresar", "Index") %>
	</div>
	<div id="progresoSeccion">		      
	</div>
	<div style="clear:both;"><hr /></div>
</div>


<% using (Html.BeginForm("Editar", "RedDetalle", FormMethod.Post, new { id = "formRedDetalleEditar" })) { %>
    
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="redId" name="redId" value='<%= this.Model.id %>' />
        <table>
            <tr><td>Red: </td>
                <td>
                    <%: this.Model.nombre%>

                </td>
            </tr>
            <tr>
                <td valign="top">Redes a agrupar:</td>
                <td>       
                    Seleccionar Todos: <input type="checkbox" name="seleccionar" onclick="selectAll(this.checked);" />
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <%
                        int cols = 1;
                        List<RedDetalle> redDetalleList = (List<RedDetalle>)ViewData["redDetalleList"];
                        string bgcolor = "#CECECE";
                        foreach (RedDetalle redDetalle in redDetalleList)
                        {
                            if (cols==1){
                                %>
                                  <tr bgcolor="<%=bgcolor%>">  
                                <%        
                                bgcolor = (bgcolor == "#CECECE") ? "" : "#CECECE";    
                            }

                            string strChecked = (redDetalle.red_id == this.Model.id) ? "checked" : "";
                            
                            %>
                                <td>
                                <input type="checkbox" name="redes[]" value="<%=redDetalle.id%>" <%=strChecked %>/>
                                <%
                                    string nombreRed = "Sin nombre - " + redDetalle.Compania.nombre + " - " + redDetalle.codigoCore;
                                    if (!string.IsNullOrEmpty(redDetalle.nombre))
                                        nombreRed = redDetalle.nombre + " - " + redDetalle.Compania.nombre + " - " + redDetalle.codigoCore;                                
                                %>

                                <%=nombreRed%>

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
                </td>
            </tr>
        </table>
        <p>
        <input type="button" value="Guardar" onclick="redDetalleSave();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>
      
    </fieldset>
<% } %>

</asp:Content>