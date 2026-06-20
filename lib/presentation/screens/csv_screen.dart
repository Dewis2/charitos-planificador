import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/csv_import_service.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class CsvScreen extends ConsumerStatefulWidget {
  const CsvScreen({super.key});
  @override
  ConsumerState<CsvScreen> createState() => _CsvScreenState();
}

class _CsvScreenState extends ConsumerState<CsvScreen> {
  bool working = false;
  static const imports = <CsvDataType, String>{
    CsvDataType.products: 'Productos',
    CsvDataType.stock: 'Stock histórico',
    CsvDataType.production: 'Producción',
    CsvDataType.sales: 'Ventas de vitrina',
    CsvDataType.waste: 'Merma',
    CsvDataType.orders: 'Pedidos confirmados',
  };
  static const exports = <String, String>{
    'products': 'Productos',
    'stock_records': 'Stock histórico',
    'production_records': 'Producción',
    'sales_records': 'Ventas de vitrina',
    'waste_records': 'Merma',
    'orders': 'Pedidos confirmados',
  };
  @override
  Widget build(BuildContext context) => Stack(
    children: [
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Los archivos deben estar en formato CSV UTF-8 y usar fechas AAAA-MM-DD. La importación valida productos, ubicaciones, fechas y cantidades.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionTitle('Importar CSV'),
          ...imports.entries.map(
            (entry) => Card(
              child: ListTile(
                leading: const Icon(Icons.file_upload_outlined),
                title: Text(entry.value),
                subtitle: const Text('Seleccionar y validar archivo'),
                trailing: const Icon(Icons.chevron_right),
                enabled: !working,
                onTap: () => _import(entry.key, entry.value),
              ),
            ),
          ),
          const SectionTitle('Exportar CSV'),
          ...exports.entries.map(
            (entry) => Card(
              child: ListTile(
                leading: const Icon(Icons.file_download_outlined),
                title: Text(entry.value),
                subtitle: const Text('Crear y compartir archivo'),
                trailing: const Icon(Icons.share_outlined),
                enabled: !working,
                onTap: () => _export(entry.key),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_graph_outlined),
              title: const Text('Recomendaciones de producción'),
              subtitle: const Text('Exportar cálculo actual'),
              trailing: const Icon(Icons.share_outlined),
              enabled: !working,
              onTap: _exportRecommendations,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      if (working)
        Container(
          color: Colors.black26,
          child: const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 14),
                    Text('Procesando archivo…'),
                  ],
                ),
              ),
            ),
          ),
        ),
    ],
  );
  Future<void> _import(CsvDataType type, String label) async {
    setState(() => working = true);
    try {
      final result = await ref
          .read(csvImportServiceProvider)
          .pickAndImport(type);
      if (!result.cancelled && mounted) {
        ref.read(dataVersionProvider.notifier).bump();
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Importación de $label'),
            content: SingleChildScrollView(
              child: Text(
                'Registros importados: ${result.imported}\nErrores: ${result.errors.length}${result.errors.isEmpty ? '' : '\n\n${result.errors.take(20).join('\n')}'}',
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo importar: $e', error: true);
    }
    if (mounted) setState(() => working = false);
  }

  Future<void> _export(String table) async {
    setState(() => working = true);
    try {
      await ref.read(csvExportServiceProvider).exportTable(table);
    } catch (e) {
      if (mounted)
        showMessage(
          context,
          e.toString().replaceFirst('Bad state: ', ''),
          error: true,
        );
    }
    if (mounted) setState(() => working = false);
  }

  Future<void> _exportRecommendations() async {
    setState(() => working = true);
    try {
      final recs = await ref.read(recommendationsProvider.future);
      await ref.read(csvExportServiceProvider).exportRecommendations(recs);
    } catch (e) {
      if (mounted) showMessage(context, '$e', error: true);
    }
    if (mounted) setState(() => working = false);
  }
}
