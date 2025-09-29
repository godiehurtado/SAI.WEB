<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SiteMapPathUserControl.ascx.cs"
    Inherits="ColpatriaSAI.UI.MVC.Views.Shared.SiteMapPathUserControl" %>

<% if (SiteMap.Provider.CurrentNode !=null) { %>
<% SiteMapNode node = SiteMap.Provider.CurrentNode.ParentNode;
    List<SiteMapNode> nodes = new List<SiteMapNode>();
    while (node != null) {
        nodes.Add(node);
        node = node.ParentNode;
    }
    nodes.Reverse();
    nodes.RemoveAt(0);
    foreach (SiteMapNode item in nodes) { %>
        <a href="<%: ResolveUrl(item.Url) %>"><%: item.Title %></a>
    <% } %>
    <%: SiteMap.Provider.CurrentNode %>
<% } %>