import 'dart:math' as math;

import 'package:sqflite/sqflite.dart';

import '../../core/database/database_helper.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/records.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../models/product_model.dart';
import '../models/record_models.dart';

class LocalInventoryRepository implements InventoryRepository {
  LocalInventoryRepository(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  @override
  Future<List<Product>> getProducts({
    bool? active,
    String search = '',
    String? category,
  }) async {
    final clauses = <String>[];
    final args = <Object?>[];
    if (active != null) {
      clauses.add('active = ?');
      args.add(active ? 1 : 0);
    }
    if (search.trim().isNotEmpty) {
      clauses.add('name LIKE ?');
      args.add('%${search.trim()}%');
    }
    if (category != null && category.isNotEmpty) {
      clauses.add('category = ?');
      args.add(category);
    }
    final rows = await (await _db).query(
      'products',
      where: clauses.isEmpty ? null : clauses.join(' AND '),
      whereArgs: args,
      orderBy: 'active DESC, name COLLATE NOCASE',
    );
    return rows.map(ProductModel.fromMap).toList();
  }

  @override
  Future<Product?> getProduct(int id) async {
    final rows = await (await _db).query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : ProductModel.fromMap(rows.first);
  }

  @override
  Future<Product?> findProductByName(String name) async {
    final rows = await (await _db).query(
      'products',
      where: 'name = ? COLLATE NOCASE',
      whereArgs: [name.trim()],
      limit: 1,
    );
    return rows.isEmpty ? null : ProductModel.fromMap(rows.first);
  }

  @override
  Future<int> saveProduct(Product product) async {
    final db = await _db;
    if (product.id == null)
      return db.insert('products', ProductModel.toMap(product));
    await db.update(
      'products',
      ProductModel.toMap(product),
      where: 'id = ?',
      whereArgs: [product.id],
    );
    return product.id!;
  }

  @override
  Future<void> setProductActive(int id, bool active) async {
    await (await _db).update(
      'products',
      {
        'active': active ? 1 : 0,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> addStockRecord(StockRecord record) async =>
      (await _db).insert('stock_records', RecordModels.stockToMap(record));

  @override
  Future<int> addProduction(ProductionRecord record) async {
    final product = await getProduct(record.productId);
    if (product == null) throw StateError('El producto no existe');
    final db = await _db;
    return db.transaction((txn) async {
      final id = await txn.insert(
        'production_records',
        RecordModels.productionToMap(record),
      );
      if (record.quantity > 0) {
        final lot = ProductionLot(
          productId: record.productId,
          productionDate: record.date,
          expiryDate: record.date.add(Duration(days: product.shelfLifeDays)),
          initialQuantity: record.quantity,
          currentQuantity: record.quantity,
          location: record.destination,
          status: 'vendible',
          createdAt: record.createdAt,
        );
        await txn.insert('production_lots', RecordModels.lotToMap(lot));
      }
      return id;
    });
  }

  @override
  Future<int> addSale(SaleRecord record) async {
    final db = await _db;
    return db.transaction((txn) async {
      final id = await txn.insert(
        'sales_records',
        RecordModels.saleToMap(record),
      );
      await _consumeFefo(
        txn,
        record.productId,
        record.location,
        record.quantity,
        record.date,
      );
      return id;
    });
  }

  @override
  Future<int> addWaste(WasteRecord record) async {
    final db = await _db;
    return db.transaction((txn) async {
      final id = await txn.insert(
        'waste_records',
        RecordModels.wasteToMap(record),
      );
      await _consumeFefo(
        txn,
        record.productId,
        record.location,
        record.quantity,
        record.date,
        includeExpired: true,
      );
      return id;
    });
  }

  Future<void> _consumeFefo(
    Transaction txn,
    int productId,
    String location,
    double quantity,
    DateTime date, {
    bool includeExpired = false,
  }) async {
    var remaining = quantity;
    if (remaining <= 0) return;
    final clauses = <String>[
      'product_id = ?',
      'current_quantity > 0',
      '(location = ? OR location = ?)',
    ];
    final args = <Object?>[productId, location, 'general'];
    if (!includeExpired) {
      clauses.add('expiry_date > ?');
      args.add(AppDateUtils.toStorage(date));
    }
    final lots = await txn.query(
      'production_lots',
      where: clauses.join(' AND '),
      whereArgs: args,
      orderBy: 'expiry_date ASC, id ASC',
    );
    for (final row in lots) {
      if (remaining <= 0) break;
      final available = (row['current_quantity'] as num).toDouble();
      final consumed = math.min(available, remaining);
      final newQuantity = available - consumed;
      await txn.update(
        'production_lots',
        {
          'current_quantity': newQuantity,
          'status': newQuantity == 0 ? 'descartado' : row['status'],
        },
        where: 'id = ?',
        whereArgs: [row['id']],
      );
      remaining -= consumed;
    }
  }

  @override
  Future<int> addOrder(OrderRecord record) async =>
      (await _db).insert('orders', RecordModels.orderToMap(record));

  @override
  Future<int> addLot(ProductionLot lot) async =>
      (await _db).insert('production_lots', RecordModels.lotToMap(lot));

  @override
  Future<List<ProductionLot>> getLots({int? productId}) async {
    final rows = await (await _db).query(
      'production_lots',
      where: productId == null ? null : 'product_id = ?',
      whereArgs: productId == null ? null : [productId],
      orderBy: 'expiry_date ASC, id ASC',
    );
    return rows.map(RecordModels.lotFromMap).toList();
  }

  @override
  Future<List<OrderRecord>> getOrders() async {
    final rows = await (await _db).query(
      'orders',
      orderBy: 'delivery_date DESC, id DESC',
    );
    return rows.map(RecordModels.orderFromMap).toList();
  }

  @override
  Future<Map<DateTime, double>> dailySales(
    int productId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await (await _db).rawQuery(
      '''SELECT date, SUM(quantity) total FROM sales_records WHERE product_id = ? AND date >= ? AND date <= ? GROUP BY date ORDER BY date''',
      [productId, AppDateUtils.toStorage(from), AppDateUtils.toStorage(to)],
    );
    return {
      for (final row in rows)
        AppDateUtils.parse(row['date'] as String): (row['total'] as num)
            .toDouble(),
    };
  }

  @override
  Future<double> totalProduction(int productId, DateTime from, DateTime to) =>
      _sum('production_records', 'quantity', productId, from, to);

  @override
  Future<double> totalWaste(int productId, DateTime from, DateTime to) =>
      _sum('waste_records', 'quantity', productId, from, to);

  Future<double> _sum(
    String table,
    String column,
    int productId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await (await _db).rawQuery(
      'SELECT COALESCE(SUM($column), 0) total FROM $table WHERE product_id = ? AND date >= ? AND date <= ?',
      [productId, AppDateUtils.toStorage(from), AppDateUtils.toStorage(to)],
    );
    return (rows.first['total'] as num).toDouble();
  }

  @override
  Future<double> scheduledProduction(int productId, DateTime date) async {
    final rows = await (await _db).rawQuery(
      'SELECT COALESCE(SUM(quantity), 0) total FROM production_records WHERE product_id = ? AND date = ?',
      [productId, AppDateUtils.toStorage(date)],
    );
    return (rows.first['total'] as num).toDouble();
  }

  @override
  Future<double> confirmedOrdersQuantity(
    int productId,
    DateTime deliveryDate,
  ) async {
    final rows = await (await _db).rawQuery(
      "SELECT COALESCE(SUM(quantity), 0) total FROM orders WHERE product_id = ? AND delivery_date = ? AND status = 'confirmado'",
      [productId, AppDateUtils.toStorage(deliveryDate)],
    );
    return (rows.first['total'] as num).toDouble();
  }

  @override
  Future<AppSettings> getSettings() async {
    final rows = await (await _db).query('app_settings');
    final values = {
      for (final row in rows) row['key'] as String: row['value'] as String,
    };
    bool flag(String key, bool fallback) =>
        (values[key] ?? '$fallback') == 'true';
    return AppSettings(
      wasteAdjustmentFactor:
          double.tryParse(values['waste_adjustment_factor'] ?? '') ?? 0.5,
      historicalAnalysisDays:
          int.tryParse(values['historical_analysis_days'] ?? '') ?? 30,
      currency: values['currency'] ?? 'S/',
      defaultLocation: values['default_location'] ?? 'general',
      batchRoundingEnabled: flag('batch_rounding_enabled', true),
      expiringThresholdDays:
          int.tryParse(values['expiring_threshold_days'] ?? '') ?? 2,
      expiredAlertsEnabled: flag('expired_alerts_enabled', true),
      expiringAlertsEnabled: flag('expiring_alerts_enabled', true),
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final values = <String, String>{
      'waste_adjustment_factor': '${settings.wasteAdjustmentFactor}',
      'historical_analysis_days': '${settings.historicalAnalysisDays}',
      'currency': settings.currency,
      'default_location': settings.defaultLocation,
      'batch_rounding_enabled': '${settings.batchRoundingEnabled}',
      'expiring_threshold_days': '${settings.expiringThresholdDays}',
      'expired_alerts_enabled': '${settings.expiredAlertsEnabled}',
      'expiring_alerts_enabled': '${settings.expiringAlertsEnabled}',
    };
    final db = await _db;
    await db.transaction((txn) async {
      for (final entry in values.entries) {
        await txn.insert('app_settings', {
          'key': entry.key,
          'value': entry.value,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  @override
  Future<List<Map<String, Object?>>> rawExport(String table) async {
    const allowed = {
      'products',
      'stock_records',
      'production_records',
      'sales_records',
      'waste_records',
      'production_lots',
      'orders',
      'recommendations',
    };
    if (!allowed.contains(table)) throw ArgumentError('Tabla no exportable');
    return (await _db).query(table, orderBy: 'id');
  }
}
