// Un nuevo widget, por ejemplo en common_widgets/info_box.dart
import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  final String text;
  final Color color;

  const InfoBox({super.key, required this.text, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border(left: BorderSide(color: color, width: 4)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}