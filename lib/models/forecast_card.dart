import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';

class ForecastDayCard extends StatelessWidget {
  final String date;
  final String icon;
  final String maxTemp;
  final String minTemp;
  final String maxWind;

  const ForecastDayCard({
    super.key,
    required this.date,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    required this.maxWind,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          date,
          style: GoogleFonts.monda(
            color: kTextColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        SvgPicture.asset(
          icon,
          height: 100,
          colorFilter: ColorFilter.mode(
            kIconColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          maxTemp,
          style: GoogleFonts.daysOne(
            fontSize: 20,
            color: kIconColor,
          ),
        ),
        const SizedBox(height: 50),
        Text(
          minTemp,
          style: GoogleFonts.daysOne(
            fontSize: 20,
            color: kIconColor,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              maxWind,
              style: GoogleFonts.monda(
                fontSize: 18,
                color: kTextColor,
              ),
            ),
            Text(
              " km/h",
              style: GoogleFonts.monda(
                fontSize: 12,
                color: kTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
