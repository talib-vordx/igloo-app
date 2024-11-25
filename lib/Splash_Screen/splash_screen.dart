import 'dart:async';
import 'package:flutter/material.dart';
import 'package:igloo/wraper.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)  => const Wraper(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff27D4C1),
      body: Center(
        child: Image.asset('res/images/splashLogo.png'),
      ),
    );
  }
}
