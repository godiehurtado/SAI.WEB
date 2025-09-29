<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Sistema de Administración de Incentivos.
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-ui.js")%>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/toolkit.js") %>'></script>--%>
    
    <link href='<% =Url.Content("/Content/toolkit/css/normalize.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/bootstrap/bootstrap.min.css") %>'
        rel="stylesheet" type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/fonts.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/axa_icons.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/toolkit.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/site/login.css") %>' rel="stylesheet"
        type="text/css" />
    
    <div class="row">
        <div id="carrusel">
            <div class="col-xs-12" style="padding:0 0 0 0;">                
                    <div class="col-xs-4" style="width:275px; height:200px; padding:0 0 0 0;margin:0 5px 0 5px; background-image:url('../../App_Themes/SAI.Estilo/Imagenes/control.jpg'); -webkit-border-radius: 20px;-moz-border-radius: 20px;border-radius: 20px;">
                        <a href="Home/TablasControl">
                                <div class="screen">
                                    <h3>Tablas de Control</h3>
                                    <p style="max-height:180px">Verifique de manera resumida y ágil los datos relacionados con los registros más importantes del aplicativo. </p>
                                </div>
                        </a>
                    </div>
                    <div class="col-xs-4" style="width:275px; height:200px; padding:0 0 0 0;margin:0 5px 0 5px; background-image:url('../../App_Themes/SAI.Estilo/Imagenes/estadisticas.jpg'); -webkit-border-radius: 20px;-moz-border-radius: 20px;border-radius: 20px;">
                        <a href="Estadisticas/">
                                <div class="screen" >
                                    <h3>Estadísticas</h3>
                                    <p style="max-height:180px">Visualice de manera estadística los valores de negocios y recaudos relacionados con el mes actual. </p>
                                </div>
                        </a>
                    </div>
                    <div class="col-xs-4" style="width:275px; height:200px; padding:0 0 0 0;margin:0 5px 0 5px; background-image:url('../../App_Themes/SAI.Estilo/Imagenes/proceso.jpg'); -webkit-border-radius: 20px;-moz-border-radius: 20px;border-radius: 20px;">
                        <a href="ProcesoAutomatico/">                             
                                <div class="screen">
                                    <h3>Proceso Automático</h3>
                                    <p style="max-height:180px">Administre los procesos de cargue de acuerdo a sus necesidades diarias, para obtener de manera oportuna los datos que necesite cargados en el aplicativo. </p>                                                                        
                                </div>
                        </a>
                    </div>                
            </div>
        </div>
    </div>
</asp:Content>
