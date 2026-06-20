class AppConstants {
  AppConstants._();

  static const categories = <String>[
    'vainilla',
    '3 leches',
    'selva negra',
    'helada',
    'pasteles',
    'torta',
    'pastel',
    'bocadito',
    'keke',
    'empanada',
    'postre',
    'otro',
  ];

  static const units = <String>['unidad', 'porcion', 'bandeja', 'caja', 'kg'];
  static const locations = <String>[
    'tienda_1',
    'tienda_2',
    'taller',
    'general',
  ];
  static const productionTypes = <String>['vitrina', 'pedido', 'ambos'];
  static const wasteReasons = <String>[
    'no_vendido',
    'vencido',
    'dañado',
    'devolucion',
    'calidad',
    'otro',
  ];
  static const orderStatuses = <String>[
    'registrado',
    'confirmado',
    'anulado',
    'entregado',
  ];
}
