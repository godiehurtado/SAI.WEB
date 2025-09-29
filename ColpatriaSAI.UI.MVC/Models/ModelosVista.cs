using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using ColpatriaSAI.Negocio.Entidades;
using System.Web.UI.WebControls;

namespace ColpatriaSAI.UI.MVC.Models
{
    public class LocalidadViewModel
    {
        public Localidad LocalidadView { get; set; }
        public SelectList ZonaList { get; set; }
        public SelectList TipoLocalidad { get; set; }
    }

    public class ZonaViewModel
    {
    }

    public class ResumenConcursoViewModel
    {
        public ResumenConcursoViewModel ResumenConcursoView { get; set; }
        public SelectList ParticipanteConcursoList { get; set; }
        public SelectList ProductoConcursoList { get; set; }
        public SelectList MonedaProductoList { get; set; }
        public SelectList TopeMonedaList { get; set; }
        public SelectList ReglaList { get; set; }
        public SelectList SubreglaList { get; set; }
        public SelectList CondicionList { get; set; }
        public SelectList PremioxSubReglaList { get; set; }

    }

    public class MonedaViewModel
    {
        public Moneda MonedaView { get; set; }
        public SelectList UnidadMedidaList { get; set; }
        public SelectList SegmentoList { get; set; }
    }

    public class BeneficiarioViewModel
    {
        public Beneficiario BeneficiarioView { get; set; }
        public SelectList ClienteList { get; set; }
    }

    public class PersistenciaEsperadaViewModel
    {
        public PersistenciaEsperada PersistenciaEsperadaView { get; set; }
        public SelectList PlazoList { get; set; }
    }

    public class SiniestralidadEsperadaViewModel
    {
        public SiniestralidadEsperada SiniestralidadEsperadaView { get; set; }
    }

    public class LineaNegocioViewModel
    {
        public LineaNegocio LineaNegocioView { get; set; }
        public SelectList CompaniaList { get; set; }
    }

    public class RamoViewModel
    {
        public Ramo RamoView { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
    }

    public class RamoDetalleViewModel
    {
        public RamoDetalle RamoDetalleView { get; set; }
    }

    public class CanalViewModel
    {
        public Canal CanalView { get; set; }
    }

    public class PremiosAnterioresViewModel
    {
        public PremiosAnteriore PremiosAnterioresView { get; set; }
    }

    public class PersistenciaCAPIDetalleViewModel
    {
        public PersistenciadeCAPIDetalle PersistenciaCAPIDetalleView { get; set; }
    }

    public class ParametrosAppViewModel
    {
        public ParametrosApp ParametrosAppView { get; set; }
    }

    public class VariableViewModel
    {
        public Variable VariableView { get; set; }
        public SelectList TipovariableList { get; set; }
    }

    public class ProductoViewModel
    {
        public Producto ProductoView { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList CompaniaList { get; set; }
    }

    public class AntiguedadViewModel
    {
        public AntiguedadxNivel AntiguedadView { get; set; }
        public SelectList NivelList { get; set; }
    }

    public class ConcursoViewModel
    {
        public Concurso ConcursoView { get; set; }
        public SelectList TipoConcursoList { get; set; }
        public SelectList SegmentoList { get; set; }
    }

    public class ParticipanteConcursoViewModel
    {
        public ParticipanteConcurso ParticipanteConcursoView { get; set; }
        public SelectList SegmentoList { get; set; }
        public SelectList CategoriaList { get; set; }
        public SelectList CanalList { get; set; }
        public SelectList NivelList { get; set; }
        public SelectList LocalidadList { get; set; }
        public SelectList ZonaList { get; set; }
        public SelectList ParticipanteList { get; set; }
        public SelectList CompaniaList { get; set; }
    }

    public class ReglaViewModel
    {
        public Regla ReglaView { get; set; }
        public SelectList TipoReglaList { get; set; }
        public SelectList PeriodoReglaList { get; set; }
        public SelectList EstrategiaReglaList { get; set; }
        public SelectList ConcursoList { get; set; }
        public MultiSelectList ConceptoDescuentoList { get; set; }
    }

    public class SubReglaViewModel
    {
        public SubRegla SubReglaView { get; set; }
        public SelectList PremioList { get; set; }
    }

    public class CondicionViewModel
    {
        public Condicion CondicionView { get; set; }
        public SelectList VariableList { get; set; }
        public SelectList OperadorList { get; set; }
        public SelectList tablaList { get; set; }
    }

    public class CondicionxPremioSubReglaViewModel
    {
        public CondicionxPremioSubregla CondicionxPremioSubreglaView { get; set; }
        public SelectList VariableList { get; set; }
        public SelectList OperadorList { get; set; }
    }

    public class CondicionAgrupadaViewModel
    {
        public CondicionAgrupada CondicionAgrupadaView { get; set; }
        public SelectList OperadorList { get; set; }
        public SelectList SubRegla1List { get; set; }
        public SelectList SubRegla2List { get; set; }
    }

    public class MonedaxNegocioViewModel
    {
        public MonedaxNegocio MonedaxNegocioView { get; set; }
        public SelectList ProductoList { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList LineaNegocioList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList AmparoList { get; set; }
        public SelectList CoberturaList { get; set; }
        public SelectList ActividadEconomicaList { get; set; }
        public SelectList ModalidadPagoList { get; set; }
        public SelectList PlanList { get; set; }
        public SelectList RedList { get; set; }
        public SelectList BancoList { get; set; }
        public SelectList ComboList { get; set; }
        public SelectList SegmentoList { get; set; }
        public SelectList TipoVehiculoList { get; set; }
        public SelectList LocalidadList { get; set; }
        public SelectList ZonaList { get; set; }
    }

    public class MaestroMonedaxNegocioViewModel
    {
        public MaestroMonedaxNegocio MaestroMonedaxNegocioView { get; set; }
        public SelectList MonedaList { get; set; }
    }

    public class ProductoConcursoViewModel
    {
        public ProductoConcurso ProductoConcursoView { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList ConcursoList { get; set; }
        public SelectList LineaNegocioList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }

    }

    public class EtapaProductoViewModel
    {
        public EtapaProducto EtapaProductoView { get; set; }

    }

    public class CompaniaxEtapaViewModel
    {
        public CompaniaxEtapa CompaniaxEtapaView { get; set; }
        public SelectList CompaniaList { get; set; }

    }

    public class PremioxSubReglaViewModel
    {
        public PremioxSubregla PremioxSubReglaView { get; set; }
        public SelectList PremioList { get; set; }
        public SelectList SubReglaList { get; set; }

    }

    public class UnidadMedidaViewModel
    {
        public UnidadMedida UnidadMedidaView { get; set; }
        public SelectList TipoUnidadMedidaList { get; set; }

    }

    public class TipoUnidadMedidaViewModel
    {
        public TipoUnidadMedida TipoUnidadMedidaView { get; set; }

    }

    public class PremioViewModel
    {
        public Premio PremioView { get; set; }
        public SelectList OperadorList { get; set; }
        public SelectList UnidadMedidaList { get; set; }
        public SelectList TipoPremiosList { get; set; }
        public SelectList VariableList { get; set; }
    }

    public class TipoPremioViewModel
    {
        public TipoPremio TipoPremioView { get; set; }
        public SelectList UnidadMedidaList { get; set; }
        public SelectList PagoList { get; set; }
    }

    public class TopeMonedaViewModel
    {
        public TopeMoneda TopeMonedaView { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }
    }

    public class TopexEdadViewModel
    {
        public TopexEdad TopexEdadView { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }
    }

    public class NivelViewModel
    {
        public Nivel NivelView { get; set; }
    }

    public class LogIntegracionBzViewModel
    {
        public LogIntegracionwsIntegrador LogIntegracionBzView { get; set; }
    }

    public class LogIntegracion
    {
        public LogIntegracion LogIntegracionView { get; set; }
    }

    public class P_P_VidaViewModel
    {
        public ParametrosPersistenciaVIDA P_P_VidaView { get; set; }
    }

    public class SegmentoViewModel
    {
        public Segmento SegmentoView { get; set; }
    }

    public class CoberturaViewModel
    {
        public Cobertura CoberturaView { get; set; }
    }

    public class AmparoViewModel
    {
        public Amparo AmparoView { get; set; }
    }

    public class ActividadEconomicaViewModel
    {
        public ActividadEconomica ActividadEconomicaView { get; set; }
    }

    public class ParticipanteViewModel
    {
        public Participante ParticipanteView { get; set; }
        public SelectList NivelList { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList ZonaList { get; set; }
        public SelectList LocalidadList { get; set; }
        public SelectList CanalList { get; set; }
        public SelectList CategoriaList { get; set; }
        public SelectList TipoDocumentoList { get; set; }
        public SelectList ModalidadPagoList { get; set; }
        public SelectList SegmentoList { get; set; }
        public SelectList TipoParticipanteList { get; set; }
        public SelectList EstadoParticipanteList { get; set; }
    }

    public class MultijerarquiaViewModel
    {
        public Multijerarquia MultijerarquiaView { get; set; }
        public SelectList SegmentoList { get; set; }
        public SelectList ParticipanteList { get; set; }
        public SelectList CompaniaList { get; set; }

    }

    public class MetaModel
    {
        public Meta Meta { get; set; }
        public List<Meta> MetaList { get; set; }
        public SelectList TipoMetaList { get; set; }
        public SelectList VariableList { get; set; }
        public SelectList FactorNota { get; set; }
        public List<ProductosMeta> ProductosMetaList { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }
        public SelectList LineaNegocioList { get; set; }
        public ProductosMeta ProductosMeta { get; set; }
        public List<MetaCompuesta> MetaCompuestaList { get; set; }
        public SelectList ModalidadPagoList { get; set; }
        public SelectList AmparoList { get; set; }
        public Boolean Acumulada { get; set; }
        public SelectList MetaMensualList { get; set; }
    }

    public class PlanViewModel
    {
        public Plan PlanView { get; set; }
        public SelectList ProductoList { get; set; }
        public SelectList AmparoList { get; set; }
        public SelectList CoberturaList { get; set; }
        public SelectList PlazoList { get; set; }
        public SelectList ModalidadPagoList { get; set; }

    }

    public class BaseMonedaViewModel
    {
        public BaseMoneda BaseMonedaView { get; set; }
        public SelectList MonedaList { get; set; }
    }

    public class BasexParticipanteViewModel
    {
        public BasexParticipante BasexParticipanteView { get; set; }
        public SelectList ParticipanteList { get; set; }
    }

    public class CategoriaViewModel
    {
        public Categoria CategoriaView { get; set; }
        public SelectList NivelList { get; set; }
    }

    public class CompaniaViewModel
    {
        public Compania CompaniaView { get; set; }
    }

    public class EscalaNotaViewModel
    {
        public EscalaNota EscalaNotaView { get; set; }
        public SelectList TipoEscalaList { get; set; }
    }

    public class FactorxNotaViewModel
    {
        public FactorxNota FactorxNotaView { get; set; }
        public SelectList TipoEscalaList { get; set; }
    }

    public class ExcepcionesporGrupoTipoEndosoViewModel
    {
        public ExcepcionesxGrupoTipoEndoso ExcepcionesxGrupoTipoEndosoView { get; set; }
        public SelectList GrupoEndosoList { get; set; }
        public SelectList TipoEndosoList { get; set; }
        public SelectList CompaniaList { get; set; }
    }
    
    public class ParticipacionFranquiciaModel
    {
        public string Partfranquiciaid { get; set; }
        public string Fechaini { get; set; }
        public string Fechafin { get; set; }
        public string FechaActualizacion { get; set; }
        public List<DetalleParticipacionFranquicia> DetalleParticipacionFranquicia { get; set; }
    }
    
    public class DetalleParticipacionFranquicia
    {
        public ParticipacionFranquicia ParticipacionFranquiciaView { get; set; }
        public ColpatriaSAI.Negocio.Entidades.TrackableCollection<ColpatriaSAI.Negocio.Entidades.DetallePartFranquicia> DetParticipacionFranquiciaView { get; set; }
        public string Partfranquiciaid { get; set; }
        public SelectList Compania { get; set; }
        public SelectList Ramo { get; set; }
        public SelectList Producto { get; set; }
        public string Porcentaje { get; set; }
        public SelectList Plan { get; set; }
        public System.Collections.Generic.List<System.Web.Mvc.SelectListItem> LineaNegocio { get; set; }
        public SelectList TipoVehiculo { get; set; }
        public string RangoInf { get; set; }
        public string RangoSup { get; set; }
        public System.Collections.Generic.List<System.Web.Mvc.SelectListItem> Amparo { get; set; }
    }

    public class ParticipacionFranquicia2Model
    {
        public string Partfranquiciaid { get; set; }
        public string Fechaini { get; set; }
        public string Fechafin { get; set; }
        public string FechaActualizacion { get; set; }
        public string DetaPartidUpdate { get; set; }
        public List<DetalleParticipacion2Franquicia> DetalleParticipacion2Franquicia { get; set; }
        public string Franquicias { get; set; }


    }
    
    public class DetalleParticipacion2Franquicia
    {
        public string Partfranquiciaid { get; set; }
        public int Compania { get; set; }
        public int Ramo { get; set; }
        public int Producto { get; set; }
        public string Porcentaje { get; set; }
        public int Plan { get; set; }
        public int LineaNegocio { get; set; }
        public int TipoVehiculo { get; set; }
        public string RangoInf { get; set; }
        public string RangoSup { get; set; }
        public int Amparo { get; set; }
    }
    
    public class ModeloXMetaViewModel
    {
        public ModeloxMeta ModeloxMetaView { get; set; }
        public SelectList ModeloList { get; set; }
        public SelectList MetaList { get; set; }
        public SelectList FactorList { get; set; }
    }

    public class ModeloxParticipanteViewModel
    {
        public SelectList ModeloList { get; set; }
        public SelectList NivelList { get; set; }
        public SelectList ZonaList { get; set; }
        public SelectList LocalidadList { get; set; }
        public SelectList ParticipanteList { get; set; }
        public ModeloxNodo ModeloxParticipanteView { get; set; }
    }

    public class ExcepcionesModel
    {
        public string idexcepcion { get; set; }
        public string fechaini { get; set; }
        public string fechafinal { get; set; }
        public string compania { get; set; }
        public string linneg { get; set; }
        public string ramo { get; set; }
        public string producto { get; set; }
        public string participante { get; set; }
        public string negocio { get; set; }
        public string poliza { get; set; }
        public string estado { get; set; }
        public string porcentaje { get; set; }
    }

    public class ExcepcionFranquiciaModel
    {
        public Excepcion Excepcion { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }
        public SelectList LineaNegocioList { get; set; }
        public SelectList TipoVehiculoList { get; set; }
        public SelectList LocalidadList { get; set; }
        public SelectList LocalidadDeList { get; set; }
        public Participante participante { get; set; }

    }

    public class CanalxModeloViewModel
    {
        public SelectList ModeloList { get; set; }
        public SelectList CanalList { get; set; }
    }

    public class ArchivosResultViewModel
    {
        public string Thumbnail_url { get; set; }
        public string Name { get; set; }
        public int Length { get; set; }
        public string Type { get; set; }
    }
    /*
    public class PresupuestoDetalles {
        public String id { get; set; }
        public String Nombre_Nodo { get; set; }
        public String CodNivel { get; set; }
        public String Nombre_participante { get; set; }
        public String Codigo_meta { get; set; }
        public String Año { get; set; }
        public Double Enero { get; set; }
        public Double Febrero { get; set; }
        public Double Marzo { get; set; }
        public Double Abril { get; set; }
        public Double Mayo { get; set; }
        public Double Junio { get; set; }
        public Double Julio { get; set; }
        public Double Agosto { get; set; }
        public Double Septiembre { get; set; }
        public Double Octubre { get; set; }
        public Double Noviembre { get; set; }
        public Double Diciembre { get; set; }
    }
    */
    public class PpacionDirectorViewModel
    {
        public SelectList CompaniaList { get; set; }
        public SelectList CanalList { get; set; }
        public ParticipacionDirector PpanteDirectorView { get; set; }
    }

    public class ParticipacionViewModel
    {
        public SelectList CompaniaList { get; set; }
        public SelectList LineaNegocioList { get; set; }
        public SelectList RamoList { get; set; }
        public Participacione ParticipacionView { get; set; }
    }

    public class ExcepcionJerarquiaDetalleModel
    {
        public ExcepcionJerarquiaDetalle ExcepcionJerarquia { get; set; }
        public JerarquiaDetalle JerarquiaOrigen { get; set; }
        public JerarquiaDetalle JerarquiaDestino { get; set; }
        public Ramo Ramo { get; set; }
        public Producto Producto { get; set; }
        public List<Compania> CompaniaList { get; set; }
        public List<Meta> MetaList { get; set; }
        public List<ExcepcionJerarquiaDetalle> ExcepcionJerarquiaDetalleList { get; set; }
    }

    public class MetaJerarquiaModel
    {
        public List<MetaxNodo> MetaJerarquiaList { get; set; }
    }

    public class MetaValidacionCumplimientoModel
    {
        //public List<MetaValidacionCumplimiento> MetaValidacionCumplimientoList { get; set; }
    }


    public class CargaColquines
    {
        public Int32? Clave { get; set; }
        public String Concepto { get; set; }
        public DateTime? Fecha { get; set; }
        public Int32? SegmentoId { get; set; }
        public Int32? CompaniaId { get; set; }
        public Int32? Cantidad { get; set; }
    }

    public class LiquidacionMonedaModel
    {
        public List<LiquidacionMoneda> LiquidacionMonedaList { get; set; }

    }

    public class CargaEjecuciones
    {
        public String CodigoNivel { get; set; }
        public String NombreNodo { get; set; }
        public Int32 MetaId { get; set; }
        public String Enero { get; set; }
        public String Febrero { get; set; }
        public String Marzo { get; set; }
        public String Abril { get; set; }
        public String Mayo { get; set; }
        public String Junio { get; set; }
        public String Julio { get; set; }
        public String Agosto { get; set; }
        public String Septiembre { get; set; }
        public String Octubre { get; set; }
        public String Noviembre { get; set; }
        public String Diciembre { get; set; }
    }

    public class CargaParticipantesModelo
    {
        public DateTime FechaInicial { get; set; }
        public DateTime FechaFinal { get; set; }
        public Int32 IdNivel { get; set; }
        public Int32 IdZona { get; set; }
        public Int32 IdLocalidad { get; set; }
        public String CodigoNivel { get; set; }
        public Int32 IdModelo { get; set; }
    }

    public class IngresoLocalidadModel
    {
        public List<IngresoLocalidad> IngresosLocalidades { get; set; }
        public SelectList Localidad { get; set; }
        public SelectList Grupo { get; set; }
        public IngresoLocalidad IngresoLocalidad { get; set; }
    }

    public class PeriodoCierreModel
    {
        public PeriodoCierre PeriodoCierre { get; set; }
        public List<Compania> CompaniaList { get; set; }
        public List<PeriodoCierre> PeriodoCierreList { get; set; }
    }

    public class AjustesModel
    {
        public List<DetallePagosRegla> listaPagosConcurso { get; set; }
        public List<LiquiContratFactorParticipante> listaPagosContratos { get; set; }
        public List<DetallePagosFranquicia> listaPagosFranquicia { get; set; }
    }

    public class ComboModel
    {
        public Combo Combo { get; set; }
        public List<Combo> ComboList { get; set; }
        public List<ProductoCombo> ProductoComboList { get; set; }
        public SelectList CompaniaList { get; set; }
        public SelectList RamoList { get; set; }
        public SelectList ProductoList { get; set; }
        public ProductoCombo ProductoCombo { get; set; }
        public List<MetaCompuesta> MetaCompuestaList { get; set; }

    }

    public class CategoriaReglaModel
    {
        public int categoria_id { get; set; }
        public string categoria_nombre { get; set; }
        public int categoriaxRegla_id { get; set; }
        public bool esColquin { get; set; }
        public bool esRecaudo { get; set; }
    }    

    public class ClaveProveedorHistorico
    {
        public string clave_old { get; set; }
        public string clave_new { get; set; }
        public DateTime fecha { get; set; }
        public string usuario { get; set; }
        public Int32 ind_actualizacion { get; set; }
    }

    public class AuditoriaViewModel
    {
        public IDictionary<int, string> Tablas { get; set; }
    }

    public class EjecucionesViewModel
    {
        public string idEjecucion { get; set; }
        public string fechaInicio { get; set; }
        public string fechaFin { get; set; }
        public string estado { get; set; }
        public string ultimaFecha { get; set; }
        public string penultimaFecha { get; set; }
        public List<AUT_Proceso> procesos { get; set; }
    }

    public class EstadisticasViewModel
    {
        public string mesactual { get; set; }
        public string mesanterior { get; set; }
    }
}
