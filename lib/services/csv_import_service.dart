import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import '../core/constants/app_constants.dart';
import '../core/utils/date_utils.dart';
import '../domain/entities/product.dart';
import '../domain/entities/records.dart';
import '../domain/repositories/inventory_repository.dart';

enum CsvDataType { products, stock, production, sales, waste, orders }

List<List<dynamic>> parseCsvRows(String content) {
  var normalized = content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  if (normalized.startsWith('\ufeff')) normalized = normalized.substring(1);

  final lines = normalized.split('\n');
  while (lines.isNotEmpty && lines.first.trim().isEmpty) {
    lines.removeAt(0);
  }
  if (lines.isEmpty) return [];

  String? declaredDelimiter;
  final firstLine = lines.first.trim().toLowerCase();
  if (firstLine == 'sep=;' || firstLine == 'sep=,') {
    declaredDelimiter = firstLine.substring(4);
    lines.removeAt(0);
  }
  if (lines.isEmpty) return [];

  final header = lines.first;
  final delimiter =
      declaredDelimiter ??
      (';'.allMatches(header).length > ','.allMatches(header).length
          ? ';'
          : ',');
  return CsvToListConverter(
    fieldDelimiter: delimiter,
    eol: '\n',
    shouldParseNumbers: false,
  ).convert(lines.join('\n'));
}

class CsvImportResult {
  const CsvImportResult({
    required this.imported,
    required this.errors,
    this.cancelled = false,
  });
  final int imported;
  final List<String> errors;
  final bool cancelled;
}

class CsvImportService {
  CsvImportService(this._repository);
  final InventoryRepository _repository;

  Future<CsvImportResult> pickAndImport(CsvDataType type) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );
    if (picked == null)
      return const CsvImportResult(imported: 0, errors: [], cancelled: true);
    final bytes = picked.files.single.bytes;
    if (bytes == null)
      return const CsvImportResult(
        imported: 0,
        errors: ['No se pudo leer el archivo'],
      );
    return importContent(type, utf8.decode(bytes, allowMalformed: true));
  }

  Future<CsvImportResult> importContent(
    CsvDataType type,
    String content,
  ) async {
    final rows = parseCsvRows(content);
    if (rows.isEmpty)
      return const CsvImportResult(imported: 0, errors: ['El CSV está vacío']);
    final headers = rows.first
        .map((value) => value.toString().trim().toLowerCase())
        .toList();
    final required = _requiredHeaders(type);
    final missing = required
        .where((header) => !headers.contains(header))
        .toList();
    if (missing.isNotEmpty)
      return CsvImportResult(
        imported: 0,
        errors: ['Faltan columnas: ${missing.join(', ')}'],
      );
    var imported = 0;
    final errors = <String>[];
    for (var i = 1; i < rows.length; i++) {
      if (rows[i].every((cell) => cell.toString().trim().isEmpty)) continue;
      final values = <String, String>{};
      for (var c = 0; c < headers.length; c++)
        values[headers[c]] = c < rows[i].length
            ? rows[i][c].toString().trim()
            : '';
      try {
        await _importRow(type, values);
        imported++;
      } catch (error) {
        errors.add(
          'Fila ${i + 1}: ${error.toString().replaceFirst('FormatException: ', '')}',
        );
      }
    }
    return CsvImportResult(imported: imported, errors: errors);
  }

  List<String> _requiredHeaders(CsvDataType type) => switch (type) {
    CsvDataType.products => [
      'nombre',
      'categoria',
      'unidad_medida',
      'vida_util_dias',
      'costo_unitario',
      'precio_venta',
      'stock_minimo',
      'stock_seguridad',
      'lote_minimo_produccion',
      'multiplo_produccion',
      'tipo_produccion',
      'aplica_recomendacion',
      'activo',
    ],
    CsvDataType.stock => [
      'fecha',
      'producto_nombre',
      'ubicacion',
      'stock_inicial',
      'stock_final',
      'cantidad_producida_vitrina',
      'cantidad_recibida_transferencia',
      'cantidad_enviada_transferencia',
    ],
    CsvDataType.production => [
      'fecha',
      'producto_nombre',
      'cantidad_producida',
      'ubicacion_destino',
    ],
    CsvDataType.sales => [
      'fecha',
      'producto_nombre',
      'ubicacion',
      'cantidad_vendida',
      'precio_unitario_aplicado',
    ],
    CsvDataType.waste => [
      'fecha',
      'producto_nombre',
      'ubicacion',
      'cantidad_merma',
      'motivo_merma',
      'costo_unitario_aplicado',
    ],
    CsvDataType.orders => [
      'fecha_pedido',
      'fecha_entrega',
      'cliente_nombre',
      'producto_nombre',
      'cantidad',
      'estado',
      'monto_total',
    ],
  };

  Future<void> _importRow(CsvDataType type, Map<String, String> row) async {
    double number(String field, {bool positive = false}) {
      final value = double.tryParse((row[field] ?? '').replaceAll(',', '.'));
      if (value == null || value < 0 || (positive && value <= 0))
        throw FormatException('$field no es válido');
      return value;
    }

    int integer(String field, {bool positive = false}) {
      final value = int.tryParse(row[field] ?? '');
      if (value == null || value < 0 || (positive && value <= 0))
        throw FormatException('$field no es válido');
      return value;
    }

    DateTime date(String field) {
      final value = AppDateUtils.tryParse(row[field] ?? '');
      if (value == null) throw FormatException('$field debe usar AAAA-MM-DD');
      return value;
    }

    Future<Product> product() async {
      final value = await _repository.findProductByName(
        row['producto_nombre'] ?? '',
      );
      if (value?.id == null)
        throw FormatException(
          'producto inexistente: ${row['producto_nombre']}',
        );
      return value!;
    }

    void validLocation(String value) {
      if (!AppConstants.locations.contains(value))
        throw FormatException('ubicación inválida: $value');
    }

    final now = DateTime.now();

    switch (type) {
      case CsvDataType.products:
        if ((row['nombre'] ?? '').isEmpty)
          throw const FormatException('nombre obligatorio');
        if (!AppConstants.categories.contains(row['categoria']))
          throw const FormatException('categoría inválida');
        if (!AppConstants.units.contains(row['unidad_medida']))
          throw const FormatException('unidad inválida');
        if (!AppConstants.productionTypes.contains(row['tipo_produccion']))
          throw const FormatException('tipo_produccion inválido');
        final existing = await _repository.findProductByName(row['nombre']!);
        await _repository.saveProduct(
          Product(
            id: existing?.id,
            name: row['nombre']!,
            category: row['categoria']!,
            unit: row['unidad_medida']!,
            shelfLifeDays: integer('vida_util_dias', positive: true),
            unitCost: number('costo_unitario'),
            salePrice: number('precio_venta'),
            minimumStock: number('stock_minimo'),
            safetyStock: number('stock_seguridad'),
            minimumProductionBatch: number('lote_minimo_produccion'),
            productionMultiple: number('multiplo_produccion', positive: true),
            estimatedProductionMinutes:
                int.tryParse(row['tiempo_estimado_produccion_minutos'] ?? '') ??
                0,
            productionType: row['tipo_produccion']!,
            appliesRecommendation: _bool(row['aplica_recomendacion']),
            active: _bool(row['activo']),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
          ),
        );
      case CsvDataType.stock:
        final p = await product();
        validLocation(row['ubicacion']!);
        await _repository.addStockRecord(
          StockRecord(
            date: date('fecha'),
            productId: p.id!,
            location: row['ubicacion']!,
            initialStock: number('stock_inicial'),
            finalStock: number('stock_final'),
            producedForDisplay: number('cantidad_producida_vitrina'),
            receivedTransfer: number('cantidad_recibida_transferencia'),
            sentTransfer: number('cantidad_enviada_transferencia'),
            note: row['observacion'] ?? '',
            createdAt: now,
          ),
        );
      case CsvDataType.production:
        final p = await product();
        validLocation(row['ubicacion_destino']!);
        await _repository.addProduction(
          ProductionRecord(
            date: date('fecha'),
            productId: p.id!,
            quantity: number('cantidad_producida'),
            destination: row['ubicacion_destino']!,
            note: row['observacion'] ?? '',
            createdAt: now,
          ),
        );
      case CsvDataType.sales:
        final p = await product();
        validLocation(row['ubicacion']!);
        final quantity = number('cantidad_vendida');
        final price = number('precio_unitario_aplicado');
        await _repository.addSale(
          SaleRecord(
            date: date('fecha'),
            productId: p.id!,
            location: row['ubicacion']!,
            quantity: quantity,
            unitPrice: price,
            total: quantity * price,
            note: row['observacion'] ?? '',
            createdAt: now,
          ),
        );
      case CsvDataType.waste:
        final p = await product();
        validLocation(row['ubicacion']!);
        if (!AppConstants.wasteReasons.contains(row['motivo_merma']))
          throw const FormatException('motivo de merma inválido');
        final quantity = number('cantidad_merma');
        final cost = number('costo_unitario_aplicado');
        await _repository.addWaste(
          WasteRecord(
            date: date('fecha'),
            productId: p.id!,
            location: row['ubicacion']!,
            quantity: quantity,
            reason: row['motivo_merma']!,
            unitCost: cost,
            estimatedCost: quantity * cost,
            note: row['observacion'] ?? '',
            createdAt: now,
          ),
        );
      case CsvDataType.orders:
        final p = await product();
        if (!AppConstants.orderStatuses.contains(row['estado']))
          throw const FormatException('estado de pedido inválido');
        await _repository.addOrder(
          OrderRecord(
            orderDate: date('fecha_pedido'),
            deliveryDate: date('fecha_entrega'),
            customerName: row['cliente_nombre']!,
            customerPhone: row['cliente_celular'] ?? '',
            productId: p.id!,
            quantity: number('cantidad'),
            description: row['descripcion'] ?? '',
            status: row['estado']!,
            total: number('monto_total'),
            note: row['observacion'] ?? '',
            createdAt: now,
          ),
        );
    }
  }

  bool _bool(String? value) =>
      const {'true', '1', 'si', 'sí'}.contains(value?.toLowerCase());
}
