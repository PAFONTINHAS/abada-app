import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Widget reutilizável para entrada de texto customizada
class CustomTextInput extends StatefulWidget {
  final String? label; // Rótulo opcional exibido acima do campo
  final String? hintText; // Texto de dica dentro do campo
  final TextStyle? hintStyle; // Estilo do texto de dica (placeholder)
  final TextEditingController? controller; // Controlador para gerenciar o texto
  final String? Function(String?)?
  validator; // Função de validação do formulário
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
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS ? _buildCupertinoInput(context) : _buildMaterialInput(context);
  }

  late TextEditingController _internalController;
  bool _hasText = false; // Controla se há texto para borda verde
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Usa controller fornecido ou cria um interno
    _internalController = widget.controller ?? TextEditingController();
    _hasText = _internalController.text.isNotEmpty;

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

  // Atualiza estado quando texto muda
  void _onTextChanged() {
    final hasText = _internalController.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  // Wrapper para onChanged que chama callback externo + interno
  void _handleTextChanged(String value) {
    widget.onChanged?.call(value);
  }

  Widget _buildMaterialInput(BuildContext context) {
    // Estrutura vertical: label opcional + campo de texto estilizado
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Renderiza label apenas se fornecido
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
        // Campo de texto principal com decoração customizada
        TextFormField(
          controller: _internalController,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          enableSuggestions: true,
          obscureText:
              widget.isPasswordField ? !_passwordVisible : widget.obscureText,
          enabled: widget.enabled,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          inputFormatters:
              widget.hasMask && widget.mask != null ? [widget.mask!] : [],
          onChanged: _handleTextChanged,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                widget.isPasswordField
                    ? IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: widget.onFocusBorderColor ?? Color.fromRGBO(78, 39, 211, 100),
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                    : widget.suffixIcon,
            // Borda padrão (cinza claro)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            // Borda quando campo está habilitado: verde se tem texto, cinza se vazio
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: 
                  _hasText 
                    ?  widget.onFocusBorderColor ?? Color.fromRGBO(78, 39, 211, 100)
                    : Colors.grey.shade300,
                width: _hasText ? 2 : 1,
              ),
            ),
            // Borda quando campo está focado (verde, mais espessa)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: widget.onFocusBorderColor ?? Color.fromRGBO(78, 39, 211, 100),
                width: 2,
              ),
            ),
            // Borda quando há erro de validação
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            // Borda quando focado E com erro
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            // Cor de fundo: branco se habilitado, cinza se desabilitado
            fillColor: widget.enabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCupertinoInput(BuildContext context) {
    return FormField<String>(
      initialValue: _internalController.text,
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
            ],
            CupertinoTextField(
              suffix:  widget.isPasswordField
                    ? IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? CupertinoIcons.eye_fill
                            : CupertinoIcons.eye_slash_fill,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )
                    : widget.suffixIcon,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              placeholder: widget.hintText,
              placeholderStyle: widget.hintStyle,
              controller: _internalController,
              keyboardType: widget.keyboardType,
              enableSuggestions: true,
              obscureText:
                  widget.isPasswordField
                      ? !_passwordVisible
                      : widget.obscureText,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              onTap: widget.onTap,
              inputFormatters:
                  widget.hasMask && widget.mask != null ? [widget.mask!] : [],
              onChanged: (value) {
                field.didChange(value);
                _handleTextChanged(value);
              },
              readOnly: widget.readOnly,
              decoration: BoxDecoration(
                color:
                    widget.enabled
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey6,
                border: Border.all(
                  // Lógica de borda adaptada para cores nativas do iOS (ou as suas customizadas)
                  color:
                      field.hasError
                          ? CupertinoColors.destructiveRed
                          : (_hasText
                              ? CupertinoColors.activeGreen
                              : CupertinoColors.systemGrey4),
                  width: field.hasError || _hasText ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
