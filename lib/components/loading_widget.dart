import 'package:clima_weather/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kOverlayColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPulse(
              color: kIconColor,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Fetching data...',
              style: TextStyle(
                fontSize: 20,
                color: kIconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
