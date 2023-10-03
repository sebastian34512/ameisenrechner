import 'package:ameisenreichner/constants/colors.dart';
import 'package:ameisenreichner/pages/challenge.dart';
import 'package:ameisenreichner/pages/counter.dart';
import 'package:ameisenreichner/pages/info.dart';
import 'package:ameisenreichner/pages/overview.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

class MyHomePage extends StatefulWidget {
  final int? itemId;

  const MyHomePage({Key? key, this.itemId}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
  int? _itemId;
  List<Widget> _children = [];

  @override
  void initState() {
    if (widget.itemId != null) {
      _currentIndex = 0;
      _itemId = widget.itemId;
    } else {
      _currentIndex = 1;
    }
    _children = [
      Overview(itemId: _itemId),
      Counter(),
      Challenge(),
      Info(),
    ];
    super.initState();
  }

  final List<String> _headings = [
    "Übersicht",
    "Ameisenreichner",
    "Tägliche Herausforderung",
    "Info",
  ];

  void onTabTapped(int index) {
    setState(() {
      _itemId = null;
      _children = [
        Overview(itemId: _itemId),
        Counter(),
        Challenge(),
        Info(),
      ];
      html.window.history.pushState(null, 'home', '#');
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_headings[_currentIndex],
            style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColor.appBrown,
        automaticallyImplyLeading: false,
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
