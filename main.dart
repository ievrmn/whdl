import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KitKat Live',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // يمكنك تغييره إلى LoginScreen أو ChatRoomScreen
    );
  }
}