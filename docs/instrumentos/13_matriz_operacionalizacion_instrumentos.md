# Matriz de operacionalización de instrumentos

**Código:** INS-MAT-01  
**Versión:** 1.0  
**Fuente:** Tabla 5 y anexos 01–04 del informe actual

| Variable/dimensión | Indicador | Instrumento | Dato/escala | Estado frente a la app |
|---|---|---|---|---|
| Implementación tecnológica | módulo operativo e integrado al flujo | INS-08 despliegue | nominal Sí/No | App móvil operativa; ML no operativo |
| Modelo predictivo | algoritmo, ventana, MAE/RMSE/MAPE | INS-10 evaluación de modelos | razón | Pendiente; solo heurística |
| Ingeniería de características | variables temporales, rezagos, tienda | INS-09 + INS-10 | discreta/nominal | Rezagos heurísticos parciales; pipeline ML pendiente |
| Uso operativo | decisiones aceptadas/modificadas | INS-03 + INS-07 | porcentaje | Captura no implementada |
| Precisión de pronóstico | MAE, RMSE, MAPE por SKU/tienda | INS-10 + ventas | razón | No evaluable como ML todavía |
| Reducción de merma | unidades y tasa de merma | INS-01 + INS-02 | razón | Registro implementado; comparación real pendiente |
| Optimización de producción | producido − vendido y sobreproducción | INS-04 + INS-02 | razón | Datos registrables; análisis pre/post pendiente |
| Adopción | facilidad, utilidad, confianza e intención | INS-06 + INS-07 | Likert/observación | Instrumentos diseñados; sin aplicación |
| Calidad de datos | completitud, duplicados, atípicos | INS-09 | porcentaje/nominal | Validación CSV parcial; profiling pendiente |
| Control de caja | diferencias, anulaciones, devoluciones | INS-05 | razón | Fuera de la app actual |

## Periodos citados por el informe

La Tabla 5 menciona pretest enero–junio de 2025, postest octubre–diciembre de 2025, perfilado junio–julio y modelos julio–agosto. Otras secciones describen un cronograma de enero–diciembre de 2026. Antes de aplicar los instrumentos debe aprobarse **una única línea temporal** y corregirse la versión final del informe.

## Validez y confiabilidad

| Mecanismo citado | Evidencia necesaria | Estado |
|---|---|---|
| Validez de contenido por asesor y experto operativo | fichas de juicio, observaciones, versión final y firmas | Pendiente |
| Validez de constructo | fundamento de métricas y correspondencia con variables | Documentada de forma conceptual |
| Validez ecológica | actas que prueben aplicación en operación real | Pendiente |
| Consistencia de logs automáticos | pruebas y auditoría de campos/fechas | Parcial; log de decisiones falta |
| Perfilado de datos | reporte reproducible y dataset con hash | Pendiente |
| Alfa de Cronbach ≥ 0,70 | respuestas, cálculo, tamaño muestral y análisis | Pendiente |

## Criterio de uso

No marcar una dimensión como lograda por haber creado el instrumento. El resultado requiere aplicación válida, datos reales, análisis reproducible y revisión del equipo investigador.
