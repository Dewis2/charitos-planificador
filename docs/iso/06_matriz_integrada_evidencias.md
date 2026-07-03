# Matriz integrada de requisitos y evidencias ISO

**Código:** ISO-MAT-01  
**Versión:** 1.0  
**Fecha:** 2026-07-03

| ID | Marco | Tema aplicado | Evidencia actual | Estado | Brecha / siguiente evidencia |
|---|---|---|---|---|---|
| E-01 | ISO 9001 | Contexto y alcance | contexto, requisitos, línea base | Documentado | aprobación de partes interesadas |
| E-02 | ISO 9001 | Objetivos de calidad | `02_iso_9001_gestion_calidad.md` | Propuesto | metas y responsables aprobados |
| E-03 | ISO 9001 | Control documental | Git + índice `docs/` | Parcial | autor, revisor y aprobación por documento |
| E-04 | ISO 9001 | Operación controlada | reglas, arquitectura, importador | Parcial | procedimiento operativo firmado |
| E-05 | ISO 9001 | Evaluación y mejora | plan de pruebas y bitácora | Parcial | auditoría, no conformidades y revisión de eficacia |
| E-06 | ISO/IEC 25000 | Adecuación funcional | módulos Flutter y requisitos | Implementado | UAT con usuarios reales |
| E-07 | ISO/IEC 25000 | Integridad/fiabilidad | restricciones SQLite y pruebas | Parcial | recuperación y pruebas de integración |
| E-08 | ISO/IEC 25000 | Interacción | prototipo y pantallas | Implementado | observación y encuesta aplicadas |
| E-09 | ISO/IEC 25000 | Desempeño | no hay medición archivada | Pendiente | benchmark en celular objetivo |
| E-10 | ISO/IEC 25000 | Mantenibilidad | capas, contrato de predictor, análisis estático | Parcial | cobertura y complejidad |
| E-11 | ISO/IEC/IEEE 29119 | Planificación | `docs/pruebas/01_estrategia_y_plan_pruebas.md` | Documentado | aprobación del plan |
| E-12 | ISO/IEC/IEEE 29119 | Diseño | casos unitarios y especificación manual | Parcial | casos de integración, seguridad y UAT |
| E-13 | ISO/IEC/IEEE 29119 | Ejecución | pruebas automatizadas | Verificar por versión | evidencias manuales y dispositivo |
| E-14 | ISO/IEC/IEEE 29119 | Incidentes/cierre | plantillas creadas | Pendiente | registros reales y firma de cierre |
| E-15 | ISO/IEC 27000 | Activos y riesgos | alcance y registro de riesgos | Documentado | propietario y aceptación formal |
| E-16 | ISO/IEC 27000 | Integridad | validación CSV y restricciones SQLite | Parcial | hash, log de cambios y respaldo |
| E-17 | ISO/IEC 27000 | Confidencialidad | almacenamiento local | Insuficiente | acceso, cifrado y retención |
| E-18 | ISO/IEC 27000 | Disponibilidad | app offline | Parcial | copia y restauración probadas |
| E-19 | Informe | ML operativo | `MlDemandPredictor` no implementado | Pendiente | pipeline, modelo, versión y evaluación temporal |
| E-20 | Informe | Adopción de recomendaciones | no se registra aceptación/modificación | Pendiente | log de decisión y observación |
| E-21 | Informe | Cierre de caja | fuera del alcance actual | No implementado | instrumento externo o nuevo módulo |
| E-22 | Informe | Instrumentos | formatos en `docs/instrumentos/` | Diseñados | validación, piloto, aplicación y resultados |

## Criterio de auditoría

Una fila solo pasa a **Verificado** cuando existe evidencia reproducible, fechada, vinculada a una versión y revisada por una persona responsable. La sola existencia de una plantilla equivale a “documentado” o “diseñado”, no a “cumplido”.
