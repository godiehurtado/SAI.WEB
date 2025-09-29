<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %><%--ColpatriaSAI.Negocio.Entidades.Moneda--%>

<script type="text/javascript">
    $().ready(function () {
        $("#ParticipanteConcursoEditar").validate();
    });
</script>

 <script type="text/javascript">
     $(function () {
         var segmentos = $("#segmento_id_editar");
         var canales = $("#canal_id_editar");
         segmentos.change(function () {
             canales.find('option').remove();
             $.getJSON('/ParticipanteConcurso/getCanales', { segmento_id: segmentos.val() }, function (data) {
                 $("<option value='0' selected>Todos</option>").appendTo(canales);
                 $(data).each(function () {
                     $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(canales);
                 });
             });
         });
     });
    </script>

             <script type="text/javascript">
                 $(function () {
                     var zonas = $("#zona_id_editar");
                     var localidades = $("#localidad_id_editar");
                     zonas.change(function () {
                         localidades.find('option').remove();
                         $.getJSON('/ParticipanteConcurso/getLocalidades', { zona_id: zonas.val() }, function (data) {
                             $("<option value='0' selected>Todos</option>").appendTo(localidades);
                             $(data).each(function () {
                                 $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidades);
                             });
                         });
                     });
                 });
              </script>

    <% using (Html.BeginForm("Editar", "ParticipanteConcurso", FormMethod.Post, new { id = "ParticipanteConcursoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ParticipanteConcursoViewModel participanteconcurso = (ColpatriaSAI.UI.MVC.Models.ParticipanteConcursoViewModel)ViewData["ParticipanteConcursoViewModel"]; %>
        <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        <tr>                
        <tr>                          
        <td><u><%: Html.Label("Compañia")%></td></u>
        <td><%: Html.DropDownList("compania_id", (SelectList)participanteconcurso.CompaniaList, "Seleccione un Valor", new { @class = "required", style = "width:150px;" })%></td>
        </tr>  
        <td><u>
            <%: Html.Label("Segmento") %></u>
        </td>
        <td>
            <%: Html.DropDownList("segmento_id", (SelectList)participanteconcurso.SegmentoList, "Seleccione un Valor", new { @class = "required", style = "width:150px;", id = "segmento_id_editar" })%>
        </td>              
        </tr>      
        <tr>                
        <td> 
            <%: Html.Label("Canal") %>
        </td>
        <td>
            <%: Html.DropDownList("canal_id", (SelectList)participanteconcurso.CanalList, "Todas", new { style = "width:150px;", id = "canal_id_editar" })%>
        </td>              
        </tr>      
        <tr>                
        <td>
            <%: Html.Label("Nivel") %>
        </td>
        <td>
            <%: Html.DropDownList("nivel_id", (SelectList)participanteconcurso.NivelList, "Todas", new { style = "width:150px;" })%>
        </td>              
        </tr>      
        <tr>                
        <td>
            <%: Html.Label("Zona") %>
        </td>
        <td>
            <%: Html.DropDownList("zona_id", (SelectList)participanteconcurso.ZonaList, "Todas", new { style = "width:150px;", id = "zona_id_editar" })%>
        </td>              
        </tr>      
        <tr>                
        <td>
            <%: Html.Label("Localidad") %>
        </td>
        <td>
            <%: Html.DropDownList("localidad_id", (SelectList)participanteconcurso.LocalidadList, "Todas", new { style = "width:150px;", id = "localidad_id_editar" })%>
        </td>              
        </tr>      
        <tr>                
        <td>
            <%: Html.Label("Participante") %>
        </td>
        <td>
            <%--<%: Html.DropDownList("participante_id", (SelectList)participanteconcurso.ParticipanteList, "Todas", new { style = "width:150px;" })%>--%>
        </td>              
        </tr>      
        <tr>                
        <td>
            <%: Html.Label("Categoria") %>
        </td>
        <td>
            <%: Html.DropDownList("categoria_id", (SelectList)participanteconcurso.CategoriaList, "Todas", new { style = "width:150px;" })%>
        </td>              
        </tr>      
        <tr>                
        <td>
        </table>
        <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>