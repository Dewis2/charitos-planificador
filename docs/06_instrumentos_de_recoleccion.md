# Instrumentos de recolección de información

## Alcance

El informe de tesis actual emplea registro documental, *data logging*, observación sistemática, encuesta estructurada y análisis de datos. Cada instrumento fue separado en un archivo utilizable dentro de [`instrumentos/`](instrumentos/).

## Inventario

| Instrumento | Archivo | Aplicabilidad actual |
|---|---|---|
| Registro histórico de merma | [INS-01](instrumentos/01_ficha_registro_historico_merma.md) | Implementable con merma SQLite/CSV |
| Registro operativo del sistema | [INS-02](instrumentos/02_registro_operativo_sistema.md) | Adaptado de PostgreSQL/MySQL planificado a SQLite real |
| Log de decisiones de recomendación | [INS-03](instrumentos/03_log_decisiones_recomendacion.md) | Captura pendiente en la app |
| Reporte de producción del taller | [INS-04](instrumentos/04_reporte_produccion_diaria_taller.md) | Implementable con producción y lotes |
| Cierre de caja | [INS-05](instrumentos/05_cierre_caja_diario_tienda.md) | Fuera del alcance actual |
| Encuesta Likert de adopción | [INS-06](instrumentos/06_encuesta_adopcion_personal.md) | Pendiente de validar y aplicar |
| Observación sistemática | [INS-07](instrumentos/07_ficha_observacion_sistematica.md) | Pendiente de aplicar |
| Verificación de despliegue | [INS-08](instrumentos/08_lista_verificacion_despliegue.md) | Aplicable al APK |
| Perfilado de calidad de datos | [INS-09](instrumentos/09_ficha_perfilado_calidad_datos.md) | Pipeline Pandas/GE pendiente |
| Evaluación de modelos | [INS-10](instrumentos/10_ficha_evaluacion_modelos_predictivos.md) | No aplicable hasta implementar ML |
| Mapa AS-IS / TO-BE | [INS-11](instrumentos/11_mapa_procesos_as_is_to_be.md) | Pendiente de validar con el negocio |
| Consentimiento informado | [INS-12](instrumentos/12_consentimiento_informado.md) | Borrador para revisión ética |
| Matriz de operacionalización | [INS-13](instrumentos/13_matriz_operacionalizacion_instrumentos.md) | Trazabilidad documentada |

## Advertencia metodológica

Crear un formato no equivale a validarlo ni aplicarlo. Las firmas de expertos, el piloto, el alfa de Cronbach, los resultados pretest/postest y las métricas predictivas siguen pendientes hasta contar con evidencia real. Los datos simulados de la app no deben presentarse como resultados empíricos.
