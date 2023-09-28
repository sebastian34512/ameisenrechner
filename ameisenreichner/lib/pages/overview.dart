import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  const Overview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown.shade50,
        body: GridView.count(
          crossAxisCount: 3,
          children: [],
        ));
  }
}
