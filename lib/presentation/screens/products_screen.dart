import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/validators/input_validators.dart';
import '../../domain/entities/product.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});
  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String search = '';
  String? category;
  bool showInactive = false;
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => setState(() => search = value),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Buscar por nombre',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          value: category,
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todas'),
                            ),
                            ...AppConstants.categories.map(
                              (v) => DropdownMenuItem(value: v, child: Text(v)),
                            ),
                          ],
                          onChanged: (value) =>
                              setState(() => category = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        label: const Text('Inactivos'),
                        selected: showInactive,
                        onSelected: (value) =>
                            setState(() => showInactive = value),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: products.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorState(error: error),
                data: (items) {
                  final filtered = items
                      .where(
                        (p) =>
                            p.active != showInactive &&
                            p.name.toLowerCase().contains(
                              search.toLowerCase(),
                            ) &&
                            (category == null || p.category == category),
                      )
                      .toList();
                  if (filtered.isEmpty)
                    return EmptyState(
                      icon: Icons.cake_outlined,
                      message: showInactive
                          ? 'No hay productos inactivos.'
                          : 'Aún no hay productos. Registre el primero.',
                    );
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            child: Text(p.name.substring(0, 1).toUpperCase()),
                          ),
                          title: Text(
                            p.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${p.category} · ${p.unit} · vida útil ${p.shelfLifeDays} días\nS/ ${p.salePrice.toStringAsFixed(2)}',
                          ),
                          isThreeLine: true,
                          trailing: PopupMenuButton<String>(
                            onSelected: (action) async {
                              if (action == 'edit') await _openForm(p);
                              if (action == 'status') await _confirmStatus(p);
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: ListTile(
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text('Editar'),
                                ),
                              ),
                              PopupMenuItem(
                                value: 'status',
                                child: ListTile(
                                  leading: Icon(
                                    p.active
                                        ? Icons.pause_circle_outline
                                        : Icons.restore,
                                  ),
                                  title: Text(
                                    p.active ? 'Desactivar' : 'Reactivar',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          right: 18,
          bottom: 18,
          child: FloatingActionButton.extended(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo producto'),
          ),
        ),
      ],
    );
  }

  Future<void> _openForm([Product? product]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => ProductFormDialog(product: product),
    );
    if (saved == true) ref.read(dataVersionProvider.notifier).bump();
  }

  Future<void> _confirmStatus(Product product) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          product.active ? 'Desactivar producto' : 'Reactivar producto',
        ),
        content: Text(
          product.active
              ? 'El historial se conservará y el producto dejará de aparecer en registros nuevos.'
              : 'El producto volverá a estar disponible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(product.active ? 'Desactivar' : 'Reactivar'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await ref
          .read(repositoryProvider)
          .setProductActive(product.id!, !product.active);
      ref.read(dataVersionProvider.notifier).bump();
    }
  }
}

class ProductFormDialog extends ConsumerStatefulWidget {
  const ProductFormDialog({super.key, this.product});
  final Product? product;
  @override
  ConsumerState<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  final formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> c;
  late String category;
  late String unit;
  late String type;
  late bool applies;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final p = widget.product;
    c = {
      'name': TextEditingController(text: p?.name),
      'life': TextEditingController(text: '${p?.shelfLifeDays ?? 1}'),
      'cost': TextEditingController(text: '${p?.unitCost ?? 0}'),
      'price': TextEditingController(text: '${p?.salePrice ?? 0}'),
      'minStock': TextEditingController(text: '${p?.minimumStock ?? 0}'),
      'safety': TextEditingController(text: '${p?.safetyStock ?? 0}'),
      'minBatch': TextEditingController(
        text: '${p?.minimumProductionBatch ?? 1}',
      ),
      'multiple': TextEditingController(text: '${p?.productionMultiple ?? 1}'),
      'minutes': TextEditingController(
        text: '${p?.estimatedProductionMinutes ?? 0}',
      ),
    };
    category = p?.category ?? 'torta';
    unit = p?.unit ?? 'unidad';
    type = p?.productionType ?? 'vitrina';
    applies = p?.appliesRecommendation ?? true;
  }

  @override
  void dispose() {
    for (final value in c.values) {
      value.dispose();
    }
    super.dispose();
  }

  double n(String key) => double.parse(c[key]!.text.replaceAll(',', '.'));
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.product == null ? 'Nuevo producto' : 'Editar producto'),
    content: SizedBox(
      width: 520,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: c['name'],
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) =>
                    InputValidators.requiredText(v, label: 'Nombre'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: AppConstants.categories
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                      onChanged: (v) => category = v!,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: unit,
                      decoration: const InputDecoration(labelText: 'Unidad'),
                      items: AppConstants.units
                          .map(
                            (v) => DropdownMenuItem(value: v, child: Text(v)),
                          )
                          .toList(),
                      onChanged: (v) => unit = v!,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _number(
                'life',
                'Vida útil (días) *',
                positive: true,
                integer: true,
              ),
              _number('cost', 'Costo unitario'),
              _number('price', 'Precio de venta'),
              _number('minStock', 'Stock mínimo'),
              _number('safety', 'Stock de seguridad'),
              _number('minBatch', 'Lote mínimo'),
              _number('multiple', 'Múltiplo de producción', positive: true),
              _number('minutes', 'Tiempo estimado (minutos)', integer: true),
              DropdownButtonFormField(
                value: type,
                decoration: const InputDecoration(
                  labelText: 'Tipo de producción',
                ),
                items: AppConstants.productionTypes
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => type = v!,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Aplicar recomendación'),
                value: applies,
                onChanged: (v) => setState(() => applies = v),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: saving ? null : () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: saving ? null : _save,
        child: Text(saving ? 'Guardando…' : 'Guardar'),
      ),
    ],
  );
  Widget _number(
    String key,
    String label, {
    bool positive = false,
    bool integer = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: c[key],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      validator: (v) => positive
          ? InputValidators.positiveNumber(v, label: label)
          : InputValidators.nonNegativeNumber(v, label: label),
    ),
  );
  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      final old = widget.product;
      final now = DateTime.now();
      final product = Product(
        id: old?.id,
        name: c['name']!.text.trim(),
        category: category,
        unit: unit,
        shelfLifeDays: n('life').toInt(),
        unitCost: n('cost'),
        salePrice: n('price'),
        minimumStock: n('minStock'),
        safetyStock: n('safety'),
        minimumProductionBatch: n('minBatch'),
        productionMultiple: n('multiple'),
        estimatedProductionMinutes: n('minutes').toInt(),
        productionType: type,
        appliesRecommendation: applies,
        active: old?.active ?? true,
        createdAt: old?.createdAt ?? now,
        updatedAt: now,
      );
      await ref.read(repositoryProvider).saveProduct(product);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => saving = false);
        showMessage(
          context,
          e.toString().contains('UNIQUE')
              ? 'Ya existe un producto con ese nombre.'
              : 'No se pudo guardar: $e',
          error: true,
        );
      }
    }
  }
}
