<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %><%--ColpatriaSAI.Negocio.Entidades.Moneda--%>

<script type="text/javascript">
    $().ready(function () {
        $("#ProductoConcursoEditar").validate();
    });
</script>

    <script  type="text/javascript">
        $(document).ready(function () {
                $("#compania_id_editar option").each(function () {
				    $(this).attr({ 'title': $.trim($(this).html()) });
				});
				$("#lineaNegocio_id option").each(function () {
				    $(this).attr({ 'title': $.trim($(this).html()) });
				});
			});
	</script>

 <script  type="text/javascript">
     $(function () {
         var dates = $("#FechaInicioEdit, #FechaFinEdit").datepicker({
             defaultDate: "+1w",
             changeMonth: false,
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
         $(function () {
             var companias = $("#compania_id_editar");
             var ramos = $("#ramo_id_editar");
             var productos = $("#producto_id_editar");
             companias.change(function () {
                 ramos.find('option').remove();
                 $("#producto_id_editar").attr("disabled", "disabled");
                 $("<option value='0' selected>Todas</option>").appendTo(productos);
                 $.getJSON('/ProductoConcurso/getRamos', { compania_id: companias.val() }, function (data) {
                     $("<option value='0' selected>Todas</option>").appendTo(ramos);
                     $(data).each(function () {
                         $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(ramos);
                     });
                 });
             });
             ramos.change(function () {
                 productos.find('option').remove();
                 $("#producto_id_editar").removeAttr("disabled");
                 $.getJSON('/ProductoConcurso/getProductos', { ramo_id: ramos.val() }, function (data) {
                     $("<option value='0' selected>Todas</option>").appendTo(productos);
                     $(data).each(function () {
                         $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(productos);
                     });
                 });
             });
         });
     </script>

     <script type="text/javascript">
         function productoConcursoSave() {
             if ($("#ProductoConcursoEditar").valid()) {
                 $("#editar").attr('disabled', true);
                 $("#ProductoConcursoEditar").submit();
                 mostrarCargando("Enviando informacion. Espere Por Favor...");
             }
         }
     </script>   

    <% using (Html.BeginForm("Editar", "ProductoConcurso", FormMethod.Post, new { id = "ProductoConcursoEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.ProductoConcursoViewModel productoconcurso = (ColpatriaSAI.UI.MVC.Models.ProductoConcursoViewModel)ViewData["ProductoConcursoViewModel"]; %>
        <table id = "Table1" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        <tr>                
            <td><u><%: Html.Label("Compañia") %></u></td>
            <td><%: Html.DropDownList("compania_id_editar", (SelectList)productoconcurso.CompaniaList, "Seleccione un Valor", new { @class = "required", style = "width:150px;", id = "compania_id_editar" })%></td>              
        </tr>      
        <tr>                
            <td><%: Html.Label("Ramo") %></td>
            <td><%: Html.DropDownList("ramo_id_editar", (SelectList)productoconcurso.RamoList, "Todas", new { style = "width:150px;", id = "ramo_id_editar" })%></td>
        </tr>      
        <tr>                
            <td><%: Html.Label("Producto") %></td>
            <td><%: Html.DropDownList("producto_id_editar", (SelectList)productoconcurso.ProductoList, "Todas", new { style = "width:150px;", id = "producto_id_editar" })%></td>
        </tr>      
        <tr>                
            <td><%: Html.Label("Linea de Negocio") %></td>
            <td><%: Html.DropDownList("lineaNegocio_id_editar", (SelectList)productoconcurso.LineaNegocioList, "Todas", new { style = "width:150px;", id = "lineaNegocio_id_editar" })%></td>
        </tr>      
         <tr>                
            <td><u><%: Html.Label("Fecha Inicial")%></u></td>
            <td><%: Html.TextBox("FechaInicioEdit", String.Format("{0:d}", productoconcurso.ProductoConcursoView.fecha_inicio), new { @readonly = "true", @class = "required", id = "FechaInicioEdit" })%>
                <%: Html.ValidationMessageFor(Model => productoconcurso.ProductoConcursoView.fecha_inicio)%></td>              
        </tr>      
        <tr>                    
            <td><u><%: Html.Label("Fecha Final") %></u></td>
            <td><%: Html.TextBox("FechaFinEdit", String.Format("{0:d}", productoconcurso.ProductoConcursoView.fecha_fin), new { @readonly = "true", @class = "required", id = "FechaFinEdit" })%>
                <%: Html.ValidationMessageFor(Model => productoconcurso.ProductoConcursoView.fecha_fin)%></td>              
        </tr>
        </table>
        <input type="hidden" id="concurso_id" name="concurso_id" value="<%: ViewData["value"] %>" />
        <p><input type="button" value="Actualizar" id = "editar" onclick="productoConcursoSave()" /></p>
    <% } %>