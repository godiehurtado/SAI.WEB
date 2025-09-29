<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuUserControl.ascx.cs"
    Inherits="MVCSiteMap.Views.Shared.Controls.MenuUserControl" %>
<ul id="menuSai">
    <%    
        foreach (SiteMapNode item in SiteMap.Provider.RootNode.ChildNodes)
        {
         %>
    <li>    <a href="http://<%=Request.ServerVariables["HTTP_HOST"]%><%= item.Url.Replace("~", "") %>">
        <%= item.Title %></a></li>
    <% } %>
    <%
        if (Request.IsAuthenticated && HttpContext.Current.Session["UltimoIngreso"] != null)
        {%>
     <% if (Roles.IsUserInRole("Administrator"))
        { %>
    <li><%= Html.ActionLink("Seguridad", "Index", "UserAdministration", new { Area = "UserAdministration" }, new { })%></li>
    <li><%= Html.ActionLink("Permisos", "Index", "SiteMapAdministration", new { Area = "SiteMapAdministration" }, null)%></li>
<% }
        } %>

</ul>
