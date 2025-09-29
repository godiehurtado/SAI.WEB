<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Base monedas
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Base monedas</h2>

    <script type="text/javascript">
        function mostrarDialog(pagina, titulo, dialog) {
            $("#" + dialog).dialog({
                height: 230, width: 350, modal: true, title: titulo,
                open: function (event, ui) { $(this).load(pagina); },
                close: function (event, ui) { $(this).dialog('destroy'); $(this).dialog("close"); }
            });
        } 
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({
                "bJQueryUI": true,
                "sPaginationType": "full_numbers",
                "bStateSave": true
            });
        });
        $().ready(function () {
            $("#BaseMonedaCrear").validate({
                rules: {
                    fecha_inicioVigencia: "required",
                    fecha_finVigencia: "required",
                    moneda_id: "required"
                },
                submitHandler: function (form) {
                    $("#crear").attr('disabled', true);
                    form.submit();
                }

            }); //
//            $("#crear").click(function () {
//                mostrarCargando(Procesando);
//            });
//            //Colocar este código cuando se utilice Ajax
            /*$("#jOverlay").css('visibility', 'hidden');
            $("#jNotify").css('visibility', 'hidden');
            $("#jSuccess").css('visibility', 'hidden');
            $("#jError").css('visibility', 'hidden');*/
        });

    </script>

        <script type="text/javascript">
        function monedaSave() {
        if ($("#BaseMonedaCrear").valid()) {
            $("#crear").attr('disabled', true);
            mostrarCargando("Enviando informacion. Espere Por Favor...");
            $("#BaseMonedaCrear").submit();
            }
        }
        </script>

      <script  type="text/javascript">
          $(function () {
              var dates = $("#fecha_inicioVigencia, #fecha_finVigencia").datepicker({
                  defaultDate: "+1w",
                  changeMonth: true,
                  numberOfMonths: 3,
                  dateFormat: "dd/mm/yy",
                  showButtonPanel: true,
                  changeMonth: true,
                  changeYear: true,
                  onSelect: function (selectedDate) {
                      var option = this.id == "fecha_inicioVigencia" ? "minDate" : "maxDate",
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
                      $.getJSON('/BaseMoneda/ObtenerSegmentoxUsuario', {}, function (data) {
                          //                          $("<option value='0' selected>Seleccione un Valor</option>").appendTo(moneda);
                          $(data).each(function () {
                              $("<option value=" + this.Key + ">" + this.Value + "</option>").appendTo(moneda);
                          });

                      });
                  });
    </script>
    
    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
    <% } %>

    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <h4>Definir base moneda</h4> <%--TODO: FECHAS--%>
                <% Html.EnableClientValidation(); %>
                <% using (Html.BeginForm("Crear", "BaseMoneda", FormMethod.Post, new { id = "BaseMonedaCrear" }))
                   {
                    Html.ValidationSummary(true); %>
                    <% ColpatriaSAI.UI.MVC.Models.BaseMonedaViewModel baseMoneda = 
                           (ColpatriaSAI.UI.MVC.Models.BaseMonedaViewModel)ViewData["BaseMonedaViewModel"]; %>
                    <table width="100%" cellpadding="2">
                    <tr>
                        <td><%: Html.Label("Fecha inicio vigencia") %>
                        <%: Html.TextBox("fecha_inicioVigencia", null, new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => baseMoneda.BaseMonedaView.fecha_inicioVigencia)%></td>
                    <td>
                        <%: Html.Label("Fecha fin vigencia")%>
                        <%: Html.TextBox("fecha_finVigencia", null, new { @readonly = "true", @class = "required" })%>
                        <%: Html.ValidationMessageFor(Model => baseMoneda.BaseMonedaView.fecha_finVigencia)%></td>
                    </tr>
                    <tr>
                        <td><%: Html.Label("Base")%>
                        <%: Html.TextBox("@base", null, new { @class = "required number" })%>
                        <%: Html.ValidationMessageFor(Model => baseMoneda.BaseMonedaView.@base)%></td>
                  
                        <td><%: Html.Label("Moneda") %>
                        <%: Html.DropDownList("moneda_id", new List<SelectListItem>(), "Seleccione un Valor", new { @class = "required", id = "moneda_id" })%>
                    </td>
                    </tr>
                    </table>
                    <p><input type="button" value="Crear" id="crear" onclick="monedaSave()" /></p>
                <% } %>

            </td>
            <td>

                <table id="tablaLista">
                <thead>
                    <tr>
                        <th align = "center">Opciones</th>                       
                        <th align = "center">Fecha inicial vigencia</th>
                        <th align = "center">Fecha final vigencia</th>
                        <th align = "center">Base</th>
                        <th align = "center">Moneda</th>
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
                <% foreach (var item in ((IEnumerable<BaseMoneda>)ViewData["BaseMonedas"])) { %>
                    <tr>
                        <td align="center">
                            <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar Base Moneda', 'dialogEditar');" style='float:left;' title='Editar Base Moneda'><span class='ui-icon ui-icon-pencil'/></a>
                            <a href="javascript:mostrarDialog('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar Base Moneda', 'dialogEliminar');" style='float:right;' title='Eliminar Base Moneda'><span class='ui-icon ui-icon-trash'/></a>
                        </td>
                        <td align = "center"><%: String.Format("{0:d}", item.fecha_inicioVigencia) %></td>
                        <td align = "center"><%: String.Format("{0:d}", item.fecha_finVigencia) %></td>
                        <td align = "center"><%: item.@base %></td>
                        <td align = "center"><%: item.Moneda.nombre %></td>
                    </tr>
                <% } %>
                </tbody>
                </table>

            </td>
        </tr>
    </table>

    <div id='dialogEditar' style="display:none;"></div>
    <div id='dialogEliminar' style="display:none;"></div>

</asp:Content>
