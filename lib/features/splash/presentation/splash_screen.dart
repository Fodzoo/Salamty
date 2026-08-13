import 'package:flutter/material.dart';
import 'package:salamty/core/widgets/logo_body.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "OnBoarding");
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LogoBody(),
      ),
    );
  }
}