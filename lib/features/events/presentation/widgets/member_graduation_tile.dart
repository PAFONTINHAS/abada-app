import 'package:flutter/material.dart';
import 'package:sistema_abada_capoeira/core/constants/color_constants.dart';
import 'package:sistema_abada_capoeira/features/class/domain/entities/class_member_entity.dart';

class MemberGraduationTileWidget extends StatelessWidget {
  final ClassMemberEntity member;
  final bool isSelected;
  final VoidCallback onChanged;

  const MemberGraduationTileWidget({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? ColorConstants.indigoLight.withOpacity(0.5)
            : ColorConstants.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? ColorConstants.indigoColor
              : ColorConstants.borderColor,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onChanged,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              // Checkbox compacto
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: isSelected,
                  onChanged: (_) => onChanged(),
                  activeColor: ColorConstants.indigoColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(
                    color: ColorConstants.textSecondary,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Avatar com inicial
              CircleAvatar(
                radius: 16,
                backgroundColor: isSelected
                    ? ColorConstants.indigoColor
                    : ColorConstants.borderColor,
                child: Text(
                  (member.name != null && member.name!.isNotEmpty)
                      ? member.name![0].toUpperCase()
                      : "A",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? ColorConstants.whiteColor
                        : ColorConstants.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Informações do Aluno com proteção contra Overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name ?? "Estudante",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: ColorConstants.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.military_tech_outlined,
                          size: 14,
                          color: ColorConstants.indigoColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "De ${member.belt} para ROXA",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: ColorConstants.textSecondary,
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}