import 'package:flutter/material.dart';

class BuildTextWidget extends StatelessWidget {
  final String text;
  final bool checked;
  const BuildTextWidget(
    this.text,
    this.checked, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          checked ? const Icon(Icons.check, color: Colors.green, size: 24) : const Icon(Icons.close, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
