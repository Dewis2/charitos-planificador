import '../../domain/entities/product.dart';

class ProductModel {
  ProductModel._();

  static Product fromMap(Map<String, Object?> map) => Product(
    id: map['id'] as int?,
    name: map['name'] as String,
    category: map['category'] as String,
    unit: map['unit'] as String,
    shelfLifeDays: map['shelf_life_days'] as int,
    unitCost: (map['unit_cost'] as num).toDouble(),
    salePrice: (map['sale_price'] as num).toDouble(),
    minimumStock: (map['minimum_stock'] as num).toDouble(),
    safetyStock: (map['safety_stock'] as num).toDouble(),
    minimumProductionBatch: (map['minimum_production_batch'] as num).toDouble(),
    productionMultiple: (map['production_multiple'] as num).toDouble(),
    estimatedProductionMinutes: map['estimated_production_minutes'] as int,
    productionType: map['production_type'] as String,
    appliesRecommendation: (map['applies_recommendation'] as int) == 1,
    active: (map['active'] as int) == 1,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  static Map<String, Object?> toMap(Product product, {bool includeId = false}) {
    final map = <String, Object?>{
      'name': product.name.trim(),
      'category': product.category,
      'unit': product.unit,
      'shelf_life_days': product.shelfLifeDays,
      'unit_cost': product.unitCost,
      'sale_price': product.salePrice,
      'minimum_stock': product.minimumStock,
      'safety_stock': product.safetyStock,
      'minimum_production_batch': product.minimumProductionBatch,
      'production_multiple': product.productionMultiple,
      'estimated_production_minutes': product.estimatedProductionMinutes,
      'production_type': product.productionType,
      'applies_recommendation': product.appliesRecommendation ? 1 : 0,
      'active': product.active ? 1 : 0,
      'created_at': product.createdAt.toIso8601String(),
      'updated_at': product.updatedAt.toIso8601String(),
    };
    if (includeId && product.id != null) map['id'] = product.id;
    return map;
  }
}
