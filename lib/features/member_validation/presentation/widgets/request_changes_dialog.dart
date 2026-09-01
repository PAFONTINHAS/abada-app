import 'package:flutter/material.dart';

class RequestChangesDialog extends StatefulWidget {
  final Future<void> Function(String reason) onConfirm;

  const RequestChangesDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  State<RequestChangesDialog> createState() =>
      _RequestChangesDialogState();
}

class _RequestChangesDialogState
    extends State<RequestChangesDialog> {
  bool beltSelected = false;
  bool nicknameSelected = false;
  bool classSelected = false;
  bool isLoading = false;

  final TextEditingController detailsController =
      TextEditingController();

  static const Color orange = Color(0xFFF59E0B);
  static const Color darkText = Color(0xFF252334);
  static const Color secondaryText = Color(0xFF6B6877);
  static const Color borderColor = Color(0xFFE4E1E8);
  static const Color fieldBackground = Color(0xFFFAF9FB);

  @override
  void dispose() {
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final reasons = <String>[];

    if (beltSelected) {
      reasons.add('Corda incorreta');
    }

    if (nicknameSelected) {
      reasons.add('Apelido incorreto');
    }

    if (classSelected) {
      reasons.add('Não pertence à turma');
    }

    if (reasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione pelo menos uma correção.',
          ),
        ),
      );

      return;
    }

    final details = detailsController.text.trim();

    String reason = reasons.join(', ');

    if (details.isNotEmpty) {
      reason = '$reason. Detalhes: $details';
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
              _buildHeader(),

              const SizedBox(height: 14),

              const Text(
                'Selecione os dados que precisam ser corrigidos pelo aluno.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 22),

              _CorrectionOption(
                label: 'Corda incorreta',
                selected: beltSelected,
                onChanged: (value) {
                  setState(() {
                    beltSelected = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              _CorrectionOption(
                label: 'Apelido incorreto',
                selected: nicknameSelected,
                onChanged: (value) {
                  setState(() {
                    nicknameSelected = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              _CorrectionOption(
                label: 'Não pertence à turma',
                selected: classSelected,
                onChanged: (value) {
                  setState(() {
                    classSelected = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              const Text(
                'Observação',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: detailsController,
                minLines: 3,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  color: darkText,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Adicione mais detalhes, se necessário...',
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
                      color: orange,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

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
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
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

                  const SizedBox(width: 8),

                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed:
                            isLoading ? null : _confirm,
                        style: FilledButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
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
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Enviar correções',
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4DD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.edit_outlined,
            color: orange,
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Text(
            'Pedir correções',
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
    );
  }
}

class _CorrectionOption extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _CorrectionOption({
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!selected);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFFF8EB)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFFF59E0B)
                : const Color(0xFFE4E1E8),
          ),
        ),
        child: Row(
          children: [
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

            Checkbox(
              value: selected,
              activeColor: const Color(0xFFF59E0B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (value) {
                onChanged(value ?? false);
              },
            ),
          ],
        ),
      ),
    );
  }
}