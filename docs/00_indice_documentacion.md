# Índice de documentación del proyecto

## Propósito

La carpeta `docs/` reúne la documentación académica y técnica que contextualiza, especifica y permite auditar el desarrollo de **Charito's Planifica**. Su finalidad es dejar trazabilidad entre el problema de negocio, las variables de investigación, los instrumentos propuestos, los requisitos, el modelo de datos, las reglas de cálculo y la implementación Flutter existente.

Esta documentación también evidencia la información que sirvió como insumo para orientar el trabajo asistido con Codex. Codex fue utilizado como herramienta de apoyo para generar y refactorizar código y documentación bajo supervisión humana; no constituye el modelo predictivo de la aplicación.

## Documentos

| Archivo | Contenido |
|---|---|
| [01_contexto_del_proyecto.md](01_contexto_del_proyecto.md) | Contexto organizacional, problema, alcance actual y proyección hacia Machine Learning. |
| [02_matriz_de_consistencia.md](02_matriz_de_consistencia.md) | Relación entre problema, objetivo, hipótesis, variables y metodología. |
| [03_matriz_operacionalizacion_variables.md](03_matriz_operacionalizacion_variables.md) | Dimensiones, indicadores e instrumentos asociados a las variables. |
| [04_requerimientos_funcionales.md](04_requerimientos_funcionales.md) | Funciones exigidas y su correspondencia con los módulos de la app. |
| [05_requerimientos_no_funcionales.md](05_requerimientos_no_funcionales.md) | Criterios de calidad, operación offline, integridad y mantenibilidad. |
| [06_instrumentos_de_recoleccion.md](06_instrumentos_de_recoleccion.md) | Registros e instrumentos que alimentan o evalúan el sistema. |
| [07_modelo_de_datos_y_datos_historicos.md](07_modelo_de_datos_y_datos_historicos.md) | Entidades, campos, relaciones y utilidad analítica de los datos. |
| [08_reglas_calculo_produccion.md](08_reglas_calculo_produccion.md) | Heurística actual, stock vendible, merma, FEFO y separación de pedidos. |
| [09_arquitectura_del_sistema.md](09_arquitectura_del_sistema.md) | Arquitectura por capas, tecnologías y punto de extensión para ML. |
| [10_intervencion_metodologica.md](10_intervencion_metodologica.md) | Intervención de software y uso supervisado de Codex. |
| [11_plan_de_pruebas.md](11_plan_de_pruebas.md) | Casos de prueba funcionales, unitarios y de integración. |
| [12_estandares_iso_aplicados.md](12_estandares_iso_aplicados.md) | Relación orientativa con ISO 25010, 29119, 27000 y 9001. |
| [13_prompt_base_usado_en_codex.md](13_prompt_base_usado_en_codex.md) | Prompt base reproducible y límites del desarrollo asistido. |
| [14_bitacora_de_decisiones_tecnicas.md](14_bitacora_de_decisiones_tecnicas.md) | Registro de decisiones arquitectónicas y de alcance. |
| [15_limitaciones_y_trabajo_futuro_ml.md](15_limitaciones_y_trabajo_futuro_ml.md) | Limitaciones actuales y ruta propuesta para incorporar ML. |
| [16_prototipo_de_interfaz.md](16_prototipo_de_interfaz.md) | Prototipo navegable, pantallas, flujos y correspondencia con la app Flutter. |
| [17_expediente_normativo_e_instrumentos.md](17_expediente_normativo_e_instrumentos.md) | Puerta de entrada al expediente ISO, los instrumentos del informe y las evidencias de prueba. |
| [README.md](README.md) | Guía de uso de la documentación y relación con el informe de tesis. |

La subcarpeta [`csv_templates/`](csv_templates/) conserva plantillas de intercambio de datos utilizadas por el importador y exportador de la aplicación.

## Expedientes especializados

- [`iso/`](iso/): gestión de calidad ISO 9001, calidad de software ISO/IEC 25000, pruebas ISO/IEC/IEEE 29119 y seguridad ISO/IEC 27000.
- [`instrumentos/`](instrumentos/): cada instrumento citado o derivado del informe, con estado de aplicabilidad y formato de uso.
- [`pruebas/`](pruebas/): estrategia, casos, ejecución, incidencias e informe de cierre.
- [`prototipo_app/`](prototipo_app/): prototipo navegable de la interfaz.

## Fuentes de información empleadas

- Contexto y reglas operativas comunicadas por el equipo solicitante.
- Catálogo de productos y precios proporcionado mediante imágenes.
- Formatos históricos de productos, stock, producción, ventas, merma y pedidos.
- Código fuente actual, entidades, esquema SQLite, servicios de cálculo y pruebas automatizadas.
- Informe de tesis actual `Plan Tesis Continental Sistemas (1).docx`, revisado estructuralmente el 2026-07-03.
- Aspectos metodológicos solicitados por el docente que aún requieren aprobación o ejecución del equipo investigador.

Cuando un dato académico, una fecha, una validación o un resultado empírico no está respaldado por evidencia disponible, se identifica como **“Pendiente de completar por el equipo investigador”**.
