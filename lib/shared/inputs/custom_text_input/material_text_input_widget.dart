import 'custom_text_input.dart';
import 'package:flutter/material.dart';

class MaterialTextInputWidget extends StatelessWidget {
  
  final bool hasText;
  final bool passwordVisible;
  final CustomTextInput widgetProps;
  final VoidCallback onTogglePassword;
  final TextEditingController controller;

  const MaterialTextInputWidget({
    super.key,
    required this.widgetProps,
    required this.controller,
    required this.hasText,
    required this.passwordVisible,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widgetProps.onFocusBorderColor ??
        const Color.fromRGBO(78, 39, 211, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widgetProps.label != null) ...[
          Text(
            widgetProps.label!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          validator: widgetProps.validator,
          keyboardType: widgetProps.keyboardType,
          enableSuggestions: true,
          obscureText:
              widgetProps.isPasswordField
                  ? !passwordVisible
                  : widgetProps.obscureText,
          enabled: widgetProps.enabled,
          maxLines: widgetProps.maxLines,
          onTap: widgetProps.onTap,
          inputFormatters:
              widgetProps.hasMask && widgetProps.mask != null
                  ? [widgetProps.mask!]
                  : [],
          onChanged: widgetProps.onChanged,
          readOnly: widgetProps.readOnly,
          decoration: InputDecoration(
            hintText: widgetProps.hintText,
            hintStyle: widgetProps.hintStyle,
            prefixIcon: widgetProps.prefixIcon,
            suffixIcon:
                widgetProps.isPasswordField
                    ? IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: primaryColor,
                      ),
                      onPressed: onTogglePassword,
                    )
                    : widgetProps.suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasText ? primaryColor : Colors.grey.shade300,
                width: hasText ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor:
                widgetProps.enabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}