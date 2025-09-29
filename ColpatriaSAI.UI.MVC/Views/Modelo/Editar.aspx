<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site2.Master" Inherits="System.Web.Mvc.ViewPage<ColpatriaSAI.Negocio.Entidades.Modelo>" %>
<%@ Import Namespace="ColpatriaSAI.Negocio.Entidades" %>
<%@ Import Namespace="ColpatriaSAI.UI.MVC.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editar modelo
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $().ready(function () {
            $("#ModeloEditar").validate({
                rules: { nombre: "required" }
            });
        });
    </script>

    <% Modelo modelo = (Modelo)ViewData["Modelo"];
        ModeloXMetaViewModel modelos = (ModeloXMetaViewModel)ViewData["ModelosXMetas"]; %>

    <h2>Modelos de Contratación / Editar Modelo.</h2>

    <%: Html.ActionLink("Regresar", "Index") %>
    <fieldset><legend>Editar nombre del modelo</legend>
        <% using (Html.BeginForm("Crear", "Modelo", FormMethod.Post, new { id = "ModeloCrear" }))
           {
            Html.ValidationSummary(true); %>
            <p>
                <%: Html.Label("Nombre")%>
                <%: Html.TextBox("descripcion", modelo.descripcion, new { @class = "required" })%>
                <%: Html.ValidationMessageFor(model => modelo.descripcion)%>
            </p>
            <p><input type="button" value="Crear" onclick="guardarModelo();" /></p>
        <% } %>

        <fieldset id="detalles" style="display:none"><legend>Incluir detalles del modelo </legend>
            <table id="tablaLista">
                <thead>
                <tr style="background-color: White">
                    <% using (Html.BeginForm("CrearDetalle", "Modelo", FormMethod.Post, new { id = "DetalleCrear" }))
                       {
                        Html.ValidationSummary(true); %>
                        <td colspan="3">&nbsp;
                            <%: Html.Label("Meta:")%>
                            <%: Html.DropDownList("meta_id", (SelectList)modelos.MetaList, "Seleccione...", new { @class = "required" })%>
                            &nbsp;
                            <%: Html.Label("Peso:")%>
                            <%: Html.TextBox("peso", null, new { @class = "required number", @style = "width:40px" })%>&nbsp;<%: Html.Label("%")%>
                            <%: Html.Hidden("modelo_id") %>
                            &nbsp;&nbsp;&nbsp;
                            <input type="button" value="Guardar/Actualizar" onclick="guardarDetalle()" />
                        </td>
                    <% } %>
                </tr>
                <tr>
                    <%--<th>Id</th>--%><th >Meta</th><th>Peso</th><th style="width:10">Opciones</th>
                </tr>
                </thead>
                <tbody>
                <% foreach (var item in ((Modelo)ViewData["Modelo"]).ModeloxMetas) { %>
                    <tr align='center'>
                        <td><%: item.Meta.nombre %></td>
                        <td><%: item.peso %></td>
                        <td><%--<a href='#'>Editar</a><img class='eliminar' src='' alt='Eliminar meta' />--%></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </fieldset>

    </fieldset>

</asp:Content>