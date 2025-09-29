using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ColpatriaSAI.UI.MVC.EjecucionETLs;
using ColpatriaSAI.Negocio.Entidades.Informacion;
using ColpatriaSAI.Negocio.Entidades;

namespace ColpatriaSAI.UI.MVC.Comun
{
    public class ETL
    {
        public EjecucionETLsClient ClienteEjecucionETLs { get; private set; }

        public static List<TipoETLRemota> ListarTiposETLRemota()
        {
            using (EjecucionETLsClient ClienteEjecucionETLs = new EjecucionETLsClient())
            {
                return ClienteEjecucionETLs.ListarTiposETLRemota().ToList();
            }
        }

        public static List<ETLRemota> ListarETLsRemotas()
        {
            using (EjecucionETLsClient ClienteEjecucionETLs = new EjecucionETLsClient())
            {
                return ClienteEjecucionETLs.ListarETLsRemotas().ToList();
            }
        }

        public static ETLRemota ObtenerETLRemotaporId(int id)
        {
            using (EjecucionETLsClient ClienteEjecucionETLs = new EjecucionETLsClient())
            {
                return ClienteEjecucionETLs.ObtenerETLRemotaporId(id);
            }
        }

        public static List<ETLRemota> ListarETLsRemotasporTipo(int tipoETLRemota_id)
        {
            using (EjecucionETLsClient ClienteEjecucionETLs = new EjecucionETLsClient())
            {
                return ClienteEjecucionETLs.ListarETLsRemotasporTipo(tipoETLRemota_id).ToList();
            }
        }

        public static void EjecutarETL(ETLRemota eTLRemota, Dictionary<string, object> parametros, InfoAplicacion info)
        {
            using (EjecucionETLsClient ClienteEjecucionETLs = new EjecucionETLsClient())
            {
                ClienteEjecucionETLs.EjecutarETL(eTLRemota, parametros, info);
            }
        }
    }
}