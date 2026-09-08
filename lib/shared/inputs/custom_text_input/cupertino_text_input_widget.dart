import 'custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CupertinoTextInputWidget extends StatelessWidget {
  final CustomTextInput widgetProps;
  final TextEditingController controller;
  final bool hasText;
  final bool passwordVisible;
  final VoidCallback onTogglePassword;

  const CupertinoTextInputWidget({
    super.key,
    required this.widgetProps,
    required this.controller,
    required this.hasText,
    required this.passwordVisible,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller.text,
      validator: widgetProps.validator,
      builder: (FormFieldState<String> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widgetProps.label != null) ...[
              Text(
                widgetProps.label!,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
            ],
            CupertinoTextField(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              placeholder: widgetProps.hintText,
              placeholderStyle: widgetProps.hintStyle,
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
              onChanged: (value) {
                field.didChange(value);
                widgetProps.onChanged?.call(value);
              },
              readOnly: widgetProps.readOnly,
              suffix:
                  widgetProps.isPasswordField
                      ? IconButton(
                        icon: Icon(
                          passwordVisible
                              ? CupertinoIcons.eye_fill
                              : CupertinoIcons.eye_slash_fill,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: onTogglePassword,
                      )
                      : widgetProps.suffixIcon,
              decoration: BoxDecoration(
                color:
                    widgetProps.enabled
                        ? CupertinoColors.white
                        : CupertinoColors.systemGrey6,
                border: Border.all(
                  color:
                      field.hasError
                          ? CupertinoColors.destructiveRed
                          : (hasText
                              ? CupertinoColors.activeGreen
                              : CupertinoColors.systemGrey4),
                  width: field.hasError || hasText ? 2 : 1,
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