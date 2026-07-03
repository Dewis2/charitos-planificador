# Log de decisiones de recomendación

**Código:** INS-03  
**Versión:** 1.0  
**Técnica:** *data logging* y observación sistemática  
**Estado:** diseñado; captura no implementada en la app

## Objetivo

Medir cuántas decisiones de producción aceptan, modifican o rechazan la recomendación y documentar la razón. Mientras la app use heurística, el instrumento debe llamarse “recomendación del sistema”, no “recomendación ML”.

## Registro requerido

| Campo | Descripción |
|---|---|
| id_decision | identificador único |
| fecha_hora | momento de la decisión |
| fecha_produccion | jornada a planificar |
| producto_id / nombre | producto evaluado |
| ubicación | tienda o destino |
| tipo_predictor | `heuristico` o versión ML real |
| version_predictor | fórmula/modelo y versión |
| recomendacion_vitrina | cantidad propuesta |
| pedidos_confirmados | cantidad separada para pedidos |
| cantidad_decidida | cantidad finalmente autorizada |
| decisión | aceptada / modificada / rechazada / no revisada |
| motivo | stock, campaña, clima, pedido, capacidad, experiencia u otro |
| usuario/rol | responsable seudonimizado |
| observación | contexto adicional |

## Formato manual provisional

| Fecha | Producto | Recomendación | Cantidad decidida | Decisión | Motivo | Responsable | Observación |
|---|---|---:|---:|---|---|---|---|
| | | | | | | | |

## Indicadores

- Alineación (%) = decisiones aceptadas / decisiones revisadas × 100.
- Modificación media = promedio de `cantidad_decidida − recomendacion_vitrina`.
- Cobertura = decisiones registradas / recomendaciones mostradas × 100.

## Requisitos para implementarlo

1. Acción explícita “Aceptar”, “Modificar” o “Rechazar”.
2. Motivo obligatorio al modificar/rechazar.
3. Marca de tiempo, producto, ubicación y versión del predictor.
4. Prohibir sobrescritura silenciosa; conservar historial.
5. Exportación seudonimizada para análisis.

No calcular adopción con el número de recomendaciones generadas; se necesita una decisión humana registrada.
