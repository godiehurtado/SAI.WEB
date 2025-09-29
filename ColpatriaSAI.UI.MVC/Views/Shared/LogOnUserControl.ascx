<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="System.Web" %>

<% if (Request.IsAuthenticated && HttpContext.Current.Session["UserName"] != null) { %>
    <div id="botonSalir" style="font-size:12px">
        [ <a href="/Cuenta/LogOff" title="Salir">Salir</a> ]
    </div>
    <div id="info">
        <table border="0" cellpadding="0" cellspacing="0" id="tableInfo">
            <tr>
                <td style="width: 100px">Bienvenido</td>
                <td style="width: 7px">|</td>
                <td style="margin-right: 10px">
                    <asp:Label ID="lblUsuario" runat="server"><%= Html.Encode(Page.User.Identity.Name) %></asp:Label>
                </td>
            </tr>
            <tr>
                <td>&Uacute;ltimo Acceso</td>
                <td>|</td>
                <td>
                    <asp:Label ID="lbl_UltIngreso" runat="server"><%: Session["UltimoIngreso"] %></asp:Label>
                </td>
            </tr>
            <tr>
                <td>IP de &uacute;ltimo ingreso</td>
                <td>|</td>
                <td>
                    <asp:Label ID="lbt_IP" runat="server"><%= Html.Encode(HttpContext.Current.Session["IPUltimoIngreso"])%></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Ambiente</td>
                <td>|</td>
                <td>
                    <asp:Label ID="lbl_Amb" runat="server"><%= Session["Ambiente"] %></asp:Label>
                </td>
            </tr>
        </table>
    </div>
<% } else { %>
    <div id="validarUsuario" style="display:none">existe</div>
    <%   RouteData ruta = HttpContext.Current.Request.RequestContext.RouteData; string url = ""; %>
       <%--<% if (ruta.Values["controller"] != null) url = "/" + ruta.Values["controller"] + "/" + ruta.Values["action"] + "/" + ruta.Values["id"]; %>--%>
        [ <%: Html.ActionLink("Entrar", "LogOn", "Cuenta", new {  area = "", RedirectUrl = url }, new { @style = "background-color:white;color:red;" })%> ]
<% } %>

<script type="text/javascript">
    if ($("#validarUsuario").text() == "") validarProcesosEnCurso();
</script>
