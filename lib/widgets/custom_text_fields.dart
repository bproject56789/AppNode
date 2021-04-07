import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final Color color;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;
  final TextEditingController controller;
  final bool obscureText;
  const CustomTextField({
    Key key,
    this.hintText,
    this.prefixIcon,
    this.color = Colors.white,
    this.onChanged,
    this.validator,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: color, width: 2),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: color),
          prefixIcon: Icon(
            prefixIcon,
            color: color,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
