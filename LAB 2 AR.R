install.packages("carData")
library(carData)
head(Duncan)

#Lo mejor ahora es pasar Type a variable categorica
#Ya que type aún no es una variable de factor
#Deberá convertirla para que R la trate como categórica en el modelo.
Duncan$type <- as.factor(Duncan$type)
modelo <- lm(prestige ~ education + income + type, data = Duncan)
summary(modelo)
summary_modelo <- summary(modelo)


#2.Es relevante la variable Education explicando la variabilidad de la variable Prestige en presencia de las otras dos
#variables
pvalor_education <- summary_modelo$coefficients["education", "Pr(>|t|)"]
cat("El p-valor para Education es:", pvalor_education, "\n","El P-valor muestra que se rechaza H0, por ende,","\n","significa que Education explicando la variabilidad de la variable Prestige,En presencia de las otras variabales.")


#3.Es relevante la variable Income explicando la variabilidad de la variable Prestige en presencia de las otras dos variables?
pvalor_income <- summary_modelo$coefficients["income", "Pr(>|t|)"]
cat("El p-valor para Income es:", pvalor_income, "\n","El P-valor muestra que se rechaza H0, por ende,","\n","significa que Income explicando la variabilidad de la variable Prestige,ademas es un predictor significativo,por el valor tan bajo que obtuvimos")

#4.Si se aumenta en 1% el porcentaje de la variable Education en cuánto se espera que aumente la variable Prestige.
# Coeficiente para Education del modelo de regresión
coeficiente_education <- coef(modelo)["education"]

# Calcular el aumento esperado en Prestige para un incremento del 1% en Education
aumento_prestige <- 0.01 * coeficiente_education

# Imprimir el resultado
print(paste("El aumento esperado en Prestige para un incremento del 1% en Education es:", aumento_prestige))

#5. Explique los betas estimados asociados a la variable Type.
# Mostrar los coeficientes estimados para 'typeprof' y 'typewc'
beta_typeprof <- coef(modelo)['typeprof']
beta_typewc <- coef(modelo)['typewc']

# Mostrar en consola
cat("El coeficiente estimado para 'typeprof' es", beta_typeprof, "con un p-valor de", summary_modelo$coefficients["typeprof", "Pr(>|t|)"], ", indicando un aumento estadísticamente significativo en 'Prestige' para la categoría 'prof' en comparación con la categoría de referencia.\n")
cat("El coeficiente estimado para 'typewc' es", beta_typewc, "con un p-valor de", summary_modelo$coefficients["typewc", "Pr(>|t|)"], ", indicando una disminución estadísticamente significativa en 'Prestige' para la categoría 'wc' en comparación con la categoría de referencia.\n")

#Ambos son estadísticamente significativos, como lo indican sus p-valores, lo que significa que las diferencias en Prestige entre estas categorías y la de referencia son consistentes y no atribuibles al azar en el contexto de este modelo. 
#La categoría de referencia es aquella que no se muestra en los resultados y es contra la cual se comparan las demás.

#6.Si se aumenta en 1% el porcentaje de la variable Income en cuánto se espera que aumente la variable Prestige

# El coeficiente para la variable 'Income' es 0.59755, lo que indica que un incremento
# de un punto porcentual en el porcentaje de personas con ingresos de $3,500 o más
# se asocia con un aumento de 0.59755 en la puntuación de Prestige. Esto asume
# que todas las demás variables en el modelo se mantienen constantes.

coeficiente_income <- coef(modelo)["income"]
aumento_prestige <- coeficiente_income * 1 # Multiplicamos por 1 punto porcentual
print(paste("Un aumento de 1 punto porcentual en 'Income' resulta en un aumento de",
            aumento_prestige, "en la variable 'Prestige'."))

#7. Con base en el modelo ajustado. Calcular un intervalo de confianza con nivel ???? = 0.04 para todos betas estimados
#Existe una funcion en R que hace esto automaticamente, pero seria interesante comparar la funcion automatica y paso a paso, ver si se diferencia o son parecidas, para comprobar su vereacidad y error
# Asumiendo que 'modelo' es tu modelo ajustado
# Calcular intervalos de confianza automáticamente
intervalos_automaticos <- confint(modelo, level = 0.96)

# Calcular intervalos de confianza manualmente
alpha <- 0.04
valor_critico <- qt(1 - alpha / 2, df = df.residual(modelo))
errores_std <- summary(modelo)$coefficients[, "Std. Error"]
limites_inferiores_manual <- coef(modelo) - valor_critico * errores_std
limites_superiores_manual <- coef(modelo) + valor_critico * errores_std

# Comparar los intervalos de confianza
comparacion <- data.frame(
  Coeficientes = rownames(intervalos_automaticos),
  LimiteInferiorAutomatico = intervalos_automaticos[, 1],
  LimiteSuperiorAutomatico = intervalos_automaticos[, 2],
  LimiteInferiorManual = limites_inferiores_manual,
  LimiteSuperiorManual = limites_superiores_manual,
  DiferenciaInferior = intervalos_automaticos[, 1] - limites_inferiores_manual,
  DiferenciaSuperior = intervalos_automaticos[, 2] - limites_superiores_manual
)

# Imprimir la comparación
print(comparacion)

# Verificar si los intervalos son similares
# Podemos establecer un umbral de tolerancia para considerar que son "similares", en esto significa que significa que consideramos que dos números son "similares" si su diferencia es menor que 0.0001.
tolerancia <- 1e-4  
intervalos_similares <- abs(comparacion$DiferenciaInferior) < tolerancia &
  abs(comparacion$DiferenciaSuperior) < tolerancia
comparacion$Similares <- intervalos_similares

# Imprimir el resultado de la verificación
print(comparacion)


#8.Calcular un intervalo de predicción con nivel ???? = 0.04 cuando Income = 35
# Preparación de datos para la predicción
valor_medio_education <- mean(Duncan$education, na.rm = TRUE)
levels_type <- levels(Duncan$type)
tipo_mas_frecuente <- names(which.max(table(Duncan$type)))

# Asegurarse de que 'type' en nuevo_dato sea un factor con los mismos niveles que en el modelo original
nuevo_dato <- data.frame(
  education = valor_medio_education, 
  income = 35, 
  type = factor(tipo_mas_frecuente, levels = levels_type)
)

# Calcular el intervalo de predicción 
# MSE, es el error cuadrático medio, que se puede calcular como la suma de los cuadrados de los residuos dividida por los grados de libertad.
mse <- sum(resid(modelo)^2) / modelo$df.residual

# Predicción para el nuevo dato
prediccion <- predict(modelo, newdata = nuevo_dato)

# Varianza de la predicción
X <- model.matrix(~ education + income + type, data = Duncan)
X0 <- model.matrix(~ education + income + type, data = nuevo_dato)
var_prediccion <- sum((X0 %*% solve(t(X) %*% X) %*% t(X0)) * mse)

# Valor crítico t
alpha <- 0.04
t_valor <- qt(1 - alpha / 2, df = modelo$df.residual)

# Margen de error para la predicción
margen_error <- t_valor * sqrt(mse + var_prediccion)

# Intervalo de predicción
intervalo_prediccion_manual <- c(prediccion - margen_error, prediccion + margen_error)
print("Intervalo de predicción 'manual':")
print(intervalo_prediccionl)



#9. Cuáles variables explicativas modelan mejor la variable respuesta Prestige en terminos del criterio BIC?
# Empezamos por definir modelos individuales para cada predictor
modelo_edu <- lm(prestige ~ education, data = Duncan)
modelo_ing <- lm(prestige ~ income, data = Duncan)
modelo_tip <- lm(prestige ~ type, data = Duncan)

# Combinamos predictores para ver su efecto conjunto
modelo_edu_ing <- lm(prestige ~ education + income, data = Duncan)
modelo_edu_tip <- lm(prestige ~ education + type, data = Duncan)
modelo_ing_tip <- lm(prestige ~ income + type, data = Duncan)

# Un modelo con todos los predictores juntos
modelo_todo <- lm(prestige ~ education + income + type, data = Duncan)

# Calculamos el BIC para determinar el modelo óptimo
valores_bic <- c(
  solo_edu = BIC(modelo_edu), 
  solo_ing = BIC(modelo_ing), 
  solo_tip = BIC(modelo_tip), 
  edu_y_ing = BIC(modelo_edu_ing), 
  edu_y_tip = BIC(modelo_edu_tip), 
  ing_y_tip = BIC(modelo_ing_tip), 
  todos = BIC(modelo_todo)
)

# Mostramos los BIC para cada combinación de modelo
print(valores_bic)

# Determinamos cuál modelo tiene el BIC más bajo
mejor_bic <- which.min(valores_bic)
modelo_elegido <- names(valores_bic)[mejor_bic]
mensaje_bic <- paste("El modelo con", modelo_elegido, "tiene el BIC más bajo y es el más adecuado para explicar la variable 'Prestige'.")
print(mensaje_bic)
