# Plan de mejora continua y auditoría interna

**Código:** ISO-AUD-01  
**Versión:** 1.0  
**Frecuencia propuesta:** por liberación y revisión mensual durante el piloto

## Revisión por liberación

1. Confirmar alcance y cambios incluidos.
2. Revisar requisitos, riesgos y documentación afectada.
3. Ejecutar análisis estático y regresión automatizada.
4. Ejecutar casos manuales críticos en el celular objetivo.
5. Revisar privacidad, permisos, archivos y respaldo.
6. Registrar incidentes y resolver los de prioridad alta/crítica.
7. Generar APK, versión, hash y acta de despliegue.
8. Obtener aceptación del responsable antes de usar datos reales.

## Auditoría mensual

| Pregunta | Evidencia | Resultado |
|---|---|---|
| ¿Los requisitos corresponden al comportamiento real? | matriz, código, demostración | Conforme / NC / observación |
| ¿Las pruebas corresponden a la versión instalada? | hash, resultados, dispositivo | Conforme / NC / observación |
| ¿Los registros diarios están completos y conciliados? | reporte y muestreo | Conforme / NC / observación |
| ¿Los CSV y respaldos están protegidos? | permisos, ubicación, simulacro | Conforme / NC / observación |
| ¿Los datos simulados están separados? | nombres y metadatos | Conforme / NC / observación |
| ¿Las incidencias tienen causa y cierre eficaz? | registro de defectos | Conforme / NC / observación |
| ¿Se actualizó la documentación tras cada cambio? | Git y bitácora | Conforme / NC / observación |

## Indicadores de mejora

- defectos abiertos por severidad;
- tiempo medio de corrección;
- porcentaje de casos críticos aprobados;
- porcentaje de registros completos;
- errores de importación por archivo;
- restauraciones exitosas;
- tareas de usuario completadas sin ayuda;
- satisfacción del personal;
- merma y diferencia producción–ventas, únicamente con datos reales comparables.

## Priorización inicial

1. Corregir la coherencia del informe con la app offline y heurística.
2. Implementar y probar respaldo/restauración.
3. Completar pruebas de integración, UI y aceptación.
4. Añadir log de decisiones si se medirá adopción de recomendaciones.
5. Decidir formalmente si el alcance final incluirá web/backend/ML.
6. Solo entonces construir y evaluar el pipeline ML evitando fuga temporal.

## Registro de auditoría

Cada auditoría debe incluir fecha, alcance, versión, auditor, entrevistados, muestras, hallazgos, no conformidades, acciones, responsables, plazo y verificación de cierre. Auditor y responsable de aprobación: **Pendientes de designar**.
