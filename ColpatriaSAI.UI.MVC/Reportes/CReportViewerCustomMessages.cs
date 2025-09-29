using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ColpatriaSAI.UI.MVC.Reportes
{
    public class CReportViewerCustomMessages : Microsoft.Reporting.WebForms.IReportViewerMessages
     {
        public string DocumentMapButtonToolTip
        {
            get { return "Mapa del documento"; }
        }

        public string ParameterAreaButtonToolTip
        {
            get { return "Area de parametros"; }
        }

        public string FirstPageButtonToolTip
        {
            get { return "Primer Página"; }
        }

        public string PreviousPageButtonToolTip
        {
            get { return "Página Anterior"; }
        }

        public string CurrentPageTextBoxToolTip
        {
            get { return "Página Actual"; }
        }

        public string PageOf
        {
            get { return "Página de"; }
        }

        public string NextPageButtonToolTip
        {
            get { return "Siquiente Página"; }
        }

        public string LastPageButtonToolTip
        {
            get { return "Última Página"; }
        }

        public string BackButtonToolTip
        {
            get { return "Regresar"; }
        }

        public string RefreshButtonToolTip
        {
            get { return "Actualizar"; }
        }

        public string PrintButtonToolTip
        {
            get { return "Imprimir"; }
        }

        public string ExportButtonToolTip
        {
            get { return "Exportar"; }
        }

        public string ZoomControlToolTip
        {
            get { return "Aumentar"; }
        }

        public string SearchTextBoxToolTip
        {
            get { return "Buscar"; }
        }

        public string FindButtonToolTip
        {
            get { return "Encontrar"; }
        }

        public string FindNextButtonToolTip
        {
            get { return "Encontrar Siguiente"; }
        }

        public string ZoomToPageWidth
        {
            get { return "Aumentar al ancho de la página"; }
        }

        public string ZoomToWholePage
        {
            get { return "Aumentar toda la página"; }
        }

        public string FindButtonText
        {
            get { return "Encontrar Siguiente"; }
        }

        public string FindNextButtonText
        {
            get { return "Encontrar Siguiente"; }
        }

        public string ViewReportButtonText
        {
            get { return "Ver Reporte"; }
        }

        public string ProgressText
        {
            get { return "Un momento"; }
        }

        public string TextNotFound
        {
            get { return "Texto no encontrado"; }
        }

        public string NoMoreMatches
        {
            get { return "No hay mas correspondencias"; }
        }

        public string ChangeCredentialsText
        {
            get { return "Cambiar Credenciales"; }
        }

        public string NullCheckBoxText
        {
            get { return "Null"; }
        }

        public string NullValueText
        {
            get { return "Null"; }
        }

        public string TrueValueText
        {
            get { return "Verdadero"; }
        }

        public string FalseValueText
        {
            get { return "Falso"; }
        }

        public string SelectAValue
        {
            get { return "Seleccione un valor"; }
        }

        public string UserNamePrompt
        {
            get { return "Nombre de usuario"; }
        }

        public string PasswordPrompt
        {
            get { return "Clave"; }
        }

        public string SelectAll
        {
            get { return "Seleccione todos"; }
        }

        public string TodayIs
        {
            get { return "Hoy es"; }
        }

        public string ExportFormatsToolTip
        {
            get { return "Exportar"; }
        }

        public string ExportButtonText
        {
            get { return "Exportar"; }
        }

        public string SelectFormat
        {
            get { return "Seleccione formato"; }
        }

        public string DocumentMap
        {
            get { return "Mapa del documento"; }
        }

        public string InvalidPageNumber
        {
            get { return "Número de Página inválido"; }
        }

        public string ChangeCredentialsToolTip
        {
            get { return "Cambiar Credenciales"; }
        }
     }
}