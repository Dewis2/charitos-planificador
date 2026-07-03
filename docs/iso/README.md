# Expediente ISO de Charito's Planifica

## Propósito

Este expediente registra cómo se gestiona y evalúa la aplicación **Charito's Planifica** tomando como referencia ISO 9001, la familia SQuaRE ISO/IEC 25000, ISO/IEC/IEEE 29119 y la familia ISO/IEC 27000.

Los documentos son una aplicación académica y proporcional al proyecto. **No constituyen una certificación ni una declaración de conformidad total.** Una auditoría formal requiere evidencia aprobada, responsables designados y, cuando corresponda, un organismo competente.

## Regla de lectura

Cada afirmación usa uno de estos estados:

- **Implementado:** existe en el código o en el flujo actual de la app.
- **Verificado:** además de estar implementado, cuenta con una prueba o revisión fechada.
- **Planificado en el informe:** figura en el plan de tesis, pero no existe todavía en la app.
- **Pendiente:** falta implementación o evidencia suficiente.
- **No aplica al alcance actual:** corresponde a un componente que la app offline no utiliza.

## Documentos

| Archivo | Contenido |
|---|---|
| [01_linea_base_y_trazabilidad.md](01_linea_base_y_trazabilidad.md) | Diferencias entre el informe de tesis, la app implementada y el trabajo pendiente. |
| [02_iso_9001_gestion_calidad.md](02_iso_9001_gestion_calidad.md) | Procesos, objetivos, control documental, no conformidades y mejora. |
| [03_iso_iec_25000_calidad_software.md](03_iso_iec_25000_calidad_software.md) | Modelo de calidad y métricas de evaluación del producto. |
| [04_iso_iec_ieee_29119_pruebas.md](04_iso_iec_ieee_29119_pruebas.md) | Gobierno, proceso, documentación y técnicas de prueba. |
| [05_iso_iec_27000_seguridad.md](05_iso_iec_27000_seguridad.md) | Alcance de seguridad, activos, riesgos y controles. |
| [06_matriz_integrada_evidencias.md](06_matriz_integrada_evidencias.md) | Trazabilidad entre norma, control, evidencia y brecha. |
| [07_registro_riesgos_y_tratamiento.md](07_registro_riesgos_y_tratamiento.md) | Registro priorizado de riesgos técnicos, operativos y de información. |
| [08_plan_mejora_y_auditoria.md](08_plan_mejora_y_auditoria.md) | Ciclo de revisión, indicadores, auditoría interna y mejora continua. |

Los formatos específicos del informe están en [`../instrumentos/`](../instrumentos/) y la documentación de pruebas en [`../pruebas/`](../pruebas/).

## Referencias normativas oficiales

- [ISO 9001:2015 — Sistemas de gestión de la calidad](https://www.iso.org/standard/62085.html). A julio de 2026 continúa publicada; ISO informa una nueva edición en fase FDIS para septiembre de 2026.
- [ISO/IEC 25010:2023 — Modelo de calidad del producto](https://www.iso.org/standard/78176.html), dentro de SQuaRE.
- [ISO/IEC/IEEE 29119-2:2021 — Procesos de prueba](https://www.iso.org/standard/79428.html) e [ISO/IEC/IEEE 29119-3:2021 — Documentación de prueba](https://www.iso.org/standard/79429.html).
- [ISO/IEC 27001:2022 — Requisitos de un SGSI](https://www.iso.org/standard/27001) e [ISO/IEC 27002:2022 — Controles de seguridad](https://www.iso.org/standard/75652.html).

No se reproduce el texto protegido de las normas; se documenta una interpretación operativa aplicada al proyecto.
