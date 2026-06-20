import 'dart:io';

import 'package:charitos_planificador/services/csv_import_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('lector CSV', () {
    test('acepta el formato tradicional separado por comas', () {
      final rows = parseCsvRows(
        'nombre,categoria,unidad_medida\nMármol,vainilla,unidad',
      );

      expect(rows, hasLength(2));
      expect(rows.first, ['nombre', 'categoria', 'unidad_medida']);
      expect(rows[1], ['Mármol', 'vainilla', 'unidad']);
    });

    test('acepta el formato de Excel separado por punto y coma con BOM', () {
      final rows = parseCsvRows(
        '\ufeffsep=;\r\nnombre;categoria;unidad_medida\r\n'
        'Mármol;vainilla;unidad',
      );

      expect(rows, hasLength(2));
      expect(rows.first, ['nombre', 'categoria', 'unidad_medida']);
      expect(rows[1], ['Mármol', 'vainilla', 'unidad']);
    });

    test('lee completo el catálogo entregado', () {
      final content = File(
        'docs/csv_templates/productos_catalogo_charitos_excel.csv',
      ).readAsStringSync();
      final rows = parseCsvRows(content);

      expect(rows, hasLength(47));
      expect(rows.every((row) => row.length == 14), isTrue);
      expect(rows[1].first, 'Vainilla - Mármol');
      expect(rows.last.first, 'Pasteles - Mil hojas');
    });
  });
}
