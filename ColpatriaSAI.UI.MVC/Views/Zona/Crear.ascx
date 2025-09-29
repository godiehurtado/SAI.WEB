<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<IEnumerable<ColpatriaSAI.Negocio.Entidades.Zona>>" %>

    <%--<script type="text/javascript">
        function CerrarDialog() {
            $("#dialog").dialog('destroy');
        }
    </script>--%>

    <% using (Html.BeginForm("Crear", "Zona")) {%>
        <%: Html.ValidationSummary(true) %>

        <%--<fieldset>--%>
            <%--<legend>Crear Zona</legend>--%>
            
            <%--<div class="editor-label">
                <%: Html.Label("Id") %>
            </div>
            <div class="editor-field">
                <%: Html.TextBoxFor(model => model.First().id)%>
                <%: Html.ValidationMessageFor(model => model.First().id)%>
            </div>--%>
            
            <div>
                <%: Html.Label("Nombre") %>
                <%: Html.TextBox("nombre")%>
                <%: Html.ValidationMessageFor(model => model.First().nombre)%>
            </div>
            <%--<div class="editor-field">
            </div>--%>
            
            <p>
                <input type="submit" value="Crear" onclick="javascript:mostrarDialog(dialogCrear);" />
                <%--<input type="submit" value="Cerrar" onclick="javascript:CerrarDialog();" />--%>
            </p>
        <%--</fieldset>--%>

    <% } %>

    <%--<div>
        <%: Html.ActionLink("Back to List", "Index") %>
    </div>--%>