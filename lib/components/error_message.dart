import 'package:clima_weather/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorMessage extends StatelessWidget {
  final String title, message;
  const ErrorMessage({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_rounded, size: 150),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.monda(
                fontSize: 20,
                color: kMidLightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(message,
                style: GoogleFonts.monda(
                  fontSize: 20,
                  color: kMidLightColor,
                ),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
