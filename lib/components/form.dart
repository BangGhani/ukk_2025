import 'package:flutter/material.dart';
import 'themes.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ConfirmButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ConfirmButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeColor.hijau,
      ),
      child: Text(label),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.onSubmitted,
    this.focusNode,
    this.textInputAction,
    this.prefixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ThemeColor.abu),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ThemeColor.hijau),
            ),
            filled: true,
            fillColor: ThemeColor.putih,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: ThemeColor.abu,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          obscureText: widget.isPassword ? _obscureText : false,
          onFieldSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
