<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Amparo>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Detalle
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
    $().ready(function () { 
        $("#formAmparoEditar").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });

    function AmparoDetalleSave() {

        var stUrl = '/Amparo/SaveAmparoDetalle';
        mostrarCargando("Enviando información. Espere Por Favor...");
        $("#btnCrear").attr('disabled', true);
        $.ajax({
            type: 'POST',
            url: stUrl,
            data: $("#formAmparoEditar").serialize(),
            success: function (response) {
                if (response.Success) {
                    closeNotify('jNotify');
                    mostrarExito("El proceso se realizó con éxito.");
                    setTimeout(function () {
                        window.location.href = "/Amparo/Detalle/?idAmparo=" + $("#amparoId").val();
                    }, 2000);
                    selectAll(false);
                }
            }
        });
    }

</script>

<div id="encabezadoSeccion">
	<div id="infoSeccion">
		<h2>Agrupar Amparos</h2>
        <h4></h4>
		<div>
			En este módulo se puede agrupar Amparos.
		</div>  
		<br /><%: Html.ActionLink("Regresar", "Index") %>
	</div>
	<div id="progresoSeccion">		      
	</div>
	<div style="clear:both;"><hr /></div>
</div>


<% using (Html.BeginForm("Editar", "AmparoDetalle", FormMethod.Post, new { id = "formAmparoEditar" }))
   { %>
    
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="amparoId" name="amparoId" value='<%= this.Model.id %>' />
        <table>
            <tr><td>Amparo: </td>
                <td>
                    <%: this.Model.nombre%>

                </td>
            </tr>
            <tr>
                <td valign="top">Amparos a agrupar:</td>
                <td>       
                    Seleccionar Todos: <input type="checkbox" name="seleccionar" onclick="selectAll(this.checked);" />
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <%
                        int cols = 1;
                        List<AmparoDetalle> ListDetalleAmparo = (List<AmparoDetalle>)ViewData["amparoDetalleList"];
                        string bgcolor = "#CECECE";
                        foreach (AmparoDetalle amparoDetalle in ListDetalleAmparo)
                        {
                            if (cols==1){
                                %>
                                  <tr bgcolor="<%=bgcolor%>">  
                                <%        
                                bgcolor = (bgcolor == "#CECECE") ? "" : "#CECECE";    
                            }

                            string strChecked = (amparoDetalle.amparo_id == this.Model.id) ? "checked" : "";
                            
                            %>
                                <td>
                                <input type="checkbox" name="amparos[]" value="<%=amparoDetalle.id%>" <%=strChecked %>/>
                                <%
                                    string nombreAmparo = "Sin nombre - " + amparoDetalle.nombre + " - " + amparoDetalle.codigoCore;
                                    if (!string.IsNullOrEmpty(amparoDetalle.nombre))
                                        nombreAmparo = amparoDetalle.nombre + " - " + amparoDetalle.codigoCore;                                
                                %>

                                <%=nombreAmparo%>

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
        <input type="button" value="Guardar" onclick="AmparoDetalleSave();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>
      
    </fieldset>
<% } %>

</asp:Content>
