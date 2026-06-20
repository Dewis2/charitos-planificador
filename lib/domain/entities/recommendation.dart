import 'product.dart';

class DemandEstimate {
  const DemandEstimate({
    required this.value,
    required this.hasSufficientData,
    required this.source,
    this.average7Days = 0,
    this.averageSameWeekday = 0,
    this.average30Days = 0,
  });
  final double value;
  final bool hasSufficientData;
  final String source;
  final double average7Days;
  final double averageSameWeekday;
  final double average30Days;
}

class ProductionRecommendation {
  const ProductionRecommendation({
    required this.product,
    required this.date,
    required this.demandEstimate,
    required this.sellableStock,
    required this.expiringStock,
    required this.expiredStock,
    required this.safetyStock,
    required this.scheduledDisplayProduction,
    required this.wasteRate,
    required this.wasteAdjustment,
    required this.displayRecommendation,
    required this.confirmedOrdersProduction,
  });
  final Product product;
  final DateTime date;
  final DemandEstimate demandEstimate;
  final double sellableStock;
  final double expiringStock;
  final double expiredStock;
  final double safetyStock;
  final double scheduledDisplayProduction;
  final double wasteRate;
  final double wasteAdjustment;
  final double displayRecommendation;
  final double confirmedOrdersProduction;
  double get totalOperationalProduction =>
      displayRecommendation + confirmedOrdersProduction;
}

class DashboardData {
  const DashboardData({
    required this.activeProducts,
    required this.inactiveProducts,
    required this.todayWaste,
    required this.todayWasteCost,
    required this.expiringProducts,
    required this.expiredProducts,
    required this.todayRecommendedProduction,
    required this.todaySales,
    required this.todayProduction,
    required this.monthlyWaste,
    required this.monthlyWasteCost,
    required this.productionVsSales,
    required this.topWasteProducts,
  });
  final int activeProducts;
  final int inactiveProducts;
  final double todayWaste;
  final double todayWasteCost;
  final int expiringProducts;
  final int expiredProducts;
  final double todayRecommendedProduction;
  final double todaySales;
  final double todayProduction;
  final Map<String, double> monthlyWaste;
  final Map<String, double> monthlyWasteCost;
  final Map<String, List<double>> productionVsSales;
  final Map<String, double> topWasteProducts;
}
