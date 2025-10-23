import 'package:flutter/material.dart';
import 'package:unit_test/features/version/version_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      home: const VersionScreen(),
    );
  }
}