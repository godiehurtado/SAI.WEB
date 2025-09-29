using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ColpatriaSAI.UI.MVC.Views.Shared
{
    public static class Mensajes
    {
        public static string Exito_Insert
        {
            get { return "Información guardada!"; }
        }

        public static string Exito_Edit
        {
            get { return "Información actualizada!"; }
        }

        public static string Exito_Delete
        {
            get { return "Información eliminada!"; }
        }

        public static string Error_Insert
        {
            get { return "Imposible completar el proceso. Error al guardar o la información resulta duplicada!"; }
        }

        public static string Error_Edit
        {
            get { return "Error al actualizar la información!"; }
        }

        public static string Error_Delete_Asociado
        {
            get { return "No se puede eliminar. El registro tiene información asociada!"; }
        }

        public static string Error_Insert_Duplicado
        {
            get { return "No se puede guardar. La información resulta duplicada!"; }
        }

        public static string Error_Update_Duplicado
        {
            get { return "No se puede actualizar. La información resulta duplicada!"; }
        }

        public static string Inicio_Sesion
        {
            get { return "El usuario " + HttpContext.Current.Request["AUTH_USER"] + " ha iniciado sesión."; }
        }

        public static string Rango_Fechas
        {
            get { return "Ya existe el rango de fechas ingresado para la moneda seleccionada"; }
        }

        public static string PremioSubregla
        {
            get { return "El Premio ya ha sido asignado a esta SubRegla"; }
        }

        public static string RegistrosObligatorios
        {
            get { return "Existen campos obligatorios que no han sido seleccionados!"; }
        }

        public static string CombinacionRepetida
        {
            get { return "La Combinación Compañía, Ramo, Producto ya ha sido creada!"; }
        }

        public static string SubReglaAgrupada
        {
            get { return "La SubRegla A  y la SubRegla B deben ser diferentes o ya existe la combinación seleccionada"; }
        }

        public static string ErrorPersistenciaEsperada
        {
            get { return "Seleccione el Tipo de Persistencia para guardar el registro!"; }
        }

        public static string MensajePremioxSubRegla
        {
            get { return "El Valor del Premio no puede ser vacio!"; }
        }

        public static string MensajeVariablesTipoLiquidacion
        {
            get { return "La SubRegla Actual no tiene Variables para Liquidación!"; }
        }

        public static string MensajeErrorLiquidacion
        {
            get { return "La Regla que intenta liquidar tiene una (s) SubRegla (s) sin Variables para Liquidación!"; }
        }

        public static string CantidadParticipantesxConcurso
        {
            get { return "El Concurso no tiene Participantes, no se puede liquidar!"; }
        }

        public static string ConcursoPrincipalxAsesores
        {
            get { return "Ya Existe un Concurso Principal de Asesores del año seleccionado!"; }
        }

        public static string ConcursoPrincipalxEjecutivos
        {
            get { return "Ya Existe un Concurso Principal de Ejecutivos del año seleccionado!"; }
        }

        public static string LiquidacionPorRegla
        {
            get { return "La regla tiene liquidaciones asociadas!"; }
        }

        public static string LiquidacionPorxSubRegla
        {
            get { return "La regla asociada a la subregla tiene liquidaciones!"; }
        }
    }
}
