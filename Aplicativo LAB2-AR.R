if (!requireNamespace("mlbench", quietly = TRUE))
  install.packages("mlbench")
library(mlbench)
data("PimaIndiansDiabetes")
head(PimaIndiansDiabetes)
# Carga de la base de datos, si no está ya cargada
# data(PimaIndiansDiabetes, package = "MASS")

# Selección de las cinco variables de interés
datos <- PimaIndiansDiabetes[, c("glucose", "mass", "age", "pressure", "triceps", "insulin")]

# Ajuste de un modelo de regresión lineal múltiple
modelo_mult <- lm(glucose ~ mass + age + pressure + triceps + insulin, data = datos)
summary(modelo_mult)

# Crear gráficos de dispersión para cada variable contra 'glucose' e incluir la línea de regresión
# Suponiendo que ya has cargado la base de datos PimaIndiansDiabetes y la has asignado a la variable datos.

# Generar un gráfico de dispersión para cada variable explicativa vs. glucosa
# y ajustar un modelo de regresión lineal simple

par(mfrow=c(3,2)) # Establecer un layout para mostrar múltiples gráficos

variables_explicativas <- c("mass", "age", "pressure", "triceps", "insulin")

for(variable in variables_explicativas) {
  # Ajustar el modelo lineal simple
  modelo <- lm(as.formula(paste("glucose ~", variable)), data = datos)
  
  # Crear el gráfico de dispersión
  plot(datos[[variable]], datos$glucose,
       main = paste("Glucosa vs", variable),
       xlab = variable, ylab = "Nivel de Glucosa en Sangre",
       pch = 19, col = "blue")
  
  # Añadir la línea de regresión
  abline(modelo, col = "red", lwd = 2)
  
  # Añadir el valor de R^2 al gráfico
  legend("topright", bty = "n", legend = paste("R^2 =", round(summary(modelo)$r.squared, digits = 4)))
}

# Restaurar el layout original
par(mfrow=c(1,1))


variables <- c("mass", "age", "pressure", "triceps", "insulin") # Ajusta esto a tus variables
combinaciones <- list()

# Genera todas las combinaciones posibles de las variables
for (i in 1:length(variables)) {
  combinaciones[[i]] <- combn(variables, i, simplify = FALSE)
}
combinaciones <- unlist(combinaciones, recursive = FALSE) # Aplana la lista

aic_values <- sapply(combinaciones, function(vars) {
  formula <- as.formula(paste("glucose ~", paste(vars, collapse = "+")))
  model <- lm(formula, data = datos)
  AIC(model)
})

best_model_index <- which.min(aic_values)
best_model_vars <- combinaciones[[best_model_index]]
best_model_formula <- as.formula(paste("glucose ~", paste(best_model_vars, collapse = "+")))

best_model <- lm(best_model_formula, data = datos)
summary(best_model)

# Instalar y cargar el paquete necesario si aún no está instalado
if (!require(MASS)) install.packages("MASS")
library(MASS)

# Inicializar el modelo con el intercepto (modelo base sin variables)
modelo_base <- lm(glucose ~ 1, data = datos)

# Definir las variables a considerar para la selección hacia adelante
variables <- c("mass", "age", "pressure", "triceps", "insulin")

# Inicializar el modelo forward con el modelo base
modelo_forward <- modelo_base
aic_forward <- AIC(modelo_forward)

# Ciclo para ir agregando variables una por una
for (var in variables) {
  # Crear un modelo temporal añadiendo la variable actual al modelo forward
  formula_temp <- as.formula(paste("glucose ~", paste(var, collapse = "+"), "+", paste(names(coef(modelo_forward))[-1], collapse = "+")))
  modelo_temp <- lm(formula_temp, data = datos)
  
  # Comparar el AIC del modelo temporal con el AIC del modelo forward
  aic_temp <- AIC(modelo_temp)
  if (aic_temp < aic_forward) {
    # Actualizar el modelo forward y su AIC si el modelo temporal es mejor
    modelo_forward <- modelo_temp
    aic_forward <- aic_temp
  }
}

# Al final del ciclo, modelo_forward contiene el mejor modelo encontrado
summary(modelo_forward)


backward_model <- lm(glucose ~ mass + age + pressure + triceps + insulin, data = datos)
variables <- colnames(datos[, c("mass", "age", "pressure", "triceps", "insulin")])

for (var in variables) {
  # Intenta eliminar cada variable del modelo actual y guarda el modelo temporal
  temp_model <- update(backward_model, formula = . ~ . - var)
  
  # Evalúa si el modelo mejora significativamente y actualiza el mejor modelo actual
  # Aquí puedes usar el criterio que prefieras, como el AIC, BIC o el p-value
  if (AIC(temp_model) < AIC(backward_model)) {
    backward_model <- temp_model
  }
}
summary(backward_model)

modelo_final <- lm(formula = glucose ~ mass + age + triceps + insulin, data = datos)
residuales_estandarizados <- rstandard(modelo_final)
residuales_studentizados <- rstudent(modelo_final)
# Gráfico de residuales estandarizados
plot(residuales_estandarizados, main="Residuales Estandarizados", ylab="Residuales Estandarizados", xlab="Número de Observación")
abline(h = c(-2, 2), col = "red")

# Gráfico de residuales studentizados
plot(residuales_studentizados, main="Residuales Studentizados", ylab="Residuales Studentizados", xlab="Número de Observación")
abline(h = c(-2, 2), col = "red")

outliers <- which(abs(residuales_studentizados) > 2)
datos[outliers, ]
