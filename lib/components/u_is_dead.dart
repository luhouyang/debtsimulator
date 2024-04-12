import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class UIsDead extends StatelessWidget {
  final String text;
  final Color textColor;
  const UIsDead(
      {super.key,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
