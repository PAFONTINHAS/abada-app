class MaskFormatter {
  MaskFormatter._();

  static double convertMoneyStringToDouble(String money) {
  if (money.trim().isEmpty) return 0.0;

  final cleanPrice = money
      .replaceAll('R\$', '')
      .replaceAll(RegExp(r'\s'), '')
      .replaceAll('.', '')
      .replaceAll(',', '.');

  return double.tryParse(cleanPrice) ?? 0.0;
}

  static double convertToTwoDecimalsValue(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static String convertMoneyDoubleToString(double money) {
    return money.toStringAsFixed(2);
  }
}