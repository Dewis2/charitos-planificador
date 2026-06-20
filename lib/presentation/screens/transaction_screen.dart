import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../core/validators/input_validators.dart';
import '../../domain/entities/records.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

enum TransactionType { stock, production, sale, waste }

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key, required this.type});
  final TransactionType type;

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final formKey = GlobalKey<FormState>();
  final controllers = <String, TextEditingController>{};
  int? productId;
  DateTime date = AppDateUtils.dateOnly(DateTime.now());
  String location = 'general';
  String reason = 'no_vendido';
  bool saving = false;

  @override
  void initState() {
    super.initState();
    for (final key in [
      'initial',
      'final',
      'produced',
      'received',
      'sent',
      'quantity',
      'price',
      'cost',
      'note',
    ]) {
      controllers[key] = TextEditingController(text: key == 'note' ? '' : '0');
    }
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double number(String key) =>
      double.parse(controllers[key]!.text.replaceAll(',', '.'));
  double numberOrZero(String key) =>
      double.tryParse(controllers[key]!.text.replaceAll(',', '.')) ?? 0;

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(activeProductsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(error: error),
          data: (products) {
            if (products.isEmpty) {
              return const EmptyState(
                icon: Icons.cake_outlined,
                message: 'Primero registre al menos un producto activo.',
              );
            }
            productId ??= products.first.id;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(_helper),
                          const SizedBox(height: 18),
                          DropdownButtonFormField<int>(
                            value: productId,
                            decoration: const InputDecoration(
                              labelText: 'Producto *',
                            ),
                            items: products
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p.id,
                                    child: Text(p.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() => productId = value);
                              final product = products.firstWhere(
                                (p) => p.id == value,
                              );
                              if (widget.type == TransactionType.sale)
                                controllers['price']!.text =
                                    '${product.salePrice}';
                              if (widget.type == TransactionType.waste)
                                controllers['cost']!.text =
                                    '${product.unitCost}';
                            },
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Fecha *',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(AppDateUtils.toDisplay(date)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: location,
                            decoration: InputDecoration(
                              labelText:
                                  widget.type == TransactionType.production
                                  ? 'Ubicación destino *'
                                  : 'Ubicación *',
                            ),
                            items: AppConstants.locations
                                .map(
                                  (v) => DropdownMenuItem(
                                    value: v,
                                    child: Text(v.replaceAll('_', ' ')),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => location = value!,
                          ),
                          const SizedBox(height: 12),
                          ..._fields(),
                          TextFormField(
                            controller: controllers['note'],
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Observación (opcional)',
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: saving ? null : _save,
                            icon: const Icon(Icons.save_outlined),
                            label: Text(
                              saving ? 'Guardando…' : 'Guardar registro',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_rule)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
  }

  List<Widget> _fields() {
    Widget field(String key, String label) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[key],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: '$label *'),
        validator: (value) =>
            InputValidators.nonNegativeNumber(value, label: label),
        onChanged: (_) => setState(() {}),
      ),
    );

    return switch (widget.type) {
      TransactionType.stock => [
        field('initial', 'Stock inicial'),
        field('final', 'Stock final'),
        field('produced', 'Cantidad producida para vitrina'),
        field('received', 'Transferencia recibida'),
        field('sent', 'Transferencia enviada'),
      ],
      TransactionType.production => [field('quantity', 'Cantidad producida')],
      TransactionType.sale => [
        field('quantity', 'Cantidad vendida'),
        field('price', 'Precio unitario aplicado'),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Monto total: S/ ${(numberOrZero('quantity') * numberOrZero('price')).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      TransactionType.waste => [
        field('quantity', 'Cantidad de merma'),
        DropdownButtonFormField<String>(
          value: reason,
          decoration: const InputDecoration(labelText: 'Motivo de merma *'),
          items: AppConstants.wasteReasons
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text(v.replaceAll('_', ' ')),
                ),
              )
              .toList(),
          onChanged: (value) => reason = value!,
        ),
        const SizedBox(height: 12),
        field('cost', 'Costo unitario aplicado'),
      ],
    };
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDate: date,
    );
    if (value != null) setState(() => date = value);
  }

  Future<void> _save() async {
    if (!formKey.currentState!.validate() || productId == null) return;
    setState(() => saving = true);
    final now = DateTime.now();
    final note = controllers['note']!.text.trim();
    try {
      final repository = ref.read(repositoryProvider);
      switch (widget.type) {
        case TransactionType.stock:
          await repository.addStockRecord(
            StockRecord(
              date: date,
              productId: productId!,
              location: location,
              initialStock: number('initial'),
              finalStock: number('final'),
              producedForDisplay: number('produced'),
              receivedTransfer: number('received'),
              sentTransfer: number('sent'),
              note: note,
              createdAt: now,
            ),
          );
        case TransactionType.production:
          await repository.addProduction(
            ProductionRecord(
              date: date,
              productId: productId!,
              quantity: number('quantity'),
              destination: location,
              note: note,
              createdAt: now,
            ),
          );
        case TransactionType.sale:
          final quantity = number('quantity');
          final price = number('price');
          await repository.addSale(
            SaleRecord(
              date: date,
              productId: productId!,
              location: location,
              quantity: quantity,
              unitPrice: price,
              total: quantity * price,
              note: note,
              createdAt: now,
            ),
          );
        case TransactionType.waste:
          final quantity = number('quantity');
          final cost = number('cost');
          await repository.addWaste(
            WasteRecord(
              date: date,
              productId: productId!,
              location: location,
              quantity: quantity,
              reason: reason,
              unitCost: cost,
              estimatedCost: quantity * cost,
              note: note,
              createdAt: now,
            ),
          );
      }
      ref.read(dataVersionProvider.notifier).bump();
      for (final key in controllers.keys.where(
        (key) => !{'note', 'price', 'cost'}.contains(key),
      )) {
        controllers[key]!.text = '0';
      }
      controllers['note']!.clear();
      if (mounted) showMessage(context, 'Registro guardado correctamente.');
    } catch (error) {
      if (mounted)
        showMessage(context, 'No se pudo guardar: $error', error: true);
    }
    if (mounted) setState(() => saving = false);
  }

  String get _title => switch (widget.type) {
    TransactionType.stock => 'Stock diario',
    TransactionType.production => 'Producción para vitrina',
    TransactionType.sale => 'Venta regular de vitrina',
    TransactionType.waste => 'Merma por producto',
  };

  String get _helper => switch (widget.type) {
    TransactionType.stock =>
      'Registre el inventario observado en una ubicación.',
    TransactionType.production =>
      'Cada producción crea automáticamente un lote con fecha de vencimiento.',
    TransactionType.sale =>
      'Solo ventas regulares; los pedidos se registran en su propio módulo.',
    TransactionType.waste =>
      'Registre cantidad, causa y costo para medir la pérdida.',
  };

  String get _rule => switch (widget.type) {
    TransactionType.stock => 'Las cantidades deben ser no negativas.',
    TransactionType.production =>
      'La fecha de vencimiento se calcula con la vida útil configurada del producto.',
    TransactionType.sale =>
      'Monto total = cantidad vendida × precio unitario. La salida de stock sigue FEFO.',
    TransactionType.waste =>
      'Costo estimado = cantidad de merma × costo unitario aplicado.',
  };
}
