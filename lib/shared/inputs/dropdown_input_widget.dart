import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class DropdownInputWidget extends StatelessWidget {
  const DropdownInputWidget({
    super.key,
    this.menuMaxHeight,
    required this.items,
    required this.inputHint,
    required this.initialValue,
    required this.onSelectedItem,
  });

  final String inputHint;
  final String? initialValue;
  final List<DropdownMenuItem<String>> items;
  final Function(String?) onSelectedItem;
  final double? menuMaxHeight;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      // Define a altura máxima do menu para evitar que ele sobreponha o input ou suba demais
      menuMaxHeight: menuMaxHeight,
      // Garante o alinhamento dos itens no início
      alignment: AlignmentDirectional.centerStart,
      initialValue: initialValue,
      hint: Text(
        inputHint,
        style: TextStyle(color: ColorConstants.textSecondary, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: ColorConstants.indigoColor,
      ),
      dropdownColor: ColorConstants.surfaceColor,
      style: const TextStyle(
        color: ColorConstants.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: inputHint,
        labelStyle: const TextStyle(
          color: ColorConstants.textSecondary,
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: ColorConstants.indigoColor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: ColorConstants.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorConstants.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorConstants.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: ColorConstants.indigoColor,
            width: 1.5,
          ),
        ),
      ),
      items: items,
      onChanged: onSelectedItem,
    );
  }
}
