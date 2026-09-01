import 'package:flutter/material.dart';

class RejectRequestDialog extends StatefulWidget {
  final Future<void> Function(String reason) onConfirm;

  const RejectRequestDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<RejectRequestDialog> createState() =>
      _RejectRequestDialogState();
}

class _RejectRequestDialogState
    extends State<RejectRequestDialog> {
  String? selectedReason;
  bool isLoading = false;

  final TextEditingController otherReasonController =
      TextEditingController();

  static const Color red = Color(0xFFEF4444);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF6B6877);
  static const Color borderColor = Color(0xFFE4E1E8);
  static const Color fieldBackground = Color(0xFFFAF9FB);

  @override
  void dispose() {
    otherReasonController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione um motivo para a rejeição.',
          ),
        ),
      );

      return;
    }

    String reason = selectedReason!;

    if (selectedReason == 'Outro motivo') {
      final otherReason =
          otherReasonController.text.trim();

      if (otherReason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Informe o motivo da rejeição.',
            ),
          ),
        );

        return;
      }

      reason = otherReason;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await widget.onConfirm(reason);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        padding: const EdgeInsets.fromLTRB(
          24,
          24,
          24,
          20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEEE),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: red,
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      'Recusar solicitação',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    icon: const Icon(
                      Icons.close,
                      size: 21,
                    ),
                    color: secondaryText,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                'Selecione o motivo da recusa.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 22),

              _ReasonOption(
                label: 'Não pertence à ABADÁ',
                selected:
                    selectedReason ==
                    'Não pertence à ABADÁ',
                onTap: () {
                  setState(() {
                    selectedReason =
                        'Não pertence à ABADÁ';
                  });
                },
              ),

              const SizedBox(height: 10),

              _ReasonOption(
                label: 'Outro motivo',
                selected:
                    selectedReason == 'Outro motivo',
                onTap: () {
                  setState(() {
                    selectedReason = 'Outro motivo';
                  });
                },
              ),

              if (selectedReason == 'Outro motivo') ...[
                const SizedBox(height: 20),

                const Text(
                  'Motivo da rejeição',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: otherReasonController,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Especifique o motivo da rejeição...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFA3A0AA),
                    ),
                    filled: true,
                    fillColor: fieldBackground,
                    contentPadding:
                        const EdgeInsets.all(14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: red,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context)
                                    .pop();
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: darkText,
                        ),
                        child: const FittedBox(
                          child: Text(
                            'Cancelar',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed:
                            isLoading ? null : _confirm,
                        style: FilledButton.styleFrom(
                          backgroundColor: red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const FittedBox(
                                child: Text(
                                  'Recusar solicitação',
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
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

class _ReasonOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReasonOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF5F5)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFEF4444)
                : const Color(0xFFE4E1E8),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF9B98A3),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration:
                            const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF252334),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}