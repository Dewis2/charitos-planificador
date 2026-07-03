# Intervención metodológica

## Producto de software

La intervención consiste en una aplicación móvil Android offline que estructura información operativa de la Pastelería Charito's y genera una recomendación inicial y explicable de producción para vitrina. El producto registra productos, stock, producción, ventas, merma, lotes y pedidos confirmados.

## Uso de inteligencia artificial durante el desarrollo

Codex fue utilizado como herramienta de asistencia para:

- orientar la estructura del proyecto;
- generar y refactorizar código;
- proponer pruebas y verificaciones;
- preparar datos de simulación;
- redactar documentación técnica y académica.

El equipo investigador conserva la responsabilidad de revisar requisitos, validar decisiones, ejecutar pruebas, aprobar los resultados y mantener trazabilidad. Codex no reemplaza al investigador, al asesor, a los usuarios ni a una validación experta.

## Estado actual y futuro de IA

| Componente | Estado |
|---|---|
| Codex como asistente de desarrollo | Utilizado bajo supervisión humana. |
| Recomendación de la app | Heurística basada en promedios, stock, producción y merma. |
| Modelo ML entrenado dentro de la app | No implementado. |
| Integración futura de ML | Arquitectura preparada mediante `DemandPredictor`; entrenamiento y validación pendientes. |

## Fases de intervención

### 1. Planificación

- delimitar el problema de desajuste entre producción y demanda;
- identificar actores, procesos y fuentes de datos;
- definir variables e instrumentos;
- acordar alcance offline y criterios de aceptación.

**Evidencia disponible:** contexto suministrado, requisitos y formatos operativos. Población, muestra, cronograma formal y responsables: **Pendiente de completar por el equipo investigador**.

### 2. Diseño

- modelar entidades y relaciones;
- separar ventas de vitrina y pedidos confirmados;
- definir reglas de vida útil, lotes y FEFO;
- diseñar arquitectura por capas y contrato del predictor;
- preparar formularios y formatos CSV.

**Evidencia disponible:** entidades de dominio, esquema SQLite, servicios y documentación de arquitectura.

### 3. Desarrollo

- implementar módulos Flutter;
- persistir datos localmente;
- implementar reglas heurísticas y reportes;
- incorporar importación/exportación;
- mantener el predictor ML como trabajo futuro.

**Evidencia disponible:** código fuente y APK generado. La aceptación formal del usuario está pendiente.

### 4. Pruebas

- ejecutar análisis estático;
- probar reglas críticas de cálculo;
- validar formatos CSV;
- ejecutar casos funcionales en dispositivo;
- registrar incidencias y resultados.

**Evidencia disponible:** pruebas unitarias en `test/services/`. Actas de pruebas de usuario, dispositivos patrón y resultados pretest/postest: **Pendiente de completar por el equipo investigador**.

### 5. Mantenimiento

- corregir defectos;
- actualizar catálogos y parámetros;
- respaldar información mediante exportaciones;
- controlar versiones de la aplicación y documentación;
- preparar la futura fase ML sin alterar la trazabilidad histórica.

El plan de soporte, responsable institucional, periodicidad de respaldo y política de versiones están **Pendientes de completar por el equipo investigador**.

## Evaluación de la intervención

La evaluación académica debe comparar indicadores definidos antes y después de la intervención, controlar variables intervinientes y documentar el periodo observado. No debe utilizar datos simulados como prueba de impacto real. El diseño estadístico y los resultados están **Pendientes de completar por el equipo investigador**.
