import '../core/utils/date_utils.dart';
import '../domain/repositories/inventory_repository.dart';
import 'calculation_utils.dart';

class ReportData {
  const ReportData({
    required this.wasteByProduct,
    required this.wasteByCategory,
    required this.wasteByLocation,
    required this.wasteCostByMonth,
    required this.riskProducts,
    required this.expiringProducts,
    required this.productionVsSales,
  });
  final Map<String, double> wasteByProduct;
  final Map<String, double> wasteByCategory;
  final Map<String, double> wasteByLocation;
  final Map<String, double> wasteCostByMonth;
  final Map<String, double> riskProducts;
  final Map<String, double> expiringProducts;
  final Map<String, List<double>> productionVsSales;
}

class ReportService {
  ReportService(this._repository);
  final InventoryRepository _repository;
  Future<ReportData> load(DateTime now) async {
    final products = await _repository.getProducts();
    final names = {for (final p in products) p.id: p.name};
    final categories = {for (final p in products) p.id: p.category};
    final waste = await _repository.rawExport('waste_records');
    final production = await _repository.rawExport('production_records');
    final sales = await _repository.rawExport('sales_records');
    final lots = await _repository.getLots();
    final settings = await _repository.getSettings();
    final byProduct = <String, double>{};
    final byCategory = <String, double>{};
    final byLocation = <String, double>{};
    final costByMonth = <String, double>{};
    final productionTotals = <int, double>{};
    for (final row in waste) {
      final id = row['product_id'] as int;
      final q = (row['quantity'] as num).toDouble();
      final name = names[id] ?? 'Producto';
      final category = categories[id] ?? 'otro';
      byProduct[name] = (byProduct[name] ?? 0) + q;
      byCategory[category] = (byCategory[category] ?? 0) + q;
      final location = row['location'] as String;
      byLocation[location] = (byLocation[location] ?? 0) + q;
      final month = (row['date'] as String).substring(0, 7);
      costByMonth[month] =
          (costByMonth[month] ?? 0) + (row['estimated_cost'] as num).toDouble();
    }
    for (final row in production) {
      final id = row['product_id'] as int;
      productionTotals[id] =
          (productionTotals[id] ?? 0) + (row['quantity'] as num).toDouble();
    }
    final risk = <String, double>{};
    for (final p in products) {
      final w = byProduct[p.name] ?? 0;
      final rate = CalculationUtils.wasteRate(w, productionTotals[p.id] ?? 0);
      if (rate > 0) risk[p.name] = rate * 100;
    }
    final expiring = <String, double>{};
    final today = AppDateUtils.dateOnly(now);
    for (final lot in lots.where(
      (lot) =>
          lot.currentQuantity > 0 &&
          lot.isExpiringOn(today, settings.expiringThresholdDays),
    )) {
      final name = names[lot.productId] ?? 'Producto';
      expiring[name] = (expiring[name] ?? 0) + lot.currentQuantity;
    }
    final comparison = <String, List<double>>{};
    for (var i = 29; i >= 0; i--) {
      final day = AppDateUtils.toStorage(today.subtract(Duration(days: i)));
      comparison[day] = [0, 0];
    }
    for (final row in production) {
      final target = comparison[row['date']];
      if (target != null) target[0] += (row['quantity'] as num).toDouble();
    }
    for (final row in sales) {
      final target = comparison[row['date']];
      if (target != null) target[1] += (row['quantity'] as num).toDouble();
    }
    Map<String, double> sorted(Map<String, double> source) {
      final entries = source.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return Map.fromEntries(entries);
    }

    return ReportData(
      wasteByProduct: sorted(byProduct),
      wasteByCategory: sorted(byCategory),
      wasteByLocation: sorted(byLocation),
      wasteCostByMonth: Map.fromEntries(
        costByMonth.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      ),
      riskProducts: sorted(risk),
      expiringProducts: sorted(expiring),
      productionVsSales: comparison,
    );
  }
}
