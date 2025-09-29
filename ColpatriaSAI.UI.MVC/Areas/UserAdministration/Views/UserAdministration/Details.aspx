<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Areas.UserAdministration.Models.UserAdministration.DetailsViewModel>" %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ContentPlaceHolderID="TitleContent" runat="server">
    Detalles del usuario:
    <% =Html.Encode(Model.DisplayName) %>
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/toolkit.js") %>'></script>
    <link href='<% =Url.Content("/Content/toolkit/css/normalize.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/bootstrap/bootstrap.min.css") %>'
        rel="stylesheet" type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/fonts.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/axa_icons.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/toolkit.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/toolkit/css/site/login.css") %>' rel="stylesheet"
        type="text/css" />
    <link href='<% =Url.Content("/Content/MvcMembership.css") %>' rel="stylesheet" type="text/css" />
    <div class="row">
        <div id="acordeon">
            <h1 class="title uppercase">
                Detalles del usuario:
                <% =Html.Encode(Model.DisplayName) %>
                [<% =Model.Status %>]</h1>
            <h4>
                <%=Html.ActionLink("Regresar","Index","UserAdministration") %></h4>
            <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                <br />
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">Cuenta <i class="iconCollapse glyphicon glyphicon-chevron-down">
                                </i></a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">
                            <div>
                                <table style="width:100%">
                                    <tr>
                                        <td>
                                            <h3>
                                                Nombre del usuario:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <% =Html.Encode(Model.User.UserName) %></h4>
                                        </td>
                                    </tr>
                                    <% if (Model.User.LastActivityDate == Model.User.CreationDate)
                                       { %>
                                    <tr>
                                        <td>
                                            <h3>
                                                Ultima actividad:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <em>Nunca</em></h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <h3>
                                                Ultima autenticación:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <em>Nunca</em></h4>
                                        </td>
                                    </tr>
                                    <% }
                                       else
                                       { %>
                                    <tr>
                                        <td>
                                            <h3>
                                                Ultima actividad:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <% =Model.User.LastActivityDate.ToString("MMMM dd, yyyy h:mm:ss tt", CultureInfo.CurrentCulture) %></h4>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <h3>
                                                Ultima autenticación:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <% =Model.User.LastLoginDate.ToString("MMMM dd, yyyy h:mm:ss tt", CultureInfo.CurrentCulture)%></h4>
                                        </td>
                                    </tr>
                                    <% } %>
                                    <tr>
                                        <td>
                                            <h3>
                                                Creado:</h3>
                                        </td>
                                        <td>
                                            <h4>
                                                <% =Model.User.CreationDate.ToString("MMMM dd, yyyy h:mm:ss tt", CultureInfo.CurrentCulture)%></h4>
                                        </td>
                                    </tr>
                                </table>
                                <% using (Html.BeginForm("ChangeApproval", "UserAdministration", new { id = Model.User.ProviderUserKey }))
                                   { %>
                                <% =Html.Hidden("isApproved", !Model.User.IsApproved) %>
                                <input type="submit" value='<% =(Model.User.IsApproved ? "Desaprobar" : "Aprobar") %> Cuenta'
                                    style="visibility: hidden; display: none" />
                                <% } %>
                                <% using (Html.BeginForm("DeleteUser", "UserAdministration", new { id = Model.User.ProviderUserKey }))
                                   { %>
                                <input type="submit" value="Borrar Cuenta" style="visibility: hidden; display: none" />
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingTwo">
                        <h4 class="panel-title">
                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">Email <i class="iconCollapse glyphicon glyphicon-chevron-down">
                                </i></a>
                        </h4>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                        <div class="panel-body">
                            <div>
                                <% using (Html.BeginForm("Details", "UserAdministration", new { id = Model.User.ProviderUserKey }))
                                   { %>
                                <table style="width: 100%">
                                    <tr>
                                        <td>
                                            <h1 class="uppercase subTit">
                                                <i class="iconSubtitulos glyphicon glyphicon-inbox"></i>Dirección de Correo:</h1>
                                        </td>
                                        <td>
                                            <h4>
                                                <% = Model.User.Email %></h4>
                                        </td>
                                        <td>
                                            <a href="#" onclick="" style="font-size: xx-large; color: #0e2e86"><i class="glyphicon glyphicon-edit"
                                                data-toggle="tooltip" data-placement="right" title="Editar"></i></a>
                                        </td>
                                    </tr>
                                </table>
                                <fieldset>
                                    <p>
                                    </p>
                                    <p style="visibility: hidden; display: none">
                                        <label for="User_Comment">
                                            Comentarios:</label>
                                        <% =Html.TextArea("User.Comment") %>
                                    </p>
                                    <input type="submit" value="Guardar Direccion de correo y comentarios" style="visibility: hidden;
                                        display: none" />
                                </fieldset>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingThree">
                        <h4 class="panel-title">
                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                href="#collapseThree" aria-expanded="false" aria-controls="collapseThree">Roles
                                <i class="iconCollapse glyphicon glyphicon-chevron-down"></i></a>
                        </h4>
                    </div>
                    <div id="collapseThree" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                        <div class="panel-body">
                            <div>
                                <table>
                                    <% foreach (var role in Model.Roles)
                                       { %>
                                    <tr>
                                        <td>
                                            <div id="tooltips">
                                                <article class="tooltipRow">
                                            <% if (role.Value)
                                               { %>
                                            <% using (Html.BeginForm("RemoveFromRole", "UserAdministration", new { id = Model.User.ProviderUserKey, role = role.Key }))
                                               { %>
                                            <%--<input type="submit" value="Remover de" />--%>
                                            <a href="#" onclick="$(this).closest('form').submit()" style="font-size: xx-large;
                                                color: #D7171F"><i class="glyphicon glyphicon-ban-circle" data-toggle="tooltip" data-placement="right" title="Quitar Rol"></i></a>                                                
                                            <% } %>
                                            <% }
                                               else
                                               { %>
                                            <% using (Html.BeginForm("AddToRole", "UserAdministration", new { id = Model.User.ProviderUserKey, role = role.Key }))
                                               { %>
                                            <a href="#" onclick="$(this).closest('form').submit()" style="font-size: xx-large;
                                                color: #5A9021"><i class="glyphicon glyphicon-plus-sign" data-toggle="tooltip" data-placement="right" title="Agregar Rol"></i></a>
                                            <% } %>
                                            <% } %>
                                            </article>
                                            </div>
                                            <br />
                                        </td>
                                        <td>
                                            <h3>
                                                <% =role.Key %></h3>
                                            <br />
                                        </td>
                                    </tr>
                                    <% } %>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="Div1">
                        <h4 class="panel-title">
                            <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion"
                                href="#collapseFour" aria-expanded="false" aria-controls="collapseThree">Segmentos
                                <i class="iconCollapse glyphicon glyphicon-chevron-down"></i></a>
                        </h4>
                    </div>
                    <div id="collapseFour" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingThree">
                       <div class="panel-body">
                            <div>
                                <table>
                                    <% foreach (var seg in Model.Segmentos)
                                       { %>
                                    <tr>
                                        <td>
                                                <article class="tooltipRow">
                                            <% if (seg.Value)
                                               { %>
                                            <% using (Html.BeginForm("RemoveFromSegmento", "UserAdministration", new { id = Model.User.ProviderUserKey, username = Model.User.UserName, seg = seg.Key }))
                                               { %>
                                            <%--<input type="submit" value="Remover de" />--%>
                                            <a href="#" onclick="$(this).closest('form').submit()" style="font-size: xx-large;
                                                color: #D7171F"><i class="glyphicon glyphicon-ban-circle" data-toggle="tooltip" data-placement="right" title="Quitar Segmento"></i></a>                                                
                                            <% } %>
                                            <% }
                                               else
                                               { %>
                                            <% using (Html.BeginForm("AddToSegmento", "UserAdministration", new { id = Model.User.ProviderUserKey, username = Model.User.UserName, seg = seg.Key }))
                                               { %>
                                            <a href="#" onclick="$(this).closest('form').submit()" style="font-size: xx-large;
                                                color: #5A9021"><i class="glyphicon glyphicon-plus-sign" data-toggle="tooltip" data-placement="right" title="Agregar Segmento"></i></a>
                                            <% } %>
                                            <% } %>
                                            </article>
                                            <br />
                                        </td>
                                        <td>
                                            <h3>
                                                <% =seg.Key%></h3>
                                            <br />
                                        </td>
                                    </tr>
                                    <% } %>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <%--<h3>Password</h3>
	<div class="mvcMembership-password">
		<% if(Model.User.IsLockedOut){ %>
			<p>Bloqueado desde <% =Model.User.LastLockoutDate.ToString("MMMM dd, yyyy h:mm:ss tt", CultureInfo.InvariantCulture) %></p>
			<% using(Html.BeginForm("Unlock", "UserAdministration", new{ id = Model.User.ProviderUserKey })){ %>
			<input type="submit" value="Desbloquear Cuenta" 
            style="visibility: hidden; display: none" />
			<% } %>
		<% }else{ %>

			<% if(Model.User.LastPasswordChangedDate == Model.User.CreationDate){ %>
			<dl>
				<dt>Ultimo Cambio:</dt>
				<dd><em>Nunca</em></dd>
			</dl>
			<% }else{ %>
			<dl>
				<dt>Ultimo Cambio:</dt>
				<dd><% =Model.User.LastPasswordChangedDate.ToString("MMMM dd, yyyy h:mm:ss tt", CultureInfo.InvariantCulture) %></dd>
			</dl>
			<% } %>

			<% using(Html.BeginForm("ResetPassword", "UserAdministration", new{ id = Model.User.ProviderUserKey })){ %>
			<fieldset>
				<p>
					<dl>
						<dt>Pregunta para el Password:</dt>
						<% if(string.IsNullOrEmpty(Model.User.PasswordQuestion) || string.IsNullOrEmpty(Model.User.PasswordQuestion.Trim())){ %>
						<dd><em>Pregunta para el password no se ha definido.</em></dd>
						<% }else{ %>
						<dd><% =Html.Encode(Model.User.PasswordQuestion) %></dd>
						<% } %>
					</dl>
				</p>
				<p>
					<label for="answer">Respuesta para el Password:</label>
					<% =Html.TextBox("answer") %>
				</p>
				<input type="submit" value="Reset Password" 
                     />
			</fieldset>
			<% } %>

		<% } %>
	</div>--%>
</asp:Content>
