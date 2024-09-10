import 'package:brtoon/common_widgets/sized_box/sized_box_widget.dart';
import 'package:brtoon/common_widgets/text/widget_text.dart';
import 'package:brtoon/constants/firebase_app_colors.dart';
import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  final IconData? icon;
  final String inputLabel;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final bool isPassword;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final ValueNotifier<bool> _isPasswordVN;

  TextFormFieldWidget({
    super.key,
    this.icon,
    required this.inputLabel,
    required this.controller,
    this.validator,
    required this.focusNode,
    this.isPassword = false,
    this.textInputType = TextInputType.text,
    this.textInputAction,
    this.onFieldSubmitted,
  }) : _isPasswordVN = ValueNotifier<bool>(isPassword);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool hasFocus = false;
  @override
  void initState() {
    hasFocus = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onRequestFocusChanges);
    super.initState();
  }

  void _onRequestFocusChanges() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onRequestFocusChanges);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget.normal(widget.inputLabel),
        const SizedBoxWidget.xxs(),
        ValueListenableBuilder(
            valueListenable: widget._isPasswordVN,
            builder: (_, bool isPassowrdVNValue, __) {
              return TextFormField(
                textCapitalization: TextCapitalization.none,
                focusNode: widget.focusNode,
                controller: widget.controller,
                style: TextStyle(
                  color: FirebaseAppColors.whiteColor,
                  fontSize: 16,
                ),
                keyboardType: widget.textInputType,
                autocorrect: false,
                onFieldSubmitted: widget.onFieldSubmitted,
                textInputAction: widget.textInputAction,
                decoration: InputDecoration(
                  filled: true,
                  errorStyle: TextStyle(
                    color: FirebaseAppColors.errorColor,
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: FirebaseAppColors.errorColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: hasFocus
                      ? FirebaseAppColors.secondaryColors.withOpacity(.7)
                      : FirebaseAppColors.whiteColor.withOpacity(.3),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          onPressed: () {
                            widget._isPasswordVN.value = !isPassowrdVNValue;
                          },
                          icon: Icon(
                              isPassowrdVNValue
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: FirebaseAppColors.whiteColor),
                        )
                      : null,
                ),
                obscureText: isPassowrdVNValue,
                validator: widget.validator,
              );
            })
      ],
    );
  }
}
