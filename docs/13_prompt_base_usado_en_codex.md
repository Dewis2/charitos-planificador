# Prompt base usado para orientar a Codex

## Nota de trazabilidad

Este documento presenta un **prompt base consolidado y reproducible** a partir de los requisitos disponibles, las reglas comunicadas y la implementación actual. No se dispone de evidencia que permita afirmar que corresponde palabra por palabra al primer mensaje utilizado durante todo el desarrollo. El historial íntegro y su aprobación formal están **Pendientes de completar por el equipo investigador**.

## Prompt consolidado

```text
Actúa como ingeniero de software senior especializado en Flutter, aplicaciones
Android offline, SQLite, arquitectura por capas y pruebas automatizadas.

Contexto del negocio:
Desarrolla una aplicación para la Pastelería Charito's que ayude a registrar
productos, stock, producción para vitrina, ventas, merma, lotes y pedidos
confirmados. El problema central es el desajuste entre producción y demanda,
que puede generar sobrantes, vencimientos y merma.

Alcance técnico:
- Aplicación móvil Android creada con Flutter y Dart.
- Funcionamiento completamente offline.
- Persistencia SQLite local; no usar Firebase, Supabase ni backend remoto.
- Estado e inyección de dependencias con Riverpod.
- Interfaz en español y Material 3.
- Importación y exportación CSV UTF-8.
- Arquitectura separada en presentación, dominio, datos, servicios y core.

Módulos solicitados:
1. Productos: crear, editar, buscar, filtrar y desactivar.
2. Stock histórico por producto, fecha y ubicación.
3. Producción para vitrina y creación de lotes.
4. Ventas de vitrina con consumo FEFO.
5. Merma con motivo y costo estimado.
6. Pedidos confirmados como módulo independiente.
7. Lotes, vencimientos y alertas.
8. Recomendación inicial de producción.
9. Dashboard y reportes.
10. Importación/exportación CSV y configuración local.

Reglas de cálculo:
- Estimar demanda de vitrina con promedios históricos explicables.
- Aplicar:
  PRp = max(0, DEp + SSp - SVp - PPp - AMp)
- Excluir productos vencidos del stock vendible.
- Identificar lotes por vencer mediante un umbral configurable.
- Consumir existencias aplicando FEFO.
- Respetar lote mínimo y múltiplo de producción.
- Calcular merma física y económica.

Pedidos confirmados:
- No usar pedidos confirmados para estimar ventas espontáneas de vitrina.
- Mantenerlos separados de las ventas regulares.
- Mostrar:
  producción_total_operativa = recomendación_vitrina
                             + pedidos_confirmados_del_día
- Cambiar pedidos no debe cambiar PRp.

Preparación para Machine Learning:
- La primera versión no debe afirmar ni simular que utiliza ML real.
- Definir un contrato de predictor desacoplado.
- Implementar inicialmente una heurística.
- Dejar una implementación futura de ML como marcador sin lógica activa.
- Permitir reemplazar el predictor sin reescribir inventario, interfaz o datos.

Calidad y aceptación:
- Validar campos, fechas, cantidades y catálogos.
- Usar claves foráneas y restricciones de integridad.
- Crear pruebas para demanda ponderada, stock vendible, vencimientos, merma,
  redondeo, resultado no negativo y separación de pedidos.
- Ejecutar flutter analyze y flutter test.
- Documentar limitaciones y no inventar validaciones o resultados.
```

## Información que alimentó el desarrollo asistido

| Tipo de insumo | Uso dentro del proyecto |
|---|---|
| Contexto de Pastelería Charito's | Definición del problema y lenguaje de la interfaz. |
| Imágenes de catálogo | Nombres, tipos y precios de productos para archivos importables. |
| Estructuras históricas | Definición de columnas para stock, producción, ventas, merma y pedidos. |
| Reglas operativas | Separación de vitrina/pedidos, vida útil, vencimientos y FEFO. |
| Requisitos académicos | Matrices, instrumentos, estándares, trazabilidad y documentación. |
| Código y pruebas | Verificación de arquitectura, campos, fórmula y límites reales. |

## Restricciones éticas y de validación

Codex puede proponer código, datos simulados y documentación, pero el equipo investigador debe verificar exactitud, adecuación metodológica, privacidad y aceptación de usuarios. Los datos simulados no constituyen evidencia de reducción real de merma.
