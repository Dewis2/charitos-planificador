# Seguridad de la información basada en ISO/IEC 27000

**Código:** ISO-ISMS-01  
**Versión:** 1.0  
**Referencias:** ISO/IEC 27001:2022 e ISO/IEC 27002:2022  
**Estado:** análisis y controles iniciales; sin SGSI certificado

## Alcance

El alcance cubre el teléfono Android, el APK, la base SQLite, los archivos CSV exportados/importados, el repositorio de código y la documentación del estudio. No hay servidor ni nube en la implementación actual.

## Activos

| Activo | Propietario propuesto | Confidencialidad | Integridad | Disponibilidad |
|---|---|---:|---:|---:|
| Base SQLite operativa | Charito's | Media | Alta | Alta |
| Ventas, costos y merma | Charito's | Alta | Alta | Media |
| Pedidos y contacto de clientes | Charito's | Alta | Alta | Media |
| CSV de intercambio y respaldo | Encargado designado | Alta | Alta | Alta |
| APK y código fuente | Equipo del proyecto | Media | Alta | Media |
| Instrumentos y consentimientos | Equipo investigador | Alta | Alta | Alta |

## Riesgos principales

- acceso al teléfono compartido sin autenticación interna;
- pérdida, robo o daño del dispositivo;
- exportación CSV en texto legible y reenvío no autorizado;
- ausencia de respaldo/restauración verificados;
- modificación o duplicación de CSV antes de importarlos;
- datos personales de pedidos conservados sin política de retención;
- APK o dependencias desactualizadas;
- confusión entre datos simulados y datos reales;
- falta de trazabilidad de ediciones/anulaciones.

El detalle y tratamiento están en [07_registro_riesgos_y_tratamiento.md](07_registro_riesgos_y_tratamiento.md).

## Controles implementados

- operación offline, que reduce exposición remota;
- persistencia privada administrada por Android/SQLite;
- claves foráneas y restricciones de valores en la base;
- validación de formatos durante la importación;
- separación de pedidos confirmados y demanda de vitrina;
- código y documentación versionables en Git.

Estos controles no eliminan el riesgo de acceso físico ni protegen por sí solos un CSV exportado.

## Controles requeridos

| Prioridad | Control | Evidencia esperada |
|---|---|---|
| Alta | Bloqueo del dispositivo, usuario responsable y PIN/biometría | acta y captura de configuración sin exponer secretos |
| Alta | Respaldo cifrado y prueba periódica de restauración | registro de respaldo y acta de simulacro |
| Alta | Carpeta autorizada y canal seguro para CSV | procedimiento y permisos revisados |
| Alta | Minimización y retención de datos de clientes | política y registro de eliminación |
| Alta | Identificación clara de datasets simulados | nombre, metadatos y aviso en cada archivo |
| Media | Autenticación/roles dentro de la app | pruebas de acceso por rol |
| Media | Registro de altas, cambios y anulaciones | log inalterable o exportable |
| Media | Revisión de dependencias y firma de APK | reporte de dependencias y hash del artefacto |
| Media | Gestión de incidentes | formato, responsable y simulacro |

## Copias y recuperación

Debe definirse: qué se respalda, frecuencia, responsable, ubicación cifrada, retención y procedimiento de restauración. Una copia no se considera control eficaz hasta que se restaura satisfactoriamente en una prueba documentada.

## Privacidad y ética

Recoger únicamente datos necesarios. Evitar publicar nombres, teléfonos, ventas, costos o consentimientos. Los datos de tesis deben seudonimizarse y almacenarse separados de la clave de reidentificación. La autorización académica no equivale a consentimiento para difusión pública.

## Incidentes

Ante pérdida, acceso indebido, archivo alterado o borrado: contener, preservar evidencia, notificar al responsable, evaluar impacto, recuperar desde copia confiable, documentar causa y aplicar acción correctiva.

## Estado de conformidad

La app cuenta con algunas salvaguardas técnicas derivadas de su operación offline, pero no existe evidencia de un SGSI completo, análisis aprobado, declaración de aplicabilidad ni auditoría. No debe afirmarse certificación ISO/IEC 27001.
