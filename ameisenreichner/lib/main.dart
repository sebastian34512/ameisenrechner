import 'package:ameisenreichner/constants/colors.dart';
import 'package:ameisenreichner/pages/challenge.dart';
import 'package:ameisenreichner/pages/overview.dart';
import 'package:ameisenreichner/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/counter.dart';
import 'pages/info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => MyHomePage(urlPageId: 1),
    ),
    GoRoute(
      name: 'overview',
      path: '/overview',
      builder: (context, state) => MyHomePage(urlPageId: 0),
    ),
  ]);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Ameisenrechner',
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
    );
  }
}

class MyHomePage extends StatefulWidget {
  int urlPageId;

  MyHomePage({Key? key, required this.urlPageId}) : super(key: key);

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
  void initState() {
    debugPrint(widget.urlPageId.toString());
    _currentIndex = widget.urlPageId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_headings[_currentIndex],
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColor.appBrown,
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
        backgroundColor: AppColor.appBrown,
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
