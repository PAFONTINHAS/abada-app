// lib/core/constants/theme/app_colors.dart
import 'package:flutter/material.dart';

// classe que consolida todas as cores utilizadas no aplicativo
class AppColors {

  AppColors._();
  
  static const Color primary                 = Color(0xFF4CAF50); // Verde principal
  static const Color accent                  = Color(0xFFFF9800); // Laranja para destaque
  static const Color primaryDark             = Color(0xFF388E3C);
  static const Color primaryLight            = Color(0xFFC8E6C9);
  static const Color scaffoldBackgroundColor = Color(0xFFF5F7F9);
  static const Color calendarGreen           = Color(0xFF6B8E7F);

  static const Color textPrimary   = Color(0xFF212121);
  static const Color textOnAccent  = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color error      = Color(0xFFD32F2F);
  static const Color surface    = Color(0xFFFFFFFF); // Cor de cards, dialogs
  static const Color background = Color(0xFFFFFFFF);

  static const Color vaseBrown   = Color(0xFFA1887F);
  static const Color cropGreen   = Color(0xFF66BB6A);
  static const Color evaBabyBlue = Color(0xFFADD8E6); // Exemplo de cor específica

  static const Color modalColorRed    = Color(0xFFDF5F5F);
  static const Color modalColorGrey   = Color(0xFFA7A7A7);
  static const Color modalColorGreen  = Color(0xFF8DCA74);
  static const Color modalColorOrange = Color(0xFFEB9245);
  static const Color greenListTile    = Color(0x7E22B647);

  static const Color logoColor  = Color(0xFF93BE3F); // Verde Mais claro
  static const Color logoColor2 = Color(0xFFBACF34); // Segundo mais claro e etc
  static const Color logoColor3 = Color(0xFF63A748);
  static const Color logoColor4 = Color(0xFF1C838F);

  static const Color lightBlue  = Color(0xFF9EBBBC);
  static const Color lightGreen = Color(0xFFBEDAB0);
  static const Color lightWhite = Color(0xFF9EBBBC);

  // Cores para cards de cuidados
  static const Color coldCyan  = Color(0xFF00BCD4);
  static const Color waterBlue = Color(0xFF2196F3);
  static const Color sunOrange = Color(0xFFFF9800);

  // Cores para info de plantas
  static const Color plantInfoPurple = Color(0xFF6A5ACD);
  
  // Cores de borda e sombra
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color shadowGrey = Color(0x1A000000);

  // Cores para chips
  static const Color chipTextGrey          = Color(0xFF616161); // Grey[700]
  static const Color chipIconGrey          = Color(0xFF757575); // Grey[600]
  static const Color chipBorderLight       = Color(0xFFE0E0E0); // Borda neutra clara
  static const Color chipBackgroundLight   = Color(0xFFEEEEEE); // Grey[200]
  static const Color chipBackgroundNeutral = Color(0xFFFFFFFF);



  // Cores com opacidade
  static Color greyOpacity01          = const Color(0xFF9E9E9E).withAlpha((0.1 * 255).toInt());
  static Color surfaceOpacity07         = const Color(0xFFFFFFFF).withAlpha((0.7 * 255).toInt());
  static Color greenListTileOpacity01 = const Color(0x7E22B647).withAlpha((0.1 * 141).toInt());
  static Color blackOpacity005        = const Color(0xFF000000).withAlpha((0.05 * 255).toInt());
  
  static Color plantInfoPurpleOpacity01 = const Color(0xFF6A5ACD).withAlpha((0.1 * 255).toInt());
  static Color plantInfoPurpleOpacity03 = const Color(0xFF6A5ACD).withAlpha((0.3 * 255).toInt());
  
  static Color primaryOpacity01 = const Color(0xFF4CAF50).withAlpha((0.3 * 255).toInt());
  static Color primaryOpacity02 = const Color(0xFF4CAF50).withAlpha((0.2 * 255).toInt());
  static Color primaryOpacity03 = const Color(0xFF4CAF50).withAlpha((0.1 * 255).toInt());
  
  static Color calendarGreenOpacity01 = const Color(0xFF6B8E7F).withAlpha((0.1 * 255).toInt());
  static Color calendarGreenOpacity03 = const Color(0xFF6B8E7F).withAlpha((0.3 * 255).toInt());
  static Color calendarGreenOpacity07 = const Color(0xFF6B8E7F).withAlpha((0.7 * 255).toInt());
  
  static Color textPrimaryOpacity03   = const Color(0xFF212121).withAlpha((0.3 * 255).toInt());
  static Color textPrimaryOpacity07   = const Color(0xFF212121).withAlpha((0.7 * 255).toInt());
  static Color textOnPrimaryOpacity03 = const Color(0xFF212121).withAlpha((0.3 * 255).toInt());
  static Color textOnPrimaryOpacity07 = const Color(0xFF212121).withAlpha((0.7 * 255).toInt());

  static Color textSecondaryOpacity06 = const Color(0xFF757575).withAlpha((0.6 * 255).toInt());
  static Color textSecondaryOpacity08 = const Color(0xFF757575).withAlpha((0.8 * 255).toInt());
  static Color textSecondaryOpacity05 = const Color(0xFF757575).withAlpha((0.5 * 255).toInt());
  static Color textSecondaryOpacity03 = const Color(0xFF757575).withAlpha((0.3 * 255).toInt());
  static Color textSecondaryOpacity02 = const Color(0xFF757575).withAlpha((0.2 * 255).toInt());
  static Color textSecondaryOpacity01 = const Color(0xFF757575).withAlpha((0.1 * 255).toInt());

  static Color modalColorRedOpacity01  = const Color(0xFFDF5F5F).withAlpha((0.1 * 255).toInt());
  static Color modalColorRedOpacity03  = const Color(0xFFDF5F5F).withAlpha((0.3 * 255).toInt());

  static Color modalColorGreyOpacity08 = const Color(0xFFA7A7A7).withAlpha((0.8 * 255).toInt());
  static Color modalColorGreyOpacity03 = const Color(0xFFA7A7A7).withAlpha((0.3 * 255).toInt());


}
