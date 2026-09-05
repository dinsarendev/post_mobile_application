import 'package:flutter/material.dart';

class AppChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AppChoiceChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.cyan,
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
