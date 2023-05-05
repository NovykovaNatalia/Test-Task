import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leads_do_it_test/themes/strings.dart';
import 'package:leads_do_it_test/themes/app_colors.dart';
import 'package:leads_do_it_test/themes/styles.dart';
import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            children: const [
              Text(Strings.searchApp, style: Styles.textSplash),
              SizedBox(height: 16),
              CupertinoActivityIndicator(
                color: AppColors.grey,
                radius: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
