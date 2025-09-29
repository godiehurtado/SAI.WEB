<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.ConcursoViewModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Crear Concurso - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%--DATEPICKER --%>
    <script type="text/javascript">
        $(function () {
            var dates = $("#FechaInicio, #FechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "yy-mm-dd",
                showButtonPanel: true,
                changeMonth: true,
                changeYear: true,
                altField: "#alternate",
			    altFormat: "DD, d MM, yy",
                onSelect: function (selectedDate) {
                    var option = this.id == "FechaInicio" ? "minDate" : "maxDate",
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

    <%--VALIDATOR--%>
    <script type="text/javascript">
    $().ready(function () {
            $("#formConcursos").validate({
                rules: {
                    nombre: "required",
                    tipoConcurso_id: "required"
                }
            });
            $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
        });
        $(function() {$( "#progressbar" ).progressbar({
			value: 11
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
        
    <div id="encabezadoConcurso">
        <div id="infoPasoActual">
            <h2>Datos básicos</h2>            
        </div>        
       <div style="clear:both;"><hr />
       </div>
    </div>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <h2>Segmento: <%: ViewBag.segmentoUsuario %></h2><br />

        <% Html.EnableClientValidation(); %>
        
         <% using (Html.BeginForm("Crear", "Concursos", FormMethod.Post, new { id = "formConcursos"}))
            {%>
        
            <%: Html.ValidationSummary(true) %>
             
            <fieldset style="border:1px solid gray">
            <table width="100%" border="0" cellspacing="0" cellpadding="2">
                <tr>
                    <td><u><%: Html.Label("Nombre") %></u></td>
                    <td><%: Html.TextBox("nombre", null, new { @class = "required", size=70 })%>
                        <%: Html.ValidationMessageFor(model => model.ConcursoView.nombre)%></td>                   
                </tr>     
                <tr>
                    <td><u><label for="FechaInicio">Fecha Inicio:</label></u></td>
                    <td><%= Html.TextBox("FechaInicio", null, new { @readonly = "true", @class = "required" })%></td>
                </tr> 
                <tr>                
                    <td><u><label for="FechaFin">Fecha Fin:</label></u></td>
                    <td><%= Html.TextBox("FechaFin", null, new { @readonly = "true",@class = "required"  })%></td>
                </tr>
                <tr>
                    <td><u><%: Html.Label("Tipo de concurso") %></u></td>
                    <td><%: Html.DropDownList("tipoConcurso_id", (SelectList)Model.TipoConcursoList, "Seleccione un Valor", new { @class = "required" })%></td>    
                </tr>               
                <tr>
                    <td><%: Html.Label("Descripción") %></td>
                    <td><%: Html.TextArea ("descripcion", null, new {rows =15, cols=70 })%>
                        <%: Html.ValidationMessageFor(model => model.ConcursoView.descripcion)%></td>
                </tr>
                <tr>
                    <td><%: Html.Label("Principal?") %></td>
                    <td><%: Html.RadioButton("principal", true, new { title = "Es Principal?", onclick = "uncheckRadio(this)" })%></td>
                </tr>     
                <tr>
                    <td></td>
                    <td><a href="../Concursos" title='Regresar a la Lista' id="bInicio">Inicio</a>
                        <input id = "btnNext" type="submit" value="Guardar y Siguiente"  />
                    </td>
                </tr>
            </table>
            </fieldset>
    <% } %>

</asp:Content>
