# Arquitectura del sistema

## Enfoque

Charito's Planifica aplica una arquitectura móvil offline por capas, inspirada en Clean Architecture y simplificada para el alcance académico. La aplicación concentra interfaz, lógica de negocio y persistencia en el dispositivo Android, sin un backend remoto.

## Tecnologías

- **Flutter y Dart:** interfaz y ejecución multiplataforma, con entrega actual para Android.
- **Riverpod:** inyección de dependencias, estado y actualización de datos.
- **SQLite mediante `sqflite`:** base local relacional.
- **Material 3:** componentes de interfaz.
- **`fl_chart`:** gráficos.
- **CSV, selector de archivos y compartición:** intercambio de datos sin servidor.

## Capas

### Presentación

Contiene pantallas, formularios, navegación, widgets y proveedores Riverpod. Solicita operaciones a servicios o repositorios, pero no ejecuta SQL directamente.

### Dominio

Define entidades y el contrato `InventoryRepository`. Representa conceptos del negocio independientemente de Flutter y SQLite.

### Datos

Implementa el repositorio local, transforma filas SQLite en entidades y ejecuta consultas y transacciones.

### Servicios

Contiene demanda, recomendación, dashboard, reportes, cálculos e importación/exportación CSV. Aquí reside la lógica que combina varias fuentes de datos.

### Core

Agrupa base SQLite, constantes, validadores y utilidades de fecha compartidas.

## Diagrama textual

```text
┌──────────────────────────────────────────┐
│ Presentación: pantallas, widgets, estado │
└───────────────────┬──────────────────────┘
                    │
┌───────────────────▼──────────────────────┐
│ Servicios y casos de uso                 │
│ demanda · recomendación · CSV · reportes │
└──────────────┬─────────────────┬─────────┘
               │                 │
┌──────────────▼──────────┐  ┌───▼────────────────┐
│ Dominio                 │  │ Contrato predictor │
│ entidades y repositorio │  │ heurística / ML    │
└──────────────┬──────────┘  └────────────────────┘
               │
┌──────────────▼───────────────────────────┐
│ Datos: repositorio local y modelos       │
└──────────────┬───────────────────────────┘
               │
┌──────────────▼───────────────────────────┐
│ SQLite en el dispositivo Android         │
└──────────────────────────────────────────┘
```

## Estructura de carpetas

```text
lib/
├── core/
│   ├── constants/
│   ├── database/
│   ├── utils/
│   └── validators/
├── data/
│   ├── models/
│   └── repositories_impl/
├── domain/
│   ├── entities/
│   └── repositories/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
├── services/
└── main.dart
test/
└── services/
docs/
└── csv_templates/
```

## Separación entre negocio y almacenamiento

Las pantallas reciben entidades de dominio mediante proveedores. `LocalInventoryRepository` implementa `InventoryRepository` y encapsula SQLite. Los servicios dependen del contrato, lo que facilita probar reglas con repositorios sustitutos y evita acoplar los cálculos a sentencias SQL en la interfaz.

## Preparación para Machine Learning

`ProductionRecommendationService` consume `DemandPredictor`. La implementación activa delega en `DemandEstimationService`; una implementación futura podría cargar un modelo TensorFlow Lite o consultar otro predictor respetando el contrato. Antes de activar esa ruta deben existir datos reales, evaluación reproducible y un mecanismo seguro de versionado y reversión.

La presencia de esta interfaz no significa que ML esté implementado actualmente.
