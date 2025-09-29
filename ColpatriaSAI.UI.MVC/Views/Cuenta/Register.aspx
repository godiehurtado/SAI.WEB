<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Registrar
</asp:Content>

<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Crear una nueva nueva cuenta</h2>
    <p>
        Use el siguiente formulario para crear una nueva cuenta
    </p>
    <p>
       La longitud del Password  requerida es como minimo <%=Html.Encode(ViewData["PasswordLength"])%> caracteres
    </p>
    <%= Html.ValidationSummary("La creación de la cuenta no fue satisfactoria. Porfavor corrija los errorese intente de nuevo.") %>

    <% using (Html.BeginForm()) { %>
        <div>
            <fieldset>
                <legend>Información de la cuenta</legend>
                <p>
                    <label for="username">Nombre de usuario:</label>
                    <%= Html.TextBox("username") %>
                    <%= Html.ValidationMessage("username") %>
                </p>
                <p>
                    <label for="email">Email:</label>
                    <%= Html.TextBox("email") %>
                    <%= Html.ValidationMessage("email") %>
                </p>
                <p>
                    <label for="password">Password:</label>
                    <%= Html.Password("password") %>
                    <%= Html.ValidationMessage("password") %>
                </p>
                <p>
                    <label for="confirmPassword">Confirme el password:</label>
                    <%= Html.Password("confirmPassword") %>
                    <%= Html.ValidationMessage("confirmPassword") %>
                </p>
                <p>
                    <input type="submit" value="Registrar" />
                </p>
            </fieldset>
        </div>
    <% } %>
</asp:Content>
