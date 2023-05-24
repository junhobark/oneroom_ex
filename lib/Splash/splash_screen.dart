import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oneroom_ex/login/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        Get.to(SampleScreen());
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF264B7F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/img/logo/Splash_logo.png',
          ),
        ],
      ),
    );
  }
}
