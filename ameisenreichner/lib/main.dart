import 'package:ameisenreichner/pages/challenge.dart';
import 'package:ameisenreichner/pages/overview.dart';
import 'package:flutter/material.dart';

import 'pages/counter.dart';
import 'pages/info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    Overview(),
    Counter(),
    Challenge(),
    Info(),
  ];

  final List<String> _headings = [
    "Übersicht",
    "Ameisenreichner",
    "Tägliche Herausforderung",
    "Info",
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_headings[_currentIndex],
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown.shade800,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.brown.shade200,
        unselectedItemColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.brown.shade800,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.space_dashboard_rounded,
              size: 30,
            ),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calculate_rounded,
              size: 30,
            ),
            label: 'Counter',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.not_listed_location_rounded,
              size: 30,
            ),
            label: 'Challenge',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info_outline_rounded,
              size: 30,
            ),
            label: 'Info',
          ),
        ],
      ),
    );
  }
}
