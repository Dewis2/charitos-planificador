import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class RecommendationScreen extends ConsumerWidget {
  const RecommendationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendations = ref.watch(recommendationsProvider);
    return recommendations.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorState(
        error: e,
        onRetry: () => ref.read(dataVersionProvider.notifier).bump(),
      ),
      data: (items) => items.isEmpty
          ? const EmptyState(
              icon: Icons.auto_graph,
              message: 'No hay productos activos que apliquen a recomendación.',
            )
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.read(dataVersionProvider.notifier).bump(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'La recomendación usa solo ventas de vitrina. Los pedidos confirmados aparecen separados y se suman únicamente al total operativo.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...items.map(
                    (r) => Card(
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            r.product.name.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Text(
                          r.product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${r.product.category} · ${r.demandEstimate.source}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              r.displayRecommendation.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Text(
                              'vitrina',
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              children: [
                                if (!r.demandEstimate.hasSufficientData)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    color: Colors.orange.shade50,
                                    child: const Text(
                                      'Datos insuficientes para estimar demanda',
                                    ),
                                  ),
                                _row(
                                  'Demanda estimada',
                                  r.demandEstimate.value,
                                ),
                                _row('Stock vendible', r.sellableStock),
                                _row(
                                  'Stock por vencer',
                                  r.expiringStock,
                                  alert: r.expiringStock > 0,
                                ),
                                _row(
                                  'Stock vencido',
                                  r.expiredStock,
                                  alert: r.expiredStock > 0,
                                ),
                                _row('Stock de seguridad', r.safetyStock),
                                _row(
                                  'Producción ya registrada',
                                  r.scheduledDisplayProduction,
                                ),
                                _row(
                                  'Tasa de merma',
                                  r.wasteRate * 100,
                                  suffix: '%',
                                ),
                                _row('Ajuste por merma', r.wasteAdjustment),
                                const Divider(),
                                _row(
                                  'Producción recomendada para vitrina',
                                  r.displayRecommendation,
                                  strong: true,
                                ),
                                _row(
                                  'Producción por pedidos confirmados',
                                  r.confirmedOrdersProduction,
                                  strong: true,
                                ),
                                _row(
                                  'Producción total operativa',
                                  r.totalOperationalProduction,
                                  strong: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(csvExportServiceProvider)
                            .exportRecommendations(items);
                      } catch (e) {
                        if (context.mounted)
                          showMessage(context, '$e', error: true);
                      }
                    },
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Exportar recomendaciones CSV'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _row(
    String label,
    double value, {
    String suffix = '',
    bool alert = false,
    bool strong = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: strong ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}$suffix',
          style: TextStyle(
            fontWeight: strong ? FontWeight.bold : FontWeight.normal,
            color: alert ? Colors.deepOrange : null,
          ),
        ),
      ],
    ),
  );
}
