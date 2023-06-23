import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldCustom extends StatefulWidget {
  final bool enabled;
  final bool readOnly;
  final double? width;
  final double? height;

  final double? titleSpace;
  final double? borderRadius;
  final double? fontSize;
  final double? titleSize;
  final double? fontHeight;
  final EdgeInsetsGeometry? padding;

  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final String? initialValue;
  final String? prefixText;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Widget? suffixIcon, prefixIcon;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? onFieldSubmitted;
  final List<TextInputFormatter>? textInputFormatter;
  final Color? fillColor;
  final Color? borderColor;
  final Color? hintColor;
  final Color? cursorColor;
  final double? hintFontSize;
  final double? borderSize;

  const TextFormFieldCustom({
    Key? key,
    this.controller,
    this.labelText,
    this.maxLength,
    this.enabled = true,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.onFieldSubmitted,
    this.validator,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixText,
    this.autofillHints,
    this.prefixIcon,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.fontHeight,
    this.titleSize,
    this.titleSpace,
    this.padding,
    this.textInputFormatter,
    this.fillColor,
    this.borderColor,
    this.cursorColor,
    this.borderSize,
    this.hintColor,
    this.hintFontSize,
  })  : assert(initialValue == null || controller == null,
            'do not provide initial value or controller at the same time'),
        super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TextFormFieldCustomState createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  final _focusNode = FocusNode();
  final _key = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      gapPadding: 0,
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
        ],
        Container(
          height: widget.maxLines!.toDouble() == 1
              ? 50
              : 25 * widget.maxLines!.toDouble(),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
            border: Border.all(
              width: widget.borderSize ?? 1,
              color: widget.errorText != null && widget.errorText!.isNotEmpty
                  ? Theme.of(context).colorScheme.error
                  : !widget.enabled
                      ? Theme.of(context).disabledColor
                      : widget.borderColor ?? Theme.of(context).dividerColor,
            ),
          ),
          child: TextFormField(
            key: _key,
            onTap: widget.onTap,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            onChanged: widget.onChanged,
            autofocus: widget.autofocus,
            maxLength: widget.maxLength,
            inputFormatters: widget.textInputFormatter ?? [],
            focusNode: _focusNode,
            validator: widget.validator,
            controller: widget.controller,
            obscureText: widget.obscureText,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboardType,
            autofillHints: widget.autofillHints,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onFieldSubmitted,
            cursorColor: widget.cursorColor ?? Theme.of(context).primaryColor,
            style: const TextStyle(fontSize: 14),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.all(12),
              fillColor: !widget.enabled
                  ? Colors.transparent
                  : widget.fillColor ?? Theme.of(context).colorScheme.secondary,
              border: outlineInputBorder.copyWith(),
              focusedBorder: outlineInputBorder,
              enabledBorder: outlineInputBorder,
              disabledBorder: outlineInputBorder,
              errorBorder: outlineInputBorder,
              filled: !widget.enabled,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              labelText: '',
              prefixText: widget.prefixText,
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
            ),
            obscuringCharacter: '*',
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Text(
            widget.errorText!,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
