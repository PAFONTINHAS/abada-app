// lib/core/constants/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart'; // Para usar as cores definidas

// classe que consolida todos os estilos de textos utilizados no aplicativo
class AppTextStyles {
  const AppTextStyles ._();
  
  static const String _fontFamilyPrimary = 'Montserrat';

  static TextStyle get bold32 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bold24 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bold18 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bold15 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bold16 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get bold12 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }
  static TextStyle get bold10 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold32 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold24 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold16 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold14 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold12 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get semiBold10 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }


  static TextStyle get light12 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w200,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular10 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular12 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular13 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get light16 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w200,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular14 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular15 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular16 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get regular18 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get button {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500, // Medium
      color: AppColors.textOnPrimary, // Geralmente texto branco em botões primários
    );
  }

  static TextStyle get greyRegular14 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get medium13 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get medium14 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle get medium12 {
    return const TextStyle(
      fontFamily: _fontFamilyPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    );
  }


  // Adicione outros estilos conforme necessário (caption, subtitle, etc.)
}
