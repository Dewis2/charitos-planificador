import '../domain/entities/product.dart';
import '../domain/entities/recommendation.dart';
import '../domain/repositories/inventory_repository.dart';
import 'calculation_utils.dart';
import 'demand_estimation_service.dart';

class ProductionRecommendationService {
  ProductionRecommendationService(
    this._repository,
    this._predictor, {
    DemandEstimationService? detailsService,
  }) : _detailsService = detailsService;
  final InventoryRepository _repository;
  final DemandPredictor _predictor;
  final DemandEstimationService? _detailsService;

  Future<ProductionRecommendation> recommend(
    Product product,
    DateTime date,
  ) async {
    final settings = await _repository.getSettings();
    final lots = await _repository.getLots(productId: product.id);
    final demandValue = await _predictor.predictDemand(product, date);
    final details = _detailsService == null
        ? DemandEstimate(
            value: demandValue,
            hasSufficientData: demandValue > 0,
            source: demandValue > 0
                ? 'Estimación de demanda'
                : 'Datos insuficientes para estimar demanda',
          )
        : await _detailsService.estimate(product, date);
    final sellable = CalculationUtils.sellableStock(lots, date);
    final expiring = CalculationUtils.expiringStock(
      lots,
      date,
      settings.expiringThresholdDays,
    );
    final expired = CalculationUtils.expiredStock(lots, date);
    final from = date.subtract(Duration(days: settings.historicalAnalysisDays));
    final production = await _repository.totalProduction(
      product.id!,
      from,
      date,
    );
    final waste = await _repository.totalWaste(product.id!, from, date);
    final rate = CalculationUtils.wasteRate(waste, production);
    final adjustment = CalculationUtils.wasteAdjustment(
      demandValue,
      rate,
      settings.wasteAdjustmentFactor,
    );
    final scheduled = await _repository.scheduledProduction(product.id!, date);
    var recommendation = CalculationUtils.rawRecommendation(
      demand: demandValue,
      safetyStock: product.safetyStock,
      sellableStock: sellable,
      scheduledProduction: scheduled,
      wasteAdjustment: adjustment,
    );
    if (settings.batchRoundingEnabled) {
      recommendation = CalculationUtils.roundToBatch(
        recommendation,
        minimumBatch: product.minimumProductionBatch,
        multiple: product.productionMultiple,
      );
    }
    // Los pedidos solo se suman a la carga operativa; nunca alimentan la fórmula de vitrina.
    final confirmedOrders = await _repository.confirmedOrdersQuantity(
      product.id!,
      date,
    );
    return ProductionRecommendation(
      product: product,
      date: date,
      demandEstimate: details,
      sellableStock: sellable,
      expiringStock: expiring,
      expiredStock: expired,
      safetyStock: product.safetyStock,
      scheduledDisplayProduction: scheduled,
      wasteRate: rate,
      wasteAdjustment: adjustment,
      displayRecommendation: recommendation,
      confirmedOrdersProduction: confirmedOrders,
    );
  }

  Future<List<ProductionRecommendation>> recommendAll(DateTime date) async {
    final products = await _repository.getProducts(active: true);
    final eligible = products.where(
      (product) =>
          product.appliesRecommendation && product.productionType != 'pedido',
    );
    return Future.wait(eligible.map((product) => recommend(product, date)));
  }
}
