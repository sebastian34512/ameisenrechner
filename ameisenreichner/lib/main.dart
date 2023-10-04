import 'package:ameisenreichner/pages/home.dart';
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
      routes: {
        '/': (context) => const MyHomePage(),
        '/overview/1': (context) => const MyHomePage(itemId: 1),
        '/overview/2': (context) => const MyHomePage(itemId: 2),
        '/overview/3': (context) => const MyHomePage(itemId: 3),
      },
      //outerConfig: _router,
      title: 'Ameisenrechner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
