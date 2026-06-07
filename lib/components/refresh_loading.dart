import 'package:clima_weather/components/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RefreshLoading extends StatefulWidget {
  const RefreshLoading({super.key});

  @override
  State<RefreshLoading> createState() => _RefreshLoadingState();
}

class _RefreshLoadingState extends State<RefreshLoading> {
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
                child: Container(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SpinKitPulse(
                          color: Colors.white,
                          size: 100,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Refreshing Data...",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
