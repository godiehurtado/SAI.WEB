<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Test
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Test</h2>



<p/>
NS SNIP or MIP IP address:
<%: Request.ServerVariables["remote_addr"] %>
<br/>
<b/>The NS Inserted Client IP:</b/>
<%: Request.ServerVariables["http_Client_ip"]%>
<br/>
Accept Encoding:
<%: Request.ServerVariables["HTTP_ACCEPT_ENCODING"]%>
<br/>
Cookies:
<%: Request.ServerVariables["HTTP_COOKIE"]%>
<br/>

</asp:Content>
