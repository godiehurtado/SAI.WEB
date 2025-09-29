<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    TablasControl
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<%
        List<ColpatriaSAI.Negocio.Entidades.TipoPanel> listDashboard = (List<ColpatriaSAI.Negocio.Entidades.TipoPanel>)ViewData["listDashboard"];
        int cantidadPaneles = listDashboard.Count;
    %>
    <link href="/Scripts/home/panels.css" rel="stylesheet" type="text/css" />
    <link href='<% =Url.Content("/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />
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
    <link href='<% =Url.Content("/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 8]>
      <link href="@Url.Content("~/Content/toolkit/css/bootstrap/bootstrap-ie7.css")" rel="stylesheet">
      <link href="@Url.Content("~/Content/toolkit/css/ie/ie7.css")" rel="stylesheet">
      <script src="@Url.Content("~/Content/toolkit/js/ie/html5shiv.min.js")"></script>
      <script src="@Url.Content("~/Content/toolkit/js/ie/ie7.js")"></script>
      <link href="http://externalcdn.com/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
      <script src="@Url.Content("~/Content/toolkit/js/bootstrap/respond.min.js")"></script>
      <![endif]-->
    <!--[if IE 9]>
        <link href="@Url.Content("~/Content/toolkit/css/ie/ie9.css")" rel="stylesheet">
    <![endif]-->
    
    <style>
        #columns table
        {
            border-collapse: collapse;
            border: 1px solid #666666;
            font: normal 11px verdana, arial, helvetica, sans-serif;
            color: #363636;
            background: #f6f6f6;
            text-align: left;
        }
        #columns caption
        {
            text-align: center;
            font: bold 16px arial, helvetica, sans-serif;
            background: transparent;
            padding: 6px 4px 8px 0px;
            color: #CC00FF;
            text-transform: uppercase;
        }
        #columns thead, #columns tfoot
        {
            text-align: left;
            height: 30px;
        }
        #columns thead th, #columns tfoot th
        {
            padding: 5px;
            width: 30%;
        }
        #columns tr
        {
            padding: 5px;
            width: 70%;
        }
        #columns table a
        {
            color: #333333;
            text-decoration: none;
        }
        #columns table a:hover
        {
            text-decoration: underline;
        }
        #columns tr.odd
        {
            background: #f1f1f1;
        }
        #columns tbody th, #columns tbody td
        {
            padding: 5px;
        }
        #columns tbody tr:hover
        {
            background: #333333;
            border: 1px solid #03476F;
            color: #FFFFFF;
        }
        #columns tbody tr:hover th, #columns tbody tr.odd:hover th
        {
            background: #333333;
            color: #FFFFFF;
        }
    </style>
    <%--<h2>
        Sistema de Administración de Incentivos</h2>--%>
    <%
        string bgColor = string.Empty;
        string color = string.Empty;

        //Tipo panel con valores en dinero
        List<int> listTipoPanel = new List<int>();
        listTipoPanel.Add(2);
        listTipoPanel.Add(3);
        listTipoPanel.Add(12);
        listTipoPanel.Add(13);
        listTipoPanel.Add(14);


        //Adicionar Descripcion al Panel 
        List<List<string>> listDescripcionTipoPanel = new List<List<string>>();
        string descripcion = String.Format("{0:MMMM}", DateTime.Now).ToString().ToUpper();

        listDescripcionTipoPanel.Add(new List<string> { "1", descripcion });
        listDescripcionTipoPanel.Add(new List<string> { "2", descripcion });
        listDescripcionTipoPanel.Add(new List<string> { "3", descripcion });
        listDescripcionTipoPanel.Add(new List<string> { "4", descripcion });
        
             
                      
    %>

<h1 class="uppercase title">
                Tablas de Control</h1>

<div id="columns">
        <ul id="column1" class="column">
            <%
                int i = 0;
                foreach (ColpatriaSAI.Negocio.Entidades.TipoPanel panel in listDashboard)//foreach(ColpatriaSAI.Negocio.Entidades.TipoPanel panel in listDashboard.Where(x => x.id == 9))
                {
                    if (i == Math.Ceiling((Double)cantidadPaneles / 2))
                    {
            %>
        </ul>
        <ul id="column2" class="column">
            <%
                }
                i++;

                string patronMoneda = "";
                if (listTipoPanel.Exists(x => x == Convert.ToInt32(panel.id)))//if (listTipoPanel.Exists(x => x == Convert.ToInt32(panel.id)))
                {
                    patronMoneda = "$";
                }

                string addDescripcion = "";
                if (listDescripcionTipoPanel.Exists(x => x[0] == panel.id.ToString()))
                {
                    addDescripcion = listDescripcionTipoPanel.Where(x => x[0] == panel.id.ToString()).ToList().First()[1].ToString();
                } 

            %>
            <li class="widget blue color-grey">
                <div class="widget-head">
                    <h3 title="<%= panel.descripcion %>" style="font-family:inherit;font-weight:bold; clear:none">
                        <%= panel.nombre %>
                        <%= addDescripcion%></h3>
                </div>
                <div class="widget-content">
                    <table cellpadding="0" cellspacing="2" border="0" width="100%">
                        <thead>
                            <tr>
                                <th align="left">
                                    <%= panel.nombreDescripcion  %>
                                </th>
                                <% if (panel.nombreValor1 != null)
                                   {
                                %>
                                <th>
                                    <%= panel.nombreValor1 %>
                                </th>
                                <% }
                                   if (panel.nombreValor2 != null)
                                   {
                                %>
                                <th align="center">
                                    <%= panel.nombreValor2 %>
                                </th>
                                <% }
                                   if (panel.nombreValor3 != null)
                                   {
                                %>
                                <th align="right">
                                    <%= panel.nombreValor3 %>
                                </th>
                                <% }
                                  
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                   bgColor = string.Empty;
                                   color = string.Empty;
                                   foreach (ColpatriaSAI.Negocio.Entidades.Dashboard dashboard in panel.Dashboards)
                                   {
                                       bgColor = (bgColor == "#fff") ? "" : "#fff";
                                       color = (color == "#000") ? "" : "#000";
                            %>
                            <tr style='background-color: <%=bgColor%>; color: <%=color%>;'>
                                <td>
                                    <%=dashboard.descripcion %>
                                </td>
                                <% if (panel.nombreValor1 != null)
                                   {
                                %>
                                <td align="center">
                                    <%=patronMoneda%><%= dashboard.valor1 %>
                                </td>
                                <% }
                                   if (panel.nombreValor2 != null)
                                   {
                                %>
                                <td align="center">
                                    <%=patronMoneda%><%= dashboard.valor2 %>
                                </td>
                                <% }
                                   if (panel.nombreValor3 != null)
                                   {
                                %>
                                <td align="right">
                                    <%=patronMoneda%><%= dashboard.valor3 %>
                                </td>
                                <% }%>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </li>
            <%
            }
            %>
        </ul>
    </div>
    <script type="text/javascript" src="http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js"></script>
    <script src="/Scripts/home/jquery-ui-personalized-1.6rc2.min.js" type="text/javascript"></script>
    <script src="/Scripts/home/panels.js" type="text/javascript"></script>

</asp:Content>
