import 'package:flutter/material.dart';

import 'csv_screen.dart';
import 'dashboard_screen.dart';
import 'lots_screen.dart';
import 'orders_screen.dart';
import 'products_screen.dart';
import 'recommendation_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'transaction_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _Destination {
  const _Destination(this.label, this.icon, this.child);
  final String label;
  final IconData icon;
  final Widget child;
}

class _AppShellState extends State<AppShell> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selected = 0;
  late final destinations = <_Destination>[
    const _Destination('Inicio', Icons.dashboard_outlined, DashboardScreen()),
    const _Destination('Productos', Icons.cake_outlined, ProductsScreen()),
    const _Destination(
      'Registrar stock',
      Icons.inventory_2_outlined,
      TransactionScreen(type: TransactionType.stock),
    ),
    const _Destination(
      'Registrar producción',
      Icons.bakery_dining_outlined,
      TransactionScreen(type: TransactionType.production),
    ),
    const _Destination(
      'Registrar ventas',
      Icons.point_of_sale_outlined,
      TransactionScreen(type: TransactionType.sale),
    ),
    const _Destination(
      'Registrar merma',
      Icons.delete_sweep_outlined,
      TransactionScreen(type: TransactionType.waste),
    ),
    const _Destination(
      'Pedidos confirmados',
      Icons.assignment_turned_in_outlined,
      OrdersScreen(),
    ),
    const _Destination(
      'Lotes y vencimientos',
      Icons.event_busy_outlined,
      LotsScreen(),
    ),
    const _Destination(
      'Recomendación',
      Icons.auto_graph_outlined,
      RecommendationScreen(),
    ),
    const _Destination('Reportes', Icons.bar_chart_outlined, ReportsScreen()),
    const _Destination(
      'Importar / Exportar',
      Icons.import_export_outlined,
      CsvScreen(),
    ),
    const _Destination(
      'Configuración',
      Icons.settings_outlined,
      SettingsScreen(),
    ),
  ];

  void select(int index) {
    setState(() => selected = index);
    scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(destinations[selected].label),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Tooltip(
              message: 'Funciona sin internet',
              child: Chip(
                avatar: const Icon(Icons.cloud_off, size: 17),
                label: const Text('Offline'),
              ),
            ),
          ),
        ],
      ),
      drawer: NavigationDrawer(
        selectedIndex: selected,
        onDestinationSelected: select,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 16, 12),
            child: Text(
              'Charito’s Planifica',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 0, 20, 12),
            child: Text('Producción con menos merma'),
          ),
          ...destinations.map(
            (item) => NavigationDrawerDestination(
              icon: Icon(item.icon),
              label: Text(item.label),
            ),
          ),
        ],
      ),
      body: SafeArea(child: destinations[selected].child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: switch (selected) {
          0 => 0,
          1 => 1,
          8 => 3,
          _ => 2,
        },
        onDestinationSelected: (index) {
          if (index == 0) select(0);
          if (index == 1) select(1);
          if (index == 2) scaffoldKey.currentState?.openDrawer();
          if (index == 3) select(8);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.cake_outlined),
            selectedIcon: Icon(Icons.cake),
            label: 'Productos',
          ),
          NavigationDestination(icon: Icon(Icons.menu), label: 'Módulos'),
          NavigationDestination(
            icon: Icon(Icons.auto_graph_outlined),
            selectedIcon: Icon(Icons.auto_graph),
            label: 'Planificar',
          ),
        ],
      ),
    );
  }
}
