<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.SiteMap>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editar  Permisos - Sistema de Administración de Incentivos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Editar  Permisos</h2>
  
    <% using (Html.BeginForm()) {%>
        <%: Html.ValidationSummary(true) %>
         
        <fieldset>
            <legend>Seleccione los roles para esta opción</legend>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.ID) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
                <%: Html.TextBoxFor(model => model.ID) %>
                <%: Html.ValidationMessageFor(model => model.ID) %>
            </div>
            
            <div class="editor-label">
                <h3><%: Model.TITLE %></h3>
                <%--<%: Html.LabelFor(model => model.TITLE) %>--%>
            </div>
          <%--  <div class="editor-field">
                <%: Html.TextBoxFor(model => model.TITLE, new { @readonly = "true" })%>
                <%: Html.ValidationMessageFor(model => model.TITLE) %>
            </div>--%>
            <%: Html.HiddenFor(model => model.TITLE) %>
            
            <div class="editor-label">
                Descripción:
                <%--<%: Html.LabelFor(model => model.DESCRIPTION) %>--%>
            </div>
            <div class="editor-field">
                <%: Html.TextAreaFor(model => model.DESCRIPTION, new { @rows = 5, @cols = 30 })%>
                <%: Html.ValidationMessageFor(model => model.DESCRIPTION) %>
            </div>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.CONTROLLER) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
                <%: Html.TextBoxFor(model => model.CONTROLLER) %>
                <%: Html.ValidationMessageFor(model => model.CONTROLLER) %>
            </div>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.ACTION) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
                <%: Html.TextBoxFor(model => model.ACTION) %>
                <%: Html.ValidationMessageFor(model => model.ACTION) %>
            </div>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.PARAMID) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
                <%: Html.TextBoxFor(model => model.PARAMID) %>
                <%: Html.ValidationMessageFor(model => model.PARAMID) %>
            </div>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.URL) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
                <%: Html.TextBoxFor(model => model.URL) %>
                <%: Html.ValidationMessageFor(model => model.URL) %>
            </div>
            
            <div class="editor-label" style="visibility: hidden; display: none">
                <%: Html.LabelFor(model => model.PARENT_ID) %>
            </div>
            <div class="editor-field" style="visibility: hidden; display: none">
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
     <%--   <div class="editor-field">
              
            <%: Html.ListBox("ListRoles",  ViewData["Roles"]  as MultiSelectList,
            new {multiple=true,size=5})%>
            </div>--%>
            <div class="editor-field">
              
            <%: Html.ListBox("ListRoles",null,new { @size = 10 })%>
            <br /> Utilice la tecla Control (Ctrl) para seleccionar varios roles.
            </div>
            
            <p>
                <input type="submit" value="Guardar" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%: Html.ActionLink("Regresar", "Index") %>
    </div>

</asp:Content>

