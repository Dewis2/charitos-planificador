import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../core/utils/date_utils.dart';
import '../domain/entities/recommendation.dart';
import '../domain/repositories/inventory_repository.dart';

class CsvExportService {
  CsvExportService(this._repository);
  final InventoryRepository _repository;

  Future<String> exportTable(String table) async {
    final rows = await _repository.rawExport(table);
    final products = await _repository.getProducts();
    final names = {for (final product in products) product.id: product.name};
    final normalized = rows.map((row) {
      final copy = Map<String, Object?>.from(row);
      final productId = copy.remove('product_id');
      if (productId != null) copy['producto_nombre'] = names[productId] ?? '';
      return copy;
    }).toList();
    return _writeAndShare(table, normalized);
  }

  Future<String> exportRecommendations(
    List<ProductionRecommendation> recommendations,
  ) async {
    final rows = recommendations
        .map(
          (r) => <String, Object?>{
            'fecha': AppDateUtils.toStorage(r.date),
            'producto_nombre': r.product.name,
            'categoria': r.product.category,
            'demanda_estimada': r.demandEstimate.value,
            'stock_vendible': r.sellableStock,
            'stock_por_vencer': r.expiringStock,
            'stock_vencido': r.expiredStock,
            'stock_seguridad': r.safetyStock,
            'tasa_merma': r.wasteRate,
            'ajuste_merma': r.wasteAdjustment,
            'produccion_recomendada_vitrina': r.displayRecommendation,
            'produccion_pedidos_confirmados': r.confirmedOrdersProduction,
            'produccion_total_operativa': r.totalOperationalProduction,
          },
        )
        .toList();
    return _writeAndShare('recomendaciones', rows);
  }

  Future<String> _writeAndShare(
    String name,
    List<Map<String, Object?>> rows,
  ) async {
    if (rows.isEmpty) throw StateError('No hay datos para exportar');
    final headers = rows.first.keys.toList();
    final data = <List<Object?>>[
      headers,
      ...rows.map((row) => headers.map((header) => row[header]).toList()),
    ];
    final csv = const ListToCsvConverter().convert(data);
    final directory = await getTemporaryDirectory();
    final path =
        '${directory.path}/charitos_${name}_${AppDateUtils.toStorage(DateTime.now())}.csv';
    final file = await File(path).writeAsString('\ufeff$csv');
    await SharePlus.instance.share(
      ShareParams(title: 'Exportación Charito’s', files: [XFile(file.path)]),
    );
    return file.path;
  }
}
