<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Red>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Bancos - Sistema de Administración de Incentivos
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

    function redSave() {

        if ($("#formRedEditar").valid()) {
            var stUrl = '/Red/SaveRed';
            mostrarCargando("Enviando información. Espere Por Favor...");
            $("#btnCrear").attr('disabled', true);
            var dataForm = $("#formRedEditar").serialize();
            $.ajax({
                type: 'POST',
                url: stUrl,
                data: dataForm,
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                        window.location.href = "/Red";
                    }
                }
            });
        }
    }

</script>

<div id="encabezadoSeccion">
	<div id="infoSeccion">
		<h2>Crear / Editar Redes</h2>
        <h4></h4>
		<div>
			En este módulo podrá administrar Redes.
		</div>
		<br /><%: Html.ActionLink("Regresar", "Index") %>
	</div>
	<div id="progresoSeccion">		      
	</div>
	<div style="clear:both;"><hr /></div>
</div>


<% using (Html.BeginForm("Editar", "Red", FormMethod.Post, new { id = "formRedEditar" }))
   { %>
    
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="redId" name="redId" value='<%= this.Model.id %>' />
        <table>
            <tr><td>Nombre: </td>
                <td>
                    <%: Html.TextBox("nombre", this.Model.nombre, new { @class = "required", @size = "50" })%>
                </td>
            </tr>
        </table>
        <p>
        <input type="button" value="Guardar" onclick="redSave();" id="btnCrear" name="btnCrear" style="float:left;margin-right:10px;"/>
      
    </fieldset>
<% } %>

</asp:Content>