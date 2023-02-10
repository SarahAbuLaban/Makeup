import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shared/index.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () => Get.offAll(()=>const Home()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
            color: kSecondary,
            image: DecorationImage(image: AssetImage('assets/splash.webp'))),
      ),
    );
  }
}
