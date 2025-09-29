<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#GrupoTipoEndosoEditar").validate();
        });
        $("#grupoEndoso_idEdit option").each(function () {
            $(this).attr({ 'title': $.trim($(this).html()) });
        });
        $("#tipoEndoso_idEdit option").each(function () {
            $(this).attr({ 'title': $.trim($(this).html()) });
        });
    </script>

    <script type="text/javascript">
        function GrupotipoEndosoSave() {
            if ($("#GrupoTipoEndosoEditar").valid()) {
                $("#editar").attr('disabled', true);
                $("#GrupoTipoEndosoEditar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>

     <%--VALIDATOR--%>
    <script type="text/javascript">
        $.validator.setDefaults({
        });
        $().ready(function () {
            $("#GrupoTipoEndosoEditar").validate();
        });
    </script>

    <% using (Html.BeginForm("Editar", "GrupoTipoEndoso", FormMethod.Post, new { id = "GrupoTipoEndosoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ExcepcionesporGrupoTipoEndosoViewModel exgrupoEndoso = (ColpatriaSAI.UI.MVC.Models.ExcepcionesporGrupoTipoEndosoViewModel)ViewData["GTEViewModel"]; %>
        <fieldset style="border:1px solid gray">
        <table id="contenidoEditar" class="tablesorter" width="100%" border="0" cellspacing="0" cellpadding="2">
        <tr>
            <td><%: Html.Label("Grupo de endoso")%></td>
            <td><%: Html.DropDownList("grupoEndoso_idEdit", (SelectList)exgrupoEndoso.GrupoEndosoList, "Seleccione", new { @class = "required", style = "width:200px;" })%></td>
        </tr>
        <tr>
            <td><%: Html.Label("Tipo de endoso")%></td>
            <td><%: Html.DropDownList("tipoEndoso_idEdit", (SelectList)exgrupoEndoso.TipoEndosoList, "Seleccione", new { @class = "required", style = "width:200px;" })%></td>
        </tr>
        <tr>
            <td><%: Html.Label("Estado destino")%></td>
                <% string estadoReal = ViewBag.estadoReal; %>
                <% if (estadoReal == "V") // Estado Vigente (V), Estado No Vigente (NV)
                   { %>
            <td><%: Html.DropDownList("estadoReal_Editar", new SelectList(new List<string>() { "V", "NV" }))%></td>
                  <% } %> 
                <% else
                   { %>
            <td><%: Html.DropDownList("estadoReal_Editar", new SelectList(new List<string>() { "NV", "V" }))%></td>
                  <% } %>                
        </tr>
        </table>
        </fieldset>
        <p align ="center"><input type="submit" value="Actualizar" id = "editar" onclick="GrupotipoEndosoSave()" /></p>
    <% } %>