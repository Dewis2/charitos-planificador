# Limitaciones y trabajo futuro de Machine Learning

## Limitaciones actuales

1. **No existe un modelo ML activo.** La demanda se estima mediante promedios ponderados y reglas explícitas.
2. **No existe evidencia longitudinal real suficiente documentada.** Los datos simulados sirven para probar la aplicación, no para entrenar o validar científicamente.
3. **La estacionalidad es limitada.** La heurística considera ventanas recientes y el mismo día de semana, pero no modela feriados, campañas, clima o promociones.
4. **Los datos son locales por instalación.** No hay sincronización ni consolidación automática entre dispositivos o locales.
5. **No hay autenticación ni roles.** El control depende del acceso al dispositivo.
6. **No hay respaldo integral cifrado.** CSV permite intercambio tabular, pero no restaura toda la base ni su historial técnico.
7. **La plataforma entregada es Android.** Otras plataformas no forman parte de la aceptación actual.
8. **La validación con usuarios y el impacto real están pendientes.** No debe afirmarse una reducción de merma sin evaluación pretest/postest.

## Datos necesarios para ML

- ventas de vitrina por producto, fecha y ubicación;
- producción preparada y producción programada;
- stock inicial/final y quiebres de stock;
- merma, motivo y costo;
- vida útil, lotes y vencimientos;
- precio y cambios de precio;
- día de semana, mes y temporada;
- feriados, campañas, promociones y eventos;
- pedidos confirmados como demanda conocida separada;
- variables externas pertinentes cuya disponibilidad y legitimidad se verifiquen.

La aplicación actual registra una parte central de estas variables. El calendario de eventos, promociones y otras variables externas requiere ampliación.

## Modelos candidatos

| Alternativa | Posible uso | Consideración |
|---|---|---|
| Random Forest | Demanda por producto con variables de calendario, inventario y categoría | Robusto para relaciones no lineales; requiere construir retardos y evitar fuga de información. |
| XGBoost | Pronóstico supervisado con múltiples características y productos | Puede ofrecer alta precisión, pero necesita ajuste, validación temporal y control de complejidad. |
| Prophet | Series con tendencia y estacionalidad para productos con histórico suficiente | Debe evaluarse por producto y frente a baselines; no garantiza ventaja en series escasas o intermitentes. |
| TensorFlow Lite | Despliegue local de un modelo compatible en Android | Es un formato/motor de inferencia, no un algoritmo específico; exige conversión, versionado y pruebas en dispositivo. |

La selección final no debe basarse solo en precisión. Debe considerar interpretabilidad, tamaño de datos, latencia, mantenimiento, privacidad y capacidad de ejecución offline.

## Ruta de evolución

1. **Consolidar datos:** definir un periodo real suficiente, responsables y frecuencia de registro.
2. **Limpiar datos:** corregir duplicados, faltantes, errores de fecha, cambios de catálogo y días sin operación.
3. **Entrenar modelos:** separar entrenamiento, validación y prueba respetando el orden temporal; mantener la heurística como baseline.
4. **Evaluar:** comparar MAE, RMSE y MAPE, documentando el tratamiento de demanda cero y series intermitentes.
5. **Integrar:** versionar el modelo, implementar inferencia y permitir volver a la heurística ante fallos.
6. **Comparar pretest/postest:** medir planificación, merma física y económica antes y después, controlando variables intervinientes.

## Criterios antes de activar ML

- calidad y cobertura temporal aprobadas;
- modelo superior a un baseline en datos no vistos;
- evaluación por producto y por periodo;
- explicación de entradas y salida;
- latencia y consumo compatibles con el dispositivo;
- política de actualización, monitoreo y reversión;
- autorización metodológica y evidencia reproducible.

El periodo mínimo, algoritmo elegido, hiperparámetros, métricas objetivo y resultados están **Pendientes de completar por el equipo investigador**.
