import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../../core/validators/input_validators.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/records.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider).value ?? [];
    final names = {for (final product in products) product.id: product.name};
    return Stack(
      children: [
        ref
            .watch(ordersProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorState(error: error),
              data: (orders) {
                if (orders.isEmpty)
                  return const EmptyState(
                    icon: Icons.assignment_outlined,
                    message: 'No hay pedidos registrados.',
                  );
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: orders.length,
                  itemBuilder: (_, index) {
                    final order = orders[index];
                    final color = order.status == 'confirmado'
                        ? Colors.green
                        : order.status == 'anulado'
                        ? Colors.red
                        : Colors.blueGrey;
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: .12),
                          child: Icon(
                            Icons.assignment_turned_in_outlined,
                            color: color,
                          ),
                        ),
                        title: Text(
                          '${names[order.productId] ?? 'Producto'} · ${order.quantity.toStringAsFixed(1)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${order.customerName}\nEntrega: ${AppDateUtils.toDisplay(order.deliveryDate)} · ${order.status}',
                        ),
                        isThreeLine: true,
                        trailing: Text('S/ ${order.total.toStringAsFixed(2)}'),
                      ),
                    );
                  },
                );
              },
            ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton.extended(
            onPressed: () async {
              final saved = await showDialog<bool>(
                context: context,
                builder: (_) => const _OrderDialog(),
              );
              if (saved == true) ref.read(dataVersionProvider.notifier).bump();
            },
            icon: const Icon(Icons.add),
            label: const Text('Nuevo pedido'),
          ),
        ),
      ],
    );
  }
}

class _OrderDialog extends ConsumerStatefulWidget {
  const _OrderDialog();
  @override
  ConsumerState<_OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends ConsumerState<_OrderDialog> {
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final phone = TextEditingController();
  final quantity = TextEditingController(text: '1');
  final description = TextEditingController();
  final total = TextEditingController(text: '0');
  final note = TextEditingController();
  int? productId;
  DateTime orderDate = AppDateUtils.dateOnly(DateTime.now());
  DateTime deliveryDate = AppDateUtils.dateOnly(DateTime.now());
  String status = 'confirmado';
  bool saving = false;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    quantity.dispose();
    description.dispose();
    total.dispose();
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(activeProductsProvider).value ?? <Product>[];
    productId ??= products.isEmpty ? null : products.first.id;
    return AlertDialog(
      title: const Text('Registrar pedido'),
      content: SizedBox(
        width: 520,
        child: products.isEmpty
            ? const Text('Primero registre un producto.')
            : Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                        onChanged: (value) => productId = value,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Cliente *',
                        ),
                        validator: (value) => InputValidators.requiredText(
                          value,
                          label: 'Cliente',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Celular'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _dateField(
                              'Fecha pedido',
                              orderDate,
                              (value) => setState(() => orderDate = value),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _dateField(
                              'Fecha entrega',
                              deliveryDate,
                              (value) => setState(() => deliveryDate = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: quantity,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Cantidad *',
                        ),
                        validator: InputValidators.nonNegativeNumber,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: description,
                        decoration: const InputDecoration(
                          labelText: 'Descripción',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(labelText: 'Estado'),
                        items: AppConstants.orderStatuses
                            .map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            )
                            .toList(),
                        onChanged: (value) => status = value!,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: total,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Monto total *',
                        ),
                        validator: (value) => InputValidators.nonNegativeNumber(
                          value,
                          label: 'Monto',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: note,
                        decoration: const InputDecoration(
                          labelText: 'Observación',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: products.isEmpty || saving ? null : _save,
          child: Text(saving ? 'Guardando…' : 'Guardar'),
        ),
      ],
    );
  }

  Widget _dateField(
    String label,
    DateTime value,
    ValueChanged<DateTime> changed,
  ) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: value,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 1000)),
      );
      if (picked != null) changed(picked);
    },
    child: InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Text(AppDateUtils.toDisplay(value)),
    ),
  );

  Future<void> _save() async {
    if (!formKey.currentState!.validate() || productId == null) return;
    if (deliveryDate.isBefore(orderDate)) {
      showMessage(
        context,
        'La entrega no puede ser anterior al pedido.',
        error: true,
      );
      return;
    }
    setState(() => saving = true);
    try {
      await ref
          .read(repositoryProvider)
          .addOrder(
            OrderRecord(
              orderDate: orderDate,
              deliveryDate: deliveryDate,
              customerName: name.text.trim(),
              customerPhone: phone.text.trim(),
              productId: productId!,
              quantity: double.parse(quantity.text.replaceAll(',', '.')),
              description: description.text.trim(),
              status: status,
              total: double.parse(total.text.replaceAll(',', '.')),
              note: note.text.trim(),
              createdAt: DateTime.now(),
            ),
          );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        setState(() => saving = false);
        showMessage(context, 'No se pudo guardar: $error', error: true);
      }
    }
  }
}
