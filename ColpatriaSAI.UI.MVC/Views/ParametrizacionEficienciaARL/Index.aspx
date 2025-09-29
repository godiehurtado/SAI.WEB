<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Parametrización Eficiencia ARL
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h3>
        Parametrización Eficiencia ARL</h3>
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
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
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
    <script type="text/javascript" language="javascript">

        $(document).ready(function () {

            $("#formParametrizacionEficienciaARL").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });
        });

        function parametrizacionSave() {
            if ($("#formParametrizacionEficienciaARL").valid()) {
                var stUrl = '/ParametrizacionEficienciaARL/Crear';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#crear").attr('disabled', true);
                var dataForm = $("#formParametrizacionEficienciaARL").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = "/ParametrizacionEficienciaARL";
                        }
                    }
                });
            }
        }

        function parametrizacionUpdate() {
            if ($("#formParametrizacionEficienciaARL").valid()) {
                var stUrl = '/ParametrizacionEficienciaARL/Update';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#update").attr('disabled', true);
                var dataForm = $("#formParametrizacionEficienciaARL").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = "/ParametrizacionEficienciaARL";
                        }
                    }
                });
            }
        }

    </script>
    <script type="text/javascript">
        function ValidateNmber(obj, evt) {
            var texto = $("#porcen").val();
            var charCode = (evt.which) ? evt.which : event.keyCode;
            var operatorComman = texto.indexOf(',');
            var operatorpoint = texto.indexOf('.');
            if (charCode == 46) {
                return true;
            }
            if ((charCode == 188 || charCode == 190) && (operatorComman < 0 && operatorpoint < 0)) {
                return true;
            }
            else {
                if (charCode > 31 && (charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105)) {
                    mostrarError("Solo valores numéricos");
                    return false;
                }
                else {
                    return true;
                }
            }
        }
    </script>
   
    <% if (TempData["Mensaje"] != null)
       { %>
    <div id="Mensaje" style="display: none;">
        <%: TempData["Mensaje"] %></div>
    <% } %>
    <table id="tablaAdmin">
        <tr valign="top">
            <td>
                <% using (Html.BeginForm("Crear", "ParametrizacionEficienciaARL", FormMethod.Post, new { id = "formParametrizacionEficienciaARL" }))
                   {
                       Html.ValidationSummary(true); %>
                <% ColpatriaSAI.UI.MVC.Models.ParametrizacionEficienciaARLViewModel parametrizacionEficienciaARL = (ColpatriaSAI.UI.MVC.Models.ParametrizacionEficienciaARLViewModel)ViewData["ParametrizacionEficienciaARLViewModel"]; %>
                <div id = "container">
                    <div id = "tabs">
                        <ul>
                            <li id="stage"> <a id = "first">Etapas</a>
                                <fieldset style="border: 1px solid gray">

                                   <table>
                        <tr>
                            <td>
                                <u>
                                    <%: Html.Label("Nombre Etapa")%></u>
                            </td>
                            <td>
                                <%: Html.TextBox("NombreEtapa" )%>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <u>
                                    <label for="FechaInicio">
                                        Mes Inicio:</label></u>
                            </td>
                            <td>
                                <%= Html.ComboMeses("FechaInicio")%>
                            </td>
                        </tr>
                        <td>
                            <u>
                                <label for="FechaFin">
                                    Mes Fin:</label></u>
                        </td>
                        <td>
                            <%=Html.ComboMeses("FechaFin")%>
                        </td>
                        <tr>
                        </tr>
                        <tr>
                            <td>
                                <u>
                                    <label for="Anio">
                                        Año:</label></u>
                            </td>
                            <td>
                                <%=Html.ComboAnios("Anio") %>
                            </td>
                        </tr>
                    </table>

                                </fieldset>
                            </li>

                            <input type="button" value="Guardar" id="crear" onclick="parametrizacionSave()" /></p>

                            <li id ="percentage"><a id = "sec">Porcentaje Cumplimiento</a>
                                <fieldset style="border: 1px solid gray">

                                    <table>
                                    <tr>
                                        <td>
                                            <u>
                                                <%: Html.Label("Porcentaje") %>                                              
                                            </u>
                                        </td>
                                        <td>
                                        <%: Html.TextBox("porcentaje", null, new { onkeydown = "javascript:return ValidateNmber(this,event);", id = "porcen" })%>
                                    </td>
                                        <td>
                                            <%: Html.Label("Porcentaje Actual: ") %>
                                        </td>
                                        <% var item1 = ((IEnumerable<ParametrosApp>)ViewData["ParametrosApp"]).Where(pa => pa.id == 34).ToList();
                                           for (int i = 0; i < item1.Count; i++)
                                           {
                                               
                                           %>
                                        <td>
                                            <%: Html.Label(item1[0].valor.Replace('.',','))%>
                                        </td>
                                        <%} %>

                                    </tr>
                                </table>
                                    
                                </fieldset>
                            </li>

                            <input type="button" value="Actualizar" id="update" onclick="parametrizacionUpdate()" /></p>

                        </ul>
                    </div>
                </div>
                <p>
                    
                <table align="center">
                    <tr>
                        <td>
                            <a href="../Administracion" id="bInicio">Inicio</a>
                        </td>
                    </tr>
                </table>
                <% } %>
            </td>
        </tr>
    </table>
    <table id="tablaLista">
        <thead>
            <tr>
                <th align="center">
                    Opciones
                </th>
                <th align="center">
                    Año
                </th>
                <th align="center">
                    Etapa
                </th>
                <th align="center">
                    Mes Inicial Etapa
                </th>
                <th align="center">
                    Mes Final Etapa
                </th>
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
            <% foreach (var item in ((IEnumerable<ParametrosEficienciaARL>)ViewData["ParametrizacionEficienciaARL"]))
               { %>
            <tr>
                <td align="center">
                    <a href="javascript:mostrarDialog('<%: ruta %>Editar/<%: item.id %>?r=<%: num %>', 'Editar', 'dialogEditar');"style='float: left;' title='Editar Parametrizacion Eficiencia ARL'><span class='ui-icon ui-icon-pencil' />>Editar</a> 
                    <a href="javascript:mostrarDialog1('<%: ruta %>Eliminar/<%: item.id %>?r=<%: num %>', 'Eliminar', 'dialogEliminar');" style='float: right;' title='Eliminar Parametrizacion Eficiencia ARL'><span class='ui-icon ui-icon-trash' /></a>
                </td>
                <td align="center">
                    <%: item.año %>
                </td>
                <td align="center">
                    <%: item.nombreEtapa %>
                </td>
                <td align="center">
                    <%:  String.Format("{0:MMMM}", Convert.ToDateTime(DateTime.Now.Year + "/" + item.mesInicial)).ToUpper()%>
                </td>
                <td align="center">
                    <%: String.Format("{0:MMMM}", Convert.ToDateTime(DateTime.Now.Year + "/" +item.mesFinal)).ToUpper() %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
    <div id='dialogEditar' style="display: none;">
    </div>
    <div id='dialogEliminar' style="display: none;">
    </div>
</asp:Content>
