import 'package:flutter/material.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrlAsync(String urlString) async {
      final Uri url = Uri.parse(urlString);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Pay Day",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Text(
              "By:\nLu Hou Yang\nLim Jia Chyuen\nSharvin A/L Kanesan",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(
              height: 36,
              width: 36,
            ),
            const Text(
              "Visit us at",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
              width: 8,
            ),
            NeuTextButton(
              buttonColor: const ui.Color.fromARGB(255, 64, 83, 231),
              enableAnimation: true,
              buttonWidth: 180,
              onPressed: () async {
                launchUrlAsync("https://www.luhouyang.com");
              },
              text: const Text(
                'Lu Hou Yang',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
              width: 16,
            ),
            NeuTextButton(
              buttonColor: const ui.Color.fromARGB(255, 64, 83, 231),
              enableAnimation: true,
              buttonWidth: 180,
              onPressed: () async {
                launchUrlAsync("https://limjiachyuen.com/");
              },
              text: const Text(
                'Lim Jia Chyuen',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 16,
              width: 16,
            ),
            NeuTextButton(
              buttonColor: const ui.Color.fromARGB(255, 64, 83, 231),
              enableAnimation: true,
              buttonWidth: 180,
              onPressed: () async {
                launchUrlAsync("https://www.linkedin.com/in/sharvin-kanesan-79b771253");
              },
              text: const Text(
                'Sharvin A/L Kanesan',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 24,
              width: 24,
            ),
            const Text(
              "Get the code at: ",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
              width: 8,
            ),
            NeuTextButton(
              buttonColor: const Color.fromARGB(255, 110, 84, 148),
              enableAnimation: true,
              buttonWidth: 180,
              onPressed: () async {
                launchUrlAsync("https://github.com/luhouyang/debtsimulator.git");
              },
              text: const Text(
                'GitHub',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 64,
              width: 64,
            ),
          ],
        ),
      ),
    );
  }
}
