# Instrumentos del informe de tesis

Esta carpeta separa cada técnica e instrumento citado en el informe actual y lo convierte en un formato utilizable. La existencia del formato no demuestra que haya sido validado o aplicado.

## Estado de los instrumentos

| Código | Instrumento | Relación con la app actual | Estado |
|---|---|---|---|
| INS-01 | [Ficha de registro histórico de merma](01_ficha_registro_historico_merma.md) | tabla `waste_records` y CSV | Aplicable |
| INS-02 | [Registro operativo del sistema](02_registro_operativo_sistema.md) | SQLite local, no PostgreSQL/MySQL | Aplicable con adaptación |
| INS-03 | [Log de decisiones de recomendación](03_log_decisiones_recomendacion.md) | no existe captura de aceptar/modificar | Pendiente de implementar |
| INS-04 | [Reporte de producción diaria del taller](04_reporte_produccion_diaria_taller.md) | tabla `production_records` | Aplicable |
| INS-05 | [Cierre de caja diario por tienda](05_cierre_caja_diario_tienda.md) | no existe módulo de caja | Instrumento externo / pendiente |
| INS-06 | [Encuesta de adopción al personal](06_encuesta_adopcion_personal.md) | evalúa uso y percepción | Pendiente de validar y aplicar |
| INS-07 | [Ficha de observación sistemática](07_ficha_observacion_sistematica.md) | evalúa el flujo real | Pendiente de aplicar |
| INS-08 | [Lista de verificación de despliegue](08_lista_verificacion_despliegue.md) | APK Android offline | Aplicable |
| INS-09 | [Ficha de perfilado de calidad de datos](09_ficha_perfilado_calidad_datos.md) | importador actual; GE no implementado | Parcial / pendiente de pipeline |
| INS-10 | [Ficha de evaluación de modelos predictivos](10_ficha_evaluacion_modelos_predictivos.md) | no existe ML real | No aplicable todavía |
| INS-11 | [Mapa de procesos AS-IS / TO-BE](11_mapa_procesos_as_is_to_be.md) | técnica de diagnóstico | Pendiente de validar con el negocio |
| INS-12 | [Consentimiento informado](12_consentimiento_informado.md) | anexo del informe sin cuerpo recuperable | Borrador para revisión ética |
| INS-13 | [Matriz de operacionalización de instrumentos](13_matriz_operacionalizacion_instrumentos.md) | trazabilidad metodológica | Documentada |

## Reglas de aplicación

1. Aprobar versión, responsables y periodo antes de aplicar.
2. Realizar revisión experta y piloto cuando corresponda.
3. Separar datos reales, datos simulados y pruebas técnicas.
4. Conservar evidencia de fecha, lugar, aplicador y participante.
5. Proteger datos personales y comerciales.
6. No completar retrospectivamente firmas, validaciones ni resultados inexistentes.

El informe menciona validez de contenido por asesor y experto operativo, revisión técnica y alfa de Cronbach ≥ 0,70. Esos mecanismos son **criterios planificados**; deben adjuntarse las fichas firmadas, el dataset y el cálculo para afirmar que fueron ejecutados.
