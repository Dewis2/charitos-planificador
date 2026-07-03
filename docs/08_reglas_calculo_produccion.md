# Reglas de cálculo de producción

## Estado actual

La aplicación todavía no utiliza Machine Learning. La estimación de demanda es heurística, explicable y basada en promedios históricos. `HeuristicDemandPredictor` implementa el contrato `DemandPredictor`; `MlDemandPredictor` es únicamente un punto de extensión y actualmente genera una excepción si se invoca.

## Estimación de demanda de vitrina

La estimación primaria combina tres componentes:

```text
DEp = 0.50 × promedio_ventas_últimos_7_días
    + 0.30 × promedio_mismo_día_de_semana_últimas_4_semanas
    + 0.20 × promedio_ventas_últimos_30_días
```

Si falta un componente, se utilizan los disponibles y se normalizan sus pesos. Si no existen ventas, la aplicación usa como respaldo la producción histórica menos la merma del periodo. Si tampoco hay producción, informa que los datos son insuficientes.

Los pedidos no se consultan para estimar `DEp`.

## Stock vendible y vida útil

- Un lote es vendible cuando tiene cantidad actual positiva y no está vencido en la fecha evaluada.
- Un lote que vence en la fecha evaluada se clasifica como vencido y no se suma al stock vendible.
- Los lotes con días restantes entre 1 y el umbral configurado se consideran próximos a vencer.
- Las salidas por venta y merma consumen lotes según **FEFO** (*First Expired, First Out*): primero el lote con vencimiento más próximo.

## Merma histórica

```text
tasa_merma = merma_del_periodo / produccion_del_periodo
AMp = DEp × tasa_merma × factor_ajuste_merma
```

La tasa se limita al intervalo de 0 a 1. Si la producción es cero, la tasa es cero. El factor inicial configurado es `0.5`, pero puede modificarse en la pantalla de configuración.

## Fórmula de recomendación

```text
PRp = max(0, DEp + SSp - SVp - PPp - AMp)
```

Donde:

- `PRp`: producción recomendada para vitrina del producto `p`.
- `DEp`: demanda estimada de vitrina.
- `SSp`: stock de seguridad configurado.
- `SVp`: stock vendible disponible en lotes no vencidos.
- `PPp`: producción para vitrina ya programada o registrada para la fecha.
- `AMp`: ajuste por merma histórica.

El resultado nunca es negativo. Cuando el redondeo está activo, una recomendación positiva respeta el lote mínimo y se eleva al siguiente múltiplo configurado.

## Tratamiento de pedidos confirmados

Los pedidos confirmados representan demanda segura y se calculan por separado. No modifican `DEp` ni `PRp`.

```text
produccion_total_operativa = produccion_recomendada_vitrina
                           + produccion_por_pedidos_confirmados
```

La interfaz debe mostrar separadamente:

1. recomendación para vitrina;
2. producción requerida por pedidos confirmados;
3. total operativo.

Esta separación evita que un pedido excepcional eleve artificialmente la estimación de ventas espontáneas futuras.

## Supuestos y límites

- La heurística depende de registros oportunos y consistentes.
- No considera explícitamente clima, promociones, feriados o campañas.
- La ventana de análisis predeterminada es de 30 días.
- No se ha demostrado todavía superioridad estadística respecto al proceso manual.
- Los umbrales de aceptación y el contraste pretest/postest están **Pendientes de completar por el equipo investigador**.
