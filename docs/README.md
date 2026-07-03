# Documentación de Charito's Planifica

## Contenido

Esta carpeta contiene la documentación académica y técnica que vincula el problema de merma de Pastelería Charito's con la solución móvil desarrollada. Incluye contexto, matrices de investigación, requisitos, instrumentos, modelo de datos, reglas de cálculo, arquitectura, intervención, pruebas, estándares, prompt base, decisiones y trabajo futuro de Machine Learning.

También incluye un [prototipo navegable de interfaz](prototipo_app/index.html) y su [ficha técnica](16_prototipo_de_interfaz.md), útiles para demostración y evaluación preliminar de usabilidad.

El expediente ampliado solicitado para el informe se organiza en tres carpetas: [`iso/`](iso/) para la aplicación de ISO 9001, ISO/IEC 25000, ISO/IEC/IEEE 29119 e ISO/IEC 27000; [`instrumentos/`](instrumentos/) para los formatos metodológicos; y [`pruebas/`](pruebas/) para la evidencia de verificación. La entrada resumida es [17_expediente_normativo_e_instrumentos.md](17_expediente_normativo_e_instrumentos.md).

El punto de entrada recomendado es [00_indice_documentacion.md](00_indice_documentacion.md). Las plantillas de intercambio utilizadas por la aplicación permanecen en [`csv_templates/`](csv_templates/).

## Cómo utilizar los documentos

1. Usar el contexto y las matrices como base del planteamiento metodológico.
2. Contrastar requisitos, datos, cálculo y arquitectura con el capítulo técnico.
3. Completar únicamente con evidencia los apartados marcados como pendientes.
4. Ejecutar el plan de pruebas y adjuntar resultados, fechas, responsables y capturas.
5. Mantener la bitácora y el prompt base bajo control de versiones.
6. Adaptar formato, numeración y referencias a la guía oficial de la institución.
7. Mantener separados los estados **implementado**, **verificado**, **planificado** y **pendiente**.

## Relación con Codex

La documentación evidencia los insumos que orientaron el desarrollo asistido: contexto del negocio, catálogo, estructuras históricas, requisitos, reglas de producción, restricciones offline y preparación futura para ML. Codex apoyó la generación y revisión de código y documentación bajo supervisión humana.

Codex no es un componente predictivo dentro del APK y su intervención no sustituye la revisión del equipo investigador.

## Relación con el informe de tesis

Los documentos pueden servir como anexos o insumos para capítulos de planteamiento, metodología, desarrollo, pruebas y discusión. Deben ser revisados por el equipo y el asesor antes de incorporarse al informe. No constituyen por sí solos evidencia de validación de instrumentos, conformidad ISO, aceptación experta o impacto real.

## Estado actual del proyecto

- aplicación Android offline implementada con Flutter;
- datos almacenados localmente en SQLite;
- módulos operativos y recomendación heurística disponibles;
- pruebas unitarias para reglas críticas;
- importación y exportación CSV;
- arquitectura preparada para cambiar el predictor;
- modelo Machine Learning real no implementado;
- validación metodológica, instrumentos aplicados y evaluación pretest/postest pendientes de completar por el equipo investigador.

La documentación ISO representa una alineación académica y un plan de evidencias. No afirma certificación ni conformidad total.

## Regla de actualización

Toda modificación significativa del código, fórmula, modelo de datos, instrumento o alcance debe reflejarse en esta carpeta y en la bitácora técnica. La versión, autores, revisores y fecha de aprobación documental están **Pendientes de completar por el equipo investigador**.
