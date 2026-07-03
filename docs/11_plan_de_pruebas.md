# Plan de pruebas

## Objetivo

Verificar que los módulos registren datos válidos, conserven integridad y apliquen correctamente las reglas de producción, vida útil, merma y separación de pedidos. Los casos marcados como manuales requieren evidencia en dispositivo.

| Código | Módulo | Caso de prueba | Datos de entrada | Resultado esperado | Tipo de prueba |
|---|---|---|---|---|---|
| CP01 | Productos | Crear producto | Nombre único, categoría válida, vida útil positiva y parámetros no negativos | El producto se guarda y aparece activo en la lista. | Funcional / integración |
| CP02 | Productos | Editar producto | Producto existente y nuevo precio o parámetro | Se actualiza el producto conservando su identificador e historial. | Funcional / integración |
| CP03 | Productos | Desactivar producto | Producto activo con historial | Se marca inactivo, no aparece en nuevos registros y el historial se conserva. | Funcional / integración |
| CP04 | Stock | Registrar stock | Fecha, producto, ubicación y cantidades válidas | Se crea un `StockRecord` y se refleja en consultas y dashboard. | Funcional / integración |
| CP05 | Producción | Registrar producción | Producto, fecha, cantidad y destino | Se registra producción y se crea un lote con vencimiento derivado de la vida útil. | Integración |
| CP06 | Ventas | Registrar venta | Producto, cantidad, ubicación y precio | Se registra la venta, se calcula el total y se consumen lotes por FEFO. | Integración |
| CP07 | Merma | Registrar merma | Producto, cantidad, motivo, costo y ubicación | Se registra la merma y se descuenta de lotes disponibles cuando corresponde. | Integración |
| CP08 | Merma | Calcular costo de merma | Cantidad `2`, costo unitario `10` | El costo estimado es `20`. | Unitaria / funcional |
| CP09 | Lotes | Excluir productos vencidos | Lote con vencimiento igual o anterior a la fecha evaluada | Su cantidad no se incluye en stock vendible y se contabiliza como vencida. | Unitaria automatizada |
| CP10 | Recomendación | Excluir pedidos de la recomendación de vitrina | Mismas ventas y stock; variar pedidos confirmados | `PRp` no cambia; solo cambia producción por pedidos y total operativo. | Unitaria automatizada |
| CP11 | CSV | Exportar CSV | Tabla con registros | Se crea un CSV UTF-8 con cabeceras y valores exportables. | Funcional / integración |
| CP12 | CSV | Importar CSV válido | Archivo con cabeceras requeridas y referencias existentes | Se importan todas las filas y se informa el total sin errores. | Integración |
| CP13 | CSV | Rechazar fila inválida | Fecha incorrecta, categoría inválida o producto inexistente | La fila se reporta con error y las filas válidas se conservan. | Integración |
| CP14 | Recomendación | Generar recomendación inicial | Ventas históricas, stock, producción y merma | Se calcula `max(0, DEp + SSp - SVp - PPp - AMp)` y se redondea según lote. | Unitaria automatizada |
| CP15 | Demanda | Normalizar pesos con datos parciales | Uno o dos grupos históricos disponibles | Se utilizan solo los componentes disponibles y sus pesos se normalizan. | Unitaria automatizada |
| CP16 | Recomendación | Impedir cantidad negativa | Stock vendible superior a demanda y seguridad | La recomendación es `0`. | Unitaria automatizada |
| CP17 | Lotes | Identificar próximo a vencer | Lote vigente dentro del umbral configurado | Se incluye en stock por vencer, no en vencido. | Unitaria automatizada |
| CP18 | Offline | Ejecutar flujos sin red | Dispositivo en modo avión | Productos, registros, reportes y recomendaciones funcionan localmente. | Sistema / manual |
| CP19 | Persistencia | Reiniciar aplicación | Registrar datos, cerrar y volver a abrir | Los datos permanecen en SQLite. | Sistema / manual |
| CP20 | Rendimiento | Importar volumen histórico | Archivo de tamaño acordado | La operación termina sin bloqueo ni pérdida de filas dentro del umbral aprobado. | Rendimiento |

## Pruebas automatizadas existentes

El proyecto contiene pruebas unitarias para promedio ponderado, normalización con datos parciales, stock vendible, productos por vencer, exclusión de vencidos, tasa y ajuste por merma, fórmula no negativa, redondeo por lote y separación de pedidos confirmados.

## Procedimiento de ejecución

```bash
flutter pub get
flutter analyze
flutter test
```

Para cada ciclo deben registrarse versión, dispositivo, fecha, responsable, entradas, resultado real, evidencia e incidencia. La matriz de ejecución firmada y los resultados en dispositivos reales están **Pendientes de completar por el equipo investigador**.

## Criterios de salida propuestos

- cero errores del analizador que impidan compilar;
- todas las pruebas automatizadas aprobadas;
- cero defectos críticos abiertos en los flujos principales;
- aceptación funcional y umbrales de rendimiento definidos por el equipo.

La aprobación formal y los umbrales cuantitativos están **Pendientes de completar por el equipo investigador**.
