# Pruebas basadas en ISO/IEC/IEEE 29119

**Código:** ISO-TST-01  
**Versión:** 1.0  
**Referencias:** partes 1:2022, 2:2021, 3:2021 y 4:2021  
**Estado:** proceso definido; evidencia parcial

## Aplicación proporcional

La serie 29119 se usa para ordenar el gobierno, la gestión, el diseño, la ejecución y la documentación de pruebas. El proyecto adopta un conjunto liviano de documentos enlazados en [`../pruebas/`](../pruebas/), adecuado a un equipo pequeño y a Scrum.

## Niveles y tipos

| Nivel / tipo | Objetivo | Evidencia actual |
|---|---|---|
| Prueba unitaria | Verificar fórmulas, redondeo, estimación e importación | `test/services/` |
| Integración local | Verificar servicio–repositorio–SQLite–CSV | Parcial; faltan pruebas automatizadas con BD real |
| Interfaz | Verificar formularios, navegación y mensajes | Pendiente de pruebas de widget |
| Sistema | Verificar flujo completo en APK | Checklist y ejecución manual pendientes |
| Aceptación | Confirmar ajuste al proceso de tienda/taller | UAT y firmas pendientes |
| Regresión | Evitar reaparición de defectos | `flutter test` y `flutter analyze` antes de liberar |
| Seguridad/recuperación | Evaluar acceso, archivos y respaldo | Pendiente |
| Rendimiento | Medir dataset de referencia en dispositivo | Pendiente |

## Proceso de prueba

1. Planificar alcance, riesgos, ambiente, responsables y criterios.
2. Analizar requisitos y diseñar condiciones de prueba.
3. Especificar datos, pasos y resultados esperados.
4. Preparar APK, dispositivo y dataset controlado.
5. Ejecutar y conservar evidencia.
6. Registrar incidentes y repetir después de corregir.
7. Evaluar criterios de salida y emitir informe de cierre.

## Técnicas de diseño seleccionadas

- particiones de equivalencia para campos y CSV;
- valores límite para cantidades, costos, vida útil y lotes;
- tablas de decisión para stock, merma, pedidos y recomendación;
- transición de estados para pedidos y lotes;
- casos de uso para flujos completos;
- pruebas basadas en experiencia para desconexión, duplicados, caracteres y fechas.

## Criterios de entrada

- versión identificada y compilable;
- requisitos y casos revisados;
- datos de prueba separados de datos reales;
- dispositivo con espacio disponible;
- respaldo de información existente cuando se prueba sobre un equipo operativo.

## Criterios de salida

- 100 % de pruebas críticas ejecutadas y aprobadas;
- 0 incidentes críticos o altos abiertos;
- regresión automatizada aprobada;
- análisis estático sin incidencias;
- limitaciones y riesgos residuales aceptados por responsable designado.

## Trazabilidad requerida

Cada resultado debe vincular: requisito → riesgo → condición/caso → versión → resultado → evidencia → incidencia → reejecución. Los documentos de prueba no sustituyen la ejecución real.

## Brechas

Faltan pruebas de widget, integración con SQLite real, respaldo/restauración, seguridad, rendimiento y aceptación formal. También falta cobertura para un modelo ML y una API, que deberán añadirse solo cuando esos componentes existan.
