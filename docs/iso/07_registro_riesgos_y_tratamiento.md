# Registro de riesgos y tratamiento

**Código:** ISO-RSK-01  
**Versión:** 1.0  
**Escala:** probabilidad e impacto de 1 a 5; nivel = P × I

| ID | Riesgo | P | I | Nivel | Tratamiento propuesto | Responsable | Estado |
|---|---|---:|---:|---:|---|---|---|
| R-01 | Pérdida o daño del único teléfono con la base | 3 | 5 | 15 | respaldo cifrado y simulacro de restauración | Por designar | Abierto |
| R-02 | Acceso no autorizado en dispositivo compartido | 4 | 4 | 16 | bloqueo Android, custodia y autenticación futura | Por designar | Abierto |
| R-03 | CSV enviado o almacenado sin protección | 4 | 4 | 16 | canal autorizado, cifrado y eliminación controlada | Por designar | Abierto |
| R-04 | Importación de datos alterados, duplicados o con fechas erróneas | 3 | 4 | 12 | validación, copia previa, reporte de errores y conciliación | Encargado de datos | Parcial |
| R-05 | Confundir datos simulados con resultados reales | 3 | 5 | 15 | etiquetado inequívoco, repositorios separados y revisión | Equipo investigador | Abierto |
| R-06 | Recomendación inadecuada por historial insuficiente | 4 | 4 | 16 | mostrar fundamento, límites y revisión humana | Product Owner | Parcial |
| R-07 | Presentar heurística como Machine Learning | 3 | 5 | 15 | declaración de línea base y corrección del informe | Equipo investigador | Mitigado documentalmente |
| R-08 | No poder reproducir una versión evaluada | 3 | 4 | 12 | tag Git, hash de APK, fecha y configuración | Desarrollador | Abierto |
| R-09 | Pérdida de trazabilidad por editar/anular movimientos sin log | 3 | 4 | 12 | auditoría de cambios y motivo obligatorio | Desarrollador | Abierto |
| R-10 | Datos personales de pedidos expuestos | 3 | 5 | 15 | minimización, seudonimización y retención definida | Responsable del estudio | Abierto |
| R-11 | Pruebas insuficientes en SQLite, UI y dispositivo | 4 | 4 | 16 | pruebas de integración, widget, sistema y UAT | QA por designar | Abierto |
| R-12 | Fechas y periodos inconsistentes en el informe | 4 | 3 | 12 | línea temporal única y control de cambios | Tesistas/asesor | Abierto |
| R-13 | Dependencias o APK vulnerables/desactualizados | 3 | 4 | 12 | revisión periódica, compilación reproducible y firma | Desarrollador | Abierto |
| R-14 | Sesgo o fuga temporal al evaluar futuro ML | 3 | 5 | 15 | partición temporal, pipeline reproducible y conjunto independiente | Responsable ML | Pendiente de ML |

## Seguimiento

Revisar riesgos antes de cada liberación y al menos mensualmente durante el piloto. Registrar fecha, evidencia, riesgo residual y aceptación. Los riesgos con nivel 15 o mayor requieren una decisión explícita antes de usar la app con datos reales.
