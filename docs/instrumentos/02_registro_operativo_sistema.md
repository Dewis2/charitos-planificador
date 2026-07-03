# Registro operativo del sistema

**Código:** INS-02  
**Versión:** 1.0  
**Técnica:** registro documental y *data logging*  
**Objetivo:** consolidar ventas, producción, stock, merma, lotes y pedidos por día, producto y ubicación.

## Nota de trazabilidad

El informe denomina este instrumento “base de datos relacional PostgreSQL/MySQL”. La app actual usa **SQLite local**. El instrumento se conserva, pero su fuente real debe declararse como `charitos_planificador.db` y/o exportaciones CSV.

## Metadatos de extracción

- Versión de app/APK: ____________________
- Dispositivo: ____________________
- Periodo: ____________________
- Fecha y hora de exportación: ____________________
- Responsable: ____________________
- Tipo de datos: ☐ reales ☐ simulados ☐ prueba
- Hash/identificador del paquete exportado: ____________________

## Tablas y campos mínimos

| Conjunto | Clave de análisis | Medidas / campos mínimos |
|---|---|---|
| Productos | producto | categoría, unidad, vida útil, costo, precio, parámetros de producción |
| Stock | fecha + producto + ubicación | inicial, final, producción vitrina, transferencias |
| Producción | fecha + producto + destino | cantidad, observación |
| Ventas | fecha + producto + ubicación | cantidad, precio unitario, total |
| Merma | fecha + producto + ubicación | cantidad, motivo, costo |
| Lotes | producto + ubicación + fecha producción | cantidad producida, remanente, vencimiento |
| Pedidos | fecha entrega + producto | cantidad, estado, monto y datos mínimos de cliente |
| Recomendaciones | fecha + producto | demanda estimada, stock, merma esperada, recomendación |

## Conciliación diaria

| Fecha | Ubicación | Productos esperados | Productos con datos | Ventas S/ | Producción u. | Merma u. | Diferencia detectada | Revisó |
|---|---|---:|---:|---:|---:|---:|---|---|
| | | | | | | | | |

## Criterios de calidad

- claves válidas y sin registros huérfanos;
- cantidades no negativas;
- fechas normalizadas ISO `AAAA-MM-DD`;
- producto y ubicación consistentes;
- duplicados identificados;
- exportación almacenada de manera segura;
- distinción inequívoca entre datos reales y simulados.

## Limitación

La tabla `recommendations` existe en SQLite, pero el flujo actual calcula y exporta recomendaciones sin registrar aceptación o modificación operativa. Para medir adopción debe añadirse INS-03.
