import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/cupertino_text_input_widget.dart';
import 'package:sistema_abada_capoeira/shared/inputs/custom_text_input/material_text_input_widget.dart';

// Widget reutilizável para entrada de texto customizada
class CustomTextInput extends StatefulWidget {
  final String? label; // Rótulo opcional exibido acima do campo
  final String? hintText; // Texto de dica dentro do campo
  final TextStyle? hintStyle; // Estilo do texto de dica (placeholder)
  final TextEditingController? controller; // Controlador para gerenciar o texto
  final String? Function(String?)? validator; // Função de validação do formulário
  final TextInputType keyboardType; // Tipo de teclado a ser exibido
  final bool obscureText; // Oculta texto (para senhas)
  final bool enabled; // Habilita/desabilita interação
  final int maxLines; // Número máximo de linhas (1 = campo simples)
  final Widget? prefixIcon; // Ícone à esquerda do campo
  final Widget? suffixIcon; // Ícone à direita do campo
  final VoidCallback? onTap; // Callback quando campo é tocado
  final Function(String)? onChanged; // Callback quando texto muda
  final bool readOnly; // Campo somente leitura (não editável)
  final bool isPasswordField;
  final bool hasMask;
  final MaskTextInputFormatter? mask;
  final Color? onFocusBorderColor;

  const CustomTextInput({
    super.key,
    this.label,
    this.hintText,
    this.hintStyle,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.name,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.isPasswordField = false,
    this.readOnly = false,
    this.hasMask = false,
    this.onFocusBorderColor,
    this.mask,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {


  late TextEditingController _internalController;
  final ValueNotifier<bool> _hasTextNotifier = ValueNotifier<bool>(false);

  bool _hasText = false; // Controla se há texto para borda verde
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Usa controller fornecido ou cria um interno
    _internalController = widget.controller ?? TextEditingController();
    // _hasText = _internalController.text.isNotEmpty;
    _hasTextNotifier.value = _internalController.text.isNotEmpty;

    // Escuta mudanças no texto para atualizar a borda
    _internalController.addListener(_onTextChanged);

    _passwordVisible = false;
  }

  @override
  void dispose() {
    // Remove listener e descarta controller apenas se criado internamente
    _internalController.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomTextInput oldWidget){
    super.didUpdateWidget(oldWidget);

    if(widget.controller != oldWidget.controller){
      oldWidget.controller?.removeListener(_onTextChanged);
      _internalController = widget.controller ?? TextEditingController();
      _internalController.addListener(_onTextChanged);
    }
  }

  // Atualiza estado quando texto muda
  void _onTextChanged() {
    final hasText = _internalController.text.isNotEmpty;
    if (hasText != _hasTextNotifier.value) {
      setState(() {
        _hasTextNotifier.value = hasText;
      });
    }
  }

  void _toglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if(isIOS){
      return CupertinoTextInputWidget(
        widgetProps: widget,
        controller: _internalController,
        hasText: _hasText,
        passwordVisible: _passwordVisible,
        onTogglePassword: _toglePasswordVisibility,
      ); 
    }

    return MaterialTextInputWidget(
      widgetProps: widget,
      controller: _internalController,
      hasText: _hasText,
      passwordVisible: _passwordVisible,
      onTogglePassword: _toglePasswordVisibility,
    );
  }


}
