﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System;
using System.Globalization;
using System.Web.Mvc;

namespace ColpatriaSAI.UI.MVC.Areas.Comisiones.CustomModelBinders
{

    public class DoubleModelBinder : IModelBinder
    {
        public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            ValueProviderResult valueResult = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);
            ModelState modelState = new ModelState { Value = valueResult };
            object actualValue = null;
            try
            {
                actualValue = Convert.ToDouble(valueResult.AttemptedValue.Replace(".",","), CultureInfo.GetCultureInfo("es-CO"));
            }
            catch (FormatException e)
            {
                modelState.Errors.Add(e);
            }
            bindingContext.ModelState.Add(bindingContext.ModelName, modelState);
            return actualValue;
        }
    }
}