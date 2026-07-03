# Calidad del producto basada en ISO/IEC 25000

**Código:** ISO-SQR-01  
**Versión:** 1.0  
**Modelo usado:** ISO/IEC 25010:2023  
**Estado:** criterios definidos; evaluación parcial

## Objeto de evaluación

APK Android de Charito's Planifica, su base SQLite, importación/exportación CSV y servicios de cálculo. La evaluación no incluye un backend, una web ni un modelo ML porque esos componentes no existen en la versión actual.

ISO/IEC 25010:2023 organiza la calidad del producto en nueve características. Para este proyecto se operativizan así:

| Característica | Criterio para Charito's Planifica | Métrica / prueba | Estado inicial |
|---|---|---|---|
| Adecuación funcional | Registra productos, stock, producción, ventas, merma, lotes y pedidos; genera reportes y recomendaciones. | % requisitos críticos aprobados | Implementado; aceptación de usuario pendiente |
| Eficiencia de desempeño | Operación fluida con el catálogo y periodo de estudio. | tiempo de apertura, importación y reporte; uso de memoria | Pendiente de medir en celular objetivo |
| Compatibilidad | Coexiste con otras apps y comparte CSV mediante funciones Android. | pruebas de instalación, importación y exportación | Parcial |
| Capacidad de interacción | Pantallas comprensibles, mensajes claros y flujo aprendible. | encuesta, observación, tasa de errores y tareas completadas | Pendiente de aplicar |
| Fiabilidad | No pierde registros y mantiene resultados coherentes. | tasa de fallos, reinicio, persistencia, recuperación | Persistencia local implementada; respaldo pendiente |
| Seguridad | Protege confidencialidad, integridad y disponibilidad. | revisión de acceso, archivos, respaldo y dependencias | Brechas: sin autenticación ni cifrado de exportaciones |
| Mantenibilidad | Capas separadas, reglas probables y cambios localizados. | análisis estático, cobertura, complejidad y revisión | Arquitectura por capas y pruebas parciales |
| Flexibilidad | Permite cambios de catálogo, parámetros y predictor. | prueba de configuración, portabilidad/adaptación | Parcial; Android es el destino probado |
| Seguridad operacional (*safety*) | Evita que una recomendación errónea se interprete como orden obligatoria. | límites, explicación, revisión humana y registro de decisión | Explicación parcial; log de decisión pendiente |

## Métricas mínimas

| ID | Métrica | Fórmula / método | Criterio propuesto |
|---|---|---|---|
| Q-01 | Cobertura funcional | casos críticos aprobados / casos críticos × 100 | 100 % antes de liberar |
| Q-02 | Exactitud de importación | filas válidas importadas / filas válidas × 100 | 100 % |
| Q-03 | Rechazo correcto | filas inválidas rechazadas / filas inválidas × 100 | 100 % en casos diseñados |
| Q-04 | Tiempo de importación | segundos para dataset de referencia | línea base + meta aprobada |
| Q-05 | Fallos por sesión | cierres inesperados / sesiones | 0 durante piloto controlado |
| Q-06 | Completitud | registros con campos requeridos / total × 100 | ≥ 99 % o meta aprobada |
| Q-07 | Usabilidad | tareas completadas sin ayuda / tareas × 100 | ≥ 90 % propuesto |
| Q-08 | Satisfacción | media de ítems Likert pertinentes | ≥ 4/5 propuesto |
| Q-09 | Calidad estática | incidencias de `flutter analyze` | 0 |
| Q-10 | Restauración | restauraciones correctas / simulacros × 100 | 100 % |

Las metas propuestas necesitan aprobación; no son resultados.

## Evidencia disponible

- restricciones de integridad y claves foráneas en `database_helper.dart`;
- validadores e importador CSV;
- cálculo FEFO, stock vendible y lotes con vencimiento;
- servicios desacoplados mediante repositorio y contrato `DemandPredictor`;
- pruebas unitarias de cálculo, recomendación e importación;
- documentación de requisitos, reglas, arquitectura y limitaciones.

## Brechas prioritarias

1. Medir desempeño y usabilidad en el celular realmente usado.
2. Añadir pruebas de widget/integración, recuperación y grandes volúmenes.
3. Registrar versión de APK, dispositivo y evidencia de aceptación.
4. Implementar autenticación o un control operativo equivalente si el equipo es compartido.
5. No evaluar “precisión ML” hasta que exista un modelo y un conjunto temporal independiente.

## Criterio de conclusión

La calidad debe concluirse por característica y evidencia. Un resultado global solo será válido si se documentan el método de agregación, los pesos y las limitaciones; no debe confundirse una lista de funciones con conformidad integral a ISO/IEC 25010.
