<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Sistema de administración de Incentivos - SAI
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2><%: ViewBag.TituloError %></h2>
    <div >
        <p>
        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
            <%: ViewBag.CuerpoError %>
        </p>
    </div>


</asp:Content>
