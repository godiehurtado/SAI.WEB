<%@ Page Title="" Language="C#" MasterPageFile="/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Listar Archivos y Carpetas
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <form id="form1" runat="server">
        <div>
            <h2>Archivos y Carpetas</h2>
            <p>Directorio actual: <%= ViewBag.CurrentPath %></p>
            <ul class="file-list">
                <% if (!String.IsNullOrEmpty(ViewBag.CurrentPath)) { %>
                    <li>
                        <a class="folder" href="<%= Url.Action("Reportesftp", "ReportesSAI", new { path = ViewBag.CurrentPath.Substring(0, ViewBag.CurrentPath.LastIndexOf('/')) }) %>">
                            <img src="/App_Themes/SAI.Estilo/Imagenes/folder-up.png" alt="Carpeta" /> Subir un nivel
                        </a>
                    </li>
                <% } %>

                <% foreach (var item in Model) { %>
                    <% if (item.IsDirectory) { %>
                        <li>
                            <a class="folder" href="<%= Url.Action("Reportesftp", "ReportesSAI", new { path = ViewBag.CurrentPath + "/" + item.Name }) %>">
                                <img src="/App_Themes/SAI.Estilo/Imagenes/folder.png" alt="Carpeta" /> <%= item.Name %>/
                            </a>
                        </li>
                    <% } else { %>
                        <li>
                            <a class="file" href="<%= Url.Action("DescargarReporte", "ReportesSAI", new { fileName = ViewBag.CurrentPath + "/" + item.Name }) %>">
                                <img src="/App_Themes/SAI.Estilo/Imagenes/file.png" alt="Archivo" /> <%= item.Name %>
                            </a>
                        </li>
                    <% } %>
                <% } %>
            </ul>
        </div>
    </form>
</asp:Content>