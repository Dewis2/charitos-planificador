# Estrategia y plan de pruebas

**Código:** TST-PLAN-01  
**Versión:** 1.0  
**Fecha:** 2026-07-03

## Objetivo y alcance

Verificar la app Android offline, reglas de cálculo, importación CSV, persistencia SQLite y flujos operativos. Web, API y ML quedan fuera porque no están implementados.

## Elementos bajo prueba

- catálogo y configuración;
- stock, producción, ventas, merma, lotes y pedidos;
- recomendación heurística y reportes;
- importación/exportación CSV;
- persistencia, funcionamiento offline y recuperación.

## Enfoque por riesgo

Prioridad alta: pérdida/corrupción de datos, stock vencido contado como vendible, mezcla de pedidos con vitrina, recomendación negativa, importación parcial silenciosa y exposición de datos. Prioridad media: visualización, rendimiento, compatibilidad y mensajes.

## Niveles

| Nivel | Responsable propuesto | Ambiente | Estado |
|---|---|---|---|
| Unitario | desarrollador | Flutter test | Ejecutado parcialmente |
| Integración | desarrollador/QA | SQLite temporal + CSV | Pendiente |
| Widget/UI | desarrollador/QA | Flutter test | Pendiente |
| Sistema | QA/PO | APK en celular objetivo | Pendiente |
| Aceptación | usuarios autorizados | tienda/taller controlado | Pendiente |

## Entradas y salidas

Entrada: versión identificada, requisitos, casos, dataset de prueba y ambiente. Salida: resultados, evidencia, incidencias, reejecuciones, riesgos residuales y decisión.

## Criterios

- Entrada: compilación disponible, datos de prueba identificados y respaldo previo si el dispositivo contiene datos reales.
- Salida: 100 % de casos críticos aprobados, 0 defectos críticos/altos abiertos, regresión y análisis estático aprobados, y riesgos residuales aceptados.

## Suspensión y reanudación

Suspender si hay pérdida de datos, cierre repetible, ambiente equivocado o riesgo para información real. Reanudar con causa controlada, versión corregida, datos restaurados y caso de regresión añadido.

## Entorno pendiente de registrar

Modelo de teléfono, Android, memoria/almacenamiento, versión Flutter/Dart, versión APK, hash y dataset de referencia: **Pendientes para la prueba en dispositivo**.
