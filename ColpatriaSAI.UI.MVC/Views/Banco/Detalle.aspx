<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Banco>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Bancos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $().ready(function () {
        $("#formBancoEditar").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function bancoDetalleSave() {

        var stUrl = '/Banco/guardarBancoDetalle';
        mostrarCargando("Enviando información. Espere Por Favor...");
        $("#btnCrear").attr('disabled', true);
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: $("#formBancoDetalleEditar").serialize(),
            success: function (response) {
                if (response.Success) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    setTimeout(function () {
                        window.location.href = "/Banco/Detalle/?idBanco=" + $("#bancoId").val();
                    }, 2000);
                    selectAll(false);
                }
            }
        });
    }

</script>

<div id="encabezadoSeccion">
	<div id="infoSeccion">
		<h2>Agrupar Bancos</h2>
        <h4></h4>
		<div>
			En este módulo se puede agrupar Bancos.
		</div>
		<br /><%: Html.ActionLink("Regresar", "Index") %>
	</div>
	<div id="progresoSeccion">		      
	</div>
	<div style="clear:both;"><hr /></div>
</div>


<% using (Html.BeginForm("Editar", "BancoDetalle", FormMethod.Post, new { id = "formBancoDetalleEditar" })) { %>
    
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="bancoId" name="bancoId" value='<%= this.Model.id %>' />
        <table>
            <tr><td>Banco: </td>
                <td>
                    <%: this.Model.nombre%>

                </td>
            </tr>
            <tr>
                <td valign="top">Bancos a agrupar:</td>
                <td>       
                    Seleccionar Todos: <input type="checkbox" name="seleccionar" onclick="selectAll(this.checked);" />
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <%
                        int cols = 1;
                        List<BancoDetalle> bancoDetalleList = (List<BancoDetalle>)ViewData["bancoDetalleList"];
                        string bgcolor = "#CECECE";
                        foreach (BancoDetalle bancoDetalle in bancoDetalleList)
                        {
                            if (cols==1){
                                %>
                                  <tr bgcolor="<%=bgcolor%>">  
                                <%        
                                bgcolor = (bgcolor == "#CECECE") ? "" : "#CECECE";    
                            }

                            string strChecked = (bancoDetalle.banco_id == this.Model.id) ? "checked" : "";
                            
                            %>
                                <td>
                                <input type="checkbox" name="bancos[]" value="<%=bancoDetalle.id%>" <%=strChecked %>/>
                                <%
                                    string nombreBanco = "Sin nombre - " + bancoDetalle.Compania.nombre + " - " + bancoDetalle.codigoCore;
                                    if (!string.IsNullOrEmpty(bancoDetalle.nombre))
                                        nombreBanco = bancoDetalle.nombre + " - " + bancoDetalle.Compania.nombre + " - " + bancoDetalle.codigoCore;                                
                                %>

                                <%=nombreBanco%>

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
        <input type="button" value="Guardar" onclick="bancoDetalleSave();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>
      
    </fieldset>
<% } %>

</asp:Content>