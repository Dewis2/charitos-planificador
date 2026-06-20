import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.read(dataVersionProvider.notifier).bump(),
      child: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          error: error,
          onRetry: () => ref.read(dataVersionProvider.notifier).bump(),
        ),
        data: (value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Resumen de hoy',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Indicadores calculados solo con datos guardados en este dispositivo.',
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                MetricCard(
                  label: 'Productos activos',
                  value: '${value.activeProducts}',
                  icon: Icons.check_circle_outline,
                ),
                MetricCard(
                  label: 'Productos inactivos',
                  value: '${value.inactiveProducts}',
                  icon: Icons.pause_circle_outline,
                ),
                MetricCard(
                  label: 'Merma del día',
                  value: value.todayWaste.toStringAsFixed(1),
                  icon: Icons.delete_outline,
                  alert: value.todayWaste > 0,
                ),
                MetricCard(
                  label: 'Costo de merma',
                  value: 'S/ ${value.todayWasteCost.toStringAsFixed(2)}',
                  icon: Icons.payments_outlined,
                  alert: value.todayWasteCost > 0,
                ),
                MetricCard(
                  label: 'Por vencer',
                  value: '${value.expiringProducts}',
                  icon: Icons.warning_amber,
                  alert: value.expiringProducts > 0,
                ),
                MetricCard(
                  label: 'Vencidos',
                  value: '${value.expiredProducts}',
                  icon: Icons.event_busy,
                  alert: value.expiredProducts > 0,
                ),
                MetricCard(
                  label: 'Producción recomendada',
                  value: value.todayRecommendedProduction.toStringAsFixed(1),
                  icon: Icons.auto_graph,
                ),
                MetricCard(
                  label: 'Ventas del día',
                  value: value.todaySales.toStringAsFixed(1),
                  icon: Icons.point_of_sale,
                ),
                MetricCard(
                  label: 'Producción registrada',
                  value: value.todayProduction.toStringAsFixed(1),
                  icon: Icons.bakery_dining,
                ),
              ],
            ),
            const SectionTitle('Producción vs ventas · últimos 7 días'),
            SizedBox(
              height: 230,
              child: _ProductionSalesChart(data: value.productionVsSales),
            ),
            const SectionTitle('Merma por mes'),
            SizedBox(
              height: 220,
              child: _MonthlyChart(data: value.monthlyWaste),
            ),
            const SectionTitle('Productos con mayor merma'),
            if (value.topWasteProducts.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Todavía no hay registros de merma.'),
                ),
              )
            else
              ...value.topWasteProducts.entries.map(
                (entry) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.delete_sweep_outlined),
                    ),
                    title: Text(entry.key),
                    trailing: Text(
                      entry.value.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProductionSalesChart extends StatelessWidget {
  const _ProductionSalesChart({required this.data});
  final Map<String, List<double>> data;
  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final maxValue = entries
        .expand((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 22, 16, 10),
        child: BarChart(
          BarChartData(
            maxY: maxValue <= 0 ? 10 : maxValue * 1.25,
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 36),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        entries[i].key.substring(8),
                        style: const TextStyle(fontSize: 11),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: [
              for (var i = 0; i < entries.length; i++)
                BarChartGroupData(
                  x: i,
                  barsSpace: 3,
                  barRods: [
                    BarChartRodData(
                      toY: entries[i].value[0],
                      width: 8,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    BarChartRodData(
                      toY: entries[i].value[1],
                      width: 8,
                      color: Colors.teal,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.data});
  final Map<String, double> data;
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty)
      return const Card(
        child: EmptyState(
          icon: Icons.show_chart,
          message: 'No hay datos mensuales de merma.',
        ),
      );
    final entries = data.entries.toList();
    final maxValue = entries
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 22, 18, 10),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: maxValue <= 0 ? 10 : maxValue * 1.25,
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 36),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final i = value.toInt();
                    if (i < 0 || i >= entries.length) return const SizedBox();
                    return Text(
                      entries[i].key.substring(5),
                      style: const TextStyle(fontSize: 11),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 4,
                dotData: const FlDotData(show: true),
                spots: [
                  for (var i = 0; i < entries.length; i++)
                    FlSpot(i.toDouble(), entries[i].value),
                ],
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: .12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
