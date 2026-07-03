# Línea base y trazabilidad informe–aplicación

**Código:** ISO-TRA-01  
**Versión:** 1.0  
**Fecha de corte:** 2026-07-03  
**Fuente:** informe de tesis actual y repositorio local

## Línea base real de la aplicación

Charito's Planifica es una aplicación móvil Android desarrollada con Flutter. Funciona sin conexión, conserva sus datos en SQLite dentro del dispositivo y usa Riverpod para inyección de dependencias y estado. Incluye productos, stock, producción, ventas, merma, lotes, pedidos confirmados, recomendaciones, reportes y transferencia CSV.

La recomendación vigente es **heurística**, no Machine Learning: combina promedios de ventas recientes y del mismo día de semana, calcula stock vendible, merma esperada, stock de seguridad y redondeo por lote. `MlDemandPredictor` es solamente un punto de extensión que lanza `UnimplementedError`.

## Diferencias que deben declararse en la tesis

| Tema | Plan de tesis | Implementación actual | Estado / acción documental |
|---|---|---|---|
| Canales | Sistema web y móvil | Aplicación móvil Android | Actualizar alcance o implementar el canal web. |
| Persistencia | PostgreSQL/MySQL y Firestore en distintas secciones | SQLite local | Documentar SQLite como línea base real. |
| Backend | API Flask/FastAPI desplegada en nube | No existe backend ni API | Pendiente si se mantiene el alcance ML/cloud. |
| Autenticación | Firebase Auth, usuarios y roles | No existe autenticación | Riesgo abierto para dispositivos compartidos. |
| Predicción | Random Forest, XGBoost o Prophet | Promedio ponderado heurístico | No presentar métricas MAE/RMSE/MAPE de ML como resultados actuales. |
| Log de adopción | Recomendación aceptada o modificada | Se calcula y exporta la recomendación, pero no se registra la decisión del usuario | Instrumento diseñado; implementación pendiente. |
| Caja | Cierre, arqueo, anulaciones y devoluciones | No existe módulo de caja | Instrumento externo o ampliación futura. |
| Calidad de datos | Pandas y Great Expectations | Validación de campos al importar CSV; no existe pipeline GE | Mantener como actividad planificada. |
| Periodo pre/post | Registros 2025 y evaluación 2026 según distintas secciones | Se dispone de datos simulados marzo–junio 2026 | Alinear fechas y separar datos simulados de evidencia real. |
| Despliegue | Infraestructura cloud | APK instalado localmente | Registrar versión, hash y dispositivo; nube no aplicable hoy. |

## Evidencia técnica actual

| Evidencia | Ubicación |
|---|---|
| Arquitectura y alcance offline | `README.md`, `docs/09_arquitectura_del_sistema.md` |
| Esquema SQLite y restricciones | `lib/core/database/database_helper.dart` |
| Reglas de recomendación | `lib/services/demand_estimation_service.dart`, `lib/services/production_recommendation_service.dart`, `lib/services/calculation_utils.dart` |
| Importación y exportación | `lib/services/csv_import_service.dart`, `lib/services/csv_export_service.dart`, `docs/csv_templates/` |
| Pruebas automatizadas | `test/services/` |
| Requisitos y casos | `docs/04_requerimientos_funcionales.md`, `docs/05_requerimientos_no_funcionales.md`, `docs/pruebas/` |
| Instrumentos de investigación | `docs/instrumentos/` |

## Regla para resultados académicos

Los datos simulados sirven para demostrar funciones y probar el flujo, pero **no deben mezclarse con observaciones reales ni usarse para demostrar reducción de merma, adopción, precisión predictiva o causalidad**. Esos resultados requieren instrumentos aplicados, evidencia fechada y análisis aprobado por el equipo investigador.
