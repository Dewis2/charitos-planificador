# Registro de ejecución de pruebas

**Código:** TST-EXEC-01  
**Versión evaluada:** árbol de trabajo local  
**Fecha:** 2026-07-03  
**Ejecutor:** Codex, bajo solicitud del equipo

## Ejecución automatizada

| Comando | Resultado | Duración informada |
|---|---|---:|
| `flutter analyze` | Aprobado: `No issues found!` | 60,2 s |
| `flutter test --reporter expanded` | Aprobado: 14/14 pruebas | 1 s de ejecución de pruebas, sin contar carga |

Áreas cubiertas por las 14 pruebas:

- promedio ponderado 50/30/20 y normalización de pesos;
- stock vendible, próximos a vencer y exclusión de vencidos;
- tasa de merma, ajuste, recomendación no negativa y lote mínimo;
- CSV tradicional con comas, CSV Excel con punto y coma/BOM y catálogo completo;
- separación de pedidos confirmados de la recomendación de vitrina.

## Limitación de evidencia

La ejecución se hizo sobre el árbol de trabajo local, que contiene documentación aún no confirmada en Git. No se registró hash de commit ni APK. Este resultado prueba los servicios cubiertos, no la app instalada en el celular.

## Formato para pruebas manuales

| ID caso | Fecha/hora | APK/hash | Dispositivo | Datos | Resultado real | A/NA/B | Evidencia | Incidencia | Ejecutor |
|---|---|---|---|---|---|---|---|---|---|
| | | | | | | | | | |

Leyenda: A = aprobado; NA = no aprobado; B = bloqueado.
