import '../domain/entities/product.dart';
import '../domain/entities/recommendation.dart';
import '../domain/repositories/inventory_repository.dart';
import 'calculation_utils.dart';

abstract class DemandPredictor {
  Future<double> predictDemand(Product product, DateTime date);
}

class DemandEstimationService {
  DemandEstimationService(this._repository);
  final InventoryRepository _repository;

  Future<DemandEstimate> estimate(Product product, DateTime date) async {
    if (product.id == null)
      return const DemandEstimate(
        value: 0,
        hasSufficientData: false,
        source: 'Datos insuficientes para estimar demanda',
      );
    final end = DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(const Duration(days: 1));
    final start30 = end.subtract(const Duration(days: 29));
    final sales = await _repository.dailySales(product.id!, start30, end);
    if (sales.isNotEmpty) {
      final last7Start = end.subtract(const Duration(days: 6));
      final last7 = sales.entries
          .where((entry) => !entry.key.isBefore(last7Start))
          .map((entry) => entry.value)
          .toList();
      final sameWeekday = <double>[];
      for (var weeks = 1; weeks <= 4; weeks++) {
        final target = DateTime(
          date.year,
          date.month,
          date.day,
        ).subtract(Duration(days: 7 * weeks));
        final value = sales[target];
        if (value != null) sameWeekday.add(value);
      }
      final last30 = sales.values.toList();
      return DemandEstimate(
        value: CalculationUtils.weightedDemand(
          last7Days: last7,
          sameWeekday: sameWeekday,
          last30Days: last30,
        ),
        hasSufficientData: true,
        source: 'Promedio ponderado de ventas de vitrina',
        average7Days: CalculationUtils.average(last7),
        averageSameWeekday: CalculationUtils.average(sameWeekday),
        average30Days: CalculationUtils.average(last30),
      );
    }

    final from = end.subtract(const Duration(days: 29));
    final production = await _repository.totalProduction(
      product.id!,
      from,
      end,
    );
    final waste = await _repository.totalWaste(product.id!, from, end);
    if (production > 0) {
      return DemandEstimate(
        value: (production - waste).clamp(0, double.infinity),
        hasSufficientData: true,
        source: 'Producción histórica menos merma',
      );
    }
    return const DemandEstimate(
      value: 0,
      hasSufficientData: false,
      source: 'Datos insuficientes para estimar demanda',
    );
  }
}

/// Esta capa puede ser reemplazada posteriormente por un modelo de Machine Learning local o remoto.
class HeuristicDemandPredictor implements DemandPredictor {
  HeuristicDemandPredictor(this._service);
  final DemandEstimationService _service;
  @override
  Future<double> predictDemand(Product product, DateTime date) async =>
      (await _service.estimate(product, date)).value;
}

/// Placeholder para una integración futura; deliberadamente no contiene lógica predictiva.
class MlDemandPredictor implements DemandPredictor {
  @override
  Future<double> predictDemand(Product product, DateTime date) =>
      throw UnimplementedError('El predictor ML aún no está habilitado');
}
