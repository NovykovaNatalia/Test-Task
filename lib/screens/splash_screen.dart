import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }); // Navigate to SecondScreen after 2 seconds

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Strings.searchApp, style: Styles.textSplash),
              const SizedBox(height: 24),
              const SpinKitRipple(
                color: Colors.blue,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
