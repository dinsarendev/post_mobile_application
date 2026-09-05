import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormCustom extends StatefulWidget {
  final String? hintText, labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final String? errorText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;

  const InputFormCustom({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.isPassword = false,
    this.errorText,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.maxLength,
  });

  @override
  State<InputFormCustom> createState() => _InputFormCustomState();
}

class _InputFormCustomState extends State<InputFormCustom> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscureText,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.onSubmitted,
        autofillHints: widget.autofillHints,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: widget.hintText ?? "",
          labelText: widget.labelText ?? "",
          errorText: widget.errorText,
          counterText: widget.maxLength != null ? "" : null,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(width: 2, color: Colors.cyan),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(width: 1.5, color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(width: 2, color: Colors.redAccent),
          ),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.cyan)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
