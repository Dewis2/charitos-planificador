import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database_helper.dart';
import '../../data/repositories_impl/local_inventory_repository.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/entities/records.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../services/csv_export_service.dart';
import '../../services/csv_import_service.dart';
import '../../services/dashboard_service.dart';
import '../../services/demand_estimation_service.dart';
import '../../services/production_recommendation_service.dart';
import '../../services/report_service.dart';

class DataVersion extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state++;
}

final dataVersionProvider = NotifierProvider<DataVersion, int>(DataVersion.new);
final repositoryProvider = Provider<InventoryRepository>(
  (ref) => LocalInventoryRepository(DatabaseHelper.instance),
);
final demandServiceProvider = Provider(
  (ref) => DemandEstimationService(ref.watch(repositoryProvider)),
);
final demandPredictorProvider = Provider<DemandPredictor>(
  (ref) => HeuristicDemandPredictor(ref.watch(demandServiceProvider)),
);
final recommendationServiceProvider = Provider(
  (ref) => ProductionRecommendationService(
    ref.watch(repositoryProvider),
    ref.watch(demandPredictorProvider),
    detailsService: ref.watch(demandServiceProvider),
  ),
);
final dashboardServiceProvider = Provider(
  (ref) => DashboardService(
    ref.watch(repositoryProvider),
    ref.watch(recommendationServiceProvider),
  ),
);
final csvImportServiceProvider = Provider(
  (ref) => CsvImportService(ref.watch(repositoryProvider)),
);
final csvExportServiceProvider = Provider(
  (ref) => CsvExportService(ref.watch(repositoryProvider)),
);
final reportServiceProvider = Provider(
  (ref) => ReportService(ref.watch(repositoryProvider)),
);

final productsProvider = FutureProvider<List<Product>>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(repositoryProvider).getProducts();
});
final activeProductsProvider = FutureProvider<List<Product>>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(repositoryProvider).getProducts(active: true);
});
final lotsProvider = FutureProvider<List<ProductionLot>>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(repositoryProvider).getLots();
});
final ordersProvider = FutureProvider<List<OrderRecord>>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(repositoryProvider).getOrders();
});
final settingsProvider = FutureProvider<AppSettings>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(repositoryProvider).getSettings();
});
final recommendationsProvider = FutureProvider<List<ProductionRecommendation>>((
  ref,
) {
  ref.watch(dataVersionProvider);
  return ref.watch(recommendationServiceProvider).recommendAll(DateTime.now());
});
final dashboardProvider = FutureProvider<DashboardData>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(dashboardServiceProvider).load(DateTime.now());
});
final reportProvider = FutureProvider<ReportData>((ref) {
  ref.watch(dataVersionProvider);
  return ref.watch(reportServiceProvider).load(DateTime.now());
});
