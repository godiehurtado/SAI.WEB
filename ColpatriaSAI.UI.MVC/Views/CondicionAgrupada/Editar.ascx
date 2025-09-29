<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

    <script type="text/javascript">
        $().ready(function () {
            $("#CondicionAgrupadaEditar").validate();
        });
    </script>

    <script type="text/javascript">
        function seleccionarSubReglaEdit(idSubRegla, nombreS) {
            $("#subregla_id_Edit").val(idSubRegla);
            $("#subregla_Edit").html(nombreS + "&nbsp;&nbsp;&nbsp;");
            $('#SubReglaNombreEdit').hide("slow");
            $("#dialogSubregla_Edit").dialog('destroy'); $("#dialogSubregla_Edit").dialog("close");
        }

        function seleccionarSubReglaEdit1(idSubRegla, nombreS) {
            $("#subregla_id_Edit1").val(idSubRegla);
            $("#subregla_Edit1").html(nombreS + "&nbsp;&nbsp;&nbsp;");
            $('#SubReglaNombreEdit1').hide("slow");
            $("#dialogSubregla_Edit1").dialog('destroy'); $("#dialogSubregla_Edit1").dialog("close");
        }   
    </script>

    <script type="text/javascript">
        function cAgrupadaSave() {
            if ($("#CondicionAgrupadaEditar").valid()) {
                $("#editar").attr('disabled', true);
                $("#CondicionAgrupadaEditar").submit();
                mostrarCargando("Enviando informacion. Espere Por Favor...");
            }
        }
    </script>

    <%  string ruta = Request.Url.ToString().Split('?')[0].ToString(); if (!ruta.EndsWith("/")) { ruta = ruta + "/"; } %>
	<% Random random = new Random(); int num = random.Next(1, 10000);  %>

    <% if (TempData["Mensaje"] != null)
       { %>
        <div id="Mensaje" style="display:none;"><%: TempData["Mensaje"] %></div>
       
    <% } %>

    <% using (Html.BeginForm("Editar", "CondicionAgrupada", FormMethod.Post, new { id = "CondicionAgrupadaEditar" }))
       {
        Html.ValidationSummary(true); %>
        <% ColpatriaSAI.UI.MVC.Models.CondicionAgrupadaViewModel condicionagrupada = (ColpatriaSAI.UI.MVC.Models.CondicionAgrupadaViewModel)ViewData["CondicionAgrupadaViewModel"]; %>
        <fieldset style="border:1px solid gray">
        <table id = "Table1" class = "tablesorter" width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left:50px">
        <tr>                
            <td><a href="javascript:mostrarDialogSubRegla_Edit('/CondicionAgrupada/SubReglaEdit?r=<%: num %>&regla_id_Edit=<%: ViewData["valuer"] %>', 'Editar SubRegla A / Condición Agrupada', 'dialogSubregla_Edit');" style='float:none;' title='Buscar SubRegla'>Buscar SubRegla A</a></td>
            <td><b><span id = "subregla_Edit" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;</span></b>
                <%: Html.Hidden("subregla_id_Edit", 0, new { id = "subregla_id_Edit" })%><span id = "SubReglaNombreEdit" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;<%: TempData["SubReglaNombre"]%></span>
            </td>
                        
        </tr>
        <tr>
            <td><%: Html.Label("Operador") %></td>
            <td><%: Html.DropDownList("operador_id", (SelectList)condicionagrupada.OperadorList, "Seleccione un Valor", new { @class = "required", style = "width:150px;" })%></td>              
        </tr>
        <tr>
            <td><a href="javascript:mostrarDialogSubRegla_Edit('/CondicionAgrupada/SubReglaEdit1?r=<%: num %>&regla_id_Edit=<%: ViewData["valuer"] %>', 'Editar SubRegla B / Condición Agrupada', 'dialogSubregla_Edit1');" style='float:none;' title='Buscar SubRegla'>Buscar SubRegla B</a></td>
            <td><b><span id = "subregla_Edit1" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;</span></b>
            <%: Html.Hidden("subregla_id_Edit1", 0, new { id = "subregla_id_Edit1" })%><span id = "SubReglaNombreEdit1" style="text-transform: uppercase;" >&nbsp;&nbsp;&nbsp;<%: TempData["SubRegla1Nombre"]%>
            </td>
        </tr>
        </table>        
        
        <table>
        <tr>
            <td><u><%: Html.Label("Nombre")%></u></td>
            <td><%: Html.TextBoxFor (Model => condicionagrupada.CondicionAgrupadaView.nombre , new { style = "width:680px;", @class = "required", id = "nombreEdit" })%>
                <%: Html.ValidationMessageFor(Model => condicionagrupada.CondicionAgrupadaView.nombre)%></td>              
        </tr>
        </table>
        </fieldset>
        <input type="hidden" id="regla_id_Edit" name="regla_id_Edit" value="<%: ViewData["valuer"] %>" />
        <p align = "center"><input type="button" value="Actualizar" id="editar" onclick="cAgrupadaSave()" /></p>
    <% } %>

         <div id='dialogSubregla_Edit' style="display: none;"></div>
         <div id='dialogSubregla_Edit1' style="display: none;"></div>