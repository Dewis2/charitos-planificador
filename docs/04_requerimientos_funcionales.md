# Requerimientos funcionales

## Convenciones

- **Alta:** función necesaria para el flujo operativo principal.
- **Media:** función de soporte, consulta o administración.
- El estado observado se refiere al código disponible, no a una validación formal por usuarios finales.

| Código | Nombre | Descripción | Prioridad | Módulo relacionado | Estado observado |
|---|---|---|---|---|---|
| RF01 | Gestionar productos | Crear, consultar, buscar, editar, desactivar y reactivar productos con categoría, unidad, vida útil, costos, precio y parámetros de producción. | Alta | Productos | Implementado. |
| RF02 | Registrar stock por producto | Registrar stock inicial y final, producción para vitrina, transferencias y ubicación para una fecha. | Alta | Stock | Implementado. |
| RF03 | Registrar producción para vitrina | Registrar cantidad producida, fecha, destino y observación; generar lotes según vida útil. | Alta | Producción | Implementado. |
| RF04 | Registrar ventas de vitrina | Registrar fecha, producto, ubicación, cantidad y precio aplicado; afectar lotes mediante FEFO. | Alta | Ventas | Implementado. |
| RF05 | Registrar merma por producto | Registrar cantidad, motivo, costo unitario y ubicación; calcular el costo estimado. | Alta | Merma | Implementado. |
| RF06 | Registrar pedidos confirmados por separado | Mantener pedidos con cliente, fechas, producto, cantidad, estado y monto sin mezclarlos con ventas de vitrina. | Alta | Pedidos confirmados | Implementado. |
| RF07 | Calcular stock vendible | Sumar las cantidades actuales de lotes con saldo y fecha de vencimiento posterior a la fecha evaluada. | Alta | Lotes y recomendación | Implementado. |
| RF08 | Identificar productos por vencer | Clasificar lotes próximos a vencer según un umbral configurable y distinguirlos de los vencidos. | Alta | Lotes, dashboard y configuración | Implementado. |
| RF09 | Calcular recomendación inicial | Estimar demanda y calcular producción sugerida para vitrina considerando stock, producción programada y merma. | Alta | Recomendación | Implementado mediante heurística; no usa ML. |
| RF10 | Importar datos CSV | Importar productos, stock, producción, ventas, merma y pedidos con validación por fila. | Alta | Importar/Exportar | Implementado. |
| RF11 | Exportar datos CSV | Generar y compartir archivos CSV de las tablas operativas y de las recomendaciones. | Media | Importar/Exportar | Implementado. |
| RF12 | Mostrar dashboard | Presentar productos activos, ventas, producción, merma, costos y alertas resumidas. | Media | Inicio | Implementado. |
| RF13 | Mostrar reportes | Presentar indicadores y gráficos de producción, ventas y merma por periodo o categoría. | Media | Reportes | Implementado. |
| RF14 | Configurar parámetros internos | Modificar factor de ajuste de merma, días históricos, moneda, ubicación, redondeo y alertas. | Media | Configuración | Implementado. |
| RF15 | Mantener preparación para ML futuro | Exponer un contrato de predicción que permita sustituir la heurística por otra implementación. | Media | Servicios de demanda | Estructura implementada; modelo ML pendiente. |

## Reglas transversales

1. Los nombres de producto son únicos sin distinguir mayúsculas y minúsculas.
2. Las cantidades y montos no pueden ser negativos; la vida útil y el múltiplo de producción deben ser mayores que cero.
3. Las ubicaciones, categorías, tipos de producción, motivos de merma y estados de pedido deben pertenecer a catálogos controlados.
4. Los pedidos confirmados se agregan al total operativo, pero no alteran la recomendación de vitrina.
5. Un producto desactivado conserva su historial y deja de estar disponible para nuevos movimientos.

## Trazabilidad

La implementación se distribuye principalmente entre `lib/presentation/screens/`, `lib/services/`, `lib/data/repositories_impl/`, `lib/domain/` y `lib/core/database/`. La aceptación final por usuarios de la pastelería está **Pendiente de completar por el equipo investigador**.
