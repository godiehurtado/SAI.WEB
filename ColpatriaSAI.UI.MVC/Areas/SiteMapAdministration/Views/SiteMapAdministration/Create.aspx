<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.SiteMap>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Views.Shared" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Create
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Create</h2>

    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Fields</legend>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.ID) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.ID) %>
                <%: Html.ValidationMessageFor(model => model.ID) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.TITLE) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.TITLE) %>
                <%: Html.ValidationMessageFor(model => model.TITLE) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.DESCRIPTION) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.DESCRIPTION) %>
                <%: Html.ValidationMessageFor(model => model.DESCRIPTION) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.CONTROLLER) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.CONTROLLER) %>
                <%: Html.ValidationMessageFor(model => model.CONTROLLER) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.ACTION) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.ACTION) %>
                <%: Html.ValidationMessageFor(model => model.ACTION) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.PARAMID) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.PARAMID) %>
                <%: Html.ValidationMessageFor(model => model.PARAMID) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.URL) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.URL) %>
                <%: Html.ValidationMessageFor(model => model.URL) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.PARENT_ID) %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.PARENT_ID) %>
                <%: Html.ValidationMessageFor(model => model.PARENT_ID) %>
            </div>
            
            <div class="editor-label">
                <%: Html.LabelFor(model => model.Roles) %>
            </div>
           <%-- <div class="editor-field">
                <%: Html.TextBoxFor(model => model.Roles) %>
                <%: Html.ValidationMessageFor(model => model.Roles) %>
            </div>--%>
              <div class="editor-field">
                  <% WebPage web = new WebPage();
                     aspnet_Roles[] roles = web.AdministracionClient.ListarRoles();
       ViewData["Roles"] = new SelectList(roles, "RoleId", "   RoleName");
        
         %>
            <%: Html.DropDownList("MyList", ViewData["Roles"] as SelectList,new {multiple=true,size=5} )%>
            </div>
            
            <p>
                <input type="submit" value="Create" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Regresar", "Index") %>
    </div>

</asp:Content>

