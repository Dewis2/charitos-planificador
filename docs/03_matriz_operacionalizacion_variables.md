# Matriz de operacionalización de variables

## Variable independiente: aplicación móvil offline perfilada para Machine Learning

| Variable | Dimensión | Indicador | Instrumento | Sustento o relación con el sistema |
|---|---|---|---|---|
| Aplicación móvil offline perfilada para ML | Registro digital de datos | Porcentaje de movimientos registrados; completitud de campos; registros por periodo | Lista de verificación y registros exportados | La app almacena productos, stock, producción, ventas, merma y pedidos en SQLite. La meta y fórmula definitiva del indicador están pendientes de completar por el equipo investigador. |
| Aplicación móvil offline perfilada para ML | Gestión de productos | Productos activos, inactivos y con vida útil configurada | Registro de productos y lista de verificación | La entidad `Product` conserva categoría, unidad, vida útil, costos, precios, stock de seguridad y parámetros de producción. |
| Aplicación móvil offline perfilada para ML | Preparación para ML | Disponibilidad de variables históricas; existencia de una interfaz de predictor | Revisión documental y lista de verificación técnica | `DemandPredictor` desacopla la estimación de demanda. No existe todavía un modelo ML entrenado. |
| Aplicación móvil offline perfilada para ML | Recomendación inicial de producción | Recomendación por producto; diferencia entre recomendación y producción real | Reporte de recomendaciones y registro de producción | La versión actual aplica promedios ponderados, stock vendible, producción programada y ajuste por merma. |
| Aplicación móvil offline perfilada para ML | Operación sin conexión | Disponibilidad de funciones críticas sin red | Ficha de observación y lista de verificación | La persistencia y los cálculos se ejecutan localmente; no hay dependencia de servicios cloud. |

## Variable dependiente: nivel de merma operativa

| Variable | Dimensión | Indicador | Instrumento | Sustento o relación con el sistema |
|---|---|---|---|---|
| Nivel de merma operativa | Merma física | Cantidad mermada por producto y periodo; tasa de merma | Registro de merma y reporte de producción | `WasteRecord.quantity` permite sumar unidades; la tasa actual relaciona merma y producción histórica. |
| Nivel de merma operativa | Merma económica | Costo estimado de merma por producto y periodo | Registro de merma y reporte económico | La app calcula `cantidad_merma × costo_unitario_aplicado`. |
| Nivel de merma operativa | Ajuste producción-demanda | Diferencia entre producción, ventas y stock final; sobrantes por periodo | Registros de stock, producción y ventas | Los datos permiten comparar producción preparada, salida por ventas y remanentes. La fórmula estadística definitiva está pendiente de completar por el equipo investigador. |
| Nivel de merma operativa | Vencimiento | Unidades vencidas o próximas a vencer | Registro de lotes y ficha de observación | La vida útil genera fechas de vencimiento y condiciona el stock vendible. |

## Variables intervinientes

| Variable | Dimensión | Indicador | Instrumento | Sustento o relación con el sistema |
|---|---|---|---|---|
| Calidad de datos | Completitud y consistencia | Campos obligatorios completos; errores de importación; continuidad de registros | Lista de verificación y reporte de importación CSV | El importador valida cabeceras, fechas, ubicaciones, cantidades y referencias de producto. |
| Estacionalidad | Variación temporal | Demanda por día de semana, mes, feriado o campaña | Registro de ventas y calendario externo | La heurística actual considera el mismo día de semanas anteriores, pero no modela formalmente feriados ni campañas. |
| Vida útil de productos | Perecibilidad | Días de vida útil; unidades por vencer y vencidas | Registro de productos y lotes | La aplicación calcula el vencimiento desde la producción y excluye lotes vencidos. |
| Adopción del sistema | Uso efectivo | Frecuencia de registro, facilidad percibida, incidencias y satisfacción | Encuesta de adopción y ficha de observación | La calidad del histórico depende de que el personal registre movimientos de manera oportuna y consistente. La encuesta aún no cuenta con resultados. |

## Criterio metodológico

Las metas, escalas, baremos, fórmulas de indicadores y criterios de pretest/postest deben concordar con el diseño aprobado. Esos valores están **Pendientes de completar por el equipo investigador**.
