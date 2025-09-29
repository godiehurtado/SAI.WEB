<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#formConcursoEditar").validate({
        });        
    });
    </script>

    <script  type="text/javascript">
     $(function () {
         var dates = $("#FechaInicioEdit, #FechaFinEdit").datepicker({
             defaultDate: "+1w",
             changeMonth: true,
             numberOfMonths: 3,
             dateFormat: "dd/mm/yy",
             showButtonPanel: true,
             changeMonth: true,
             changeYear: true,
             onSelect: function (selectedDate) {
                 var option = this.id == "FechaInicioEdit" ? "minDate" : "maxDate",
					instance = $(this).data("datepicker"),
					date = $.datepicker.parseDate(
						instance.settings.dateFormat ||
						$.datepicker._defaults.dateFormat,
						selectedDate, instance.settings);
                 dates.not(this).datepicker("option", option, date);
             }
         });
     });
	</script>

    <script type="text/javascript">
        var era;
        function uncheckRadio(rbutton) {
            if (rbutton.checked == true && era == true) { rbutton.checked = false; }
            era = rbutton.checked;
        }
    </script>

    <h2>Segmento: <%: ViewBag.segmentoUsuario %></h2><br />


    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Editar", "Concursos", FormMethod.Post, new { id = "formConcursoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ConcursoViewModel concurso =
                (ColpatriaSAI.UI.MVC.Models.ConcursoViewModel)ViewData["ConcursoViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>
                    <td><u><%: Html.Label("Nombre")%></u></td>
                    <td><%: Html.TextBoxFor(Model => concurso.ConcursoView.nombre, new { @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.nombre)%></td>                   
                </tr>     
                <tr>
                    <td><u><%: Html.Label("Fecha Inicial")%></u></td>
                    <td><%: Html.TextBox("FechaInicioEdit", String.Format("{0:d}",concurso.ConcursoView.fecha_inicio), new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.fecha_inicio)%></td>              
                </tr> 
                <tr>                
                    <td><u><%: Html.Label("Fecha Final")%></u></td>
                    <td><%: Html.TextBox("FechaFinEdit", String.Format("{0:d}",concurso.ConcursoView.fecha_fin), new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.fecha_fin)%></td>              
                </tr>                             
                <tr>                
                    <td><%: Html.Label("Descripción")%></td>
                    <td><%: Html.TextAreaFor(Model => concurso.ConcursoView.descripcion, new {@style = "height:200px;width:250px;border:#000000 1px solid;" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.descripcion)%></td>              
                </tr>
                <tr><td><% bool principal = (bool)concurso.ConcursoView.principal; %></td>
                    <td align = "center"><%: Html.RadioButton("principal_Edit", true, principal ? true : false, new { title = "Principal?", onclick = "uncheckRadio(this)" })%><label>Principal?</label></td>
                </tr>
                <tr>                
                    <td><input type="hidden" id="tipoConcurso_id_Edit" name="tipoConcurso_id_Edit" value="<%: TempData["tipoConcurso_id_Edit"] %>" /></td>
                    <td><input type="hidden" id="segmento_id_Edit" name="segmento_id_Edit" value="<%: TempData["segmento_id_Edit"] %>" /></td>
                </tr>
            </table>
      
        <p><input type="submit" value="Actualizar" /></p>
    <% } %>