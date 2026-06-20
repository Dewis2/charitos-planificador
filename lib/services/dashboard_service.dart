import '../core/utils/date_utils.dart';
import '../domain/entities/recommendation.dart';
import '../domain/repositories/inventory_repository.dart';
import 'production_recommendation_service.dart';

class DashboardService {
  DashboardService(this._repository, this._recommendations);
  final InventoryRepository _repository;
  final ProductionRecommendationService _recommendations;

  Future<DashboardData> load(DateTime now) async {
    final today = AppDateUtils.dateOnly(now);
    final products = await _repository.getProducts();
    final productNames = {
      for (final product in products) product.id: product.name,
    };
    final lots = await _repository.getLots();
    final settings = await _repository.getSettings();
    final wasteRows = await _repository.rawExport('waste_records');
    final productionRows = await _repository.rawExport('production_records');
    final salesRows = await _repository.rawExport('sales_records');
    final recs = await _recommendations.recommendAll(today);
    final todayKey = AppDateUtils.toStorage(today);

    double sumToday(List<Map<String, Object?>> rows, String field) => rows
        .where((row) => row['date'] == todayKey)
        .fold(0, (sum, row) => sum + (row[field] as num).toDouble());
    final monthlyWaste = <String, double>{};
    final monthlyCost = <String, double>{};
    final topWaste = <String, double>{};
    for (final row in wasteRows) {
      final month = (row['date'] as String).substring(0, 7);
      final quantity = (row['quantity'] as num).toDouble();
      monthlyWaste[month] = (monthlyWaste[month] ?? 0) + quantity;
      monthlyCost[month] =
          (monthlyCost[month] ?? 0) + (row['estimated_cost'] as num).toDouble();
      final name = productNames[row['product_id']] ?? 'Producto';
      topWaste[name] = (topWaste[name] ?? 0) + quantity;
    }
    final productionVsSales = <String, List<double>>{};
    for (var i = 6; i >= 0; i--) {
      productionVsSales[AppDateUtils.toStorage(
        today.subtract(Duration(days: i)),
      )] = [
        0,
        0,
      ];
    }
    for (final row in productionRows) {
      final bucket = productionVsSales[row['date']];
      if (bucket != null) bucket[0] += (row['quantity'] as num).toDouble();
    }
    for (final row in salesRows) {
      final bucket = productionVsSales[row['date']];
      if (bucket != null) bucket[1] += (row['quantity'] as num).toDouble();
    }
    final sortedTop = topWaste.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return DashboardData(
      activeProducts: products.where((p) => p.active).length,
      inactiveProducts: products.where((p) => !p.active).length,
      todayWaste: sumToday(wasteRows, 'quantity'),
      todayWasteCost: sumToday(wasteRows, 'estimated_cost'),
      expiringProducts: lots
          .where(
            (lot) =>
                lot.currentQuantity > 0 &&
                lot.isExpiringOn(today, settings.expiringThresholdDays),
          )
          .map((lot) => lot.productId)
          .toSet()
          .length,
      expiredProducts: lots
          .where((lot) => lot.currentQuantity > 0 && lot.isExpiredOn(today))
          .map((lot) => lot.productId)
          .toSet()
          .length,
      todayRecommendedProduction: recs.fold(
        0,
        (sum, rec) => sum + rec.displayRecommendation,
      ),
      todaySales: sumToday(salesRows, 'quantity'),
      todayProduction: sumToday(productionRows, 'quantity'),
      monthlyWaste: Map.fromEntries(
        monthlyWaste.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
      monthlyWasteCost: Map.fromEntries(
        monthlyCost.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
      productionVsSales: productionVsSales,
      topWasteProducts: Map.fromEntries(sortedTop.take(5)),
    );
  }
}
