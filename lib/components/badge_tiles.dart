import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class BadgeTiles extends StatelessWidget {
  final String imagePath;

  const BadgeTiles({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      child: imagePath.isNotEmpty ? Image.asset(imagePath, fit: BoxFit.fill,) : const Placeholder(),
    );
  }
}
