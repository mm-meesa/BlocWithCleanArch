
import 'package:blocwithcleanarch/features/fincluddata/presentation/screens/fincluddata_screen.dart';
import 'package:blocwithcleanarch/features/fintechData/presentation/presentaiont_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>
          PresentationScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Welcome \n\n\n to \n\n\n Splash Screen")));
  }
}
