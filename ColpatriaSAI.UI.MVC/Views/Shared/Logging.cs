using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Diagnostics;
using ColpatriaSAI.Negocio.Entidades.Informacion;

namespace ColpatriaSAI.UI.MVC.Views.Shared
{
    /// <summary>
    /// Nombre del módulo a registrar
    /// </summary>
    public static class Modulo {
        public static readonly string General = "General";
        public static readonly string Contratacion = "Contratación";
        public static readonly string Franquicias = "Franquicias";
        public static readonly string Concursos = "Concursos";
        public static readonly string Jerarquia = "Jerarquia";
    }
    /// <summary>
    /// Estructura para los tipos de eventos
    /// </summary>
    public static class TipoEvento {
        public static TraceEventType Error = TraceEventType.Error;
        public static TraceEventType Advertencia = TraceEventType.Warning;
        public static TraceEventType Critico = TraceEventType.Critical;
        public static TraceEventType Informacion = TraceEventType.Information;
        public static TraceEventType Inicio = TraceEventType.Start;
        public static TraceEventType Parada = TraceEventType.Stop;
    }

    /// <summary>
    /// Clase para registrar eventos de la aplicación en el Event Viewer de Windows
    /// </summary>
    public class Logging
    {
        /// <summary>
        /// Importancia del evento a registrar
        /// </summary>
        public enum Prioridad
        {
            MuyAlta = 4,
            Alta = 3,
            Media = 2,
            Baja = 1
        }

        /// <summary>
        /// Inserta un registro en el Event Viewer con categoria Información
        /// </summary>
        /// <param name="mensaje">Descripción del evento a registrar</param>
        /// <param name="prioridad">Importancia del evento</param>
        /// <param name="modulo">Origen del evento</param>
        /// <param name="InfoAplicacion">Usuario e IP de donde se originó el evento</param>
        public static void Auditoria(string mensaje, Prioridad prioridad, string modulo, InfoAplicacion InfoAplicacion)
        {
            LoggingSvc.LoggingClient log = new LoggingSvc.LoggingClient();
            log.Auditoria(mensaje, Convert.ToInt16(prioridad), modulo, InfoAplicacion);
        }

        /// <summary>
        /// Inserta un registro en el Event Viewer de Windows con categoria Error y Advertencia
        /// </summary>
        /// <param name="mensaje">Descripcion del evento a registrar</param>
        /// <param name="prioridad">Frecuencia con que ocurre el evento</param>
        /// <param name="modulo">Origen del evento</param>
        /// <param name="tipoEvento">Tipo de evento generado</param>
        /// <param name="InfoAplicacion">Usuario e IP de donde se originó el evento</param>
        public static void Error(string mensaje, Prioridad prioridad, string modulo, TraceEventType tipoEvento, InfoAplicacion InfoAplicacion)
        {
            LoggingSvc.LoggingClient log = new LoggingSvc.LoggingClient();
            log.Error(mensaje, Convert.ToInt16(prioridad), modulo, tipoEvento, InfoAplicacion);
        }
    }
}