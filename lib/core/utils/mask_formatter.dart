class MaskFormatter {

  MaskFormatter._();

  static double convertMoneyStringToDouble(String money){

    final cleanPrice = money
      .replaceAll('R\$', '')
      .replaceAll('.', '')
      .replaceAll(',', '.')
      .trim();

    return double.tryParse(cleanPrice) ?? 0.0;
  }
  
  static double convertToTwoDecimalsValue(double value){

    String formatedValue = value.toStringAsFixed(2);

    return double.parse(formatedValue);
  }

  static String convertMoneyDoubleToString(double money){

    return money.toStringAsFixed(2);
  }
}