import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Color dropdownColor;
  final TextStyle style;

  const CustomDropdown({
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.dropdownColor = Colors.white,
    this.style = const TextStyle(color: Colors.black),
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(hintText),
      value: value,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: dropdownColor,
      style: style,
      underline: Container(
        height: 2,
        color: Color(0xFF007BFF),
      ),
    );
  }
}