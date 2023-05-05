import 'package:flutter/material.dart';
import 'package:leads_do_it_test/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github repos list',
      home: SplashScreen(),
    );
  }
}
