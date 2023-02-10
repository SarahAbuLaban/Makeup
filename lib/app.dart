import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_makeup/shared/index.dart';

import 'views/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Makeup',
      theme: ThemeData(
        primaryColor:kSecondary,
      ),
      home: const Splash(),
    );
  }
}