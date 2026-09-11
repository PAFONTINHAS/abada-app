import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  const SummaryCardWidget({
    super.key,
    required this.metricIcon,
    required this.metricDescription,
    required this.iconColor,
    required this.backgroundIconColor,
    this.metricValue,
    this.onPressed,
  });

  final IconData metricIcon;
  final String metricDescription;
  final Color iconColor;
  final Color backgroundIconColor;
  final String? metricValue;
  final VoidCallback? onPressed;

  bool get isActionable => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActionable 
                  ? iconColor.withValues(alpha: 0.3) // Borda destacada se for clicável
                  : const Color(0xFFE2E8F0), 
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Indicador visual discreto de ação (canto superior direito)
              if (isActionable)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: iconColor.withValues(alpha: 0.7),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone Principal
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: backgroundIconColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      metricIcon,
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Métrica (FittedBox impede estouro em números grandes)
                  SizedBox(
                    height: 26,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          metricValue ?? '--',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: metricValue != null 
                                ? const Color(0xFF1E293B) 
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Descrição (Reduz tamanho se necessário e limita linhas)
                  Text(
                    metricDescription,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}