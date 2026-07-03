# Especificación y trazabilidad de casos de prueba

**Código:** TST-SPEC-01  
**Versión:** 1.0

Los pasos y resultados esperados de CP01–CP20 están en [`../11_plan_de_pruebas.md`](../11_plan_de_pruebas.md). Esta matriz registra requisito, riesgo y técnica.

| Casos | Requisitos | Riesgo principal | Técnica | Automatización |
|---|---|---|---|---|
| CP01–CP03 | RF01, RNF07, RNF09 | catálogo inconsistente o historial perdido | equivalencia, transición de estado | Pendiente |
| CP04 | RF02, RNF07 | stock diario inválido | equivalencia, límite | Pendiente |
| CP05 | RF03, RF08 | lote/vencimiento incorrecto | caso de uso, límite | Pendiente integración |
| CP06 | RF04, RF07 | consumo de lote incorrecto | caso de uso, tabla de decisión | Pendiente integración |
| CP07–CP08 | RF05, RNF10 | merma o costo incorrectos | límite, cálculo | Parcial |
| CP09, CP17 | RF07, RF08, RNF10 | vencidos incluidos | frontera de fecha | Sí |
| CP10 | RF06, RF09 | pedidos contaminan demanda de vitrina | comparación A/B | Sí |
| CP11–CP13 | RF10, RF11, RNF08 | importación/exportación incorrecta | equivalencia, error guessing | Parcial |
| CP14–CP16 | RF09, RNF10 | cálculo erróneo o negativo | tabla de decisión, límites | Sí |
| CP18 | RNF03, RNF06 | dependencia de red | caso de uso | Manual pendiente |
| CP19 | RNF07, RNF10 | pérdida de persistencia | recuperación/reinicio | Manual pendiente |
| CP20 | RNF02 | bloqueo con datos históricos | volumen/carga | Pendiente |

## Datos de prueba

Usar productos con vida útil de 1 y varios días, cantidad cero y límites, lotes vencidos/hoy/vigentes, ventas con y sin historial, pedidos confirmados, CSV con coma/punto y coma/BOM, caracteres acentuados, duplicados y fechas inválidas.

## Cobertura faltante

- permisos y compartición de archivos;
- respaldo/restauración integral;
- edición concurrente o duplicada;
- navegación y formularios;
- compatibilidad entre versiones Android;
- privacidad y acceso físico;
- accesibilidad;
- ML, API y autenticación si se incorporan.
