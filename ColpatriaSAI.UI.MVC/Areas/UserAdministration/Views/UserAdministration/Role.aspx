<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Areas.UserAdministration.Models.UserAdministration.RoleViewModel>" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">
	Rol: <% =Html.Encode(Model.Role) %>
</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

	<link href='<% =Url.Content("~/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />

    <h2>Rol: <% =Html.Encode(Model.Role) %></h2>
    <h4><%=Html.ActionLink("Regresar","Index","UserAdministration")%></h4>
    <div class="mvcMembership-roleUsers">
		<% if(Model.Users.Count() > 0){ %>
        <table>
        <% foreach(var user in Model.Users){ %>
				<tr>
                <td><% using(Html.BeginForm("RemoveFromRole", "UserAdministration", new{id = user.ProviderUserKey, role = Model.Role})){ %>
						<input type="submit" value="Remover a:" /> </td>
                <td><% =Html.ActionLink(user.UserName, "Details", new{id=user.ProviderUserKey}) %></td>
					
					<% } %>
				<% } %>
                </tr>
		</table>
		<% }else{ %>
		<p>No existen usuarios para este rol</p>
		<% } %>
	</div>

</asp:Content>