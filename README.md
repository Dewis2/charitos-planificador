# Charito’s Planifica

Aplicación móvil Android completamente offline para apoyar la planificación diaria de producción y reducir la merma en la Pastelería Charito’s (Huancayo). Registra productos, stock, producción para vitrina, ventas regulares, merma, lotes y pedidos confirmados; con esos datos calcula una recomendación explicable por producto.

## Funciones incluidas

- Productos con edición, búsqueda, filtros y desactivación lógica.
- Stock histórico por fecha, producto y ubicación.
- Producción para vitrina con creación automática de lotes.
- Ventas de vitrina y consumo de lotes por FEFO.
- Merma con motivo y costo estimado.
- Pedidos confirmados en un módulo independiente.
- Vida útil configurable, alertas por vencer y exclusión de vencidos.
- Recomendación diaria desglosada entre vitrina, pedidos y total operativo.
- Dashboard y reportes con gráficos `fl_chart`.
- Importación y exportación CSV con validación por fila.
- Configuración local de parámetros de cálculo y alertas.
- Arquitectura preparada para sustituir la heurística por ML en el futuro.

No usa Firebase, Supabase, Render, servicios cloud ni conexión a internet. La información permanece en SQLite dentro del dispositivo.

## Tecnologías

- Flutter 3.32 / Dart 3.8
- SQLite mediante `sqflite`
- Riverpod para inyección, estado y refresco de datos
- `fl_chart` para gráficos
- `csv`, `file_picker`, `path_provider` y `share_plus` para intercambio de CSV
- Material 3, interfaz en español y diseño responsive para Android

## Ejecutar el proyecto

Requisitos: Flutter estable, Android SDK y un emulador o teléfono Android.

```bash
flutter pub get
flutter test
flutter analyze
flutter run
```

Para crear un APK de instalación:

```bash
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

## Estructura

```text
lib/
├── core/                 # constantes, SQLite, fechas y validadores
├── data/                 # mapeo de datos y repositorio SQLite
├── domain/               # entidades y contrato del repositorio
├── presentation/
│   ├── providers/        # proveedores Riverpod
│   ├── screens/          # dashboard, formularios, reportes y configuración
│   └── widgets/          # componentes compartidos
├── services/             # demanda, recomendación, CSV y reportes
└── main.dart
test/services/            # pruebas unitarias de reglas críticas
docs/csv_templates/       # cabeceras y ejemplos importables
```

La base crea automáticamente estas tablas al primer inicio: `products`, `stock_records`, `production_records`, `sales_records`, `waste_records`, `production_lots`, `orders`, `recommendations` y `app_settings`.

## Demanda estimada

La estimación para ventas de vitrina es un promedio ponderado:

```text
DEp = 0.50 × promedio_ventas_7_días
    + 0.30 × promedio_mismo_día_de_semana_4_semanas
    + 0.20 × promedio_ventas_30_días
```

Si falta uno de los grupos, se usan los disponibles y sus pesos se normalizan. Si no hay ventas, se usa `producción histórica − merma`. Sin ventas ni producción se muestra “Datos insuficientes para estimar demanda”. Solo se consultan `sales_records`; los pedidos no participan.

## Producción recomendada

```text
PRp = max(0, DEp + SSp − SVp − PPp − AMp)
AMp = DEp × tasa_merma × factor_ajuste_merma
tasa_merma = merma_30_días / producción_vitrina_30_días
```

- `SSp`: stock de seguridad configurado en el producto.
- `SVp`: cantidad actual de lotes no vencidos.
- `PPp`: producción para vitrina ya registrada en el día.
- `AMp`: reducción prudente basada en la merma histórica (factor inicial `0.5`).

El resultado respeta el lote mínimo y se redondea al múltiplo superior si esa opción está activa. Los lotes que vencen hoy se clasifican como vencidos y no se consideran vendibles.

## Pedidos confirmados

Los pedidos representan demanda segura, no una señal para estimar ventas espontáneas de vitrina. Por eso se mantienen y muestran separados:

```text
producción_total_operativa = recomendación_vitrina + pedidos_confirmados_del_día
```

Modificar la cantidad de pedidos cambia el total operativo, pero no cambia `PRp`. Una prueba unitaria protege explícitamente esta regla.

## CSV

El catálogo transcrito de las fotos está listo para importar en
[`docs/csv_templates/productos_catalogo_charitos.csv`](docs/csv_templates/productos_catalogo_charitos.csv).
Usa las categorías `vainilla`, `3 leches`, `selva negra`, `helada` y `pasteles`.
Como las fotos no contienen costos, precios ni parámetros de inventario, esos
campos llevan valores neutros válidos que deben ajustarse en la pantalla de
productos después de importar.

Todos los archivos usan UTF-8 y fechas `AAAA-MM-DD`. El importador detecta
automáticamente los separadores coma y punto y coma, y también acepta la línea
`sep=;` que utiliza Excel. Los nombres de producto no distinguen
mayúsculas/minúsculas. Las ubicaciones válidas son `tienda_1`, `tienda_2`,
`taller` y `general`.

Formatos aceptados:

```text
productos.csv
nombre,categoria,unidad_medida,vida_util_dias,costo_unitario,precio_venta,stock_minimo,stock_seguridad,lote_minimo_produccion,multiplo_produccion,tipo_produccion,aplica_recomendacion,activo

stock_historico.csv
fecha,producto_nombre,ubicacion,stock_inicial,stock_final,cantidad_producida_vitrina,cantidad_recibida_transferencia,cantidad_enviada_transferencia,observacion

produccion.csv
fecha,producto_nombre,cantidad_producida,ubicacion_destino,observacion

ventas_vitrina.csv
fecha,producto_nombre,ubicacion,cantidad_vendida,precio_unitario_aplicado,observacion

merma.csv
fecha,producto_nombre,ubicacion,cantidad_merma,motivo_merma,costo_unitario_aplicado,observacion

pedidos_confirmados.csv
fecha_pedido,fecha_entrega,cliente_nombre,cliente_celular,producto_nombre,cantidad,descripcion,estado,monto_total,observacion
```

Las plantillas listas para copiar están en [`docs/csv_templates`](docs/csv_templates). La importación informa el número de filas correctas y el detalle de errores sin descartar las filas válidas.

## Preparación para Machine Learning

`DemandPredictor` es el contrato que consume `ProductionRecommendationService`. La implementación actual, `HeuristicDemandPredictor`, delega en promedios ponderados. `MlDemandPredictor` queda como placeholder sin lógica. Un modelo local o remoto podría sustituir el predictor sin reescribir inventario, lotes, UI ni recomendación. La aplicación actual continúa siendo 100 % offline y no incluye ML.

## Pruebas

Las pruebas cubren demanda ponderada y datos parciales, stock vendible, lotes por vencer, exclusión de vencidos, tasa de merma, ajuste, fórmula no negativa, redondeo por lote y separación de pedidos confirmados.

## Limitaciones actuales

- No hay autenticación ni sincronización entre los dos puntos de venta; cada instalación conserva su propia base.
- No se incluye respaldo cifrado ni restauración integral de SQLite; CSV cubre el intercambio tabular.
- Los movimientos de venta y merma consumen lotes disponibles por FEFO, pero permiten registrar una cantidad mayor al stock para no bloquear la captura de datos históricos.
- La estimación no modela feriados, campañas, clima, estacionalidad avanzada ni promociones.
- Solo se genera la plataforma Android.
- El APK entregado usa la firma de desarrollo de la plantilla; para publicar en Google Play debe configurarse un keystore de producción.

## Mejoras futuras

- Sincronización opcional entre locales con resolución de conflictos.
- Copias de seguridad cifradas y restauración completa.
- Calendario de feriados/campañas y pronóstico estacional.
- Edición/anulación auditada de movimientos.
- Notificaciones locales de vencimiento.
- Predictor ML local con TensorFlow Lite, evaluado contra la heurística antes de activarse.
