import '../utils/date_utils.dart';

class InputValidators {
  InputValidators._();

  static String? requiredText(String? value, {String label = 'Campo'}) {
    if (value == null || value.trim().isEmpty) return '$label es obligatorio';
    return null;
  }

  static String? nonNegativeNumber(String? value, {String label = 'Cantidad'}) {
    final number = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (number == null) return '$label debe ser numérico';
    if (number < 0) return '$label no puede ser negativo';
    return null;
  }

  static String? positiveNumber(String? value, {String label = 'Valor'}) {
    final number = double.tryParse((value ?? '').replaceAll(',', '.'));
    if (number == null || number <= 0) return '$label debe ser mayor a cero';
    return null;
  }

  static String? storageDate(String? value) {
    if (AppDateUtils.tryParse(value ?? '') == null)
      return 'Use una fecha válida: AAAA-MM-DD';
    return null;
  }
}
