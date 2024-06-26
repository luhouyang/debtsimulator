import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

class MoneyCard extends StatelessWidget {
  final String text;
  final String amount;
  final Color iconColor;
  final Color textColor;
  const MoneyCard(
      {super.key,
      required this.text,
      required this.amount,
      required this.iconColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return NeuContainer(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            NeuContainer(
              color: iconColor,
              width: 35,
              height: 35,
              borderRadius: BorderRadius.circular(30),
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                amount,
                style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
