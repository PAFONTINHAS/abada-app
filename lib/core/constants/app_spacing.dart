import 'package:flutter/material.dart';

/// Design Tokens - Sistema de Espaçamento EVA
/// Baseado nos valores realmente utilizados no projeto
class AppSpacing {
  const AppSpacing._();


  // ========== PADDING ==========

  // All sides
  static const EdgeInsets all4  = EdgeInsets.all(4.0);
  static const EdgeInsets all8  = EdgeInsets.all(8.0);
  static const EdgeInsets all9  = EdgeInsets.all(9.0);
  static const EdgeInsets all10 = EdgeInsets.all(10.0);
  static const EdgeInsets all12 = EdgeInsets.all(12.0);
  static const EdgeInsets all16 = EdgeInsets.all(16.0);
  static const EdgeInsets all20 = EdgeInsets.all(20.0);
  static const EdgeInsets all24 = EdgeInsets.all(24.0);
  static const EdgeInsets all32 = EdgeInsets.all(32.0);

  // Horizontal
  static const EdgeInsets horizontal8  = EdgeInsets.symmetric(horizontal: 8.0);
  static const EdgeInsets horizontal12 = EdgeInsets.symmetric(horizontal: 12.0);
  static const EdgeInsets horizontal16 = EdgeInsets.symmetric(horizontal: 16.0);

  // Vertical
  static const EdgeInsets vertical4  = EdgeInsets.symmetric(vertical: 4.0);
  static const EdgeInsets vertical6  = EdgeInsets.symmetric(vertical: 6.0);
  static const EdgeInsets vertical8  = EdgeInsets.symmetric(vertical: 8.0);
  static const EdgeInsets vertical10 = EdgeInsets.symmetric(vertical: 10.0);
  static const EdgeInsets vertical12 = EdgeInsets.symmetric(vertical: 12.0);
  static const EdgeInsets vertical16 = EdgeInsets.symmetric(vertical: 16.0);
  static const EdgeInsets vertical24 = EdgeInsets.symmetric(vertical: 24.0);

  // Combined (horizontal + vertical)
  static const EdgeInsets symmetricH8V4   = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
  static const EdgeInsets symmetricH8V6   = EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
  static const EdgeInsets symmetricH8V8   = EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  static const EdgeInsets symmetricH12V6  = EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
  static const EdgeInsets symmetricH12V8  = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
  static const EdgeInsets symmetricH16V8  = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
  static const EdgeInsets symmetricH16V10 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);
  static const EdgeInsets symmetricH16V12 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
  static const EdgeInsets symmetricH16V15 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0);
  static const EdgeInsets symmetricH16V16 = EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
  static const EdgeInsets symmetricH24V20 = EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0);

  // Only
  static const EdgeInsets onlyBottom8  = EdgeInsets.only(bottom: 8.0);
  static const EdgeInsets onlyBottom12 = EdgeInsets.only(bottom: 12.0);
  static const EdgeInsets onlyBottom16 = EdgeInsets.only(bottom: 16.0);
  static const EdgeInsets onlyBottom20 = EdgeInsets.only(bottom: 20.0);
  static const EdgeInsets onlyBottom24 = EdgeInsets.only(bottom: 24.0);
  static const EdgeInsets onlyBottom32 = EdgeInsets.only(bottom: 32.0);

  static const EdgeInsets onlyTop16 = EdgeInsets.only(top: 16.0);

  static const EdgeInsets onlyRight2  = EdgeInsets.only(right: 2.0);
  static const EdgeInsets onlyRight12 = EdgeInsets.only(right: 12.0);

  static const EdgeInsets onlyLeft16Right16Top32      = EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0);
  static const EdgeInsets onlyLeft16Top16Bottom8      = EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0);
  static const EdgeInsets onlyLeft56Right4Bottom6     = EdgeInsets.only(left: 56.0, right: 4.0, bottom: 6.0);
  static const EdgeInsets onlyLeft5Right10Top0Bottom0 = EdgeInsets.only(left: 5.0, right: 10.0, top: 0, bottom: 0);

  // ========== GAPS (SizedBox) ==========

  // Vertical
  static const SizedBox gapV4  = SizedBox(height: 4.0);
  static const SizedBox gapV5  = SizedBox(height: 5.0);
  static const SizedBox gapV6  = SizedBox(height: 6.0);
  static const SizedBox gapV8  = SizedBox(height: 8.0);
  static const SizedBox gapV10 = SizedBox(height: 10.0);
  static const SizedBox gapV12 = SizedBox(height: 12.0);
  static const SizedBox gapV15 = SizedBox(height: 15.0);
  static const SizedBox gapV16 = SizedBox(height: 16.0);
  static const SizedBox gapV20 = SizedBox(height: 20.0);
  static const SizedBox gapV24 = SizedBox(height: 24.0);
  static const SizedBox gapV30 = SizedBox(height: 30.0);
  static const SizedBox gapV32 = SizedBox(height: 32.0);
  static const SizedBox gapV40 = SizedBox(height: 40.0);
  static const SizedBox gapV60 = SizedBox(height: 60.0);
  static const SizedBox gapV64 = SizedBox(height: 64.0);
  static const SizedBox gapV70 = SizedBox(height: 70.0);

  // Horizontal
  static const SizedBox gapH4  = SizedBox(width: 4.0);
  static const SizedBox gapH8  = SizedBox(width: 8.0);
  static const SizedBox gapH12 = SizedBox(width: 12.0);
  static const SizedBox gapH16 = SizedBox(width: 16.0);
  static const SizedBox gapH20 = SizedBox(width: 20.0);

  // ========== RADIUS ==========

  // Presets
  static BorderRadius get rounded4    => BorderRadius.circular(4.0);
  static BorderRadius get rounded8    => BorderRadius.circular(8.0);
  static BorderRadius get rounded10   => BorderRadius.circular(10.0);
  static BorderRadius get rounded12   => BorderRadius.circular(12.0);
  static BorderRadius get rounded14   => BorderRadius.circular(14.0);
  static BorderRadius get rounded16   => BorderRadius.circular(16.0);
  static BorderRadius get rounded20   => BorderRadius.circular(20.0);
  static BorderRadius get rounded25   => BorderRadius.circular(25.0);
  static BorderRadius get roundedFull => BorderRadius.circular(100.0);

  // ========== ICON SIZES ==========
  
  static const double iconXSmall = 14.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;

  // ========== BORDER WIDTHS ==========
  
  static const double borderThin = 1.0;
  static const double borderMedium = 1.5;
  static const double borderThick = 2.0;
}
