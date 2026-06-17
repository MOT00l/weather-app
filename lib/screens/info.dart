import 'package:clima_weather/components/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: GlassContainer(
                blurStrength: 15,
                borderRadius: 30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Icon(
                                Icons.info_outline,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Welcome to Clima Weather! \n\n"
                              "Stay ahead of the weather with accurate real-time updates"
                              " and detailed climate insights. \nEnjoy a seamless and user"
                              "-friendly experience designed to keep you informed and "
                              "prepared."
                              "\n\nVersion: 3.3.0",
                              style: GoogleFonts.monda(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
