class Product {
  const Product({
    this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.shelfLifeDays,
    required this.unitCost,
    required this.salePrice,
    required this.minimumStock,
    required this.safetyStock,
    required this.minimumProductionBatch,
    required this.productionMultiple,
    required this.estimatedProductionMinutes,
    required this.productionType,
    required this.appliesRecommendation,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String name;
  final String category;
  final String unit;
  final int shelfLifeDays;
  final double unitCost;
  final double salePrice;
  final double minimumStock;
  final double safetyStock;
  final double minimumProductionBatch;
  final double productionMultiple;
  final int estimatedProductionMinutes;
  final String productionType;
  final bool appliesRecommendation;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product copyWith({
    int? id,
    String? name,
    String? category,
    String? unit,
    int? shelfLifeDays,
    double? unitCost,
    double? salePrice,
    double? minimumStock,
    double? safetyStock,
    double? minimumProductionBatch,
    double? productionMultiple,
    int? estimatedProductionMinutes,
    String? productionType,
    bool? appliesRecommendation,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      unitCost: unitCost ?? this.unitCost,
      salePrice: salePrice ?? this.salePrice,
      minimumStock: minimumStock ?? this.minimumStock,
      safetyStock: safetyStock ?? this.safetyStock,
      minimumProductionBatch:
          minimumProductionBatch ?? this.minimumProductionBatch,
      productionMultiple: productionMultiple ?? this.productionMultiple,
      estimatedProductionMinutes:
          estimatedProductionMinutes ?? this.estimatedProductionMinutes,
      productionType: productionType ?? this.productionType,
      appliesRecommendation:
          appliesRecommendation ?? this.appliesRecommendation,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
