<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Acceso al sistema - SAI
</asp:Content>

<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $('#username').focus();
            var url = window.location.search.substring(1).split("&")[0].split("=");
            if (url[0] == "RedirectUrl") {
                var item = url[1].split("%2F");
                url = "";
                for (i = 0; i < item.length; i++) {
                    if (item[i] != "") {
                        url = url + "/" + item[i];
                    }
                }
                $('#returnUrl').val(url);
            }
        });
    </script>

    <h2>Acceso al sistema</h2>
    <p>
        <%--Por favor registre su nombre de usuario y password en  <%= Html.ActionLink("Registrar", "Register") %> si usted no tiene cuenta.--%>
    </p>
    <%= Html.ValidationSummary("La autenticación del usuario es incorrecta.Por favor corrija los errores e intente de nuevo.") %>

    <% using (Html.BeginForm()) { %>
        <div>
            <fieldset id="loginForm">
                <legend>Información de la cuenta</legend>
                <p>
                    <label for="username">Nombre de usuario:</label>
                    <%= Html.TextBox("username","", new { autocomplete = "off" })%>
                    <%= Html.ValidationMessage("username") %>
                </p>
                <p>
                    <label for="password">Contraseña:</label>
                    <%= Html.Password("password", "", new { autocomplete = "off" })%>
                    <%= Html.ValidationMessage("password") %>
                </p>
                <%: Html.Hidden("returnUrl") %>
                <p>
                    <input type="submit" value="Ingresar" />                    
                </p>
                <%
                   if (ViewData["sessionexpired"] != "" && ViewData["sessionexpired"] != null)
                   {
                       Response.Write("Por su seguridad su sesión se ha cerrado automaticamente."); 
                   }
                %>

            </fieldset>
        </div>
    <%
} %>
</asp:Content>
