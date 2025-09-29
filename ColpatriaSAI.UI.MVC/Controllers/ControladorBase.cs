using System;
using System.Data.Linq;
using System.Data.Objects;
using System.Linq;
using System.Web.Mvc;
using System.Configuration;
using System.Web.Configuration;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Reflection;
using System.ComponentModel;
using ColpatriaSAI.Datos;
using ColpatriaSAI.Seguridad.Encripcion;
using System.Data;

namespace ColpatriaSAI.UI.MVC.Controllers
{
    [AuthorizaciondeCuenta]
    [FiltroSessionExpira]
    [Auditoria]
    public class ControladorBase : Controller
    {
    }
}
