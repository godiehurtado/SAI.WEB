<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<ColpatriaSAI.Negocio.Entidades.Localidad>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Copiar Porcentajes
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">

        $(document).ready(function () {
            $("#FormPartFranquicias").validate({
                errorClass: "invalid",
                errorPlacement: function (error, element) {
                    return true;
                }                
            });
        });

        function copiarPorcentajes() {

            var seleccionoDestinos = false;
            $("input:checked").each(function (id) {
                objCheck = $("input:checked").get(id);
                seleccionoDestinos = true;
            });
            
            if (seleccionoDestinos) {
                $("#copiar").attr('disabled', true);
                mostrarCargando("Enviando informacion. Espere Por Favor...");
                $.ajax({ url: '/ParticipacionFranquicias/CopiarParametrizacionFranquicia', data: $("#FormPartFranquicias").serialize(), type: "POST", async: false,
                    success: function (result) {
                        closeNotify('jNotify');
                        if (result.Success) {
                            mostrarExito(result.Messagge);
                            setTimeout(function () {
                                window.location.href = "/ParticipacionFranquicias/Index/" + $("#localidad").val();
                            }, 3000);
                        }
                        else
                            mostrarError(result.Messagge);
                    }
                });
            }
            else
                mostrarError("Debe seleccionar por lo menos una franquicia de destino.");
        }
    </script>

	<div id="encabezadoSeccion">
		<div id="infoSeccion" style="width:auto;">
			<h2>Copiar Porcentajes desde <%: ViewData["NombreFranq"] %></h2>
			<p>Del siguiente listado seleccione las franquicias a las que quiere copiar los porcentajes de: <b><%: ViewData["NombreFranq"] %></b></p>
			<br /><%: Html.ActionLink("Regresar", "Index", "ParticipacionFranquicias", new { id = ViewData["localidad"] }, null)%>
		</div>
		<div id="progresoSeccion"></div>
		<div style="clear:both;"><hr /></div>
	</div>

 <% using (Html.BeginForm("CopiarParametrizacionFranquicia", "ParticipacionFranquicias", FormMethod.Post, new { id = "FormPartFranquicias" }))
    {%>
        <table class="tbl" id="tablaLista" >
          <thead>                
            <tr>
                <th>
                    Franquicia Origen:
                </th>
                <th>
                    <%: ViewData["NombreFranq"] %><br/>
                    Fecha Inicio: <%: ViewData["FechaInicio"] %>
                    <br>
                    Fecha Fin: <%: ViewData["FechaFin"] %>
                </th>
            </tr>
            <tr>
                <th valign="top">
                    Franquicia Destino:
                </th>
                <th>
                    Seleccione una Franquicia:<br/>
                    <%
                        int auxLocalidad = 0;
                        foreach (var lista in Model)
                        {
                            if (auxLocalidad != lista.id)
                            {
                                %>                                    
                                    <input type="checkbox" name="franquicia_destino[]" id="franquicia_destino[]" value="<%=lista.id%>"/><%=lista.nombre%><br/>
                                <%                                    
                            }                             
                            auxLocalidad = Convert.ToInt32(lista.id);    
                        }
                    %>                    
                </th>
            </tr>
            </thead>
        </table>
        <br />
        <p>
        
        <input type="hidden" name="localidad" id="localidad" value="<%=ViewData["localidad"] %>"/>
        <input type="hidden" name="franquicia_origen" id="franquicia_origen" value="<%=ViewData["parameorigen"]%>"/>
        <input type="button" id="copiar" value="Copiar" onclick="copiarPorcentajes();"/>
        </p>
        <%
    }%>
</asp:Content>
