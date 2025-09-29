<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Maestro Moneda x Negocio
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h3>Tabla de Monedas</h3>

    <script type="text/javascript">
    function mostrarDialog(pagina, titulo, dialog) {
        $("#" + dialog).dialog({
            height: 200, width: 350, modal: true, title: titulo,
            open: function (event, ui) { $(this).load(pagina); },
            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
        });
    }

    function mostrarDialog1(pagina, titulo, dialog) {
        $("#" + dialog).dialog({
            height: 190, width: 300, modal: true, title: titulo,
            open: function (event, ui) { $(this).load(pagina); },
            close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
        });
    }

    function cerrarDialog(dialog) {
        $("#" + dialog).dialog('destroy'); $("#" + dialog).dialog("close");
    }
    $(document).ready(function () {
        oTable = $('#tablaLista').dataTable({"bJQueryUI": true,"sPaginationType": "full_numbers","bStateSave": true});
        $("#bInicio").button({ icons: { primary: "ui-icon-home"} });
    });
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".defaultText").focus(function (srcc) {
                if ($(this).val() == $(this)[0].title) {
                    $(this).removeClass("defaultTextActive");
                    $(this).val("");
                }
            });

            $(".defaultText").blur(function () {
                if ($(this).val() == "") {
                    $(this).addClass("defaultTextActive");
                    $(this).val($(this)[0].title);
                }
            });

            $(".defaultText").blur();
        });        
       
</script>

<%--DATEPICKER --%>
    <script type="text/javascript">
        $(function () {
            var dates = $("#FechaInicio, #FechaFin").datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                dateFormat: "dd/mm/yy",
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

            <script type="text/javascript">
              $(function () {
                  var moneda = $("#moneda_id");                  
                      $.getJSON('/MaestroMonedaxnegocio/ObtenerSegmentoxUsuario', { }, function (data) {
                          $(data).each(function () {
                              $("<option value=" + this.Key + ">" + this.Value + "</option>").appendTo(moneda);
                          });
                     
                  });
              });
            </script>

            <script type="text/javascript">
                function maestroMonedaSave() {
                    if ($("#formMaestroMonedaConcurso").valid()) {
                        $("#crear").attr('disabled', true);
                        $("#formMaestroMonedaConcurso").submit();
                        mostrarCargando("Enviando informacion. Espere Por Favor...");
                    }
                }
            </script>


      <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table>
    <tr>
        <td>Ver Reporte</td>
        <td align="center"><a href='#' onclick="popupReport('ReporteColquinesxRecaudo');" title='Ver Reporte de Colquines por Recaudo'><span class='ui-icon ui-icon-document-b'></span></a></td>
    </tr>
    </table>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>          
                <% using (Html.BeginForm("Crear", "MaestroMonedaxNegocio", FormMethod.Post, new { id = "formMaestroMonedaConcurso" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.MaestroMonedaxNegocioViewModel maestromonedaxnegocio = (ColpatriaSAI.UI.MVC.Models.MaestroMonedaxNegocioViewModel)ViewData["MaestroMonedaxNegocioViewModel"]; %>
                    
                    <fieldset style="border:1px solid gray">
                    <table>
                    <tr>
                        <td><u><%: Html.Label("Moneda")%></u></td>
                        <td><%: Html.DropDownList("moneda_id", new List<SelectListItem>(), "Seleccione un Valor", new { style = "width:300px;", @class = "required" })%></td>
                    </tr>
                    <tr>
                        <td><u><label for="FechaInicio">Fecha Inicio:</label></u></td>
                        <td><%= Html.TextBox("FechaInicio", null, new { @readonly = "true", @class = "required" })%></td>
                    </tr>
                    <tr>                
                        <td><u><label for="FechaFin">Fecha Fin:</label></u></td>
                        <td><%= Html.TextBox("FechaFin", null, new { @readonly = "true",@class = "required"  })%></td>
                    </tr>                                         
                    </table>
                    </fieldset>

                    <p><input type="button" value="Guardar" id="crear" onclick="maestroMonedaSave()"/></p>
                    
                    
                    <table align = "center">
                    <tr>
                        <td><a href="../Concursos" id="bInicio">Inicio</a></td>                    
                    </tr>
                    </table>

                <% } %>

            </td>
         
        </tr>
    </table>    

    <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Opciones</th>
                        <th align = "center">Moneda</th>
                        <th align = "center">Fecha Inicio Vigencia</th>
                        <th align = "center">Fecha Fin Vigencia</th>           
                        <th align = "center">Acciones</th> 
                    </tr>
                </thead>
                <tbody>
                    <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); 
					 // Corrige error con un Substring que daña opciones de Editar/Eliminar/Duplicar etc..
                    // Se deben eliminar la palabra Index, causa raiz del error. 
					// Adicionalmente se debe agregar el https debido a que esta haciendo el request 
					// de la Url de servidor y no del balanceador CAAM 17.05.2019
                     if (ruta.EndsWith("x")) { ruta = "https"+ ruta.Substring(4, ruta.Length - 10).Trim(); }
					 else { ruta = "https"+ ruta.Substring(4, ruta.Length-4).Trim(); }
					  if (!ruta.EndsWith("/")) { ruta = ruta + "/"; }					 %>
                <% Random random = new Random();
                   int num = random.Next(1, 10000);  %>
                <% foreach (var item in ((IEnumerable<MaestroMonedaxNegocio>)ViewData["MaestroMonedaxNegocios"])) { %>
                    
                    <tr>
                        <td align= "center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');" style='float:left;' title='Editar Maestro de Monedas'><span class='ui-icon ui-icon-pencil'/>>Editar</a>
                            <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float:right;' title='Eliminar Maestro de Monedas'><span class='ui-icon ui-icon-trash'/></a>
                        </td>               
                        <td align = "center"><%: item.Moneda.nombre %></td>
                        <td align = "center"><%: String.Format("{0:d}",  item.fecha_inicial) %></td>
                        <td align = "center"><%: String.Format("{0:d}",  item.fecha_final) %></td>
                         <td align= "center">
                            <%=Html.ActionLink("Detalle", "Index", "MonedaxNegocio", new { value = item.id}, new { })%> |
                            <%=Html.ActionLink("Topes por Moneda", "Index", "TopeMoneda", new { value = item.id}, new { })%> |
                            <%=Html.ActionLink("Topes por Edad", "Index", "TopexEdad", new { value = item.id}, new { })%>
                         </td>
                     
                    </tr>
                <% } %>
                </tbody>
                </table>   
    
    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
