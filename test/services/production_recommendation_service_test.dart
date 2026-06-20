import 'package:charitos_planificador/domain/entities/product.dart';
import 'package:charitos_planificador/domain/entities/records.dart';
import 'package:charitos_planificador/domain/repositories/inventory_repository.dart';
import 'package:charitos_planificador/services/demand_estimation_service.dart';
import 'package:charitos_planificador/services/production_recommendation_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FixedPredictor implements DemandPredictor {
  @override
  Future<double> predictDemand(Product product, DateTime date) async => 10;
}

class _FakeRepository implements InventoryRepository {
  _FakeRepository(this.confirmedOrders);
  final double confirmedOrders;

  @override
  Future<AppSettings> getSettings() async =>
      const AppSettings(batchRoundingEnabled: false);
  @override
  Future<List<ProductionLot>> getLots({int? productId}) async => [];
  @override
  Future<double> totalProduction(
    int productId,
    DateTime from,
    DateTime to,
  ) async => 0;
  @override
  Future<double> totalWaste(int productId, DateTime from, DateTime to) async =>
      0;
  @override
  Future<double> scheduledProduction(int productId, DateTime date) async => 0;
  @override
  Future<double> confirmedOrdersQuantity(
    int productId,
    DateTime deliveryDate,
  ) async => confirmedOrders;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'los pedidos confirmados no cambian la recomendación de vitrina',
    () async {
      final date = DateTime(2026, 6, 19);
      final product = Product(
        id: 1,
        name: 'Torta chocolate',
        category: 'torta',
        unit: 'unidad',
        shelfLifeDays: 5,
        unitCost: 20,
        salePrice: 35,
        minimumStock: 0,
        safetyStock: 0,
        minimumProductionBatch: 1,
        productionMultiple: 1,
        estimatedProductionMinutes: 60,
        productionType: 'ambos',
        appliesRecommendation: true,
        active: true,
        createdAt: date,
        updatedAt: date,
      );

      final withoutOrders = await ProductionRecommendationService(
        _FakeRepository(0),
        _FixedPredictor(),
      ).recommend(product, date);
      final withOrders = await ProductionRecommendationService(
        _FakeRepository(100),
        _FixedPredictor(),
      ).recommend(product, date);

      expect(withoutOrders.displayRecommendation, 10);
      expect(withOrders.displayRecommendation, 10);
      expect(withOrders.confirmedOrdersProduction, 100);
      expect(withOrders.totalOperationalProduction, 110);
    },
  );
}
