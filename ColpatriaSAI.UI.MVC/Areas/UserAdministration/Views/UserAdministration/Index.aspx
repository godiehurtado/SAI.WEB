<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.UI.MVC.Areas.UserAdministration.Models.UserAdministration.IndexViewModel>" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">
    Administración de Usuarios
</asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/jquery/jquery-1.11.3.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/bootstrap.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/modernizr.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/bootstrap/validator.min.js") %>'></script>
    <%--<script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/main.js") %>'></script>--%>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/slick/slick.min.js") %>'></script>
    <script type="text/javascript" src='<% =Url.Content("/Content/toolkit/js/toolkit.js") %>'></script>
    <script type="text/javascript">
        function crearUsuario() {
            if ($("#formularioRegistro").is(":hidden")) {
                $("#formularioRegistro").show("slow");
                $("#botonCrear").hide();
                $("#botonCancelar").show();
            }
            else {
                $("#formularioRegistro").slideUp();
            }
        };

        function cancelarcrearUsuario() {
            if ($("#formularioRegistro").is(":hidden")) {
                $("#formularioRegistro").show("slow");
            }
            else {
                $("#formularioRegistro").slideUp();
                $("#botonCrear").show();
                $("#botonCancelar").hide();
            }
        }

        function crearRol() {
            if ($("#formularioRol").is(":hidden")) {
                $("#formularioRol").show("slow");
                $("#botonCrearRol").hide();
                $("#botonCancelarRol").show();
            }
            else {
                $("#formularioRol").slideUp();
            }
        };

        function cancelarcrearRol() {
            if ($("#formularioRol").is(":hidden")) {
                $("#formularioRol").show("slow");
            }
            else {
                $("#formularioRol").slideUp();
                $("#botonCrearRol").show();
                $("#botonCancelarRol").hide();
            }
        }

        function cambiarRol(rol) {
            $("#txtrol").html(rol);
            $("#hrol").val(rol);
        }

        function cambiarTipoDoc(tidoc) {
            $("#txttidoc").html(tidoc);
            $("#htipodoc").val(tidoc);
        }

        function cambiarSegmento(seg) {
            $("#txtsegmento").html(seg);
            $("#hsegmento").val(seg);
        }

        function guardarusuario() {
            var stUrl = '/UserAdministration/UserAdministration/CreateUser';
            mostrarCargando("Creando Usuario. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    nombreUsuario: document.getElementById("txtusuario").value,
                    tipoDocumento: document.getElementById("htipodoc").value,
                    numeroDocumento: document.getElementById("txtnumdoc").value,
                    email: document.getElementById("txtemail").value,
                    rol: document.getElementById("hrol").value,
                    segmento: document.getElementById("hsegmento").value
                },
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        location.reload();
                    }
                }
            });
        }

        function guardarrol() {
            var stUrl = '/UserAdministration/UserAdministration/CreateRole';
            mostrarCargando("Creando Rol. Espere Por Favor...");
            var prueba1 = $.ajax({
                type: 'POST',
                url: stUrl,
                data:
                {
                    nombreRol: document.getElementById("txtrole").value
                },
                success: function (response) {
                    if (response.Success) {
                        closeNotify('jNotify');
                        mostrarExito("El proceso se realizó con éxito.");
                        location.reload();
                    }
                }
            });
        }
    </script>
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
        <br />
        <div id="tabs">
            <h1 class="uppercase title">
                Administración de Usuarios</h1>
            <%--<caption>
                Estilos para pestañas</caption>--%>
            <br />
            <div class="bs-example bs-example-tabs" data-example-id="togglable-tabs">
                <br />
                <ul id="myTabs" class="nav nav-tabs" role="tablist">
                    <li role="presentation" class="active col-xs-4 text-center no-pad"><a href="#usuarios"
                        id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">
                        <i class="hidden-xs glyphicon glyphicon-ok-circle"></i>Usuarios</a></li>
                    <li role="presentation" class="col-xs-4 text-center no-pad"><a href="#roles" role="tab"
                        id="profile-tab" data-toggle="tab" aria-controls="profile"><i class="hidden-xs glyphicon glyphicon-ok-circle">
                        </i>Roles</a></li>
                </ul>
                <div id="myTabContent" class="tab-content">
                    <div role="tabpanel" class="tab-pane fade in active" id="usuarios" aria-labelledby="home-tab">
                        <div id="divBuscarUsuario" class="col-lg-8 col-sm-8 col-md-8" style="padding: 10px;">
                            <div class="row">
                                <div class="col-lg-8 col-md-8 col-sm-8">
                                    <input id="txtBuscar" type="text" class="form-control" />
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 text-left">
                                    <a href="#" class="btn btn-default btn-circle" id="btnBuscar">Buscar <i class="glyphicon glyphicon-search">
                                    </i></a>
                                </div>
                            </div>
                            <div class="row" style="padding-top: 10px;">
                                <div id="UsersList">
                                    <% Html.RenderPartial("_UsersPagedList", Model.Users); %>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4" style="padding: 10px;">
                            <div id="botonCrear" class="col-xs-12" style="text-align: right">
                                <a href="javascript:crearUsuario()" class="btn btn-default btn-circle">Crear Usuario
                                    <i class="glyphicon glyphicon-plus-sign"></i></a>
                            </div>
                            <div id="botonCancelar" class="col-xs-12" style="text-align: right; display: none">
                                <a href="javascript:cancelarcrearUsuario()" class="btn btn-cancel btn-circle">Cancelar
                                    <i class="glyphicon glyphicon-remove"></i></a>
                            </div>
                            <br />
                            <div id="formularioRegistro" style="display: none">
                                <div class="form-group  has-feedback">
                                    <label for="txtusuario">
                                        Nombre de Usuario</label>
                                    <input attern="^[_A-z0-9]{1,}$" type="text" class="form-control animated" id="txtusuario"
                                        placeholder="Usuario" required>
                                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span><span class="help-block with-errors">
                                    </span>
                                </div>
                                <div class="form-group  has-feedback">
                                    <input id="htipodoc" type="hidden" />
                                    <label for="txttidoc">
                                        Tipo Documento</label>
                                    <div class="dropdown">
                                        <button id="txttidoc" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown"
                                            aria-haspopup="true" aria-expanded="true" style="width: 100%">
                                            Escoja el tipo de documento del usuario <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="txttidoc">
                                            <% foreach (var tidoc in Model.TipoDocumentos)
                                               { %>
                                            <li><a href="javascript:cambiarTipoDoc('<%=tidoc.Value%>')">
                                                <%=tidoc.Value%></a></li>
                                            <%} %>
                                        </ul>
                                    </div>
                                </div>
                                <div class="form-group  has-feedback">
                                    <label for="txtnumdoc">
                                        Número Documento</label>
                                    <input attern="^[_A-z0-9]{1,}$" type="text" class="form-control animated" id="txtnumdoc"
                                        placeholder="Usuario" required>
                                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span><span class="help-block with-errors">
                                    </span>
                                </div>
                                <div class="form-group  has-feedback">
                                    <label for="txtemail">
                                        Email</label>
                                    <input attern="^[_A-z0-9]{1,}$" type="email" class="form-control animated" id="txtemail"
                                        placeholder="Email" required>
                                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span><span class="help-block with-errors">
                                    </span>
                                </div>
                                <div class="form-group  has-feedback">
                                    <input id="hrol" type="hidden" />
                                    <label for="txtrol">
                                        Rol</label>
                                    <div class="dropdown">
                                        <button id="txtrol" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown"
                                            aria-haspopup="true" aria-expanded="true" style="width: 100%">
                                            Escoja el rol por defecto del usuario <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="txtrol">
                                            <% foreach (string role in Model.Roles)
                                               { %>
                                            <li><a href="javascript:cambiarRol('<%=role%>')">
                                                <%=role%></a></li>
                                            <%} %>
                                        </ul>
                                    </div>
                                </div>
                                <div class="form-group  has-feedback">
                                    <input id="hsegmento" type="hidden" />
                                    <label for="txtsegmento">
                                        Segmento por defecto</label>
                                    <div class="dropdown">
                                        <button id="txtsegmento" class="btn btn-cancel dropdown-toggle" type="button" data-toggle="dropdown"
                                            aria-haspopup="true" aria-expanded="true" style="width: 100%">
                                            Escoja el segmento por defecto del usuario <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="txtrol">
                                            <% foreach (var seg in Model.Segmentos)
                                               { %>
                                            <li><a href="javascript:cambiarSegmento('<%=seg.Value%>')">
                                                <%=seg.Value%></a></li>
                                            <%} %>
                                        </ul>
                                    </div>
                                </div>
                                <div class="col-xs-12" style="text-align: right">
                                    <a href="javascript:guardarusuario()" class="btn btn-default btn-circle">Guardar <i
                                        class="glyphicon glyphicon-plus-sign"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div role="tabpanel" class="tab-pane fade" id="roles" aria-labelledby="profile-tab">
                        <div class="col-lg-6">
                            <div style="text-align: left">
                                <% if (Model.Roles.Count() > 0)
                                   { %>
                                <ul>
                                    <% foreach (var role in Model.Roles)
                                       { %>
                                    <li>
                                        <div class="select-items" style="text-align: left; width: 100%">
                                            <h1 class="uppercase subTit">
                                                <i class="iconTitulos glyphicon glyphicon-briefcase"></i>
                                                <% =Html.ActionLink(role,"Role", new{id = role}) %></h1>
                                            <% if (role != "Administrator") using (Html.BeginForm("DeleteRole", "UserAdministration", new { id = role }))
                                                   { %>
                                            <div style="text-align: right">
                                                <a href="#" onclick="$(this).closest('form').submit()" style="font-size: xx-large;
                                                    color: #D7171F"><i class="glyphicon glyphicon-remove-sign" data-toggle="tooltip"
                                                        data-placement="right" title="Borrar"></i></a>
                                            </div>
                                            <%--<input type="submit" value="Borrar" onclick="return confirm('Está seguro que desea eliminar este rol?')" />--%>
                                            <% } %>
                                        </div>
                                        <br />
                                        <br />
                                    </li>
                                    <% } %>
                                </ul>
                                <% }
                                   else
                                   { %>
                                <p>
                                    No Hay Roles Creados.</p>
                                <% } %>
                                <%--<h3>
                                Creación de Roles</h3>
                            <% using (Html.BeginForm("CreateRole", "UserAdministration",
    FormMethod.Post, new { id = "RolCrear" }))
                               { %>
                            <fieldset>
                                <label for="id">
                                    Rol:</label>
                                <% =Html.TextBox("id") %>
                                <input type="submit" value="Crear Rol" />
                            </fieldset>
                            <% } %>--%>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div id="botonCrearRol" class="col-xs-12" style="text-align: right">
                                <a href="javascript:crearRol()" class="btn btn-default btn-circle">Crear Rol <i class="glyphicon glyphicon-plus-sign">
                                </i></a>
                            </div>
                            <div id="botonCancelarRol" class="col-xs-12" style="text-align: right; display: none">
                                <a href="javascript:cancelarcrearRol()" class="btn btn-cancel btn-circle">Cancelar <i
                                    class="glyphicon glyphicon-remove"></i></a>
                            </div>
                            <div id="formularioRol" style="display: none">
                                <div class="form-group  has-feedback">
                                    <label for="txtusuario">
                                        Nombre del Rol</label>
                                    <input attern="^[_A-z0-9]{1,}$" type="text" class="form-control animated" id="txtrole"
                                        placeholder="Rol" required>
                                    <span class="glyphicon form-control-feedback" aria-hidden="true"></span><span class="help-block with-errors">
                                    </span>
                                </div>
                                <div class="col-xs-12" style="text-align: right">
                                    <a href="javascript:guardarrol()" class="btn btn-default btn-circle">Guardar <i class="glyphicon glyphicon-plus-sign">
                                    </i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--<h2> Administración de Usuarios</h2>--%>
    <div style="clear: right;">
    </div>
    <%--<h3>SiteMap</h3> <div class="mvcMembership-allRoles"> <% if(Model.Roles.Count()
    > 0 ){ %> <ul> <% foreach(var role in Model.Roles){ %> <li> <% =Html.ActionLink(role,
    "Role", new{id = role}) %> <% using(Html.BeginForm("DeleteRole", "UserAdministration",
    new{id=role})){ %> <input type="submit" value="Borrar" /> <% } %> </li> <% } %>
    </ul> <% }else{ %> <p>SiteMap no se han creado.</p> <% } %> <% using(Html.BeginForm("CreateRole",
    "UserAdministration")){ %> <fieldset> <label for="id">Rol:</label> <% =Html.TextBox("id")
    %> <input type="submit" value="Crear Roles" /> </fieldset> <% } %> </div>--%>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#btnBuscar").click(function () {
                var dto = { filter: $("#txtBuscar").val() };
                $.ajax({
                    url: '/Useradministration/Useradministration/buscar',
                    type: 'POST',
                    dataType: "html",
                    data: dto,
                    cache: false,
                    success: function (data) {
                        $("#UsersList").html(data);
                    },
                    error: function (xhr, status, error) {
                        alert(xhr.responseText);
                    }
                });
            });
        });
    </script>
</asp:Content>
