<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="verReporte.aspx.cs" Inherits="ColpatriaSAI.UI.MVC.Reportes.verReporte" MasterPageFile="~/Reportes/Reportes.Master" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server" EnableViewState=false>    
        <asp:ScriptManager ID="ScriptManager1" runat="server"  AsyncPostBackTimeout ="360000"></asp:ScriptManager>
        <div id="cuadroReporte">
            <rsweb:ReportViewer ID="ReportViewerWeb" runat="server"
                Width="100%" Height="100%" >
            </rsweb:ReportViewer>
        </div>
    </asp:Content>
