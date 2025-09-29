<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Models.MetaModel>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Metas - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        $(document).ready(function () {
            oTable = $('#tablaLista').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            oTable = $('#tablaLista1').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            oTable = $('#tablaLista2').dataTable({ "bJQueryUI": true, "sPaginationType": "full_numbers", "bStateSave": true });
            $("#MetaCrear").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });

            $("#MetaCompuestaCrear").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }
            });

            if ($("#metaId").val() == '0')
                $("#acumulada").removeAttr("disabled");
            else
                $("#acumulada").attr("disabled", true);

            if ($("#meta_id").val() != "" || ($("#totalProductos").val() == 0 && $("#totalMetasSimples").val() == 0))
                $("#acumulada").removeAttr("disabled");   

        });

        function metaSave() {

            if ($("#acumulada").is(':checked')) {
                $("#tipoMedida_id").removeAttr("class");
                $("#tipoMeta_id").removeAttr("class");
                $("#meta_id").attr("class", 'required');
            }
            else {
                $("#tipoMedida_id").attr("class", 'required');
                $("#tipoMeta_id").attr("class", 'required');
                $("#meta_id").removeAttr("class");
                $("#meta_id").val('');
            }

            if ($("#MetaCrear").valid()) {
                var stUrl = '/Meta/SaveMeta';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnCrear").attr('disabled', true);
                $("#tipoMetaCalculo").attr('disabled', false);                
                var dataForm = $("#MetaCrear").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            if ($("#metaId").val() == 0)
                                window.location.href = window.location.href + "?metaId=" + response.IdMeta;
                            else
                                window.location.href = window.location.href;
                        }
                    }
                });
            }
        }

        function productoMeta(idProductoMeta, idMeta) {
            $("#productoMeta").dialog({
                width: 500,
                minHeight: 250,
                title: 'Producto Meta',
                position: 'center',
                modal: true
            });

            var stUrl = '/Meta/ProductoMeta';
            $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                    {
                        idProductoMeta:idProductoMeta,
                        idMeta:idMeta
                    },
                success: function (response) {
                    $("#productoMeta").html(response);
                }
            });         
        }

        function metaCompuesta() {

            $("#metaCompuesta").dialog({
                width: 800,
                minHeight: 350,
                title: 'Meta',
                position: 'center',
                modal: true
            });

            $("#metaCompuesta").dialog("open");
        }

        function metaCompuestaSave() {

            if ($("#MetaCompuestaCrear").valid()) {
                var stUrl = '/Meta/SaveMetaCompuesta';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnGuardarMetaCompuesta").attr('disabled', true);
                var dataForm = $("#MetaCompuestaCrear").serialize() + "&idMeta=" + $("#metaId").val();               
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = window.location.href;
                        }
                    }
                });
            }
        }

        function eliminarMetaCompuesta(idMetaCompuesta) {

            if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
                var stUrl = '/Meta/DeleteMetaCompuesta';
                mostrarCargando("Eliminando Meta. Espere Por Favor...");
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: {
                        idMetaCompuesta: idMetaCompuesta
                    },
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = window.location.href;
                        }
                    }
                });
            }
        }

        function eliminarProductoMeta(idProductoMeta) {

            if (confirm("Esta seguro de eliminar este registro?\n\nEl proceso no se podra deshacer.")) {
                var stUrl = '/Meta/DeleteProductoMeta';
                mostrarCargando("Eliminando Producto. Espere Por Favor...");
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: {
                        idProductoMeta: idProductoMeta
                    },
                    success: function (response) {
                        if (response.Success) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = window.location.href;
                        }
                    }
                });
            }
        }

        function cambiaAcumulada(checkbox) {
            $("#metaAcumuladaNo").toggle();
            $("#metaAcumuladaSi").toggle();
            if (checkbox.checked) {
                $("#productoMetaList").hide();
                $("#metaCompuestaList").hide();
            }
            
        }

    </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion">
			<h2>Crear nueva meta</h2>
            <h4></h4>
		    <div>
			    En este módulo podrá crear las metas del sistema que posteriormente utilizará para la carga del presupuesto,
                cálculo de la contratación al desempeño y para la liquidación del PAI de ejecutivos
			</div>
			<br /><%: Html.ActionLink("Regresar", "Index") %>
		</div>
		<div id="progresoSeccion">		      
		</div>
		<div style="clear:both;"><hr /></div>
	</div>

<% using (Html.BeginForm("Create", "Meta", FormMethod.Post, new { id = "MetaCrear" })) { %>
    <fieldset style="border:1px solid gray">

        <input type="hidden" id="metaId" name="metaId" value='<%= this.Model.Meta.id %>' />
        <table>
            <tr><td>Nombre: </td>
                <td>
                    <%: Html.TextBox("nombre", this.Model.Meta.nombre, new { @class = "required", @size = "70" })%>
                </td>
            </tr>
            <tr><td>Acumulada?: </td>
                <td>
                    <%: Html.CheckBox("acumulada", this.Model.Acumulada, new { @onclick = "cambiaAcumulada(this)" })%>
                    <%
                        var displayMetaAcumuladaSi = "display:none;";
                        var displayMetaAcumuladaNo = "display:block;";
                        if (this.Model.Acumulada == true)
                        {
                            displayMetaAcumuladaSi = "display:block;";
                            displayMetaAcumuladaNo = "display:none;";
                        }
                    %>
                </td>
            </tr>
        </table>
        <div id="metaAcumuladaNo" style="<%=displayMetaAcumuladaNo%>">
            <table>
                <tr><td>Tipo Medida: </td>
                    <td>
                        <%: Html.DropDownList("tipoMedida_id", this.Model.VariableList, "Seleccione uno...")%>
                    </td>
                </tr>
                <tr><td>Tipo: </td>
                    <td>
                        <%: Html.DropDownList("tipoMeta_id", this.Model.TipoMetaList, "Seleccione uno...")%>
                    </td>
                </tr>
                <tr>
                    <td>Automática?: </td>
                    <td>
                        <%
                           var checkedAutomaticaSi = "";
                           var checkedAutomaticaNo = "checked='checked'";
                           if (this.Model.Meta.automatica == true)
                           {
                               checkedAutomaticaSi = "checked='checked'";
                               checkedAutomaticaNo = "";
                           }
                        %>
                        Si <input type="radio" name="automatica" id="automatica" value="1" <%=checkedAutomaticaSi%> />
                        No <input type="radio" name="automatica" id="automatica" value="0" <%=checkedAutomaticaNo%> />
                    </td>
                </tr>
                <tr>
                    <td>Tipo Meta Calculo: </td>
                    <td>   
                        <%
                           var displayProductoMetaList = "display:none;";
                           var displayMetaCompuestaList = "display:none;";
                           var tipoMeta = string.Empty;
                           if (this.Model.Meta.tipoMetaCalculo_id == 2 && this.Model.Acumulada == false)
                           {
                               displayMetaCompuestaList = "display:block;";
                               tipoMeta = "<b>Calculada</b>";
                           }

                           if (this.Model.Meta.tipoMetaCalculo_id == 1 && this.Model.Acumulada == false)
                           {
                               displayProductoMetaList = "display:block;";
                               tipoMeta = "<b>Simple<b/>"; 
                           }
                        %>                             
                        <%
                           if (tipoMeta == string.Empty)
                           {
                        %>    
                                Simple <input type="radio" name="tipoMetaCalculo" id="tipoMetaCalculo" value="1" checked/>
                                Calculada <input type="radio" name="tipoMetaCalculo" id="tipoMetaCalculo" value="2"/>
                        <%
                            }
                            else
                            {
                                Response.Write(tipoMeta);
                                Response.Write("<input type='hidden' name='tipoMetaCalculo' id='tipoMetaCalculo' value='" + this.Model.Meta.tipoMetaCalculo_id + "'>");
                            }
                        %>
                    </td>
                </tr>
            </table>
        </div>
        <div id="metaAcumuladaSi" style="<%=displayMetaAcumuladaSi%>">
            <table>
                <tr><td>Meta mensual: </td>
                    <td>
                        <%: Html.DropDownList("meta_id", this.Model.MetaMensualList, "Seleccione una...") %>
                    </td>
                </tr>
            </table>
        </div>
        <p><input type="button" value="Guardar" onclick="metaSave();" id="btnCrear" name="btnCrear"/></p>
        <hr/>
        <div id="productoMetaList" style="<%=displayProductoMetaList%>">
            <input type="button" value="Adicionar Producto" onclick="productoMeta(0,<%= this.Model.Meta.id %>);" id="btnCrearProductoMeta"/>
            <input type="hidden" value="<%=this.Model.ProductosMetaList.Count() %>" name="totalProductos" id="totalProductos"/>
            <table id="tablaLista">
                <thead>
                <tr>
                    <th>Compañia</th>
                    <th>Ramo</th>
                    <th>Producto</th>
                    <th>Linea Negocio</th>
                    <th>Modalidad de pago</th>
                    <th>Amparo</th>
                    <th align="center">Opciones</th>
                </tr>
                </thead>
                <% foreach (var item in this.Model.ProductosMetaList) { %>
                <tr>
                    <td><%: item.Compania.nombre %></td>
                    <td><%: item.ramo_id == 0 ? "Todos" : item.Ramo.nombre %></td>
                    <td><%: item.producto_id == 0 ? "Todos" : item.Producto.nombre %></td>
                    <td><%: item.lineaNegocio_id == 0 ? "Todas" : item.LineaNegocio.nombre %></td>
                    <td><%: item.modalidadPago_id == 0 ? "Todas" : item.ModalidadPago.nombre %></td>
                    <td><%: item.amparo_id == 0 ? "Todos" : item.Amparo.nombre %></td>
                    <td nowrap = "nowrap" align="right">
                        <a href="javascript:productoMeta(<%= item.id %>,<%= this.Model.Meta.id %>);" title='Editar' style="float:left;"><span class='ui-icon ui-icon-pencil'/></a>                                    
                        <a href="javascript:eliminarProductoMeta(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
        <div id="metaCompuestaList" style="<%=displayMetaCompuestaList%>">
            <input type="button" value="Adicionar Meta Simple" onclick="metaCompuesta();" id="btnCrearMetaCompuesta" />
            <input type="hidden" value="<%=this.Model.MetaCompuestaList.Count() %>" name="totalMetasSimples" id="totalMetasSimples"/>
            <table id="tablaLista1">
                <thead>
                <tr>
                    <th>Meta Destino</th>
                    <th>Tipo Medida</th>
                    <th>Tipo Meta</th>
                    <th align="center">Opciones</th>
                </tr>
                </thead>
                <% foreach (var item in this.Model.MetaCompuestaList) { %>
                <tr>
                    <td><%: item.Meta1.nombre %></td>
                    <td><%: item.Meta1.TipoMedida.nombre %></td>
                    <td><%: item.Meta1.TipoMeta.nombre %></td>
                    <td nowrap = "nowrap" align="right">
                         <a href="javascript:eliminarMetaCompuesta(<%: item.id %>);" title='Eliminar' style="float:left;"><span class='ui-icon ui-icon-trash'/></a>
                    </td>
                </tr>
                <% } %>
            </table>
        </div>
    </fieldset>
<% } %>
<div id="productoMeta" style="display:none;"></div>
<div id="metaCompuesta" style="display:none;">
<% using (Html.BeginForm("Create", "MetaCompuesta", FormMethod.Post, new { id = "MetaCompuestaCrear" }))
   {       
       %>
    <fieldset  style="border:1px solid gray">
        Seleccione una o varias metas que haran parte de la meta calculada.
        <table id="tablaLista2" style="width:100%;">
            <thead>
            <tr>
                <th>Seleccione</th>
                <th>Nombre de la meta</th>
                <th>Tipo Medida</th>
                <th>Tipo</th>
                <th>¿Automatica?</th>
            </tr>
            </thead>
            <% 
                foreach (var item in this.Model.MetaList) {
            %>
            <tr>
                <td><input type="checkbox" name="metasDestino[]" value="<%=item.id %>" /></td>
                <td><%: item.nombre %></td>
                <td><%: item.TipoMedida.nombre %></td>
                <td><%: item.TipoMeta.nombre %></td>
                <td align="center"><%: ((item.automatica == true) ? "Si" : "No") %></td>               
            </tr>
            <% } %>
        </table>
        <p><input type="button" value="Guardar" onclick="metaCompuestaSave();" id="btnGuardarMetaCompuesta"/></p>
    </fieldset>
<% } %>
</div>
</asp:Content>