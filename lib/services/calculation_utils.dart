import 'dart:math' as math;

import '../domain/entities/records.dart';

class CalculationUtils {
  CalculationUtils._();

  static double average(Iterable<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  static double weightedDemand({
    required List<double> last7Days,
    required List<double> sameWeekday,
    required List<double> last30Days,
  }) {
    final components = <(double, double)>[];
    if (last7Days.isNotEmpty) components.add((average(last7Days), 0.50));
    if (sameWeekday.isNotEmpty) components.add((average(sameWeekday), 0.30));
    if (last30Days.isNotEmpty) components.add((average(last30Days), 0.20));
    if (components.isEmpty) return 0;
    final weight = components.fold<double>(0, (sum, item) => sum + item.$2);
    return components.fold<double>(0, (sum, item) => sum + item.$1 * item.$2) /
        weight;
  }

  static double sellableStock(Iterable<ProductionLot> lots, DateTime date) =>
      lots
          .where((lot) => lot.currentQuantity > 0 && !lot.isExpiredOn(date))
          .fold(0, (sum, lot) => sum + lot.currentQuantity);
  static double expiringStock(
    Iterable<ProductionLot> lots,
    DateTime date,
    int threshold,
  ) => lots
      .where(
        (lot) => lot.currentQuantity > 0 && lot.isExpiringOn(date, threshold),
      )
      .fold(0, (sum, lot) => sum + lot.currentQuantity);
  static double expiredStock(Iterable<ProductionLot> lots, DateTime date) =>
      lots
          .where((lot) => lot.currentQuantity > 0 && lot.isExpiredOn(date))
          .fold(0, (sum, lot) => sum + lot.currentQuantity);

  static double wasteRate(double totalWaste, double totalProduction) =>
      totalProduction <= 0 ? 0 : (totalWaste / totalProduction).clamp(0, 1);
  static double wasteAdjustment(double demand, double rate, double factor) =>
      demand * rate * factor;

  static double rawRecommendation({
    required double demand,
    required double safetyStock,
    required double sellableStock,
    required double scheduledProduction,
    required double wasteAdjustment,
  }) => math.max(
    0,
    demand +
        safetyStock -
        sellableStock -
        scheduledProduction -
        wasteAdjustment,
  );

  static double roundToBatch(
    double value, {
    required double minimumBatch,
    required double multiple,
  }) {
    if (value <= 0) return 0;
    var result = math.max(value, minimumBatch);
    if (multiple > 0) result = (result / multiple).ceil() * multiple;
    return result;
  }
}
