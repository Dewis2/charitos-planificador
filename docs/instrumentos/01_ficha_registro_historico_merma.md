# Ficha de registro histórico de merma

**Código:** INS-01  
**Versión:** 1.0  
**Técnica:** registro documental  
**Objetivo:** medir unidades desechadas y costo de merma por producto, fecha y ubicación.

## Identificación

- Periodo: ____________________
- Fuente original: ☐ Google Sheets ☐ cuaderno ☐ SQLite ☐ otro: __________
- Responsable de extracción: ____________________
- Fecha de extracción: ____/____/______
- Condición: ☐ dato real ☐ dato simulado ☐ prueba

## Registro

| Fecha | Producto/SKU | Ubicación | Cantidad | Unidad | Motivo | Costo unitario S/ | Costo estimado S/ | Fuente/folio | Observación |
|---|---|---|---:|---|---|---:|---:|---|---|
| | | | | | | | | | |

Ubicaciones normalizadas: `tienda_1` (Tienda Chica), `tienda_2` (Tienda Grande), `taller`, `general`.

Motivos sugeridos según la app: vencimiento, deterioro, devolución, error de producción u otro catálogo aprobado.

## Indicadores

- Unidades de merma = suma de cantidades desechadas.
- Costo de merma = suma de cantidad × costo unitario.
- Tasa de merma (%) = unidades desechadas / unidades producidas × 100.

No calcular la tasa si la producción del mismo periodo, producto y ubicación no está disponible; registrar “no calculable”.

## Control de calidad

☐ Fecha válida y dentro del periodo.  
☐ Producto existe en catálogo.  
☐ Cantidad y costo no negativos.  
☐ Ubicación y motivo normalizados.  
☐ Duplicados revisados.  
☐ Total conciliado con fuente original.

Revisado por: ____________________ Fecha: ____/____/______ Firma: ____________________

## Correspondencia técnica

Se relaciona con `waste_records` y `docs/csv_templates/merma.csv`. La app calcula el costo estimado y usa la merma histórica en la recomendación heurística.
