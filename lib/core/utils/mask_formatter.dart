class MaskFormatter {
  MaskFormatter._();

  static double convertMoneyStringToDouble(String money) {
    if (money.trim().isEmpty) return 0.0;

    var cleanPrice = money
        .replaceAll('R\$', '')
        .replaceAll(RegExp(r'\s'), '')
        .trim();

    // Formato brasileiro: 1.234,56 ou 297,00
    if (cleanPrice.contains(',')) {
      cleanPrice = cleanPrice
          .replaceAll('.', '')
          .replaceAll(',', '.');
    } else {
      // Formato decimal: 297.00 ou 3.00
      // Mantém o ponto como separador decimal.
      cleanPrice = cleanPrice.replaceAll(
        RegExp(r'[^0-9.\-]'),
        '',
      );
    }

    return double.tryParse(cleanPrice) ?? 0.0;
  }

  static double convertToTwoDecimalsValue(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static String convertMoneyDoubleToString(double money) {
    return money.toStringAsFixed(2);
  }
}