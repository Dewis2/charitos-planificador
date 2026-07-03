# Contexto del proyecto

## Título

**Aplicación móvil offline perfilada para Machine Learning para apoyar la planificación de producción y la reducción de merma en la Pastelería Charito's.**

La denominación definitiva del proyecto de investigación y su correspondencia con la carátula institucional están **Pendientes de completar por el equipo investigador**.

## Contexto organizacional

Pastelería Charito's desarrolla actividades de producción y comercialización de tortas, pasteles y productos relacionados. La operación requiere decidir cuánto producir para vitrina, registrar existencias, controlar la vida útil, atender pedidos confirmados y reconocer las unidades que terminan como merma.

La información disponible para orientar el sistema comprendió el catálogo de productos y precios, los tipos de producto, las estructuras requeridas para registrar stock, producción, ventas, merma y pedidos, y las reglas operativas comunicadas por el equipo solicitante. La caracterización cuantitativa formal del negocio —volumen promedio, número de trabajadores, sedes evaluadas y tasa histórica real de merma— está **Pendiente de completar por el equipo investigador**.

## Problema principal

El problema abordado es la merma originada o agravada por el desajuste entre la producción preparada y la demanda efectiva. Una producción superior a la venta esperada puede generar sobrantes o vencimientos; una producción inferior puede producir quiebres de stock y pérdida de oportunidades de venta.

Antes de plantear un modelo predictivo es necesario disponer de datos estructurados, consistentes y trazables. Por ello, la primera versión prioriza la digitalización de los movimientos operativos y una recomendación inicial explicable.

## Alcance actual

La solución actual es una aplicación móvil Android desarrollada con Flutter y diseñada para operar sin conexión a internet. Incluye:

- gestión de productos y parámetros de vida útil;
- registros de stock, producción para vitrina, ventas y merma;
- lotes y control de vencimiento;
- pedidos confirmados en un módulo independiente;
- dashboard, reportes e intercambio mediante CSV;
- recomendación heurística de producción para vitrina;
- persistencia local mediante SQLite.

La aplicación no depende de Firebase, Supabase, servicios web ni una base de datos remota. Cada instalación mantiene su información en el dispositivo.

## Alcance futuro

La arquitectura incorpora el contrato `DemandPredictor`, lo que permite sustituir la implementación heurística por un predictor futuro sin reescribir la interfaz, el inventario ni la persistencia principal. El alcance futuro contempla consolidar datos históricos, entrenar y evaluar un modelo de predicción de demanda e integrarlo localmente o mediante un servicio controlado.

## Estado real de la inteligencia artificial

- **Codex:** se utilizó como asistente de desarrollo y documentación bajo supervisión del equipo.
- **Aplicación actual:** utiliza reglas internas y promedios ponderados; no ejecuta un modelo de Machine Learning entrenado.
- **Machine Learning futuro:** existe una interfaz preparada y un marcador `MlDemandPredictor`, pero su método no está implementado.

En consecuencia, no corresponde afirmar que la aplicación actual predice mediante IA o que un modelo ML ya fue validado.
