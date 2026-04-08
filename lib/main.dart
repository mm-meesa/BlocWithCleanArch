
import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'features/splash/presentation/splash_page.dart';

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      home: SplashPage(),
    );
  }
}
