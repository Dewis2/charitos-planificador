import '../entities/product.dart';
import '../entities/records.dart';

abstract class InventoryRepository {
  Future<List<Product>> getProducts({
    bool? active,
    String search = '',
    String? category,
  });
  Future<Product?> getProduct(int id);
  Future<Product?> findProductByName(String name);
  Future<int> saveProduct(Product product);
  Future<void> setProductActive(int id, bool active);

  Future<int> addStockRecord(StockRecord record);
  Future<int> addProduction(ProductionRecord record);
  Future<int> addSale(SaleRecord record);
  Future<int> addWaste(WasteRecord record);
  Future<int> addOrder(OrderRecord record);
  Future<int> addLot(ProductionLot lot);
  Future<List<ProductionLot>> getLots({int? productId});
  Future<List<OrderRecord>> getOrders();

  Future<Map<DateTime, double>> dailySales(
    int productId,
    DateTime from,
    DateTime to,
  );
  Future<double> totalProduction(int productId, DateTime from, DateTime to);
  Future<double> totalWaste(int productId, DateTime from, DateTime to);
  Future<double> scheduledProduction(int productId, DateTime date);
  Future<double> confirmedOrdersQuantity(int productId, DateTime deliveryDate);
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<List<Map<String, Object?>>> rawExport(String table);
}
