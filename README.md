# Análisis de Regresión Lineal Múltiple sobre Diabetes usando Pima Indians Diabetes Dataset

## Descripción
Este proyecto se centra en la aplicación de **análisis de regresión lineal múltiple** sobre el conjunto de datos **Pima Indians Diabetes** con el objetivo de predecir el nivel de glucosa en sangre en función de varios factores de riesgo. El conjunto de datos contiene variables como el **Índice de Masa Corporal (IMC)**, **edad**, **presión arterial**, **grosor del pliegue cutáneo del tríceps** y **nivel de insulina en suero**, que se analizan para identificar su relación con la glucosa en sangre y su capacidad para predecir la diabetes.

El análisis se realiza utilizando herramientas de **R**, y se evalúan diferentes métodos de selección de variables como **Mejor Subconjunto**, **Forward Selection** y **Backward Elimination**. Se visualizan los datos, se calculan modelos de regresión, y se examinan los residuos para evaluar la calidad del ajuste del modelo.

## Tecnologías y Herramientas Utilizadas:
- **R**: Lenguaje de programación utilizado para realizar el análisis de regresión y la visualización de datos.
- **Paquete `mlbench`**: Para cargar y trabajar con el conjunto de datos **Pima Indians Diabetes**.
- **Regresión Lineal**: Se aplicaron modelos de regresión lineal múltiple para prever los niveles de glucosa.
- **Gráficos de Dispersión**: Visualización de las relaciones entre las variables independientes y la variable dependiente **glucosa**.
- **Selección de Variables**: Métodos de **Mejor Subconjunto**, **Selección hacia Adelante** y **Selección hacia Atrás** para identificar las variables más significativas.

## Objetivos del Proyecto:
1. **Aplicación de Regresión Lineal**: Ajustar un modelo de regresión lineal múltiple para prever los niveles de glucosa en función de varias variables de entrada.
2. **Selección de Variables Significativas**: Utilizar diferentes métodos de selección de variables para mejorar el modelo.
3. **Visualización de Resultados**: Crear gráficos de dispersión con líneas de regresión para visualizar las relaciones entre las variables.
4. **Diagnóstico de Modelo**: Analizar los residuos estandarizados y studentizados para evaluar el ajuste del modelo.

## Resultados Obtenidos:
- **Modelos de Regresión**: Se ajustaron modelos de regresión lineal múltiple utilizando variables como el IMC, edad, presión arterial, grosor del pliegue cutáneo del tríceps y nivel de insulina en suero.
- **R²**: Los valores de **R²** sugieren que el modelo no captura completamente la variabilidad de los niveles de glucosa, pero sí proporciona predicciones útiles.
- **Selección de Variables**: A través del método de **Mejor Subconjunto**, se identificaron las variables más influyentes (IMC, edad, insulina) para la predicción de glucosa.
- **Gráficos**: Se generaron gráficos de dispersión con líneas de regresión para observar la relación de cada variable con el nivel de glucosa en sangre.
- **Análisis de Residuos**: Los residuos estandarizados y studentizados mostraron que el modelo ajustado es razonablemente adecuado, aunque algunos valores atípicos podrían influir en los resultados.

## Enlace a Repositorio
Puedes acceder a los detalles completos del proyecto y al código utilizado en este repositorio de GitHub.
