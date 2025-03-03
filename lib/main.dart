import 'package:clima_weather/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      theme: ThemeData.dark(),
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Clima Weather App',
      home: const Home(),
    );
  }
}

// class AppTheme {
//   static ThemeData customThemeData() {
//     return ThemeData(
//       useMaterial3: true,
//       colorScheme: ColorScheme(isDark? darkScheme : lightScheme),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ButtonStyle(
//           backgroundColor: MaterialStateProperty.all(Colors.red),
//         ),
//       ),
//       textTheme: const TextTheme(
//         labelLarge: TextStyle(
//           fontSize: 15.0,
//         ),
//         labelMedium: TextStyle(
//           fontSize: 12.0,
//         ),
//       ),
//     );
//   }
// }
