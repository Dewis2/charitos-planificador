# Requerimientos no funcionales

| Código | Categoría | Descripción | Criterio de aceptación |
|---|---|---|---|
| RNF01 | Usabilidad | La interfaz debe utilizar etiquetas en español, navegación consistente y formularios con validación comprensible. | Un usuario puede completar los flujos principales sin campos ambiguos; los errores identifican el dato inválido. La evaluación formal de usabilidad está pendiente de completar por el equipo investigador. |
| RNF02 | Rendimiento | Las consultas, registros y cálculos habituales deben responder de manera adecuada en un dispositivo Android compatible. | Los flujos principales no presentan bloqueos perceptibles con el volumen de datos definido para la prueba. El dispositivo patrón y los umbrales temporales están pendientes de completar por el equipo investigador. |
| RNF03 | Seguridad | Los datos deben permanecer en el dispositivo y la aplicación no debe incluir credenciales o servicios remotos innecesarios. | No se realizan solicitudes de red para operar y no se almacenan secretos de producción en el repositorio. No existe autenticación local en la versión actual. |
| RNF04 | Mantenibilidad | La lógica de presentación, dominio, datos y servicios debe permanecer separada y contar con pruebas para reglas críticas. | Las reglas de demanda y recomendación pueden probarse sin depender de pantallas; `flutter analyze` y las pruebas automatizadas concluyen sin errores antes de una entrega. |
| RNF05 | Portabilidad | El proyecto debe compilar como aplicación Android desde un entorno Flutter compatible. | `flutter build apk` genera un APK instalable. La versión actual no compromete entrega para iOS, web o escritorio. |
| RNF06 | Disponibilidad offline | Productos, movimientos, reportes y recomendaciones deben funcionar sin internet. | Los flujos principales operan con SQLite local y no requieren Firebase, API ni servicio cloud. |
| RNF07 | Integridad de datos | La persistencia debe aplicar identificadores, claves foráneas, restricciones de no negatividad y unicidad donde corresponda. | SQLite mantiene claves foráneas activas, producto único por nombre y restricciones `CHECK` en cantidades y montos. |
| RNF08 | Interoperabilidad | La aplicación debe intercambiar datos tabulares mediante CSV UTF-8. | Se aceptan cabeceras documentadas, fechas `AAAA-MM-DD` y separadores coma o punto y coma; los errores se informan por fila. |
| RNF09 | Trazabilidad | Cada movimiento debe guardar fecha, producto, cantidades y momento de creación; las observaciones deben conservar contexto operativo. | Los registros de stock, producción, ventas, merma, lotes y pedidos contienen los campos trazables definidos en el modelo. |
| RNF10 | Confiabilidad | Los cálculos no deben producir cantidades negativas y deben excluir stock vencido. | La recomendación usa `max(0, ...)`; las pruebas cubren resultados no negativos y exclusión de vencidos. |
| RNF11 | Escalabilidad futura hacia ML | La fuente de predicción debe poder reemplazarse sin acoplar el modelo a la interfaz ni al repositorio. | `ProductionRecommendationService` consume `DemandPredictor`; una implementación futura respeta ese contrato. |
| RNF12 | Privacidad | Los datos de clientes deben limitarse a los necesarios para gestionar pedidos y tratarse conforme a las políticas aplicables. | Se documentan propósito, acceso, conservación y eliminación antes de usar información real. La política institucional está pendiente de completar por el equipo investigador. |
| RNF13 | Recuperación | Debe existir un mecanismo de exportación de datos operativos. | El usuario puede exportar CSV. La copia integral cifrada y la restauración de SQLite no forman parte de esta versión. |

## Consideraciones

Los criterios que requieren mediciones de tiempo, encuestas, dispositivos específicos, revisión de seguridad o pruebas con usuarios deben ejecutarse y adjuntar evidencia. No se considera que estén validados únicamente por aparecer en esta especificación.
