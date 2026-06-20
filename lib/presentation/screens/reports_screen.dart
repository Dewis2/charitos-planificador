import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(reportProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorState(error: error),
          data: (data) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Análisis acumulado de los datos guardados en el dispositivo.',
              ),
              const SectionTitle('Merma por producto'),
              _Bars(data: data.wasteByProduct),
              const SectionTitle('Merma por categoría'),
              _rank(data.wasteByCategory, Icons.category_outlined),
              const SectionTitle('Merma por ubicación'),
              _rank(data.wasteByLocation, Icons.store_outlined),
              const SectionTitle('Costo de merma por mes'),
              _rank(
                data.wasteCostByMonth,
                Icons.payments_outlined,
                prefix: 'S/ ',
              ),
              const SectionTitle('Productos con mayor riesgo de merma'),
              _rank(data.riskProducts, Icons.trending_up, suffix: '%'),
              const SectionTitle('Productos próximos a vencer'),
              _rank(data.expiringProducts, Icons.warning_amber),
              const SizedBox(height: 24),
            ],
          ),
        );
  }

  static Widget _rank(
    Map<String, double> data,
    IconData icon, {
    String prefix = '',
    String suffix = '',
  }) {
    if (data.isEmpty)
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No hay datos para este reporte.'),
        ),
      );
    return Column(
      children: data.entries
          .take(8)
          .map(
            (entry) => Card(
              child: ListTile(
                leading: Icon(icon),
                title: Text(entry.key.replaceAll('_', ' ')),
                trailing: Text(
                  '$prefix${entry.value.toStringAsFixed(1)}$suffix',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Bars extends StatelessWidget {
  const _Bars({required this.data});
  final Map<String, double> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty)
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text('No hay registros de merma.'),
        ),
      );
    final entries = data.entries.take(6).toList();
    final max = entries
        .map((entry) => entry.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return Card(
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
          child: BarChart(
            BarChartData(
              maxY: max <= 0 ? 10 : max * 1.2,
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
                    reservedSize: 46,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= entries.length) return const SizedBox();
                      final name = entries[index].key;
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          name.length > 7 ? '${name.substring(0, 7)}…' : name,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var index = 0; index < entries.length; index++)
                  BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: entries[index].value,
                        color: Theme.of(context).colorScheme.primary,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
