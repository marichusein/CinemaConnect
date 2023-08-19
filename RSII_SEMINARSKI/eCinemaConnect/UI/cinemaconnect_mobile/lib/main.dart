import 'package:cinemaconnect_mobile/components/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema Connect',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'SFUIText',
          ),
          headlineLarge: TextStyle(
            fontFamily: 'SFUIText',
          ),
          headlineMedium: TextStyle(
            fontFamily: 'SFUIText',
          ),
          headlineSmall: TextStyle(
            fontFamily: 'SFUIText',
          )
        ),
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
