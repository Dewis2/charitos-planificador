# Gestión de calidad basada en ISO 9001

**Código:** ISO-QMS-01  
**Versión:** 1.0  
**Estado:** marco aplicado; sin certificación

## Alcance del sistema de calidad del proyecto

El alcance comprende el levantamiento de necesidades de Pastelería Charito's, diseño, desarrollo, prueba, instalación y mejora de la app móvil que registra operaciones y recomienda producción de vitrina. No comprende la certificación del negocio, la inocuidad alimentaria ni procesos contables.

## Partes interesadas y necesidades

| Parte interesada | Necesidad verificable |
|---|---|
| Propietario/encargado | Reducir merma y tener información trazable. |
| Tienda Chica y Tienda Grande | Registrar ventas, stock y merma con pocos pasos. |
| Taller | Conocer producción sugerida y pedidos confirmados. |
| Equipo investigador | Datos íntegros, instrumentos válidos y evidencia reproducible. |
| Asesor/jurado | Correspondencia entre objetivos, método, resultados y software real. |

## Procesos controlados

| Proceso | Entrada | Salida | Responsable propuesto | Indicador |
|---|---|---|---|---|
| Gestión de requisitos | Informe, entrevistas, observación | Requisitos versionados | Product Owner | % requisitos con criterio de aceptación |
| Gestión de datos | CSV/registros operativos | Datos válidos en SQLite | Encargado de datos | % filas aceptadas; % errores |
| Desarrollo | Requisito aprobado | Incremento Flutter | Desarrollador | defectos por versión |
| Pruebas | Build y casos | Resultado y defectos | Responsable QA | % casos aprobados |
| Despliegue | APK probado | App instalada y verificada | Soporte/PO | % ítems de checklist conformes |
| Operación | Registros diarios | Reportes y recomendaciones | Personal operativo | completitud diaria |
| Mejora | Incidencias, encuestas, métricas | acción correctiva | Equipo del proyecto | % acciones cerradas en plazo |

## Política de calidad propuesta

El equipo del proyecto se compromete a mantener una aplicación comprensible, trazable y adecuada al proceso real de Charito's; proteger la información operativa; verificar los cambios antes de liberarlos; registrar las desviaciones entre informe e implementación; y mejorar el sistema a partir de datos y retroalimentación verificables.

La política debe ser revisada y aprobada por: **Pendiente de designar por el equipo investigador**.

## Objetivos de calidad

| Objetivo | Métrica | Meta inicial | Evidencia |
|---|---|---:|---|
| Trazabilidad | Requisitos con caso de prueba | 100 % de requisitos críticos | matriz y casos de prueba |
| Integridad de importación | Filas válidas importadas sin alteración | 100 % | registro de importación |
| Estabilidad | Pruebas automatizadas aprobadas | 100 % antes de liberar | salida de `flutter test` |
| Calidad estática | Incidencias de `flutter analyze` | 0 | salida de análisis |
| Recuperación | Restauraciones de respaldo satisfactorias | 100 % de simulacros | acta de recuperación |
| Adopción | Promedio de encuesta | meta por aprobar | encuesta y análisis |

Las metas de adopción e impacto no se declaran logradas hasta aplicar los instrumentos.

## Control de información documentada

Cada documento debe tener nombre descriptivo, código, versión, fecha, estado, autor, revisor y evidencia de aprobación. Los cambios se conservan en Git. Las exportaciones, actas firmadas y resultados deben almacenarse en una ubicación autorizada; no deben incorporarse al repositorio público si contienen datos personales o comerciales.

Convención sugerida: `CODIGO_nombre_vMAJOR.MINOR_AAAA-MM-DD.ext`.

## No conformidades y acciones correctivas

Una no conformidad se registra cuando un requisito, prueba, instrumento o procedimiento no se cumple. El registro mínimo incluye: identificador, fecha, evidencia, requisito afectado, impacto, contención, causa, acción, responsable, vencimiento y verificación de eficacia.

Flujo: detectar → contener → analizar causa → corregir → probar → cerrar o reabrir.

## Aplicación del ciclo PHVA

- **Planificar:** requisitos, riesgos, instrumentos, criterios y plan de pruebas.
- **Hacer:** implementar, importar datos, capacitar y operar.
- **Verificar:** analizar calidad, ejecutar pruebas, revisar métricas y auditar evidencia.
- **Actuar:** corregir defectos, ajustar procesos y actualizar la documentación.

## Estado de conformidad

Existe soporte documental para aplicar un proceso de calidad, pero todavía faltan aprobaciones, auditorías internas, registros de competencia, evidencia de restauración y resultados de satisfacción. Por ello, el estado correcto es **alineación parcial de referencia**, no conformidad ni certificación ISO 9001.
