import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final root = await getDatabasesPath();
    return openDatabase(
      p.join(root, 'charitos_planificador.db'),
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _create,
    );
  }

  Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL COLLATE NOCASE UNIQUE,
        category TEXT NOT NULL,
        unit TEXT NOT NULL,
        shelf_life_days INTEGER NOT NULL CHECK(shelf_life_days > 0),
        unit_cost REAL NOT NULL DEFAULT 0 CHECK(unit_cost >= 0),
        sale_price REAL NOT NULL DEFAULT 0 CHECK(sale_price >= 0),
        minimum_stock REAL NOT NULL DEFAULT 0 CHECK(minimum_stock >= 0),
        safety_stock REAL NOT NULL DEFAULT 0 CHECK(safety_stock >= 0),
        minimum_production_batch REAL NOT NULL DEFAULT 0 CHECK(minimum_production_batch >= 0),
        production_multiple REAL NOT NULL DEFAULT 1 CHECK(production_multiple > 0),
        estimated_production_minutes INTEGER NOT NULL DEFAULT 0 CHECK(estimated_production_minutes >= 0),
        production_type TEXT NOT NULL,
        applies_recommendation INTEGER NOT NULL DEFAULT 1,
        active INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE stock_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        location TEXT NOT NULL,
        initial_stock REAL NOT NULL CHECK(initial_stock >= 0),
        final_stock REAL NOT NULL CHECK(final_stock >= 0),
        produced_for_display REAL NOT NULL DEFAULT 0 CHECK(produced_for_display >= 0),
        received_transfer REAL NOT NULL DEFAULT 0 CHECK(received_transfer >= 0),
        sent_transfer REAL NOT NULL DEFAULT 0 CHECK(sent_transfer >= 0),
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE production_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        quantity REAL NOT NULL CHECK(quantity >= 0),
        destination TEXT NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE sales_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        location TEXT NOT NULL,
        quantity REAL NOT NULL CHECK(quantity >= 0),
        unit_price REAL NOT NULL CHECK(unit_price >= 0),
        total REAL NOT NULL CHECK(total >= 0),
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE waste_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        location TEXT NOT NULL,
        quantity REAL NOT NULL CHECK(quantity >= 0),
        reason TEXT NOT NULL,
        unit_cost REAL NOT NULL CHECK(unit_cost >= 0),
        estimated_cost REAL NOT NULL CHECK(estimated_cost >= 0),
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE production_lots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        production_date TEXT NOT NULL,
        expiry_date TEXT NOT NULL,
        initial_quantity REAL NOT NULL CHECK(initial_quantity >= 0),
        current_quantity REAL NOT NULL CHECK(current_quantity >= 0),
        location TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_date TEXT NOT NULL,
        delivery_date TEXT NOT NULL,
        customer_name TEXT NOT NULL,
        customer_phone TEXT NOT NULL DEFAULT '',
        product_id INTEGER NOT NULL,
        quantity REAL NOT NULL CHECK(quantity >= 0),
        description TEXT NOT NULL DEFAULT '',
        status TEXT NOT NULL,
        total REAL NOT NULL CHECK(total >= 0),
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE recommendations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        product_id INTEGER NOT NULL,
        estimated_demand REAL NOT NULL,
        sellable_stock REAL NOT NULL,
        expiring_stock REAL NOT NULL,
        expired_stock REAL NOT NULL,
        waste_rate REAL NOT NULL,
        waste_adjustment REAL NOT NULL,
        display_recommendation REAL NOT NULL,
        confirmed_orders REAL NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(date, product_id),
        FOREIGN KEY(product_id) REFERENCES products(id)
      )
    ''');
    await db.execute(
      'CREATE TABLE app_settings (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
    );

    await db.execute(
      'CREATE INDEX idx_sales_product_date ON sales_records(product_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_production_product_date ON production_records(product_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_waste_product_date ON waste_records(product_id, date)',
    );
    await db.execute(
      'CREATE INDEX idx_lots_product_expiry ON production_lots(product_id, expiry_date)',
    );
    await db.execute(
      'CREATE INDEX idx_orders_product_delivery ON orders(product_id, delivery_date)',
    );

    final defaults = <String, String>{
      'waste_adjustment_factor': '0.5',
      'historical_analysis_days': '30',
      'currency': 'S/',
      'default_location': 'general',
      'batch_rounding_enabled': 'true',
      'expiring_threshold_days': '2',
      'expired_alerts_enabled': 'true',
      'expiring_alerts_enabled': 'true',
    };
    final batch = db.batch();
    for (final entry in defaults.entries) {
      batch.insert('app_settings', {'key': entry.key, 'value': entry.value});
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
