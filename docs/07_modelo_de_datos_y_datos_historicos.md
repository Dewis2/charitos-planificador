# Modelo de datos y datos históricos

## Visión general

La aplicación utiliza SQLite local con claves foráneas activas. `Product` es la entidad maestra y los registros históricos se relacionan mediante `product_id`. Las tablas aplican restricciones de no negatividad y conservan una fecha de creación.

## Entidades

### Product

- **Propósito:** describir cada producto y sus parámetros comerciales y productivos.
- **Campos principales:** `id`, nombre, categoría, unidad, vida útil, costo, precio, stock mínimo, stock de seguridad, lote mínimo, múltiplo de producción, minutos estimados, tipo de producción, indicador de recomendación, estado activo y marcas de tiempo.
- **Relaciones:** es referenciado por stock, producción, ventas, merma, lotes, pedidos y recomendaciones.
- **Utilidad en el cálculo:** proporciona vida útil, stock de seguridad y reglas de redondeo por lote.
- **Utilidad futura para ML:** aporta variables estáticas, categóricas y económicas por producto.

### StockRecord

- **Propósito:** conservar el conteo y movimiento de stock por fecha y ubicación.
- **Campos principales:** fecha, producto, ubicación, stock inicial/final, producción para vitrina, transferencias recibidas/enviadas, observación y creación.
- **Relaciones:** referencia a `Product`.
- **Utilidad en el cálculo:** ofrece trazabilidad de disponibilidad y conciliación; el stock vendible inmediato se obtiene de los lotes vigentes.
- **Utilidad futura para ML:** permite detectar quiebres, restricciones de disponibilidad y posibles ventas censuradas por falta de stock.

### ProductionRecord

- **Propósito:** registrar cantidades producidas y su destino.
- **Campos principales:** fecha, producto, cantidad, destino, observación y creación.
- **Relaciones:** referencia a `Product`; el flujo de registro genera `ProductionLot`.
- **Utilidad en el cálculo:** determina producción programada y el denominador de la tasa histórica de merma.
- **Utilidad futura para ML:** permite contrastar la decisión de producción con ventas, merma y stock resultante.

### SalesRecord

- **Propósito:** registrar ventas regulares de vitrina.
- **Campos principales:** fecha, producto, ubicación, cantidad, precio unitario, total, observación y creación.
- **Relaciones:** referencia a `Product` y reduce lotes por FEFO.
- **Utilidad en el cálculo:** es la fuente primaria para estimar demanda de vitrina.
- **Utilidad futura para ML:** constituye la serie temporal objetivo por producto.

### WasteRecord

- **Propósito:** registrar merma física, causa y efecto económico.
- **Campos principales:** fecha, producto, ubicación, cantidad, motivo, costo unitario, costo estimado, observación y creación.
- **Relaciones:** referencia a `Product` y puede consumir lotes.
- **Utilidad en el cálculo:** alimenta la tasa y el ajuste histórico de merma.
- **Utilidad futura para ML:** permite analizar sobreproducción, vencimientos, calidad y costo de error.

### ProductionLot

- **Propósito:** representar unidades producidas con fecha de vencimiento y saldo actual.
- **Campos principales:** producto, fecha de producción, fecha de vencimiento, cantidad inicial/actual, ubicación, estado y creación.
- **Relaciones:** referencia a `Product`; es consumido por ventas y merma.
- **Utilidad en el cálculo:** determina stock vendible, por vencer y vencido; habilita FEFO.
- **Utilidad futura para ML:** aporta edad del inventario, perecibilidad y riesgo de vencimiento.

### Order

- **Propósito:** registrar compromisos de entrega como demanda segura.
- **Campos principales:** fechas de pedido/entrega, cliente, teléfono, producto, cantidad, descripción, estado, total, observación y creación.
- **Relaciones:** referencia a `Product`.
- **Utilidad en el cálculo:** los pedidos confirmados del día se suman separadamente a la carga operativa.
- **Utilidad futura para ML:** funciona como variable conocida; no debe mezclarse con ventas espontáneas de vitrina.

### Recommendation

- **Propósito:** conservar el resultado explicable de una recomendación por producto y fecha.
- **Campos persistidos:** demanda estimada, stock vendible, por vencer y vencido, tasa y ajuste de merma, recomendación de vitrina, pedidos confirmados y creación.
- **Objeto de dominio:** `ProductionRecommendation` incorpora además el producto, fecha, stock de seguridad y producción programada; calcula el total operativo.
- **Relaciones:** una recomendación pertenece a un producto y es única por fecha y producto en la tabla actual.
- **Utilidad en el cálculo:** materializa los componentes de la fórmula para auditoría.
- **Utilidad futura para ML:** permite comparar recomendación heurística, pronóstico futuro, producción real y resultado observado.

### AppSettings

- **Propósito:** administrar parámetros locales sin recompilar la aplicación.
- **Campos principales:** factor de ajuste por merma, días de análisis, moneda, ubicación predeterminada, redondeo por lote, umbral por vencer y alertas.
- **Relaciones:** es consumida por los servicios de recomendación, lotes y formularios.
- **Utilidad en el cálculo:** controla ventana histórica, factor de merma, redondeo y umbral de vencimiento.
- **Utilidad futura para ML:** puede almacenar versión, umbral o modo de activación del predictor; esa extensión está pendiente.

## Relaciones principales

```text
Product 1 ── N StockRecord
Product 1 ── N ProductionRecord
Product 1 ── N SalesRecord
Product 1 ── N WasteRecord
Product 1 ── N ProductionLot
Product 1 ── N Order
Product 1 ── N Recommendation
AppSettings ──> reglas globales del dispositivo
```

## Datos históricos mínimos

Para calcular la heurística actual se requieren ventas diarias, producción y merma. Para un futuro ML deben añadirse periodos suficientes y consistentes, días sin venta, stock disponible, feriados, campañas, promociones y cualquier cambio de precio. El horizonte mínimo, volumen real y criterio de calidad del conjunto de entrenamiento están **Pendientes de completar por el equipo investigador**.

Los archivos de simulación son útiles para verificar flujos técnicos, pero no reemplazan datos reales para entrenamiento o validación científica.
