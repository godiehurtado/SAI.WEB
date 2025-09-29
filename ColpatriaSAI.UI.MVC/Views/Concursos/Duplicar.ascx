<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

        <script  type="text/javascript">
        $(function () {
            var dates = $("#FechaInicioDup, #FechaFinDup").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                onSelect: function (selectedDate) {
                    var option = this.id == "FechaInicioDup" ? "minDate" : "maxDate",
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

        <h2>Segmento: <%: ViewBag.segmentoUsuario %></h2><br />

    <% Html.EnableClientValidation(); %>
    <% using (Html.BeginForm("Duplicar", "Concursos", FormMethod.Post, new { id = "formConcursoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ConcursoViewModel concurso =
                (ColpatriaSAI.UI.MVC.Models.ConcursoViewModel)ViewData["ConcursoViewModel"]; %>
          <table id = "contenidoEditar" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
                <tr>
                   <td><%: Html.Label("Nombre")%></td>
                   <td><%: Html.Label("NombreConcurso:", Convert.ToString(TempData["nombreConcurso"]))%></td>                   
                </tr>     
                <tr>
                    <td><%: Html.Label("Fecha Inicial")%></td>
                    <td><%: Html.TextBox("FechaInicioDup", String.Format("{0:d}",concurso.ConcursoView.fecha_inicio), new { @readonly = "true" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.fecha_inicio)%></td>              
                </tr> 
                <tr>                
                    <td><%: Html.Label("Fecha Final")%></td>
                    <td><%: Html.TextBox("FechaFinDup", String.Format("{0:d}",concurso.ConcursoView.fecha_fin), new { @readonly = "true" })%>
                        <%: Html.ValidationMessageFor(Model => concurso.ConcursoView.fecha_fin)%></td>              
                </tr> 
                <tr>                
                    <td><%: Html.Label("Tipo de Concurso")%></td>
                    <td><%: Html.Label("tipoConcurso:", Convert.ToString(TempData["tipoConcurso"]))%></td>                   
                </tr>                        
                <tr>                    
                    <td><input type="hidden" id="segmento_idDup" name="segmento_idDup" value="<%: TempData["segmento_idDup"] %>" /></td>
                    <td><input type="hidden" id="descripcion" name="descripcion" value="<%: TempData["descripcion"] %>" /></td>
                </tr>
                </table>

            <h4 align = "center">¿Esta seguro de duplicar este Registro?</h4>
      
        <p align = "center"><input type="Submit" value="Duplicar" /></p>
    <% } %>