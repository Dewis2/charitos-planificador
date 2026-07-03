# Prototipo de interfaz de la aplicación

## Identificación

- **Nombre:** Charito's Planifica.
- **Tipo:** prototipo navegable de alta fidelidad visual.
- **Plataforma representada:** teléfono Android.
- **Tecnología del prototipo:** HTML, CSS y JavaScript sin dependencias externas.
- **Implementación real relacionada:** aplicación Flutter offline incluida en este repositorio.

## Objetivo

Representar visualmente la estructura, navegación y flujos principales de la aplicación antes de su evaluación académica o demostración. Aunque el sistema funcional ya existe, este artefacto permite presentar el diseño de interacción separadamente del APK y documentar las decisiones de interfaz.

## Acceso

Abra [`prototipo_app/index.html`](prototipo_app/index.html) en un navegador moderno. El prototipo funciona localmente y no requiere internet ni instalación.

## Pantallas incluidas

| Pantalla | Propósito representado |
|---|---|
| Inicio | Resumen de productos, ventas, producción, merma, vencimientos y gráfico operativo. |
| Productos | Búsqueda, filtro, listado y formulario de nuevo producto. |
| Registrar stock | Conteo inicial/final, producción y transferencias. |
| Registrar producción | Cantidad producida, fecha, producto y ubicación de destino. |
| Registrar ventas | Venta de vitrina con precio y consumo FEFO representado. |
| Registrar merma | Cantidad, costo y motivo de pérdida. |
| Pedidos confirmados | Demanda segura separada de las ventas de vitrina. |
| Lotes y vencimientos | Lotes vigentes, por vencer y vencidos. |
| Recomendación | Desglose de demanda, stock, ajuste, vitrina, pedidos y total operativo. |
| Reportes | Barras de merma, costos y riesgo de vencimiento. |
| Importar/Exportar | Entradas y salidas CSV por módulo. |
| Configuración | Parámetros de cálculo, alertas y ubicación predeterminada. |

## Flujos demostrables

1. Abrir el menú lateral y recorrer todos los módulos.
2. Buscar y filtrar productos.
3. Abrir y guardar un formulario demostrativo de producto.
4. Simular registros de stock, producción, venta y merma.
5. Registrar un pedido confirmado.
6. Expandir una recomendación para observar sus componentes.
7. Simular importación/exportación y configuración de parámetros.

## Correspondencia con la aplicación implementada

La paleta, navegación, títulos y módulos se basan en `lib/main.dart` y `lib/presentation/screens/`. El color primario deriva de `#9C4668`, la interfaz representa Material 3 y mantiene el indicador de funcionamiento offline.

Los datos mostrados son demostrativos y no se conectan con SQLite. Las acciones generan respuestas visuales temporales; la persistencia, validaciones completas, cálculos y exportaciones reales pertenecen al APK Flutter.

## Uso en la investigación

El prototipo puede utilizarse para explicar el flujo, aplicar una evaluación preliminar de usabilidad o anexar capturas al informe. Si se utiliza con participantes, deben documentarse tarea, perfil, tiempo, errores, observaciones y consentimiento. La aplicación del instrumento y los resultados están **Pendientes de completar por el equipo investigador**.

## Criterios de revisión propuestos

- claridad de etiquetas y estados;
- facilidad para localizar módulos;
- consistencia de formularios;
- comprensión de la separación entre vitrina y pedidos;
- comprensión de alertas de vencimiento;
- comprensión del desglose de recomendación;
- legibilidad en el dispositivo objetivo.

## Limitaciones

- No guarda datos al cerrar la página.
- No ejecuta la fórmula real ni accede a SQLite.
- No reemplaza las pruebas de la aplicación instalada.
- No constituye evidencia de validación experta o aceptación de usuarios hasta que se aplique el instrumento correspondiente.
