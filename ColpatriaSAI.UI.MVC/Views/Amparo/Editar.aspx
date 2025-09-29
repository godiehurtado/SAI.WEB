<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Amparo>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Editar
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" language="javascript">
 
    $(document).ready(function () {

        $("#formeditaramparo").validate({
            errorClass: "invalid",
            errorPlacement: function (error, element) {
                return true;
            }
        });
    });


    function amparoUpdate() {

        if ($("#formeditaramparo").valid()) {
            var stUrl = '/Amparo/Actualizar';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnCrear").attr('disabled', true);
            var dataForm = $("#formeditaramparo").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = "/Amparo";
                    }
                }
            });
        }
    }

</script>

<div id="encabezadoSeccion">
	<div id="infoSeccion">
		<h2>Editar Amparos</h2>
        <h4></h4>
		<div>
			En este módulo podrá administrar Amparos.
		</div>
		<br /><%: Html.ActionLink("Regresar", "Index") %>
	</div>
	<div id="progresoSeccion">		      
	</div>
	<div style="clear:both;"><hr /></div>
</div>

<% using (Html.BeginForm("Editar", "Amparo", FormMethod.Post, new {id = "formeditaramparo" }))
   { %>
    <%: Html.ValidationSummary(true)%>
    <fieldset>
    <input type="hidden" id="amparoId" name="amparoId" value='<%= this.Model.id %>' />
        <table>
            <tr>
                <td>
                    Nombre:
                </td>
                
                <td>
                  <%: Html.TextBox("nombre",this.Model.nombre,new { @class="required", @size="50"}) %>
                </td>
            </tr>
        </table>     
        

        <p>
            <input  type="button" value="Guardar" onclick="amparoUpdate();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>
        </p>
    </fieldset>
<% } %>



</asp:Content>
