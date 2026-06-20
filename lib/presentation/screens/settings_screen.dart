import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/validators/input_validators.dart';
import '../../domain/entities/records.dart';
import '../providers/app_providers.dart';
import '../widgets/common_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(settingsProvider)
      .when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(error: e),
        data: (settings) =>
            _SettingsForm(key: ValueKey(settings), initial: settings),
      );
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({super.key, required this.initial});
  final AppSettings initial;
  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController factor;
  late final TextEditingController days;
  late final TextEditingController currency;
  late final TextEditingController threshold;
  late String location;
  late bool rounding;
  late bool expiredAlerts;
  late bool expiringAlerts;
  bool saving = false;
  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    factor = TextEditingController(text: '${s.wasteAdjustmentFactor}');
    days = TextEditingController(text: '${s.historicalAnalysisDays}');
    currency = TextEditingController(text: s.currency);
    threshold = TextEditingController(text: '${s.expiringThresholdDays}');
    location = s.defaultLocation;
    rounding = s.batchRoundingEnabled;
    expiredAlerts = s.expiredAlertsEnabled;
    expiringAlerts = s.expiringAlertsEnabled;
  }

  @override
  void dispose() {
    factor.dispose();
    days.dispose();
    currency.dispose();
    threshold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
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
                  'Parámetros internos',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Estos valores afectan los cálculos y alertas del dispositivo.',
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: factor,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Factor de ajuste por merma',
                  ),
                  validator: (v) =>
                      InputValidators.nonNegativeNumber(v, label: 'Factor'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: days,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Días de análisis histórico',
                  ),
                  validator: (v) =>
                      InputValidators.positiveNumber(v, label: 'Días'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: currency,
                  decoration: const InputDecoration(labelText: 'Moneda'),
                  validator: (v) =>
                      InputValidators.requiredText(v, label: 'Moneda'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  value: location,
                  decoration: const InputDecoration(
                    labelText: 'Ubicación predeterminada',
                  ),
                  items: AppConstants.locations
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.replaceAll('_', ' ')),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => location = v!,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: threshold,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Umbral por vencer (días)',
                  ),
                  validator: (v) =>
                      InputValidators.positiveNumber(v, label: 'Umbral'),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Redondear por lote'),
                  subtitle: const Text(
                    'Aplica lote mínimo y múltiplo de producción',
                  ),
                  value: rounding,
                  onChanged: (v) => setState(() => rounding = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Alertas de stock vencido'),
                  value: expiredAlerts,
                  onChanged: (v) => setState(() => expiredAlerts = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Alertas de stock por vencer'),
                  value: expiringAlerts,
                  onChanged: (v) => setState(() => expiringAlerts = v),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(saving ? 'Guardando…' : 'Guardar configuración'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
  Future<void> _save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      final settings = AppSettings(
        wasteAdjustmentFactor: double.parse(factor.text.replaceAll(',', '.')),
        historicalAnalysisDays: int.parse(days.text),
        currency: currency.text.trim(),
        defaultLocation: location,
        batchRoundingEnabled: rounding,
        expiringThresholdDays: int.parse(threshold.text),
        expiredAlertsEnabled: expiredAlerts,
        expiringAlertsEnabled: expiringAlerts,
      );
      await ref.read(repositoryProvider).saveSettings(settings);
      ref.read(dataVersionProvider.notifier).bump();
      if (mounted) showMessage(context, 'Configuración guardada.');
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo guardar: $e', error: true);
    }
    if (mounted) setState(() => saving = false);
  }
}
