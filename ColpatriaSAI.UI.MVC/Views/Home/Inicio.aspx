<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="indexTitle" ContentPlaceHolderID="TitleContent" runat="server">
   Sistema de Administración de Incentivos - SAI - Unidad de Inversión Colpatria
</asp:Content>

<asp:Content ID="indexContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            // Datepicker
            $('#fecha').datepicker({
                inline: true
            });

            $("#tabs").tabs();

        });
    </script>

    
    <h2><%= Html.Encode(ViewData["Message"]) %></h2>
    <p>
        Bienvenido al Sistema de Administración de Incentivos de fuerzas comerciales de la Unidad de Inversión de Colpatria.

    </p>

    <div id="sidebar">
        <div id="fecha"></div>
    </div>
    <div id="contenidoHome">

    <% if (Request.IsAuthenticated && HttpContext.Current.Session["UltimoIngreso"] != null)
       { %>


        <div id="tabs">
	        <ul>
		        <li><a href="#tabs-1">Presupuesto</a></li>
		        <li><a href="#tabs-2">Concursos</a></li>
		        <li><a href="#tabs-3">Contratación al desempeño</a></li>
                <li><a href="#tabs-4">Franquicias</a></li>
                <li><a href="#tabs-5">Reportes</a></li>
                
	        </ul>
	        <div id="tabs-1">
		        <p>
                    El módulo de presupuestos permite la carga de información del presupuesto comercial y financiero al sistema. <br />
                    El último presupuesto se cargó el <b>17 de Julio de 2011</b>.
                </p>
	        </div>
	        <div id="tabs-2">
		        <p>La administración de concursos, incluyendo el Plan Anual de Incentivos para asesores y ejecutivos y el Concurso Nacional de Ventas entre otros.</p>
                <p>El sistema permite crear un concurso en el sistema definiendo el segmento, la 
                    compañía, los participantes, los premios, los productos, la duración y las 
                    reglas que regirán el mismo. Se podrán combinar varias condiciones en una regla 
                    y estas podrán agruparse por etapas. Cada condición podrá utilizar como base una 
                    variable del modelo (moneda, recaudos, primas, cumplimiento, etc.). El sistema 
                    permitirá modificaciones al concurso antes de su publicación. Un concurso en 
                    curso no podrá ser eliminado ni modificado. El sistema almacenará el histórico 
                    de los concursos.</p>
	        </div>
	        <div id="tabs-3">
		        <p>Permite realizar el proceso de liquidación de la contratación al desempeño para ejecutivos</p>
	        </div>
	        <div id="tabs-4">
		        <p>El proceso de administración y liquidación de franquicias incluyendo el pago de anticipos</p>
	        </div>
	        <div id="tabs-5">
		        <p>Reportes para el seguimiento de los incentivos de la Fuerza de Ventas</p>
	        </div>

        

        <% }
       else
       { %>
    <p>
        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
            Debe autenticarse con su usuario y clave para acceder al sistema. Haga <a href="Cuenta/LogOn">clic aquí</a> para ingresar.
    </p>
        <% } %>
        </div>
    </div>
   
    </div>
</asp:Content>