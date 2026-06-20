import '../../core/utils/date_utils.dart';
import '../../domain/entities/records.dart';

class RecordModels {
  RecordModels._();

  static Map<String, Object?> stockToMap(StockRecord r) => {
    'date': AppDateUtils.toStorage(r.date),
    'product_id': r.productId,
    'location': r.location,
    'initial_stock': r.initialStock,
    'final_stock': r.finalStock,
    'produced_for_display': r.producedForDisplay,
    'received_transfer': r.receivedTransfer,
    'sent_transfer': r.sentTransfer,
    'note': r.note,
    'created_at': r.createdAt.toIso8601String(),
  };
  static Map<String, Object?> productionToMap(ProductionRecord r) => {
    'date': AppDateUtils.toStorage(r.date),
    'product_id': r.productId,
    'quantity': r.quantity,
    'destination': r.destination,
    'note': r.note,
    'created_at': r.createdAt.toIso8601String(),
  };
  static Map<String, Object?> saleToMap(SaleRecord r) => {
    'date': AppDateUtils.toStorage(r.date),
    'product_id': r.productId,
    'location': r.location,
    'quantity': r.quantity,
    'unit_price': r.unitPrice,
    'total': r.total,
    'note': r.note,
    'created_at': r.createdAt.toIso8601String(),
  };
  static Map<String, Object?> wasteToMap(WasteRecord r) => {
    'date': AppDateUtils.toStorage(r.date),
    'product_id': r.productId,
    'location': r.location,
    'quantity': r.quantity,
    'reason': r.reason,
    'unit_cost': r.unitCost,
    'estimated_cost': r.estimatedCost,
    'note': r.note,
    'created_at': r.createdAt.toIso8601String(),
  };
  static Map<String, Object?> lotToMap(ProductionLot r) => {
    'product_id': r.productId,
    'production_date': AppDateUtils.toStorage(r.productionDate),
    'expiry_date': AppDateUtils.toStorage(r.expiryDate),
    'initial_quantity': r.initialQuantity,
    'current_quantity': r.currentQuantity,
    'location': r.location,
    'status': r.status,
    'created_at': r.createdAt.toIso8601String(),
  };
  static Map<String, Object?> orderToMap(OrderRecord r) => {
    'order_date': AppDateUtils.toStorage(r.orderDate),
    'delivery_date': AppDateUtils.toStorage(r.deliveryDate),
    'customer_name': r.customerName,
    'customer_phone': r.customerPhone,
    'product_id': r.productId,
    'quantity': r.quantity,
    'description': r.description,
    'status': r.status,
    'total': r.total,
    'note': r.note,
    'created_at': r.createdAt.toIso8601String(),
  };

  static ProductionLot lotFromMap(Map<String, Object?> m) => ProductionLot(
    id: m['id'] as int?,
    productId: m['product_id'] as int,
    productionDate: AppDateUtils.parse(m['production_date'] as String),
    expiryDate: AppDateUtils.parse(m['expiry_date'] as String),
    initialQuantity: (m['initial_quantity'] as num).toDouble(),
    currentQuantity: (m['current_quantity'] as num).toDouble(),
    location: m['location'] as String,
    status: m['status'] as String,
    createdAt: DateTime.parse(m['created_at'] as String),
  );
  static OrderRecord orderFromMap(Map<String, Object?> m) => OrderRecord(
    id: m['id'] as int?,
    orderDate: AppDateUtils.parse(m['order_date'] as String),
    deliveryDate: AppDateUtils.parse(m['delivery_date'] as String),
    customerName: m['customer_name'] as String,
    customerPhone: m['customer_phone'] as String,
    productId: m['product_id'] as int,
    quantity: (m['quantity'] as num).toDouble(),
    description: m['description'] as String,
    status: m['status'] as String,
    total: (m['total'] as num).toDouble(),
    note: m['note'] as String,
    createdAt: DateTime.parse(m['created_at'] as String),
  );
}
