# Ficha de perfilado y calidad de datos

**Código:** INS-09  
**Versión:** 1.0  
**Técnica:** análisis de datos  
**Herramientas planificadas en el informe:** Pandas y Great Expectations

## Estado

La app valida campos durante la importación CSV, pero el repositorio actual no contiene un pipeline de Pandas/Great Expectations. Esta ficha define la evidencia que deberá producirse si se ejecuta ese trabajo.

## Identificación del dataset

- Nombre y versión: ____________________
- Origen: ____________________
- Periodo: ____________________
- Tipo: ☐ real ☐ simulado ☐ prueba
- Filas/columnas: ______ / ______
- Hash: ____________________
- Responsable: ____________________

## Resultados

| Regla | Resultado | Umbral | Estado | Evidencia |
|---|---:|---:|---|---|
| Campos requeridos no nulos | ____ % | meta aprobada | C/NC | |
| Fechas válidas y dentro del periodo | ____ % | 100 % | C/NC | |
| Productos reconocidos | ____ % | 100 % | C/NC | |
| Ubicaciones normalizadas | ____ % | 100 % | C/NC | |
| Cantidades/costos no negativos | ____ % | 100 % | C/NC | |
| Duplicados exactos | ____ | 0 o justificados | C/NC | |
| Valores atípicos revisados | ____ | 100 % revisados | C/NC | |
| Continuidad diaria por SKU/tienda | ____ % | meta aprobada | C/NC | |

## Tratamiento

| Hallazgo | Registros afectados | Decisión: corregir/excluir/conservar | Regla y justificación | Responsable |
|---|---:|---|---|---|
| | | | | |

No imputar ni eliminar datos sin conservar el valor original, la regla, el código y la justificación. Para ML futuro, ejecutar transformaciones dentro del pipeline para evitar fuga de datos.

## Salidas requeridas

- reporte reproducible;
- script y dependencias versionadas;
- dataset de entrada inmutable;
- dataset transformado con hash;
- resumen de exclusiones/correcciones;
- aprobación del responsable de datos.
