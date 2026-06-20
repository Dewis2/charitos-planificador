import 'package:charitos_planificador/domain/entities/records.dart';
import 'package:charitos_planificador/services/calculation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 6, 19);
  ProductionLot lot(double quantity, DateTime expiry) => ProductionLot(
    productId: 1,
    productionDate: today.subtract(const Duration(days: 1)),
    expiryDate: expiry,
    initialQuantity: quantity,
    currentQuantity: quantity,
    location: 'general',
    status: 'vendible',
    createdAt: today,
  );

  group('estimación de demanda', () {
    test('calcula el promedio ponderado 50/30/20', () {
      final value = CalculationUtils.weightedDemand(
        last7Days: [10, 10],
        sameWeekday: [20, 20],
        last30Days: [30, 30],
      );
      expect(value, 17);
    });

    test('normaliza los pesos cuando hay menos datos', () {
      final value = CalculationUtils.weightedDemand(
        last7Days: [12],
        sameWeekday: [],
        last30Days: [18],
      );
      expect(value, closeTo(13.714285, 0.00001));
    });
  });

  group('vida útil y stock', () {
    final lots = <ProductionLot>[
      lot(8, today.add(const Duration(days: 3))),
      lot(4, today.add(const Duration(days: 1))),
      lot(6, today),
      lot(2, today.subtract(const Duration(days: 1))),
    ];

    test(
      'suma únicamente stock vendible',
      () => expect(CalculationUtils.sellableStock(lots, today), 12),
    );
    test(
      'identifica stock por vencer',
      () => expect(CalculationUtils.expiringStock(lots, today, 2), 4),
    );
    test(
      'excluye y contabiliza productos vencidos',
      () => expect(CalculationUtils.expiredStock(lots, today), 8),
    );
  });

  group('merma y recomendación', () {
    test(
      'calcula tasa de merma',
      () => expect(CalculationUtils.wasteRate(20, 100), .2),
    );
    test(
      'calcula ajuste por merma',
      () => expect(CalculationUtils.wasteAdjustment(20, .2, .5), 2),
    );
    test('aplica la fórmula de producción recomendada', () {
      expect(
        CalculationUtils.rawRecommendation(
          demand: 20,
          safetyStock: 5,
          sellableStock: 4,
          scheduledProduction: 3,
          wasteAdjustment: 2,
        ),
        16,
      );
    });
    test('nunca recomienda valores negativos', () {
      expect(
        CalculationUtils.rawRecommendation(
          demand: 5,
          safetyStock: 0,
          sellableStock: 20,
          scheduledProduction: 0,
          wasteAdjustment: 0,
        ),
        0,
      );
    });
    test('redondea al múltiplo superior y respeta lote mínimo', () {
      expect(
        CalculationUtils.roundToBatch(13, minimumBatch: 5, multiple: 5),
        15,
      );
      expect(
        CalculationUtils.roundToBatch(2, minimumBatch: 10, multiple: 5),
        10,
      );
      expect(
        CalculationUtils.roundToBatch(0, minimumBatch: 10, multiple: 5),
        0,
      );
    });
  });
}
