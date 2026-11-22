import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';

class PageIndicatorWidget extends StatelessWidget {
  const PageIndicatorWidget({
    super.key,
    required this.selectedSection,
    required this.onSelected,
  });

  final int selectedSection;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['Noticias', 'Acervo Histórico'];

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(options.length, (index) {
              final isSelected = selectedSection == index;
              return GestureDetector(
                onTap: () => onSelected(index),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: isSelected ? 11 : 9,
                        height: isSelected ? 11 : 9,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorConstants.indigoColor
                              : ColorConstants.borderColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 220),
                        style: TextStyle(
                          color: isSelected
                              ? ColorConstants.indigoColor
                              : ColorConstants.textSecondary,
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                        child: Text(options[index]),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: ColorConstants.textPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
