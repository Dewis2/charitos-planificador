class StockRecord {
  const StockRecord({
    this.id,
    required this.date,
    required this.productId,
    required this.location,
    required this.initialStock,
    required this.finalStock,
    required this.producedForDisplay,
    required this.receivedTransfer,
    required this.sentTransfer,
    this.note = '',
    required this.createdAt,
  });
  final int? id;
  final DateTime date;
  final int productId;
  final String location;
  final double initialStock;
  final double finalStock;
  final double producedForDisplay;
  final double receivedTransfer;
  final double sentTransfer;
  final String note;
  final DateTime createdAt;
}

class ProductionRecord {
  const ProductionRecord({
    this.id,
    required this.date,
    required this.productId,
    required this.quantity,
    required this.destination,
    this.note = '',
    required this.createdAt,
  });
  final int? id;
  final DateTime date;
  final int productId;
  final double quantity;
  final String destination;
  final String note;
  final DateTime createdAt;
}

class SaleRecord {
  const SaleRecord({
    this.id,
    required this.date,
    required this.productId,
    required this.location,
    required this.quantity,
    required this.unitPrice,
    required this.total,
    this.note = '',
    required this.createdAt,
  });
  final int? id;
  final DateTime date;
  final int productId;
  final String location;
  final double quantity;
  final double unitPrice;
  final double total;
  final String note;
  final DateTime createdAt;
}

class WasteRecord {
  const WasteRecord({
    this.id,
    required this.date,
    required this.productId,
    required this.location,
    required this.quantity,
    required this.reason,
    required this.unitCost,
    required this.estimatedCost,
    this.note = '',
    required this.createdAt,
  });
  final int? id;
  final DateTime date;
  final int productId;
  final String location;
  final double quantity;
  final String reason;
  final double unitCost;
  final double estimatedCost;
  final String note;
  final DateTime createdAt;
}

class ProductionLot {
  const ProductionLot({
    this.id,
    required this.productId,
    required this.productionDate,
    required this.expiryDate,
    required this.initialQuantity,
    required this.currentQuantity,
    required this.location,
    required this.status,
    required this.createdAt,
  });
  final int? id;
  final int productId;
  final DateTime productionDate;
  final DateTime expiryDate;
  final double initialQuantity;
  final double currentQuantity;
  final String location;
  final String status;
  final DateTime createdAt;

  int remainingDays(DateTime date) => DateTime(
    expiryDate.year,
    expiryDate.month,
    expiryDate.day,
  ).difference(DateTime(date.year, date.month, date.day)).inDays;
  bool isExpiredOn(DateTime date) => remainingDays(date) <= 0;
  bool isExpiringOn(DateTime date, int threshold) {
    final days = remainingDays(date);
    return days > 0 && days <= threshold;
  }
}

class OrderRecord {
  const OrderRecord({
    this.id,
    required this.orderDate,
    required this.deliveryDate,
    required this.customerName,
    this.customerPhone = '',
    required this.productId,
    required this.quantity,
    this.description = '',
    required this.status,
    required this.total,
    this.note = '',
    required this.createdAt,
  });
  final int? id;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String customerName;
  final String customerPhone;
  final int productId;
  final double quantity;
  final String description;
  final String status;
  final double total;
  final String note;
  final DateTime createdAt;
}

class AppSettings {
  const AppSettings({
    this.wasteAdjustmentFactor = 0.5,
    this.historicalAnalysisDays = 30,
    this.currency = 'S/',
    this.defaultLocation = 'general',
    this.batchRoundingEnabled = true,
    this.expiringThresholdDays = 2,
    this.expiredAlertsEnabled = true,
    this.expiringAlertsEnabled = true,
  });
  final double wasteAdjustmentFactor;
  final int historicalAnalysisDays;
  final String currency;
  final String defaultLocation;
  final bool batchRoundingEnabled;
  final int expiringThresholdDays;
  final bool expiredAlertsEnabled;
  final bool expiringAlertsEnabled;

  AppSettings copyWith({
    double? wasteAdjustmentFactor,
    int? historicalAnalysisDays,
    String? currency,
    String? defaultLocation,
    bool? batchRoundingEnabled,
    int? expiringThresholdDays,
    bool? expiredAlertsEnabled,
    bool? expiringAlertsEnabled,
  }) => AppSettings(
    wasteAdjustmentFactor: wasteAdjustmentFactor ?? this.wasteAdjustmentFactor,
    historicalAnalysisDays:
        historicalAnalysisDays ?? this.historicalAnalysisDays,
    currency: currency ?? this.currency,
    defaultLocation: defaultLocation ?? this.defaultLocation,
    batchRoundingEnabled: batchRoundingEnabled ?? this.batchRoundingEnabled,
    expiringThresholdDays: expiringThresholdDays ?? this.expiringThresholdDays,
    expiredAlertsEnabled: expiredAlertsEnabled ?? this.expiredAlertsEnabled,
    expiringAlertsEnabled: expiringAlertsEnabled ?? this.expiringAlertsEnabled,
  );
}
