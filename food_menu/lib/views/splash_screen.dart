import 'package:flutter/material.dart';
import 'package:food_menu/style/color.dart';
import 'package:food_menu/widget/splash_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      backgroundColor: appcolor, 
      body: splashContainer("Hoşgeldiniz", "https://assets10.lottiefiles.com/packages/lf20_GUQObWT5Mw.json",context),
    );
  }
}