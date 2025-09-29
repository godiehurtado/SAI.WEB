<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

 <script type="text/javascript">

        $(function () { 
            $("#zona").change(function () {

                var localidad = $("#localidad");
                localidad.find('option').remove();
                $.getJSON('/Concursos/ListarLocalidadesZona', { zonaid: $("#zona").val() }, function (data) {
                    if (data != 0) {

                        $("<option value='0' selected> Seleccione </option>").appendTo(localidad);
                        $(data).each(function () {
                            $("<option value=" + this.id + ">" + this.nombre + "</option>").appendTo(localidad);
                        });
                    }

                });
            });

        });

        function GenerarReporteExcepcion() {
            if ($("#ReporteAsesor").valid()){

                var stUrl = '/Concursos/GeneraReporte';
                mostrarCargando("Enviando información. Espere Por Favor...");
                $("#btnReporte").attr('disabled', true);
                var dataForm = $("#ReporteAsesor").serialize();
                $.ajax({
                    type: 'POST',
                    url: stUrl,
                    data: dataForm,
                    success: function (response) {
                        if (response.Success && response.result != 0) {
                            closeNotify('jNotify');
                            mostrarExito("El proceso se realizó con éxito. Espere Por Favor...");
                            window.location.href = "/ReportesSAI";
                        }
                    }
                });
            }
         }
        </script>

  <div class="seccion" id="dialog">
   <% using (Html.BeginForm("ReporteAsesor", "ConcursoController", FormMethod.Post, new  { id ="ReporteAsesor" })){ %>
        <%: Html.ValidationSummary(true); %>
        <table>
            <tr>
                <td style="width: 19px">
                    <h3>
                        Filtros</h3>
                </td>
            </tr>
            <tr>
                <td style="width: 19px">
                   Premio:
                </td>
                <td>
                <select id="premio" name="premio" style = "width:209px;">
                 <option value="0">Seleccione</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
                <option>CONVENCIÓN POR TOTAL COLQUINES</option>
                <option>CONVENCIÓN POR VIDA INDIVIDUAL</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
                <option>CONVENCIÓN POR CAPITALIZACIÓN TRADICIONAL</option>
                <option>CONVENCIÓN POR PYMES</option>
                <option>CONVENCIÓN INTERNACIONAL</option>
            </select>
                </td>
            </tr>
            <tr>
                <td style="width: 19px">
                    
                        Asesor: 
                   
                    </td>
                    <td>
                    <input type="text" id="asesor" name="asesor" style="width: 205px;" />
                </td>
            </tr>
            <tr>
            
                <td style="width: 19px">
                Zona:
                 </td>
                 <td>                                  
                       <%: Html.DropDownList("ddlzona", (SelectList)ViewData["zona"], "Seleccione", new { id = "zona", @style = "width:209px;", @class = "required", title = "Seleccione  la Zona" })%>
                  </td>
                
            </tr>
            <tr>
                      
                <td style="width: 19px">
                   Localidad:
                </td>
                <td>
                    <select id="localidad" name="localidad" style="width: 209px;">
                    </select></td>
                
            
            <tr >
               <td style="width: 19px" colspan="3" align="center">
        <p></p>
            <input type="button" value="Generar" id="btnReporte" onclick="GenerarReporteExcepcion();"
                name="btnReporte" />
        </td>
     
            </tr>
        </table>
        <%} %>
    </div>


