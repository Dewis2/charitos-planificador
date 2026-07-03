# Expediente normativo e instrumentos del informe

## Objetivo

Registrar de forma auditable la aplicación actual, su relación con el plan de tesis y las evidencias necesarias para evaluarla bajo ISO 9001, ISO/IEC 25000, ISO/IEC/IEEE 29119 e ISO/IEC 27000.

## Fuente revisada

- Documento: `Plan Tesis Continental Sistemas (1).docx`.
- Revisión estructural: 2026-07-03.
- Contenido considerado: texto, tablas, anexos, matriz de operacionalización e instrumento de encuesta.
- Limitación: el anexo de consentimiento solo contiene el encabezado en el contenido recuperado; se creó un borrador claramente marcado para revisión ética.

## Rutas del expediente

1. [Línea base y diferencias entre tesis y app](iso/01_linea_base_y_trazabilidad.md).
2. [Expediente de normas ISO](iso/README.md).
3. [Instrumentos del informe](instrumentos/README.md).
4. [Expediente de pruebas](pruebas/README.md).
5. [Matriz integrada de evidencias y brechas](iso/06_matriz_integrada_evidencias.md).
6. [Registro de riesgos](iso/07_registro_riesgos_y_tratamiento.md).

## Hallazgo principal

El informe propone web, móvil, backend, base centralizada, autenticación y Machine Learning. El repositorio actual implementa una app Android offline con SQLite y una recomendación heurística. La documentación conserva ambas visiones, pero las etiqueta como **planificada** e **implementada** para impedir conclusiones falsas.

## Uso recomendado en la tesis

- emplear la línea base en el capítulo de implementación;
- incorporar los instrumentos como anexos después de validarlos;
- usar los expedientes ISO como plan y matriz de evidencias;
- adjuntar resultados de pruebas, firmas, hashes y capturas reales;
- corregir la inconsistencia de periodos 2025/2026 antes de aprobar el protocolo;
- no reportar precisión ML, reducción causal de merma o adopción hasta ejecutar el estudio con datos reales.

## Estado del expediente

Documentación técnica: elaborada.  
Pruebas automatizadas al 2026-07-03: `flutter analyze` sin incidencias y 14/14 pruebas aprobadas.  
Pruebas en celular, aceptación, aplicación de instrumentos y auditoría: pendientes del equipo investigador.
