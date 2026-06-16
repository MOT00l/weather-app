import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsWidget extends StatelessWidget {
  final String? text;
  final String? detailText;
  final Color? color;
  final Color? colorDetail;
  const DetailsWidget({
    super.key,
    required this.detailText,
    required this.text,
    required this.color,
    required this.colorDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              text!,
              style: GoogleFonts.monda(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: detailText == "WIND" ? true : false,
              child: Text(
                " km/h",
                style: GoogleFonts.monda(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
            Visibility(
              visible: detailText == "\n PRESSURE" ? true : false,
              child: Text(
                " mbar",
                style: GoogleFonts.monda(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        Text(
          detailText!,
          style: GoogleFonts.monda(
            fontSize: 11,
            color: colorDetail,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
