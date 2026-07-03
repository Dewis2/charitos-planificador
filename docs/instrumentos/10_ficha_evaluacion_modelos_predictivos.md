# Ficha de evaluación comparativa de modelos predictivos

**Código:** INS-10  
**Versión:** 1.0  
**Técnica:** análisis predictivo comparativo  
**Estado:** no aplicable a la versión actual; Machine Learning no implementado

## Objetivo

Comparar una línea base y modelos candidatos —el informe propone Random Forest, XGBoost y Prophet— usando una partición temporal reproducible por producto y tienda.

## Diseño de evaluación

- Dataset/hash: ____________________
- Periodo de entrenamiento: ____________________
- Periodo de validación: ____________________
- Periodo de prueba final: ____________________
- Variable objetivo: ____________________
- Unidad/granularidad: ____________________
- Características disponibles al momento del pronóstico: ____________________
- Estrategia temporal: ____________________
- Semilla y entorno: ____________________

## Resultados

| Modelo/versión | Hiperparámetros | MAE | RMSE | MAPE* | Tiempo | Observación |
|---|---|---:|---:|---:|---:|---|
| Línea base heurística | | | | | | |
| Random Forest | | | | | | |
| XGBoost | | | | | | |
| Prophet | | | | | | |

\* MAPE requiere tratamiento explícito cuando la demanda real es cero.

## Validaciones obligatorias

☐ No hay observaciones futuras en entrenamiento ni ingeniería de variables.  
☐ Preprocesamiento ajustado solo con entrenamiento.  
☐ Métricas por SKU/tienda y agregadas con método declarado.  
☐ Se compara contra una línea base simple.  
☐ Se reportan intervalos o variabilidad cuando corresponde.  
☐ Se evalúa impacto operativo, no solo error promedio.  
☐ Modelo, datos, código y entorno están versionados.

## Decisión

- Modelo seleccionado: ____________________
- Criterio: ____________________
- Riesgos y segmentos con bajo desempeño: ____________________
- Aprobó: ____________________ Fecha: ____________________

No completar esta ficha con valores inventados ni con los datos simulados de demostración como si fueran resultados de campo.
