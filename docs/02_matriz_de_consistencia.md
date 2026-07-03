# Matriz de consistencia

## Formulación principal

| Elemento | Formulación |
|---|---|
| Problema general | ¿En qué medida la implementación de una aplicación móvil offline perfilada para Machine Learning contribuye a estructurar la información operativa necesaria para reducir la merma en la Pastelería Charito's? |
| Objetivo general | Implementar una aplicación móvil offline que registre productos, stock, producción, ventas y merma, dejando preparada la estructura de datos para una futura integración de Machine Learning orientada a reducir la merma. |
| Hipótesis general | La implementación de una aplicación móvil offline perfilada para Machine Learning contribuye a organizar los datos operativos necesarios para mejorar la planificación de producción y reducir la merma en la Pastelería Charito's. |
| Variable independiente | Aplicación móvil offline perfilada para Machine Learning. |
| Variable dependiente | Nivel de merma operativa. |
| Variables intervinientes | Calidad de datos, estacionalidad, vida útil de los productos y adopción del sistema por el personal. |
| Tipo de investigación | Pendiente de completar por el equipo investigador. |
| Diseño | Pendiente de completar por el equipo investigador. |
| Técnicas | Observación operativa, análisis de registros y encuesta de adopción propuestas. Su aplicación definitiva está pendiente de completar por el equipo investigador. |
| Instrumentos | Registros históricos, ficha de observación, encuesta de adopción y lista de verificación. Su validación y aplicación están pendientes de completar por el equipo investigador. |

## Correspondencia lógica

| Problema específico de información | Objetivo operativo del sistema | Evidencia esperada |
|---|---|---|
| Los movimientos se encuentran dispersos o no estructurados. | Centralizar productos, stock, producción, ventas, merma y pedidos en registros normalizados. | Registros SQLite y exportaciones CSV. |
| No se dispone de una base histórica uniforme para analizar demanda. | Capturar fechas, productos, cantidades, ubicaciones, precios, costos y motivos. | Series históricas por producto y fecha. |
| La producción de vitrina y los pedidos representan demandas distintas. | Mantener ambos componentes separados en el cálculo y en la presentación. | Recomendación de vitrina, pedidos confirmados y total operativo diferenciados. |
| La vida útil modifica la disponibilidad efectiva. | Excluir del stock vendible los lotes vencidos y alertar los próximos a vencer. | Lotes con fecha de producción, vencimiento, cantidad y estado. |
| Aún no existe evidencia suficiente para un modelo ML. | Implementar una heurística explicable y preparar una interfaz sustituible. | `HeuristicDemandPredictor`, contrato `DemandPredictor` y marcador futuro `MlDemandPredictor`. |

## Datos metodológicos pendientes

La población, muestra, unidad de análisis, periodo formal de observación, procedimiento de validación de instrumentos, estadístico de contraste y criterios de aceptación de la hipótesis están **Pendientes de completar por el equipo investigador**. Esta matriz no reemplaza la aprobación metodológica del asesor.
