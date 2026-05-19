
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/injection.dart';
import 'features/splash/presentation/splash_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ MUST initialize Firebase FIRST
  await Firebase.initializeApp();

  /// ✅ Then setup DI
  setupInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Moodies',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C3C73)),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF6C3C73),
              foregroundColor: Colors.white,
            ),
          ),
          home: child,
        );
      },
      child: const SplashPage(),
    );
  }
}
