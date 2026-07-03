# Bitácora de decisiones técnicas

| Fecha | Decisión | Justificación | Impacto | Estado |
|---|---|---|---|---|
| Pendiente de completar | Usar una aplicación móvil Android | Facilitar el registro en el entorno operativo mediante un dispositivo móvil. | Define Flutter como tecnología y Android como plataforma de entrega actual. | Implementada. |
| Pendiente de completar | Mantener funcionamiento offline | Evitar dependencia de conectividad y servicios externos durante la operación. | Los datos y cálculos permanecen en el dispositivo; no existe sincronización automática. | Implementada. |
| Pendiente de completar | Utilizar SQLite local | Se requiere persistencia relacional, consultas históricas y operación sin red. | Introduce esquema local, claves foráneas, índices y necesidad de respaldo. | Implementada. |
| Pendiente de completar | Aplicar arquitectura por capas | Separar interfaz, reglas, persistencia y utilidades para favorecer pruebas y mantenimiento. | Reduce acoplamiento y permite sustituir implementaciones. | Implementada. |
| Pendiente de completar | Usar Riverpod | Centralizar inyección, estado y refresco de datos. | Las pantallas reciben servicios/repositorios mediante proveedores. | Implementada. |
| Pendiente de completar | Separar pedidos confirmados de ventas de vitrina | Los pedidos son demanda segura y no representan comportamiento espontáneo de vitrina. | Evita sesgar `DEp`; se muestran recomendación, pedidos y total operativo por separado. | Implementada y protegida con prueba unitaria. |
| Pendiente de completar | Registrar vida útil por producto | La perecibilidad determina vencimiento y stock realmente vendible. | Cada producción puede originar un lote con fecha de vencimiento. | Implementada. |
| Pendiente de completar | Aplicar FEFO | Reducir el riesgo de vencimiento consumiendo primero los lotes más próximos a expirar. | Ventas y merma afectan lotes ordenados por vencimiento. | Implementada. |
| Pendiente de completar | Utilizar una heurística inicial | Aún no existe un histórico real validado suficiente para entrenar ML. | La recomendación es explicable y puede operar desde la primera versión. | Implementada. |
| Pendiente de completar | No implementar ML real en la primera versión | Evitar afirmar capacidad predictiva sin datos, entrenamiento y evaluación. | `MlDemandPredictor` permanece como marcador no operativo. | Decisión vigente. |
| Pendiente de completar | Preparar un contrato para ML | Permitir evolución sin reescribir módulos principales. | `DemandPredictor` desacopla la fuente de la estimación. | Implementada estructuralmente. |
| Pendiente de completar | Usar Codex como asistente IA | Acelerar generación, refactorización, pruebas y documentación bajo supervisión. | Requiere revisión humana, trazabilidad de prompts y verificación de resultados. | Aplicada. |
| Pendiente de completar | Incorporar intercambio CSV | Facilitar carga histórica, revisión y portabilidad sin backend. | Se definen plantillas, validación por fila y exportación compartible. | Implementada. |

## Gestión de la bitácora

El equipo debe sustituir las fechas pendientes con evidencia de actas, commits o entregas; agregar autor, revisor y versión; y registrar cualquier cambio de alcance. Esta tabla describe decisiones observables, pero no reemplaza el acta de aprobación del proyecto.
