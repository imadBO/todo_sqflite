import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {super.key,
      required this.label,
      required this.titleController,
      this.readOnly = false,
      required this.type,
      required this.prefixIcon,
      this.suffixIcon,
      required this.validator,
      this.onTap});

  final String label;
  final TextEditingController titleController;
  final bool readOnly;
  final TextInputType type;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: Icon(suffixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      readOnly: readOnly,
      validator: validator,
      onTap: onTap,
    );
  }
}