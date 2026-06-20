import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../domain/entities/records.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class LotsScreen extends ConsumerWidget {
  const LotsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider).value ?? [];
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();
    final names = {for (final product in products) product.id: product.name};
    final today = AppDateUtils.dateOnly(DateTime.now());

    return ref
        .watch(lotsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(error: error),
          data: (items) {
            final available = items
                .where((lot) => lot.currentQuantity > 0)
                .toList();
            if (available.isEmpty) {
              return const EmptyState(
                icon: Icons.inventory_2_outlined,
                message:
                    'No hay lotes con existencias. Los lotes se crean al registrar producción.',
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Orden FEFO: aparecen primero los lotes que vencen antes. Los vencidos nunca se cuentan como stock vendible.',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...available.map((lot) {
                  final days = lot.remainingDays(today);
                  final expired = lot.isExpiredOn(today);
                  final expiring = lot.isExpiringOn(
                    today,
                    settings.expiringThresholdDays,
                  );
                  final label = expired
                      ? 'Vencido'
                      : expiring
                      ? 'Por vencer'
                      : 'Vendible';
                  final color = expired
                      ? Colors.red
                      : expiring
                      ? Colors.orange
                      : Colors.green;
                  return Card(
                    color: color.withValues(alpha: .06),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: .15),
                        child: Icon(
                          expired
                              ? Icons.event_busy
                              : expiring
                              ? Icons.warning_amber
                              : Icons.inventory_2_outlined,
                          color: color,
                        ),
                      ),
                      title: Text(
                        names[lot.productId] ?? 'Producto',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${lot.location.replaceAll('_', ' ')} · vence ${AppDateUtils.toDisplay(lot.expiryDate)}\n$label · ${expired ? '0 días útiles' : '$days días restantes'}',
                      ),
                      isThreeLine: true,
                      trailing: Text(
                        lot.currentQuantity.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
  }
}
