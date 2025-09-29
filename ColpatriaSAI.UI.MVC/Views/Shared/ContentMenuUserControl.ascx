<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentMenuUserControl.ascx.cs"Inherits="MVCSiteMap.Views.Shared.Controls.ContentMenuUserControl" %>
<% 
    if (SiteMap.Provider.CurrentNode.ChildNodes.Count != 0) { %>
    <h3>Opciones</h3>
    <ul>
    <% foreach (SiteMapNode item in SiteMap.Provider.CurrentNode.ChildNodes) { %>
        <li><a href="<%= ResolveUrl(item.Url) %>"><%= item.Title %></a>
        
            <% if (item.ChildNodes.Count != 0) { %>
            <ul>
                <% foreach (SiteMapNode item2 in item.ChildNodes){  %>
                        <li><a href="<%= ResolveUrl(item2.Url) %>"><%= item2.Title %></a> </li>
                <% } %>
            </ul>
            <% } %>
        </li>
    <% } %>
    </ul>
<% } %>

