using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Web.Mvc;
using System.ComponentModel;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.Models.ViewModels
{
    public class BitacoraComisionCalculada
    {
        [DisplayName("No. Extración")]
        public string numExtraccion { get; set; }

        [DisplayName("Usuarios Extraidos de BH")]
        public long usuariosEntrantes { get; set; }

        [DisplayName("Usuarios Procesados")]
        public long UsuariosSalientes { get; set; }
    }
}